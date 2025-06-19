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
    <style>
        :root {
            --primary: #4f8cff;
            --secondary: #232946;
            --accent: #f7c873;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg-primary: #ffffff;
            --bg-secondary: #f8fafc;
            --bg-tertiary: #f1f5f9;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --border: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            --radius: 12px;
            --radius-lg: 16px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary), #3b82f6);
            color: white;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: var(--shadow-lg);
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 72px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 700;
            font-size: 1.5rem;
            color: white;
            text-decoration: none;
        }

        .logo-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius);
            overflow: hidden;
            background: rgba(255, 255, 255, 0.1);
        }

        .logo-icon img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: var(--radius);
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.15);
        }

        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
            display: grid;
            grid-template-columns: 1fr 2fr 1fr;
            gap: 2rem;
            min-height: calc(100vh - 72px);
        }

        /* Profile Header */
        .profile-header {
            grid-column: 1 / -1;
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .cover-photo {
            height: 300px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .cover-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info {
            padding: 2rem;
            position: relative;
            margin-top: -80px;
        }

        .avatar-section {
            display: flex;
            align-items: end;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }

        .avatar {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 6px solid white;
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            background: var(--bg-primary);
        }

        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-details h1 {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .profile-details .role {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--primary);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 999px;
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item .value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }

        .stat-item .label {
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* Sidebar Left */
        .sidebar-left {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        /* Sidebar Right */
        .sidebar-right {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        /* Main Content */
        .main-content {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        /* Widget Styles */
        .widget {
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .widget-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            background: var(--bg-tertiary);
        }

        .widget-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .widget-content {
            padding: 1.5rem;
        }

        /* Course Progress */
        .course-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-radius: var(--radius);
            transition: all 0.3s;
            margin-bottom: 1rem;
        }

        .course-item:hover {
            background: var(--bg-tertiary);
        }

        .course-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius);
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }

        .course-info {
            flex: 1;
        }

        .course-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .course-progress {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        .progress-bar {
            width: 100%;
            height: 6px;
            background: var(--bg-tertiary);
            border-radius: 3px;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            transition: width 0.3s;
        }

        /* Recent Activity */
        .activity-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }

        .activity-icon.comment {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }

        .activity-icon.post {
            background: rgba(79, 140, 255, 0.1);
            color: var(--primary);
        }

        .activity-icon.achievement {
            background: rgba(245, 158, 11, 0.1);
            color: var(--warning);
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .activity-time {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        /* Achievements */
        .achievement-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .achievement-card {
            background: var(--bg-tertiary);
            border-radius: var(--radius);
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s;
        }

        .achievement-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .achievement-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--warning), #f97316);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 1.5rem;
        }

        .achievement-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .achievement-desc {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        /* Forum Posts */
        .post-item {
            padding: 1rem 0;
            border-bottom: 1px solid var(--border);
        }

        .post-item:last-child {
            border-bottom: none;
        }

        .post-title {
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
            margin-bottom: 0.5rem;
            display: block;
        }

        .post-title:hover {
            text-decoration: underline;
        }

        .post-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 1rem;
            background: var(--bg-tertiary);
            border: none;
            border-radius: var(--radius);
            color: var(--text-primary);
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
        }

        .action-btn:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .container {
                grid-template-columns: 1fr 2fr;
            }
            
            .sidebar-right {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
                padding: 1rem;
            }
            
            .sidebar-left {
                order: 2;
            }
            
            .main-content {
                order: 1;
            }
            
            .profile-info {
                padding: 1rem;
            }
            
            .avatar-section {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            
            .profile-details h1 {
                font-size: 2rem;
            }
            
            .profile-stats {
                justify-content: center;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Fade In Animation */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
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
                <a href="<%= request.getContextPath() %>/logout" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Đăng xuất</span>
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
