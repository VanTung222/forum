<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.*, java.text.SimpleDateFormat, java.sql.Timestamp" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) return "";
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
    <title>Trang cá nhân - <%= escapeHtml(((User) request.getAttribute("user")).getFullName()) %></title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/forum_css/userProfileForum.css" rel="stylesheet" />
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="<%= request.getContextPath() %>/" class="logo">
                <div class="logo-icon">
                    <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo" />
                </div>
                <span>JLPT Learning</span>
            </a>

            <nav class="nav">
                <a href="<%= request.getContextPath() %>/" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/courses" class="nav-link">
                    <i class="fas fa-book"></i>
                    <span>Khóa học</span>
                </a>
                <a href="<%= request.getContextPath() %>/forum" class="nav-link">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/profile" class="nav-link active">
                    <i class="fas fa-user"></i>
                    <span>Hồ sơ</span>
                </a>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <%
            User user = (User) request.getAttribute("user");
            List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
            List<ForumPost> userPosts = (List<ForumPost>) request.getAttribute("userPosts");
            List<Achievement> achievements = (List<Achievement>) request.getAttribute("achievements");
            UserActivityScore activityScore = (UserActivityScore) request.getAttribute("activityScore");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        %>

        <!-- Profile Header -->
        <div class="profile-header fade-in">
            <div class="cover-photo">
                <img src="<%= request.getContextPath() %>/assets/img/cover-default.jpg" alt="Cover Photo" />
            </div>
            <div class="profile-info">
                <div class="avatar-section">
                    <div class="avatar">
                        <img src="<%= request.getContextPath() %>/<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? escapeHtml(user.getProfilePicture()) : "assets/img/avatar.png" %>" alt="Avatar" />
                    </div>
                    <div class="profile-details">
                        <h1><%= escapeHtml(user.getFullName()) %></h1>
                        <div class="role">
                            <i class="fas fa-<%= user.getRole().equals("Student") ? "graduation-cap" : user.getRole().equals("Teacher") ? "chalkboard-teacher" : "user-shield" %>"></i>
                            <%= escapeHtml(user.getRole()) %>
                        </div>
                        <div class="profile-stats">
                            <div class="stat-item">
                                <div class="value"><%= enrolledCourses != null ? enrolledCourses.size() : 0 %></div>
                                <div class="label">Khóa học</div>
                            </div>
                            <div class="stat-item">
                                <div class="value"><%= userPosts != null ? userPosts.size() : 0 %></div>
                                <div class="label">Bài viết</div>
                            </div>
                            <div class="stat-item">
                                <div class="value"><%= activityScore != null ? activityScore.getTotalComments() : 0 %></div>
                                <div class="label">Bình luận</div>
                            </div>
                            <div class="stat-item">
                                <div class="value"><%= achievements != null ? achievements.size() : 0 %></div>
                                <div class="label">Thành tích</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar Left -->
        <aside class="sidebar-left">
            <!-- Quick Actions -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-bolt"></i>
                        Hành động nhanh
                    </h3>
                </div>
                <div class="widget-content">
                    <div class="quick-actions">
                        <a href="<%= request.getContextPath() %>/courses" class="action-btn">
                            <i class="fas fa-plus"></i>
                            Đăng ký khóa học
                        </a>
                        <a href="<%= request.getContextPath() %>/forum" class="action-btn">
                            <i class="fas fa-edit"></i>
                            Viết bài mới
                        </a>
                    </div>
                </div>
            </div>

            <!-- Personal Info -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-info-circle"></i>
                        Thông tin cá nhân
                    </h3>
                </div>
                <div class="widget-content">
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <div>
                            <strong>Email:</strong><br>
                            <span style="color: var(--text-secondary);"><%= escapeHtml(user.getEmail()) %></span>
                        </div>
                        <div>
                            <strong>Số điện thoại:</strong><br>
                            <span style="color: var(--text-secondary);"><%= user.getPhone() != null ? escapeHtml(user.getPhone()) : "Chưa cập nhật" %></span>
                        </div>
                        <div>
                            <strong>Ngày sinh:</strong><br>
                            <span style="color: var(--text-secondary);"><%= user.getBirthDate() != null ? sdf.format(user.getBirthDate()) : "Chưa cập nhật" %></span>
                        </div>
                        <div>
                            <strong>Ngày đăng ký:</strong><br>
                            <span style="color: var(--text-secondary);"><%= user.getRegistrationDate() != null ? sdf.format(user.getRegistrationDate()) : "Chưa có thông tin" %></span>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Course Progress -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-book-open"></i>
                        Tiến độ khóa học
                    </h3>
                </div>
                <div class="widget-content">
                    <%
                        if (enrolledCourses != null && !enrolledCourses.isEmpty()) {
                            for (Course course : enrolledCourses) {
                                // Calculate progress (this would come from your Progress table)
                                int progress = (int)(Math.random() * 100); // Mock data
                    %>
                    <div class="course-item">
                        <div class="course-icon">
                            <%= course.getTitle().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="course-info">
                            <div class="course-title"><%= escapeHtml(course.getTitle()) %></div>
                            <div class="course-progress"><%= progress %>% hoàn thành</div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= progress %>%;"></div>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="text-align: center; padding: 2rem; color: var(--text-muted);">
                        <i class="fas fa-book" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                        <p>Bạn chưa đăng ký khóa học nào</p>
                        <a href="<%= request.getContextPath() %>/courses" style="color: var(--primary); text-decoration: none; font-weight: 600;">Khám phá khóa học →</a>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Recent Forum Posts -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-comments"></i>
                        Bài viết gần đây
                    </h3>
                </div>
                <div class="widget-content">
                    <%
                        if (userPosts != null && !userPosts.isEmpty()) {
                            for (ForumPost post : userPosts) {
                    %>
                    <div class="post-item">
                        <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="post-title">
                            <%= escapeHtml(post.getTitle()) %>
                        </a>
                        <div class="post-meta">
                            <span><i class="fas fa-eye"></i> <%= post.getViewCount() %> lượt xem</span>
                            <span><i class="fas fa-thumbs-up"></i> <%= post.getVoteCount() %> lượt thích</span>
                            <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %> bình luận</span>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="text-align: center; padding: 2rem; color: var(--text-muted);">
                        <i class="fas fa-edit" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                        <p>Bạn chưa có bài viết nào</p>
                        <a href="<%= request.getContextPath() %>/forum" style="color: var(--primary); text-decoration: none; font-weight: 600;">Viết bài đầu tiên →</a>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </main>

        <!-- Sidebar Right -->
        <aside class="sidebar-right">
            <!-- Achievements -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-trophy"></i>
                        Thành tích
                    </h3>
                </div>
                <div class="widget-content">
                    <%
                        if (achievements != null && !achievements.isEmpty()) {
                    %>
                    <div class="achievement-grid">
                        <%
                            for (Achievement achievement : achievements) {
                        %>
                        <div class="achievement-card">
                            <div class="achievement-icon">
                                <i class="fas fa-<%= achievement.getAchievementType().equals("TopActiveUser") ? "star" : "medal" %>"></i>
                            </div>
                            <div class="achievement-title"><%= escapeHtml(achievement.getTitle()) %></div>
                            <div class="achievement-desc"><%= escapeHtml(achievement.getDescription()) %></div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                    <%
                        } else {
                    %>
                    <div style="text-align: center; padding: 2rem; color: var(--text-muted);">
                        <i class="fas fa-trophy" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                        <p>Chưa có thành tích nào</p>
                        <p style="font-size: 0.875rem;">Tham gia hoạt động để nhận thành tích!</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="widget fade-in">
                <div class="widget-header">
                    <h3 class="widget-title">
                        <i class="fas fa-clock"></i>
                        Hoạt động gần đây
                    </h3>
                </div>
                <div class="widget-content">
                    <!-- Mock recent activities -->
                    <div class="activity-item">
                        <div class="activity-icon comment">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Bình luận trong bài "Cách học Hiragana hiệu quả"</div>
                            <div class="activity-time">2 giờ trước</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon post">
                            <i class="fas fa-edit"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Đăng bài viết mới về JLPT N3</div>
                            <div class="activity-time">1 ngày trước</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon achievement">
                            <i class="fas fa-trophy"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-text">Nhận thành tích "Người dùng tích cực"</div>
                            <div class="activity-time">3 ngày trước</div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>
    </div>

    <script>
        // Add fade-in animation to elements when they come into view
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.fade-in').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
            observer.observe(el);
        });

        // Smooth scroll for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>
