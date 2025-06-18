package controller;

import dao.ForumPostDAO;
import dao.UserDAO;
import model.ForumPost;
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
import java.util.logging.Logger;

@WebServlet(name = "EditPostServlet", urlPatterns = {"/forum/editPost/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EditPostServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EditPostServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        userDAO = new UserDAO();
        LOGGER.info("EditPostServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = (String) request.getSession().getAttribute("userId");
            String username = (String) request.getSession().getAttribute("username");
            
            if (userId == null) {
                userId = "U001"; // Default userID
                username = "quy123"; // Default username
                request.getSession().setAttribute("userId", userId);
                request.getSession().setAttribute("username", username);
            }

            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int postId = Integer.parseInt(pathInfo.substring(1));
                ForumPost post = postDAO.getPostById(postId);
                
                if (post == null) {
                    request.getSession().setAttribute("message", "Bài viết không tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/forum");
                    return;
                }
                
                // Check if user is the author
                if (!post.getPostedBy().equals(userId)) {
                    request.getSession().setAttribute("message", "Bạn không có quyền chỉnh sửa bài viết này!");
                    response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                    return;
                }
                
                User user = userDAO.getUserByUsername(username);
                request.setAttribute("post", post);
                request.setAttribute("username", username);
                request.setAttribute("user", user);
                
                request.getRequestDispatcher("/view/editPost.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/forum");
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu!");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid post ID: " + e.getMessage());
            request.getSession().setAttribute("message", "ID bài viết không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forum");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = (String) request.getSession().getAttribute("userId");
            if (userId == null) {
                userId = "U001";
                request.getSession().setAttribute("userId", userId);
            }

            int postId = Integer.parseInt(request.getParameter("postId"));
            String title = request.getParameter("postTitle");
            String content = request.getParameter("postContent");
            String category = request.getParameter("postCategory");
            
            if (title == null || title.trim().isEmpty() || 
                content == null || content.trim().isEmpty() || 
                category == null || category.trim().isEmpty()) {
                request.getSession().setAttribute("message", "Tiêu đề, nội dung và chủ đề không được để trống!");
                response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                return;
            }

            // Get existing post to check ownership
            ForumPost existingPost = postDAO.getPostById(postId);
            if (existingPost == null || !existingPost.getPostedBy().equals(userId)) {
                request.getSession().setAttribute("message", "Bạn không có quyền chỉnh sửa bài viết này!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            String fileName = existingPost.getPicture(); // Keep existing image by default
            
            // Handle image upload
            Part filePart = request.getPart("imageInput");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    request.getSession().setAttribute("message", "Chỉ hỗ trợ hình ảnh!");
                    response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
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
                LOGGER.info("Uploaded new file: " + fileName);
            }

            ForumPost post = new ForumPost();
            post.setId(postId);
            post.setTitle(title);
            post.setContent(content);
            post.setCategory(category);
            post.setPicture(fileName);
            post.setPostedBy(userId);

            boolean updated = postDAO.updatePost(post);
            if (updated) {
                request.getSession().setAttribute("message", "Cập nhật bài viết thành công!");
            } else {
                request.getSession().setAttribute("message", "Có lỗi xảy ra khi cập nhật bài viết!");
            }
            
            response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu!");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid post ID: " + e.getMessage());
            request.getSession().setAttribute("message", "ID bài viết không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi không xác định!");
            response.sendRedirect(request.getContextPath() + "/forum");
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
