<%@page import="dao.UserActivityScoreDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.UserDAO, model.ForumPost, model.ForumComment, model.UserActivityScore, model.User, java.text.SimpleDateFormat, java.sql.Timestamp, dao.ForumPostDAO" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chi tiết bài viết - HIKARI Forum</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/postDetail.css" rel="stylesheet" />
    </head>
    <body>
        <div class="topbar">
            <div class="logo">
                <div class="logo-icon">
                    <img src="<%= request.getContextPath()%>/assets/img/logo.png" alt="Logo" class="logo-img" />
                </div>
                Diễn Đàn HIKARI
            </div>
            <nav class="nav">
                <a href="<%= request.getContextPath()%>/"><i class="fas fa-home"></i> Trang Chủ</a>
                <a href="<%= request.getContextPath()%>/contact"><i class="fas fa-phone"></i> Liên Hệ</a>
                <a href="<%= request.getContextPath()%>/profile?user=" + userID() class="nav-link ">
                    <i class="fas fa-user"></i>
                    <span>Hồ sơ</span>
                </a>
                <div class="account-dropdown" id="accountDropdown">
                    <button class="account-btn">
                        <div class="avatar sm">
                            <img src="<%= request.getContextPath()%>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                    </button> 
                </div>
            </nav>
        </div>

        <!-- Main Container -->
        <div class="container">
            <div class="content-wrapper">
                <!-- Left Sidebar: Author Info & Related Posts -->
                <%
                    ForumPost post = (ForumPost) request.getAttribute("postDetail");
                    User author = post != null ? new UserDAO().getUserById(post.getPostedBy()) : null;
                    UserActivityScore authorScore = null;
                    List<UserActivityScore> allScores = (List<UserActivityScore>) request.getAttribute("topUsers");
                    if (author != null && allScores != null) {
                        for (UserActivityScore s : allScores) {
                            if (s.getUserId().equals(author.getUserId())) {
                                authorScore = s;
                                break;
                            }
                        }
                    }
                %>
                <aside class="sidebar-left">
                    <div class="widget user-card">
                        <div class="widget-title">
                            <i class="fas fa-user-circle"></i>
                            Thông tin tác giả
                        </div>
                        <% if (author != null) {%>
                        <div class="avatar">
                            <img src="<%= request.getContextPath()%>/<%= author.getProfilePicture() != null && !author.getProfilePicture().isEmpty() ? escapeHtml(author.getProfilePicture()) : "assets/img/avatar.png"%>" alt="Avatar" />
                        </div>
                        <div class="username">
                            <%= escapeHtml(author.getUsername())%>
                        </div>
                        <div class="role">
                            <%= escapeHtml(author.getRole() != null ? author.getRole() : "Thành viên")%>
                            <% if (author.getRole() != null && author.getRole().toLowerCase().contains("admin")) { %>
                            <span style="display:block;margin-top:0.5rem;padding:0.3rem 1rem;font-size:0.85rem;background:linear-gradient(90deg,#a18cd1 0%,#fbc2eb 100%);color:#5a189a;border-radius:12px;font-weight:600;">Admin</span>
                            <% }%>
                        </div>
                        <div class="user-stats">
                            <div class="stat-item">
                                <span class="value"><%= authorScore != null ? authorScore.getTotalComments() : 0%></span>
                                <span class="label">Bình luận</span>
                            </div>
                            <div class="stat-item">
                                <span class="value"><%= authorScore != null ? authorScore.getTotalVotes() : 0%></span>
                                <span class="label">Lượt thích</span>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-user-slash"></i>
                            </div>
                            <h3 class="empty-title">Không tìm thấy tác giả</h3>
                        </div>
                        <% } %>
                    </div>

                    <!-- Related Posts -->
                    <section class="related-posts">
                        <div class="related-header">
                            <h2 class="related-title">
                                <i class="fas fa-newspaper"></i>
                                Bài viết liên quan
                            </h2>
                        </div>
                        <div class="related-list">
                            <%
                                List<ForumPost> relatedPosts = (List<ForumPost>) request.getAttribute("relatedPosts");
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                if (relatedPosts != null && !relatedPosts.isEmpty()) {
                                    for (ForumPost relatedPost : relatedPosts) {
                                        String relatedPicture = relatedPost.getPicture() != null ? relatedPost.getPicture() : "";
                                        Timestamp relatedDate = relatedPost.getCreatedDate();
                                        String formattedRelatedDate = relatedDate != null ? sdf.format(relatedDate) : "";
                            %>
                            <a href="<%= request.getContextPath()%>/forum/post/<%= relatedPost.getId()%>" class="related-item">
                                <div class="related-image">
                                    <img src="<%= request.getContextPath()%>/<%= relatedPicture != null && !relatedPicture.isEmpty() ? escapeHtml(relatedPicture) : "assets/img/learning.jpg"%>" alt="Related post" />
                                </div>
                                <div class="related-content">
                                    <h3 class="related-post-title">
                                        <%= escapeHtml(relatedPost.getTitle())%>
                                    </h3>
                                    <div class="related-meta">
                                        <span>
                                            <i class="fas fa-calendar-alt"></i>
                                            <%= formattedRelatedDate%>
                                        </span>
                                        <span>
                                            <i class="fas fa-comment"></i>
                                            <%= relatedPost.getCommentCount()%>
                                        </span>
                                        <span>
                                            <i class="fas fa-eye"></i>
                                            <%= relatedPost.getViewCount()%>
                                        </span>
                                    </div>
                                </div>
                            </a>
                            <%
                                }
                            } else {
                            %>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-newspaper"></i>
                                </div>
                                <h3 class="empty-title">Không có bài viết liên quan</h3>
                                <p>Hiện tại chưa có bài viết nào cùng danh mục.</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </section>
                </aside>

                <!-- Main Content -->
                <div class="main-content">
                    <nav class="breadcrumb">
                        <a href="<%= request.getContextPath()%>/forum">
                            <i class="fas fa-comments"></i>
                            Diễn đàn
                        </a>
                        <i class="fas fa-chevron-right"></i>
                        <span>Chi tiết bài viết</span>
                    </nav>
                    <a href="<%= request.getContextPath()%>/forum" class="back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại diễn đàn
                    </a>
                    <%
                        String message = (String) session.getAttribute("message");
                        if (message != null && !message.isEmpty()) {
                    %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= escapeHtml(message)%>
                    </div>
                    <%
                            session.removeAttribute("message");
                        }
                    %>
                    <%
                        String currentUserId = (String) request.getSession().getAttribute("userId");
                        if (post == null) {
                    %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3 class="empty-title">Bài viết không tồn tại</h3>
                        <p>Bài viết này có thể đã bị xóa hoặc bạn không có quyền truy cập.</p>
                    </div>
                    <%
                    } else {
                        ForumPostDAO postDAO = new ForumPostDAO();
                        String postPicture = post.getPicture() != null ? post.getPicture() : "";
                        Timestamp createdDate = post.getCreatedDate();
                        String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                        boolean hasLiked = currentUserId != null && postDAO.hasUserLikedPost(post.getId(), currentUserId);
                        boolean isAuthor = currentUserId != null && post.getPostedBy().equals(currentUserId);
                    %>
                    <article class="post-container" style="margin-bottom:0;">
                        <header class="post-header">
                            <div class="post-meta">
                                <div class="author-info">
                                    <div class="author-avatar">
                                        <img src="<%= request.getContextPath()%>/<%= author != null && author.getProfilePicture() != null && !author.getProfilePicture().isEmpty() ? escapeHtml(author.getProfilePicture()) : "assets/img/avatar.png"%>" alt="Avatar" />
                                    </div>
                                    <div class="author-details">
                                        <h3>
                                            <a href="<%= request.getContextPath()%>/profile?userId=<%= escapeHtml(post.getPostedBy())%>" style="color: inherit; text-decoration: none;">
                                                <%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy()))%>
                                            </a>
                                        </h3>
                                        <p>
                                            <i class="fas fa-clock"></i>
                                            <%= formattedDate%>
                                            <span style="margin-left: 1rem;">
                                                <i class="fas fa-eye"></i>
                                                <%= post.getViewCount()%> lượt xem
                                            </span>
                                        </p>
                                    </div>
                                </div>
                                <% if (isAuthor) {%>
                                <div class="post-actions">
                                    <button class="actions-btn" onclick="toggleActionsMenu()">
                                        <i class="fas fa-ellipsis-v"></i>
                                    </button>
                                    <div class="actions-menu" id="actionsMenu">
                                        <a href="<%= request.getContextPath()%>/forum/editPost/<%= post.getId()%>">
                                            <i class="fas fa-edit"></i>
                                            Chỉnh sửa
                                        </a>
                                        <button class="delete-btn" onclick="confirmDelete(<%= post.getId()%>)">
                                            <i class="fas fa-trash"></i>
                                            Xóa bài viết
                                        </button>
                                    </div>
                                </div>
                                <% }%>
                            </div>
                            <h1 class="post-title"><%= escapeHtml(post.getTitle())%></h1>
                            <div class="post-category">
                                <i class="fas fa-tag"></i>
                                <%= escapeHtml(post.getCategory())%>
                            </div>
                        </header>
                        <div class="post-content">
                            <div class="post-text">
                                <%= escapeHtml(post.getContent()).replace("\n", "<br>")%>
                            </div>
                            <% if (postPicture != null && !postPicture.isEmpty()) {%>
                            <div class="post-image">
                                <img src="<%= request.getContextPath()%>/<%= escapeHtml(postPicture)%>" alt="Post image" />
                            </div>
                            <% }%>
                        </div>
                        <div class="post-stats">
                            <div class="stats-row">
                                <button class="interaction-btn <%= hasLiked ? "liked" : ""%>" onclick="toggleLike(<%= post.getId()%>, this)">
                                    <i class="fas fa-thumbs-up"></i>
                                    <span class="like-count"><%= post.getVoteCount()%> Thích</span>
                                </button>
                                <button class="interaction-btn" onclick="focusCommentForm()">
                                    <i class="fas fa-comment"></i>
                                    <span><%= post.getCommentCount()%> Bình luận</span>
                                </button>
                                <button class="interaction-btn" onclick="sharePost()">
                                    <i class="fas fa-share"></i>
                                    Chia sẻ
                                </button>
                            </div>
                        </div>
                        <section class="comments-section">
                            <div class="comments-header">
                                <h2 class="comments-title">
                                    <i class="fas fa-comments"></i>
                                    Bình luận (<%= post.getCommentCount()%>)
                                </h2>
                            </div>
                            <div class="comments-list">
                                <%
                                    List<ForumComment> comments = post.getComments();
                                    if (comments != null && !comments.isEmpty()) {
                                        for (ForumComment comment : comments) {
                                            Timestamp commentDate = comment.getCommentedDate();
                                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                                %>
                                <div class="comment-item">
                                    <div class="comment-header">
                                        <div class="comment-avatar">
                                            <img src="<%= request.getContextPath()%>/<%= new UserDAO().getUserById(comment.getCommentedBy()) != null && new UserDAO().getUserById(comment.getCommentedBy()).getProfilePicture() != null && !new UserDAO().getUserById(comment.getCommentedBy()).getProfilePicture().isEmpty() ? escapeHtml(new UserDAO().getUserById(comment.getCommentedBy()).getProfilePicture()) : "assets/img/avatar.png"%>" alt="Avatar" />
                                        </div>
                                        <a href="<%= request.getContextPath()%>/profile?userId=<%= escapeHtml(comment.getCommentedBy())%>" class="comment-author">
                                            <%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy()))%>
                                        </a>
                                        <span class="comment-date">
                                            <i class="fas fa-clock"></i>
                                            <%= formattedCommentDate%>
                                        </span>
                                    </div>
                                    <div class="comment-content">
                                        <%= escapeHtml(comment.getCommentText()).replace("\n", "<br>")%>
                                    </div>
                                    <div class="comment-actions">
                                        <button class="comment-action">
                                            <i class="fas fa-thumbs-up"></i>
                                            <%= comment.getVoteCount()%>
                                        </button>
                                        <button class="comment-action" onclick="replyToComment(<%= comment.getId()%>)">
                                            <i class="fas fa-reply"></i>
                                            Phản hồi
                                        </button>
                                    </div>
                                </div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-comment-slash"></i>
                                    </div>
                                    <h3 class="empty-title">Chưa có bình luận nào</h3>
                                    <p>Hãy là người đầu tiên bình luận cho bài viết này!</p>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <form action="<%= request.getContextPath()%>/forum/createComment" method="post" class="comment-form" id="commentForm">
                                <input type="hidden" name="postId" value="<%= post.getId()%>">
                                <div class="form-group">
                                    <textarea class="form-control" name="commentText" id="commentText" placeholder="Viết bình luận của bạn..." required></textarea>
                                </div>
                                <div class="form-footer">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane"></i>
                                        Gửi bình luận
                                    </button>
                                </div>
                            </form>
                        </section>
                    </article>

                    <% }%>
                </div>

                <!-- Right Sidebar: User Card & Leaderboard -->
                <aside class="sidebar-right">
                    <!-- User Card -->
                    <div class="widget" style="padding:0;overflow:hidden;">
                        <div style="background:linear-gradient(135deg,#6a85f1 0%,#b8c6ff 100%);height:90px;position:relative;">
                            <img src="<%= request.getContextPath()%>/assets/img/backgroundLogin.png" alt="Cover" style="width:100%;height:100%;object-fit:cover;opacity:0.7;position:absolute;top:0;left:0;">
                        </div>
                        <div style="display:flex;flex-direction:column;align-items:center;padding:0 0 18px 0;position:relative;top:-40px;">
                            <div style="width:80px;height:80px;border-radius:50%;overflow:hidden;border:4px solid #fff;box-shadow:0 2px 8px rgba(0,0,0,0.08);background:#fff;">
                                <img src="<%= request.getContextPath()%>/<%= request.getAttribute("user") != null && ((User) request.getAttribute("user")).getProfilePicture() != null && !((User) request.getAttribute("user")).getProfilePicture().isEmpty() ? ((User) request.getAttribute("user")).getProfilePicture() : "assets/img/avatar.png"%>" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="margin-top:10px;text-align:center;">
                                <div style="color:#888;font-size:1em;">Welcome back,</div>
                                <div style="font-weight:700;font-size:1.2em;"><%= escapeHtml(((User) request.getAttribute("user")).getUsername())%></div>
                                <div style="color:#888;font-size:0.98em;"><%= escapeHtml(((User) request.getAttribute("user")).getRole())%></div>
                                <% if (((User) request.getAttribute("user")).getRole() != null && ((User) request.getAttribute("user")).getRole().toLowerCase().contains("admin")) { %>
                                <span style="display:inline-block;margin-top:7px;padding:2px 14px;font-size:0.95em;background:linear-gradient(90deg,#a18cd1 0%,#fbc2eb 100%);color:#5a189a;border-radius:12px;font-weight:600;">Admin</span>
                                <% }%>
                            </div>
                        </div>
                    </div>
                    <!-- Leaderboard -->
                    <div class="widget" style="padding-top:18px;">
                        <div class="widget-title">
                            <i class="fas fa-trophy" style="color:#f7c873;"></i>
                            Leaderboard
                        </div>
                        <div style="display:flex;gap:8px;margin-bottom:18px;">
                            <%
                                String currentPostId = post != null ? String.valueOf(post.getId()) : "";
                                String currentTimeFrame = (String) request.getAttribute("timeFrame");
                                String currentFilter = (String) request.getAttribute("filter");
                                String currentSearch = (String) request.getAttribute("search");
                                if (currentFilter == null) {
                                    currentFilter = "all";
                                }
                                if (currentSearch == null)
                                    currentSearch = "";
                            %>
                            <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "weekly".equals(currentTimeFrame) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum/post/<%= currentPostId%>?sort=weekly&filter=<%= escapeHtml(currentFilter)%>&search=<%= escapeHtml(currentSearch)%>'">This Week</button>
                            <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "monthly".equals(currentTimeFrame) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum/post/<%= currentPostId%>?sort=monthly&filter=<%= escapeHtml(currentFilter)%>&search=<%= escapeHtml(currentSearch)%>'">This Month</button>
                            <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "alltime".equals(currentTimeFrame) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum/post/<%= currentPostId%>?sort=alltime&filter=<%= escapeHtml(currentFilter)%>&search=<%= escapeHtml(currentSearch)%>'">All Time</button>
                        </div>
                        <div style="display:flex;align-items:flex-end;justify-content:center;gap:18px;margin-bottom:18px;">
                            <%
                                List<UserActivityScore> topUsers = (List<UserActivityScore>) request.getAttribute("topUsers");
                                UserActivityScore first = null, second = null, third = null;
                                if (topUsers != null && topUsers.size() > 0) {
                                    first = topUsers.get(0);
                                }
                                if (topUsers != null && topUsers.size() > 1) {
                                    second = topUsers.get(1);
                                }
                                if (topUsers != null && topUsers.size() > 2) {
                                    third = topUsers.get(2);
                                }
                            %>
                            <% if (second != null) {%>
                            <div style="display:flex;flex-direction:column;align-items:center;">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= request.getContextPath()%>/<%= second.getUser().getProfilePicture() != null && !second.getUser().getProfilePicture().isEmpty() ? second.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                                <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= escapeHtml(second.getUser().getUsername())%></div>
                                <div style="color:#888;font-size:0.95em;"><%= second.getTotalScore()%></div>
                            </div>
                            <% } %>
                            <% if (first != null) {%>
                            <div style="display:flex;flex-direction:column;align-items:center;">
                                <div style="width:60px;height:60px;border-radius:50%;overflow:hidden;border:3px solid #f7c873;box-shadow:0 2px 8px #f7c87344;">
                                    <img src="<%= request.getContextPath()%>/<%= first.getUser().getProfilePicture() != null && !first.getUser().getProfilePicture().isEmpty() ? first.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                                <div style="font-size:1.05em;font-weight:700;margin-top:4px;color:#f7c873;"><%= escapeHtml(first.getUser().getUsername())%></div>
                                <div style="color:#232946;font-size:1.05em;font-weight:700;"><%= first.getTotalScore()%></div>
                            </div>
                            <% } %>
                            <% if (third != null) {%>
                            <div style="display:flex;flex-direction:column;align-items:center;">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= request.getContextPath()%>/<%= third.getUser().getProfilePicture() != null && !third.getUser().getProfilePicture().isEmpty() ? third.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                                <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= escapeHtml(third.getUser().getUsername())%></div>
                                <div style="color:#888;font-size:0.95em;"><%= third.getTotalScore()%></div>
                            </div>
                            <% } %>
                        </div>
                        <div>
                            <%
                                int rank = 4;
                                if (topUsers != null && topUsers.size() > 3) {
                                    for (int i = 3; i < Math.min(topUsers.size(), 9); i++) {
                                        UserActivityScore score = topUsers.get(i);
                                        User user = score.getUser();
                            %>
                            <div style="display:flex;align-items:center;gap:10px;padding:7px 0;border-radius:8px;<%= i == 4 ? "background:#f4f6fb;" : ""%>">
                                <div style="width:28px;text-align:center;font-weight:600;color:#232946;font-size:1em;"><%= rank%></div>
                                <div style="width:32px;height:32px;border-radius:50%;overflow:hidden;">
                                    <img src="<%= request.getContextPath()%>/<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                                <div style="flex:1;">
                                    <div style="font-weight:600;font-size:1em;color:#232946;"><%= escapeHtml(user.getUsername())%></div>
                                </div>
                                <div style="color:#888;font-size:1em;font-weight:500;"><%= score.getTotalScore()%></div>
                            </div>
                            <%
                                        rank++;
                                    }
                                }
                            %>
                        </div>
                    </div>
                </aside>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal-overlay" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-exclamation-triangle" style="color: #dc2626;"></i>
                        Xác nhận xóa
                    </h3>
                    <p class="modal-text">Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.</p>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                    <button class="btn btn-danger" onclick="deletePost()">Xóa bài viết</button>
                </div>
            </div>
        </div>

        <script>
            let postIdToDelete = null;
            function toggleUserMenu() {
                document.getElementById('userDropdown').classList.toggle('show');
            }
            function toggleActionsMenu() {
                document.getElementById('actionsMenu').classList.toggle('show');
            }
            document.addEventListener('click', function (event) {
                const userMenu = document.querySelector('.user-menu');
                const userDropdown = document.getElementById('userDropdown');
                const actionsMenu = document.getElementById('actionsMenu');
                if (!userMenu.contains(event.target)) {
                    userDropdown.classList.remove('show');
                }
                if (!event.target.closest('.post-actions')) {
                    actionsMenu.classList.remove('show');
                }
            });
            function toggleLike(postId, button) {
                const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : ""%>";
                if (!userId) {
                    alert("Vui lòng đăng nhập để thích bài viết!");
                    window.location.href = "<%= request.getContextPath()%>/login";
                    return;
                }
                const isLiked = button.classList.contains("liked");
                const url = "<%= request.getContextPath()%>/forum/toggleLike";
                button.disabled = true;
                fetch(url, {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                button.querySelector(".like-count").textContent = `${data.voteCount} Thích`;
                                button.classList.toggle("liked");
                            } else {
                                alert(data.message || "Có lỗi xảy ra!");
                            }
                        })
                        .catch(error => {
                            console.error("Error:", error);
                            alert("Có lỗi xảy ra!");
                        })
                        .finally(() => {
                            button.disabled = false;
                        });
            }
            function focusCommentForm() {
                const commentText = document.getElementById('commentText');
                commentText.focus();
                commentText.scrollIntoView({behavior: 'smooth', block: 'center'});
            }
            function replyToComment(commentId) {
                const commentText = document.getElementById('commentText');
                commentText.value = `@comment-${commentId} `;
                commentText.focus();
                commentText.scrollIntoView({behavior: 'smooth', block: 'center'});
            }
            function sharePost() {
                if (navigator.share) {
                    navigator.share({title: document.title, url: window.location.href});
                } else {
                    navigator.clipboard.writeText(window.location.href).then(() => {
                        alert('Đã sao chép liên kết vào clipboard!');
                    });
                }
            }
            function confirmDelete(postId) {
                postIdToDelete = postId;
                document.getElementById('deleteModal').classList.add('active');
                document.body.style.overflow = 'hidden';
            }
            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.remove('active');
                document.body.style.overflow = '';
                postIdToDelete = null;
            }
            function deletePost() {
                if (postIdToDelete) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%= request.getContextPath()%>/forum/deletePost';
                    const postIdInput = document.createElement('input');
                    postIdInput.type = 'hidden';
                    postIdInput.name = 'postId';
                    postIdInput.value = postIdToDelete;
                    form.appendChild(postIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeDeleteModal();
                }
            });
            document.getElementById('commentText').addEventListener('input', function () {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        </script>

        <%@include file="chatbox.jsp" %>
    </body>
</html>