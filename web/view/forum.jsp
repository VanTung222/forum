<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Diễn Đàn Luyện Thi HIKARI</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/forum_css/mainForum.css" rel="stylesheet" />
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
                <a href="<%= request.getContextPath() %>/profile?user=" + userID() class="nav-link ">
                    <i class="fas fa-user"></i>
                    <span>Hồ sơ</span>
                </a>
                <div class="account-dropdown">
                        <div class="avatar">
                            <img src="<%= request.getContextPath()%>/assets/img/avatar.png" alt="Avatar" />
                        </div>

                </div>
            </nav>
        </div>
        <div class="layout">
            <aside class="sidebar-left">
                <div class="topics">
                    <div class="topics-title">Chủ Đề Thảo Luận</div>
                    <ul class="topic-list">
                        <li><a href="#" data-filter="all" class="active"><i class="fas fa-star"></i> Tất Cả</a></li>
                        <li><a href="#" data-filter="N5"><span>5</span> JLPT N5</a></li>
                        <li><a href="#" data-filter="N4"><span>4</span> JLPT N4</a></li>
                        <li><a href="#" data-filter="N3"><span>3</span> JLPT N3</a></li>
                        <li><a href="#" data-filter="N2"><span>2</span> JLPT N2</a></li>
                        <li><a href="#" data-filter="N1"><span>1</span> JLPT N1</a></li>
                        <li><a href="#" data-filter="Ngữ pháp"><i class="fas fa-language"></i> Ngữ Pháp</a></li>
                        <li><a href="#" data-filter="Kinh nghiệm thi"><i class="fas fa-lightbulb"></i> Kinh Nghiệm Thi</a></li>
                        <li><a href="#" data-filter="Tài liệu"><i class="fas fa-book"></i> Tài Liệu</a></li>
                        <li><a href="#" data-filter="Công cụ"><i class="fas fa-tools"></i> Công Cụ</a></li>
                    </ul>
                </div>
            </aside>
            <main class="main-content">
                <%
                    String message = (String) session.getAttribute("message");
                    if (message != null && !message.isEmpty()) {
                %>
                <div class="alert alert-success">
                    <%= escapeHtml(message)%>
                </div>
                <%
                        session.removeAttribute("message");
                    }
                %>
                <div class="forum-toolbar">
                    <h1>Bài Viết Mới Nhất</h1>
                    <div class="toolbar-actions">
                        <div class="search-container" style="position: relative;">
                            <input type="text" id="searchInput" placeholder="Tìm kiếm bài viết..." value="<%= request.getParameter("search") != null ? escapeHtml(request.getParameter("search")) : ""%>">
                            <div id="suggestionList" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: #fff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); z-index: 100; max-height: 200px; overflow-y: auto;"></div>
                        </div>
                        <button class="btn btn-primary" onclick="handleSearch()"><i class="fas fa-search"></i> Tìm</button>
                        <button class="btn btn-primary" onclick="openPostModal()">
                            <i class="fas fa-plus"></i> Tạo Bài Viết Mới
                        </button>
                        <div class="filters">
                            <select id="sortSelect" onchange="handleSortChange()">
                                <option value="newest" <%= "newest".equals(request.getAttribute("sort")) ? "selected" : ""%>>Mới Nhất</option>
                                <option value="popular" <%= "popular".equals(request.getAttribute("sort")) ? "selected" : ""%>>Phổ Biến</option>
                                <option value="most-liked" <%= "most-liked".equals(request.getAttribute("sort")) ? "selected" : ""%>>Được Thích Nhiều</option>
                            </select>
                            <select id="filterSelect" onchange="handleFilterChange()">
                                <option value="all" <%= "all".equals(request.getAttribute("filter")) ? "selected" : ""%>>Tất Cả</option>
                                <option value="with-replies" <%= "with-replies".equals(request.getAttribute("filter")) ? "selected" : ""%>>Có Phản Hồi</option>
                                <option value="no-replies" <%= "no-replies".equals(request.getAttribute("filter")) ? "selected" : ""%>Chưa Có Phản Hồi</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="post-list">
                    <%
                        List<ForumPost> posts = (List<ForumPost>) request.getAttribute("posts");
                        String userId = (String) request.getSession().getAttribute("userId");
                        ForumPostDAO postDAO = new ForumPostDAO();
                        if (posts == null || posts.isEmpty()) {
                    %>
                    <p>Chưa có bài viết nào.</p>
                    <%
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        for (ForumPost post : posts) {
                            String postPicture = post.getPicture() != null ? post.getPicture() : "";
                            Timestamp createdDate = post.getCreatedDate();
                            String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                            boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);
                    %>
                    <div class="post-card" data-tags="<%= escapeHtml(post.getCategory())%>">
                        <div class="post-content">
                            <div class="post-header">
                                <%-- Update avatar image to be a clickable link --%>
                                <a href="<%= request.getContextPath()%>/profile?userId=<%= escapeHtml(post.getPostedBy())%>" class="avatar" style="text-decoration: none;">
                                    <img src="<%= request.getContextPath()%>/assets/images/avatar<%= escapeHtml(post.getPostedBy())%>.png" alt="Avatar" />
                                </a>
                                <div class="author-info">
                                    <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy()))%></span>
                                    <div class="post-meta">
                                        <span><i class="fas fa-clock"></i> <%= formattedDate%></span>
                                        <span><i class="fas fa-eye"></i> <%= post.getViewCount()%></span>
                                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount()%></span>
                                    </div>
                                </div>
                                <div class="post-tags">
                                    <span class="tag"><%= escapeHtml(post.getCategory())%></span>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="post-title"><%= escapeHtml(post.getTitle())%></a>
                            <div class="post-body">
                                <p><%= escapeHtml(post.getContent())%></p>
                            </div>
                            <% if (!postPicture.isEmpty()) {%>
                            <div class="post-image">
                                <img src="<%= request.getContextPath()%>/<%= escapeHtml(postPicture)%>" alt="Post image" />
                            </div>
                            <% }%>
                            <div class="post-actions">
                                <button class="action-btn like-btn <%= hasLiked ? "liked" : ""%>" onclick="toggleLike(<%= post.getId()%>, this)">
                                    <i class="fas fa-thumbs-up"></i> <span class="like-count"><%= post.getVoteCount()%></span>
                                </button>
                                <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="action-btn comment-btn">
                                    <i class="fas fa-comment"></i> <%= post.getCommentCount()%>
                                </a>
                            </div>
                            <div class="comment-section" id="comment-section-<%= post.getId()%>" style="display:none;">
                                <%
                                    List<ForumComment> comments = post.getComments();
                                    if (comments != null) {
                                        for (ForumComment comment : comments) {
                                            Timestamp commentDate = comment.getCommentedDate();
                                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                                %>
                                <div class="comment">
                                    <div class="avatar sm">
                                        <img src="<%= request.getContextPath()%>/assets/images/avatar.png" alt="Avatar" />
                                    </div>
                                    <div class="comment-content">
                                        <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy()))%></span>
                                        <p><%= escapeHtml(comment.getCommentText())%></p>
                                        <span class="comment-time"><i class="fas fa-clock"></i> <%= formattedCommentDate%></span>
                                        <button class="action-btn">
                                            <i class="fas fa-thumbs-up"></i> <%= comment.getVoteCount()%>
                                        </button>
                                    </div>
                                </div>
                                <%
                                        }
                                    }
                                %>
                                <form action="<%= request.getContextPath()%>/forum/createComment" method="post" class="comment-form">
                                    <input type="hidden" name="postId" value="${post.id}">
                                    <textarea name="commentText" placeholder="Viết bình luận..." required></textarea>
                                    <button type="submit" class="btn btn-primary">Gửi</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="pagination">
                    <%
                        Integer pageNum = (Integer) request.getAttribute("page");
                        String sort = (String) request.getAttribute("sort");
                        String filter = (String) request.getAttribute("filter");
                        String search = request.getParameter("search") != null ? request.getParameter("search") : "";
                        if (pageNum != null && pageNum > 1) {
                    %>
                    <a href="<%= request.getContextPath()%>/forum?sort=<%= escapeHtml(sort)%>&filter=<%= escapeHtml(filter)%>&search=<%= escapeHtml(search)%>&page=<%= pageNum - 1%>">« Trang Trước</a>
                    <%
                        }
                        if (posts != null && !posts.isEmpty()) {
                    %>
                    <a href="<%= request.getContextPath()%>/forum?sort=<%= escapeHtml(sort)%>&filter=<%= escapeHtml(filter)%>&search=<%= escapeHtml(search)%>&page=<%= pageNum != null ? pageNum + 1 : 2%>">Trang Sau »</a>
                    <%
                        }
                    %>
                </div>
            </main>
            <aside class="sidebar-right">
                <!-- User Card -->
                <div class="widget" style="padding:0;overflow:hidden;">
                    <div style="background:linear-gradient(135deg,#6a85f1 0%,#b8c6ff 100%);height:90px;position:relative;">
                        <img src="<%= request.getContextPath()%>/assets/img/backgroundLogin.png" alt="Cover" style="width:100%;height:100%;object-fit:cover;opacity:0.7;position:absolute;top:0;left:0;">
                    </div>
                    <div style="display:flex;flex-direction:column;align-items:center;padding:0 0 18px 0;position:relative;top:-40px;">
                        <div style="width:80px;height:80px;border-radius:50%;overflow:hidden;border:4px solid #fff;box-shadow:0 2px 8px rgba(0,0,0,0.08);background:#fff;">
                            <img src="<%= request.getContextPath()%>/<%= request.getAttribute("user") != null && ((model.User) request.getAttribute("user")).getProfilePicture() != null && !((model.User) request.getAttribute("user")).getProfilePicture().isEmpty() ? ((model.User) request.getAttribute("user")).getProfilePicture() : "assets/img/avatar.png"%>" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                        </div>
                        <div style="margin-top:10px;text-align:center;">
                            <div style="color:#888;font-size:1em;">Welcome back,</div>
                            <div style="font-weight:700;font-size:1.2em;">
                                <%= escapeHtml(((model.User) request.getAttribute("user")).getUsername())%>
                            </div>
                            <div style="color:#888;font-size:0.98em;">
                                <%= escapeHtml(((model.User) request.getAttribute("user")).getRole())%>
                            </div>
                            <% if (((model.User) request.getAttribute("user")).getRole() != null && ((model.User) request.getAttribute("user")).getRole().toLowerCase().contains("admin")) { %>
                            <span style="display:inline-block;margin-top:7px;padding:2px 14px;font-size:0.95em;background:linear-gradient(90deg,#a18cd1 0%,#fbc2eb 100%);color:#5a189a;border-radius:12px;font-weight:600;">Admin</span>
                            <% }%>
                        </div>
                    </div>
                </div>
                <!-- Leaderboard -->
                <div class="widget" style="padding-top:18px;">
                    <div style="font-size:1.15em;font-weight:700;color:#232946;margin-bottom:18px;display:flex;align-items:center;gap:10px;">
                        <i class="fas fa-trophy" style="color:#f7c873;"></i> Leaderboard
                    </div>
                    <div style="display:flex;gap:8px;margin-bottom:18px;">
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "weekly".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=weekly&filter=<%= escapeHtml((String) request.getAttribute("filter"))%>&search=<%= escapeHtml(request.getParameter("search") != null ? request.getParameter("search") : "")%>'">This Week</button>
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "monthly".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=monthly&filter=<%= escapeHtml((String) request.getAttribute("filter"))%>&search=<%= escapeHtml(request.getParameter("search") != null ? request.getParameter("search") : "")%>'">This Month</button>
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "alltime".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=alltime&filter=<%= escapeHtml((String) request.getAttribute("filter"))%>&search=<%= escapeHtml(request.getParameter("search") != null ? request.getParameter("search") : "")%>'">All Time</button>
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
                                <img src="<%= request.getContextPath()%>/<%= second.getUser().getProfilePicture() != null && !second.getUser().getProfilePicture().isEmpty() ? second.getUser().getProfilePicture() : "/assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= escapeHtml(second.getUser().getUsername())%></div>
                            <div style="color:#888;font-size:0.95em;"><%= second.getTotalScore()%></div>
                        </div>
                        <% } %>
                        <% if (first != null) {%>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <div style="width:60px;height:60px;border-radius:50%;overflow:hidden;border:3px solid #f7c873;box-shadow:0 2px 8px #f7c87344;">
                                <img src="<%= request.getContextPath()%>/<%= first.getUser().getProfilePicture() != null && !first.getUser().getProfilePicture().isEmpty() ? first.getUser().getProfilePicture() : "/assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
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
                        <div style="display:flex;align-items:center;gap:10px;padding:7px 0 7px 0;border-radius:8px;<%= i == 4 ? "background:#f4f6fb;" : ""%>">
                            <div style="width:28px;text-align:center;font-weight:600;color:#232946;font-size:1.08em;"><%= rank%></div>
                            <div style="width:32px;height:32px;border-radius:50%;overflow:hidden;">
                                <img src="<%= request.getContextPath()%>/<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="flex:1;">
                                <div style="font-weight:600;font-size:1em;color:#232946;"><%= escapeHtml(user.getUsername())%></div>
                            </div>
                            <div style="color:#888;font-size:1em;font-weight:500;"><%= score.getTotalScore()%></div>
                        </div>
                        <%      rank++;
                                }
                            }
                        %>
                    </div>
                </div>
            </aside>

        </div>
        <div class="modal-overlay" id="createPostModal">
            <div class="modal">
                <div class="modal-header">
                    <h2 class="modal-title">Tạo Bài Viết Mới</h2>
                    <button class="btn" onclick="closePostModal()"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <form id="createPostForm" action="<%= request.getContextPath()%>/forum/createPost" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label" for="postTitle">Tiêu đề</label>
                            <input type="text" class="form-control" id="postTitle" name="postTitle" placeholder="Nhập tiêu đề bài viết..." required maxlength="200" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="postCategory">Chủ đề</label>
                            <select class="form-control" id="postCategory" name="postCategory" required>
                                <option value="">Chọn chủ đề</option>
                                <option value="N5">JLPT N5</option>
                                <option value="N4">JLPT N4</option>
                                <option value="N3">JLPT N3</option>
                                <option value="N2">JLPT N2</option>
                                <option value="N1">JLPT N1</option>
                                <option value="Ngữ pháp">Ngữ Pháp</option>
                                <option value="Kinh nghiệm thi">Kinh Nghiệm Thi</option>
                                <option value="Tài liệu">Tài Liệu</option>
                                <option value="Công cụ">Công Cụ</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="postContent">Nội Dung</label>
                            <textarea class="form-control" id="postContent" name="postContent" rows="6" placeholder="Nhập nội dung bài viết..." required maxlength="5000"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Hình Ảnh</label>
                            <div class="image-upload" onclick="document.getElementById('imageInput').click()">
                                <input type="file" id="imageInput" name="imageInput" accept="image/*" onchange="previewImage(event)" />
                                <i class="fas fa-cloud-upload-alt" style="font-size: 2em; margin-bottom: 10px"></i>
                                <p>Nhấp để chọn hình ảnh hoặc kéo thả vào đây</p>
                                <img id="imagePreview" class="image-preview" style="display:none;" alt="Preview" />
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" onclick="document.getElementById('createPostForm').submit()">Đăng Bài</button>
                    <button class="btn" onclick="closePostModal()">Đóng</button>
                </div>
            </div>
        </div>
        <script>
            
            function openPostModal() {
                document.getElementById("createPostModal").classList.add("active");
            }
            function closePostModal() {
                document.getElementById("createPostModal").classList.remove("active");
            }
            function previewImage(event) {
                const file = event.target.files[0];
                const preview = document.getElementById("imagePreview");
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = "block";
                    };
                    reader.readAsDataURL(file);
                }
            }
            function openCommentSection(postId) {
                const section = document.getElementById("comment-section-" + postId);
                section.style.display = section.style.display === "none" ? "block" : "none";
            }
            function toggleLike(postId, button) {
                const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : ""%>";
                if (!userId) {
                    alert("Vui lòng đăng nhập để thích bài viết!");
                    window.location.href = "<%= request.getContextPath()%>/login";
                    return;
                }
                const isLiked = button.classList.contains("liked");
                const url = "<%= request.getContextPath()%>/forum/toggleLike";
                fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                const likeCountSpan = button.querySelector(".like-count");
                                likeCountSpan.textContent = data.voteCount;
                                if (isLiked) {
                                    button.classList.remove("liked");
                                } else {
                                    button.classList.add("liked");
                                }
                            } else {
                                alert(data.message || "Có lỗi xảy ra khi thích bài viết!");
                            }
                        })
                        .catch(error => {
                            console.error("Error:", error);
                            alert("Có lỗi xảy ra khi thích bài viết!");
                        });
            }
            function handleSearch() {
                const search = document.getElementById("searchInput").value.trim();
                const sort = document.getElementById("sortSelect").value;
                const filter = document.getElementById("filterSelect").value;
                window.location.href = "<%= request.getContextPath()%>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
            }
            document.querySelectorAll(".topic-list a").forEach(function (link) {
                link.addEventListener("click", function (e) {
                    e.preventDefault();
                    const topic = link.getAttribute("data-filter");
                    document.querySelectorAll(".topic-list a").forEach(function (l) {
                        l.classList.remove("active");
                    });
                    link.classList.add("active");
                    const posts = document.querySelectorAll(".post-card");
                    posts.forEach(function (post) {
                        const tags = post.getAttribute("data-tags");
                        if (topic === "all" || tags === topic) {
                            post.style.display = "flex";
                        } else {
                            post.style.display = "none";
                        }
                    });
                });
            });
            document.getElementById("createPostModal").addEventListener("click", function (e) {
                if (e.target === this) {
                    closePostModal();
                }
            });
            function toggleMobileMenu() {
                document.querySelector(".sidebar-left").classList.toggle("active");
            }
            function handleSortChange() {
                const sort = document.getElementById("sortSelect").value;
                const filter = document.getElementById("filterSelect").value;
                const search = document.getElementById("searchInput").value.trim();
                window.location.href = "<%= request.getContextPath()%>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
            }
            function handleFilterChange() {
                const sort = document.getElementById("sortSelect").value;
                const filter = document.getElementById("filterSelect").value;
                const search = document.getElementById("searchInput").value.trim();
                window.location.href = "<%= request.getContextPath()%>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
            }
            document.getElementById("searchInput").addEventListener("keypress", function (e) {
                if (e.key === "Enter") {
                    handleSearch();
                }
            });
            document.querySelector('.topic-list a[data-filter="all"]').click();
        </script>
        <%@include file="chatbox.jsp" %>
    </body>
</html>
