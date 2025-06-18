package controller;

import dao.ForumPostDAO;
import dao.UserActivityScoreDAO;
import dao.UserDAO;
import model.ForumPost;
import model.UserActivityScore;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "ForumServlet", urlPatterns = {"/forum", "/forum/createPost", "/forum/post/*", "/forum/deletePost"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ForumServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForumServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserActivityScoreDAO scoreDAO;
    private UserDAO userDAO;

    private static final List<String> VALID_SORTS = Arrays.asList("newest", "popular", "most-liked");
    private static final List<String> VALID_FILTERS = Arrays.asList("all", "with-replies", "no-replies");

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        scoreDAO = new UserActivityScoreDAO();
        userDAO = new UserDAO();
        LOGGER.info("ForumServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumServlet doGet called for URL: " + request.getRequestURI());
        try {
            String pathInfo = request.getPathInfo();
            String username = (String) request.getSession().getAttribute("username");
            String userId = (String) request.getSession().getAttribute("userId");
            User user = null;
            if (username == null || userId == null) {
                username = "quy123"; // Default username
                userId = "U001"; // Default userID
                request.getSession().setAttribute("username", username);
                request.getSession().setAttribute("userId", userId);
                LOGGER.info("No user in session, defaulting to U001/quy123");
            }
            user = userDAO.getUserByUsername(username);
            request.setAttribute("username", username);
            request.setAttribute("user", user);

            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int postId = Integer.parseInt(pathInfo.substring(1));
                ForumPost post = postDAO.getPostById(postId);
                if (post == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bài viết không tồn tại");
                    return;
                }
                postDAO.incrementViewCount(postId);
                request.setAttribute("postDetail", post);

                // Lấy bài viết liên quan
                List<ForumPost> relatedPosts = postDAO.getRelatedPosts(postId, post.getCategory(), 3);
                request.setAttribute("relatedPosts", relatedPosts);

                request.getRequestDispatcher("/view/postDetail.jsp").forward(request, response);
                return;
            } else {
                // Handle forum main page
                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";
                String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all";
                String search = request.getParameter("search");
                int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int size = 10;

                if (!VALID_SORTS.contains(sort) && !Arrays.asList("weekly", "monthly", "alltime").contains(sort)) {
                    sort = "newest";
                    LOGGER.warning("Invalid sort parameter, defaulting to newest");
                }
                if (!VALID_FILTERS.contains(filter)) {
                    filter = "all";
                    LOGGER.warning("Invalid filter parameter, defaulting to all");
                }
                if (page < 1) {
                    page = 1;
                    LOGGER.warning("Invalid page parameter, defaulting to 1");
                }

                List<ForumPost> posts = postDAO.getPostsSortedAndFiltered(sort, filter, search, page, size);

                // Handle leaderboard with 100 users
                int limit = 100;
                String timeFrame = "alltime"; // Default to alltime
                if ("weekly".equals(sort)) {
                    timeFrame = "weekly";
                } else if ("monthly".equals(sort)) {
                    timeFrame = "monthly";
                } else if ("alltime".equals(sort)) {
                    timeFrame = "alltime";
                }
                List<UserActivityScore> topUsers = scoreDAO.getTopUsers(limit, timeFrame);
                request.setAttribute("topUsers", topUsers);
                request.setAttribute("timeFrame", timeFrame); // Pass timeFrame to JSP

                request.setAttribute("posts", posts);
                request.setAttribute("sort", sort);
                request.setAttribute("filter", filter);
                request.setAttribute("page", page);
                request.setAttribute("search", search);

                LOGGER.info("Forwarding to /view/forum.jsp with sort: " + sort + ", filter: " + filter + ", search: " + search + ", page: " + page + ", timeFrame: " + timeFrame);
                request.getRequestDispatcher("/view/forum.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid post ID format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumServlet doPost called for URL: " + request.getServletPath());
        String action = request.getServletPath();

        if ("/forum/createPost".equals(action)) {
            try {
                String userId = (String) request.getSession().getAttribute("userId");
                if (userId == null) {
                    userId = "U001"; // Default userID
                    request.getSession().setAttribute("userId", userId);
                    request.getSession().setAttribute("username", "quy123");
                    LOGGER.info("No user logged in, using default user U001");
                }

                String title = request.getParameter("postTitle");
                String content = request.getParameter("postContent");
                String category = request.getParameter("postCategory");
                if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()
                        || category == null || category.trim().isEmpty()) {
                    request.getSession().setAttribute("message", "Tiêu đề, nội dung và chủ đề không được để trống");
                    response.sendRedirect(request.getContextPath() + "/forum");
                    return;
                }

                Part filePart = request.getPart("imageInput");
                String fileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        request.getSession().setAttribute("message", "Chỉ hỗ trợ hình ảnh");
                        response.sendRedirect(request.getContextPath() + "/forum");
                        return;
                    }
                    fileName = System.currentTimeMillis() + "_" + extractFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    fileName = "Uploads/" + fileName;
                    LOGGER.info("Uploaded file: " + fileName);
                }

                ForumPost post = new ForumPost();
                post.setTitle(title);
                post.setContent(content);
                post.setPostedBy(userId);
                post.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                post.setCategory(category);
                post.setPicture(fileName);
                post.setViewCount(0);
                post.setVoteCount(0);

                postDAO.createPost(post);

                request.getSession().setAttribute("message", "Bài viết đã được tạo thành công!");
                LOGGER.info("Redirecting to /forum after creating post");
                response.sendRedirect(request.getContextPath() + "/forum");
            } catch (SQLException e) {
                LOGGER.severe("Database error in doPost: " + e.getMessage());
                request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu khi tạo bài viết");
                response.sendRedirect(request.getContextPath() + "/forum");
            } catch (Exception e) {
                LOGGER.severe("Unexpected error in doPost: " + e.getMessage());
                request.getSession().setAttribute("message", "Lỗi không xác định khi tạo bài viết");
                response.sendRedirect(request.getContextPath() + "/forum");
            }
        } else if ("/forum/deletePost".equals(action)) {
            try {
                String userId = (String) request.getSession().getAttribute("userId");
                if (userId == null) {
                    userId = "U001";
                    request.getSession().setAttribute("userId", userId);
                }

                int postId = Integer.parseInt(request.getParameter("postId"));
                boolean deleted = postDAO.deletePost(postId, userId);

                if (deleted) {
                    request.getSession().setAttribute("message", "Xóa bài viết thành công!");
                    response.sendRedirect(request.getContextPath() + "/forum");
                } else {
                    request.getSession().setAttribute("message", "Bạn không có quyền xóa bài viết này!");
                    response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                }
            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid post ID when deleting: " + e.getMessage());
                request.getSession().setAttribute("message", "ID bài viết không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/forum");
            } catch (Exception e) {
                LOGGER.severe("Unexpected error when deleting post: " + e.getMessage());
                request.getSession().setAttribute("message", "Lỗi không xác định khi xóa bài viết!");
                response.sendRedirect(request.getContextPath() + "/forum");
            }
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}