<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.UserDAO, model.ForumPost, model.ForumComment, model.UserActivityScore, model.User, java.text.SimpleDateFormat, java.sql.Timestamp, dao.ForumPostDAO" %>
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
    <title>Chi tiết bài viết - JLPT Forum</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        html, body {
            height: 100%;
            min-height: 100vh;
            width: 100vw;
            background: linear-gradient(135deg, #f0f4f8 0%, #e0e7ef 100%);
            overflow-x: hidden;
        }
        body {
            min-height: 100vh;
            width: 100vw;
            display: flex;
            flex-direction: column;
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            color: #222b45;
            background: transparent;
        }
        .header {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px 0 rgba(0,0,0,0.03);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
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
            color: #2563eb;
            text-decoration: none;
            letter-spacing: 1px;
        }
        .logo-icon img {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            box-shadow: 0 2px 8px 0 rgba(59,130,246,0.08);
        }
        .nav {
            display: flex;
            align-items: center;
            gap: 2rem;
        }
        .nav-link {
            color: #64748b;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }
        .nav-link:hover, .nav-link.active {
            color: #2563eb;
            background: #f1f5f9;
        }
        .user-menu {
            position: relative;
        }
        .user-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: none;
            background: #f1f5f9;
            border-radius: 999px;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
        }
        .user-btn:hover {
            background: #e0e7ef;
        }
        .avatar img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid #e5e7eb;
            object-fit: cover;
        }
        .dropdown {
            position: absolute;
            top: 110%;
            right: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.08);
            min-width: 220px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s;
            z-index: 50;
        }
        .dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            color: #222b45;
            text-decoration: none;
            transition: all 0.2s;
            border-bottom: 1px solid #f1f5f9;
            font-size: 1rem;
        }
        .dropdown-item:last-child {
            border-bottom: none;
        }
        .dropdown-item:hover {
            background: #f1f5f9;
            color: #2563eb;
        }
        .container {
            flex: 1 1 auto;
            width: 100vw;
            min-height: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 2.5rem 0;
            background: transparent;
        }
        .main-content {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            background: transparent;
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
        }
        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            color: #94a3b8;
            font-size: 1rem;
            font-weight: 500;
        }

        .breadcrumb a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: #64748b;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            font-size: 1rem;
        }

        .back-button:hover {
            color: #2563eb;
        }

        /* Post Container */
        .post-container {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px 0 rgba(59,130,246,0.08);
            overflow: hidden;
            margin-bottom: 2rem;
            border: none;
            transition: box-shadow 0.2s;
        }

        /* Post Header */
        .post-header {
            padding: 2rem 2.5rem 1.5rem 2.5rem;
            border-bottom: 1px solid #f1f5f9;
            background: linear-gradient(90deg, #f1f5f9 60%, #e0e7ef 100%);
        }

        .post-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
        }

        .author-info {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .author-avatar img {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            border: 2px solid #e5e7eb;
            object-fit: cover;
        }

        .author-details h3 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #222b45;
            margin-bottom: 0.15rem;
        }

        .author-details p {
            color: #64748b;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .post-actions {
            position: relative;
        }

        .actions-btn {
            width: 40px;
            height: 40px;
            border: none;
            background: #f1f5f9;
            color: #64748b;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            font-size: 1.2rem;
        }

        .actions-btn:hover {
            background: #e0e7ef;
            color: #2563eb;
        }

        .actions-menu {
            position: absolute;
            top: 110%;
            right: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.08);
            min-width: 160px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s;
            z-index: 50;
        }

        .actions-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .actions-menu a,
        .actions-menu button {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.5rem;
            color: #222b45;
            text-decoration: none;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 1px solid #f1f5f9;
            font-size: 1rem;
        }

        .actions-menu a:last-child,
        .actions-menu button:last-child {
            border-bottom: none;
        }

        .actions-menu a:hover,
        .actions-menu button:hover {
            background: #f1f5f9;
            color: #2563eb;
        }

        .actions-menu .delete-btn {
            color: #ef4444;
        }

        .actions-menu .delete-btn:hover {
            background: #fee2e2;
        }

        .post-title {
            font-size: 2.2rem;
            font-weight: 800;
            color: #222b45;
            line-height: 1.2;
            margin-bottom: 0.75rem;
            letter-spacing: -1px;
        }

        .post-category {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: #e0e7ef;
            color: #2563eb;
            padding: 0.4rem 1rem;
            border-radius: 999px;
            font-size: 1rem;
            font-weight: 600;
            margin-top: 0.5rem;
        }

        /* Post Content */
        .post-content {
            padding: 2rem 2.5rem;
            background: #fff;
        }

        .post-image {
            width: 100%;
            max-height: 420px;
            border-radius: 18px;
            overflow: hidden;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 16px 0 rgba(59,130,246,0.08);
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .post-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 18px;
        }

        .post-text {
            font-size: 1.15rem;
            line-height: 1.8;
            color: #222b45;
            word-break: break-word;
            padding: 0.5rem 0;
        }

        /* Post Stats */
        .post-stats {
            padding: 1.25rem 2.5rem;
            border-top: 1px solid #f1f5f9;
            border-bottom: 1px solid #f1f5f9;
            background: #f9fafb;
        }

        .stats-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
        }

        .stats-info {
            display: flex;
            align-items: center;
            gap: 2rem;
            color: #64748b;
            font-size: 1rem;
            font-weight: 500;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .interaction-buttons {
            display: flex;
            gap: 1rem;
        }

        .interaction-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.4rem;
            border: 1.5px solid #e5e7eb;
            background: #fff;
            color: #64748b;
            border-radius: 999px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 1rem;
            font-weight: 600;
            box-shadow: 0 2px 8px 0 rgba(59,130,246,0.03);
        }

        .interaction-btn:hover {
            background: #f1f5f9;
            color: #2563eb;
            border-color: #2563eb;
        }

        .interaction-btn.liked {
            background: #2563eb;
            color: #fff;
            border-color: #2563eb;
            box-shadow: 0 4px 16px 0 rgba(59,130,246,0.08);
        }

        /* Comments Section */
        .comments-section {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px 0 rgba(59,130,246,0.08);
            overflow: hidden;
            margin-top: 2rem;
            border: none;
        }

        .comments-header {
            padding: 1.5rem 2.5rem;
            border-bottom: 1px solid #f1f5f9;
            background: #f9fafb;
        }

        .comments-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #222b45;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .comments-list {
            padding: 0;
        }

        .comment-item {
            padding: 1.5rem 2.5rem;
            border-bottom: 1px solid #f1f5f9;
            background: #fff;
            transition: background 0.2s;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.5rem;
        }

        .comment-avatar img {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            border: 2px solid #e5e7eb;
            object-fit: cover;
        }

        .comment-author {
            font-weight: 700;
            color: #222b45;
            text-decoration: none;
            font-size: 1rem;
        }

        .comment-author:hover {
            color: #2563eb;
        }

        .comment-date {
            color: #94a3b8;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .comment-content {
            margin-bottom: 0.75rem;
            line-height: 1.7;
            font-size: 1.05rem;
            color: #222b45;
            word-break: break-word;
        }

        .comment-actions {
            display: flex;
            gap: 1.5rem;
        }

        .comment-action {
            display: flex;
            align-items: center;
            gap: 0.3rem;
            color: #64748b;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 8px;
            padding: 0.3rem 0.8rem;
            transition: all 0.2s;
        }

        .comment-action:hover {
            color: #2563eb;
            background: #f1f5f9;
        }

        /* Comment Form */
        .comment-form {
            padding: 1.5rem 2.5rem;
            border-top: 1px solid #f1f5f9;
            background: #f9fafb;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-control {
            width: 100%;
            padding: 1rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 16px;
            background: #fff;
            color: #222b45;
            transition: all 0.2s;
            resize: vertical;
            min-height: 110px;
            font-size: 1.05rem;
            font-family: inherit;
            box-shadow: 0 2px 8px 0 rgba(59,130,246,0.03);
        }

        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.08);
        }

        .form-footer {
            display: flex;
            justify-content: flex-end;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 999px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 1rem;
        }

        .btn-primary {
            background: #2563eb;
            color: #fff;
            box-shadow: 0 2px 8px 0 rgba(59,130,246,0.08);
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 4px 16px 0 rgba(59,130,246,0.12);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #64748b;
            border: 1.5px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e0e7ef;
            color: #2563eb;
        }

        .btn-danger {
            background: #ef4444;
            color: #fff;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        /* Related Posts */
        .related-posts {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px 0 rgba(59,130,246,0.08);
            overflow: hidden;
            margin-top: 2rem;
            border: none;
        }

        .related-header {
            padding: 1.5rem 2.5rem;
            border-bottom: 1px solid #f1f5f9;
            background: #f9fafb;
        }

        .related-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #222b45;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .related-list {
            padding: 0;
        }

        .related-item {
            display: flex;
            gap: 1.25rem;
            padding: 1.2rem 2.5rem;
            border-bottom: 1px solid #f1f5f9;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
            align-items: center;
            background: #fff;
        }

        .related-item:hover {
            background: #f1f5f9;
            box-shadow: 0 2px 8px 0 rgba(59,130,246,0.06);
        }

        .related-item:last-child {
            border-bottom: none;
        }

        .related-image img {
            width: 90px;
            height: 68px;
            border-radius: 12px;
            object-fit: cover;
            background: #f1f5f9;
        }

        .related-content {
            flex: 1;
            min-width: 0;
        }

        .related-post-title {
            font-weight: 700;
            color: #222b45;
            margin-bottom: 0.25rem;
            line-height: 1.4;
            font-size: 1.08rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .related-meta {
            color: #94a3b8;
            font-size: 0.95rem;
            display: flex;
            gap: 1.2rem;
            font-weight: 500;
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s;
        }

        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .modal {
            background: #fff;
            border-radius: 24px;
            width: 90%;
            max-width: 420px;
            box-shadow: 0 8px 32px 0 rgba(59,130,246,0.12);
            transform: scale(0.95);
            transition: transform 0.3s;
        }

        .modal-overlay.active .modal {
            transform: scale(1);
        }

        .modal-header {
            padding: 2rem 1.5rem 1rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
            text-align: center;
        }

        .modal-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #222b45;
            margin-bottom: 0.5rem;
        }

        .modal-text {
            color: #64748b;
            line-height: 1.5;
            font-size: 1.05rem;
        }

        .modal-footer {
            padding: 1.5rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        /* Alert */
        .alert {
            padding: 1.1rem 1.5rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.05rem;
            font-weight: 600;
        }

        .alert-success {
            background: rgb(16 185 129 / 0.1);
            color: #10b981;
            border: 1.5px solid rgb(16 185 129 / 0.2);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            color: #94a3b8;
            background: transparent;
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.15rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #64748b;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .header-container, .main-content, .post-header, .post-content, .post-stats, .comments-header, .comment-item, .comment-form, .related-header, .related-item {
                padding-left: 1.2rem !important;
                padding-right: 1.2rem !important;
            }
        }
        @media (max-width: 768px) {
            .header-container {
                padding: 0 0.5rem;
            }
            .main-content {
                padding: 0 0.5rem;
            }
            .post-header, .post-content, .post-stats, .comments-header, .comment-item, .comment-form, .related-header, .related-item {
                padding: 0.5rem !important;
            }
            .post-title {
                font-size: 1.3rem;
            }
            .post-header {
                padding: 1.2rem 0.5rem 1rem 0.5rem;
            }
            .post-content {
                padding: 1rem 0.5rem;
            }
            .post-stats {
                padding: 1rem 0.5rem;
            }
            .comments-header, .comment-item, .comment-form, .related-header, .related-item {
                padding: 1rem 0.5rem;
            }
            .author-avatar img, .comment-avatar img {
                width: 36px;
                height: 36px;
            }
            .related-image img {
                width: 60px;
                height: 44px;
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
                <span>JLPT Forum</span>
            </a>

            <nav class="nav">
                <a href="<%= request.getContextPath() %>/" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/forum" class="nav-link">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/contact" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Liên hệ</span>
                </a>

                <div class="user-menu">
                    <button class="user-btn" onclick="toggleUserMenu()">
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                        <span><%= escapeHtml((String) request.getAttribute("username")) %></span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="dropdown" id="userDropdown">
                        <% 
                            String username = (String) request.getAttribute("username");
                            if ("Guest".equals(username)) {
                        %>
                            <a href="<%= request.getContextPath() %>/login" class="dropdown-item">
                                <i class="fas fa-sign-in-alt"></i>
                                Đăng nhập
                            </a>
                        <% 
                            } else {
                        %>
                            <a href="<%= request.getContextPath() %>/profile" class="dropdown-item">
                                <i class="fas fa-user"></i>
                                Hồ sơ cá nhân
                            </a>
                            <a href="<%= request.getContextPath() %>/settings" class="dropdown-item">
                                <i class="fas fa-cog"></i>
                                Cài đặt
                            </a>
                            <a href="<%= request.getContextPath() %>/logout" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i>
                                Đăng xuất
                            </a>
                        <% 
                            }
                        %>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <div class="main-content">
            <!-- Breadcrumb -->
            <nav class="breadcrumb">
                <a href="<%= request.getContextPath() %>/forum">
                    <i class="fas fa-comments"></i>
                    Diễn đàn
                </a>
                <i class="fas fa-chevron-right"></i>
                <span>Chi tiết bài viết</span>
            </nav>

            <!-- Back Button -->
            <a href="<%= request.getContextPath() %>/forum" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Quay lại diễn đàn
            </a>

            <!-- Alert -->
            <% 
                String message = (String) session.getAttribute("message");
                if (message != null && !message.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= escapeHtml(message) %>
                </div>
                <% 
                    session.removeAttribute("message");
                }
            %>

            <% 
                ForumPost post = (ForumPost) request.getAttribute("postDetail");
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
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    String postPicture = post.getPicture() != null ? post.getPicture() : "";
                    Timestamp createdDate = post.getCreatedDate();
                    String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                    boolean hasLiked = currentUserId != null && postDAO.hasUserLikedPost(post.getId(), currentUserId);
                    boolean isAuthor = currentUserId != null && post.getPostedBy().equals(currentUserId);
            %>

            <!-- Post Container -->
            <article class="post-container" style="margin-bottom:0;">
                <!-- Post Header -->
                <header class="post-header">
                    <div class="post-meta">
                        <div class="author-info">
                            <div class="author-avatar">
                                <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                            </div>
                            <div class="author-details">
                                <h3>
                                    <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(post.getPostedBy()) %>" style="color: inherit; text-decoration: none;">
                                        <%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %>
                                    </a>
                                </h3>
                                <p>
                                    <i class="fas fa-clock"></i>
                                    <%= formattedDate %>
                                </p>
                            </div>
                        </div>
                        <% if (isAuthor) { %>
                        <div class="post-actions">
                            <button class="actions-btn" onclick="toggleActionsMenu()">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                            <div class="actions-menu" id="actionsMenu">
                                <a href="<%= request.getContextPath() %>/forum/editPost/<%= post.getId() %>">
                                    <i class="fas fa-edit"></i>
                                    Chỉnh sửa
                                </a>
                                <button class="delete-btn" onclick="confirmDelete(<%= post.getId() %>)">
                                    <i class="fas fa-trash"></i>
                                    Xóa bài viết
                                </button>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <h1 class="post-title"><%= escapeHtml(post.getTitle()) %></h1>
                    <div class="post-category">
                        <i class="fas fa-tag"></i>
                        <%= escapeHtml(post.getCategory()) %>
                    </div>
                </header>

                <!-- Post Content -->
                <div class="post-content">
                    <% if (postPicture != null && !postPicture.isEmpty()) { %>
                        <div class="post-image">
                            <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                        </div>
                    <% } %>
                    <div class="post-text">
                        <%= escapeHtml(post.getContent()).replace("\n", "<br>") %>
                    </div>
                </div>

                <!-- Post Stats -->
                <div class="post-stats">
                    <div class="stats-row">
                        <div class="stats-info">
                            <div class="stat-item">
                                <i class="fas fa-thumbs-up"></i>
                                <span><%= post.getVoteCount() %> lượt thích</span>
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-comment"></i>
                                <span><%= post.getCommentCount() %> bình luận</span>
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-eye"></i>
                                <span><%= post.getViewCount() %> lượt xem</span>
                            </div>
                        </div>
                        <div class="interaction-buttons">
                            <button class="interaction-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                                <i class="fas fa-thumbs-up"></i>
                                <span class="like-count"><%= post.getVoteCount() %></span>
                            </button>
                            <button class="interaction-btn" onclick="focusCommentForm()">
                                <i class="fas fa-comment"></i>
                                Bình luận
                            </button>
                            <button class="interaction-btn" onclick="sharePost()">
                                <i class="fas fa-share"></i>
                                Chia sẻ
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Comments Section (gắn liền với bài viết) -->
                <section class="comments-section" style="margin-top:0; border-radius:0 0 24px 24px; box-shadow:none; border-top:1px solid #f1f5f9;">
                    <div class="comments-header">
                        <h2 class="comments-title">
                            <i class="fas fa-comments"></i>
                            Bình luận (<%= post.getCommentCount() %>)
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
                                        <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                                    </div>
                                    <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(comment.getCommentedBy()) %>" class="comment-author">
                                        <%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %>
                                    </a>
                                    <span class="comment-date">
                                        <i class="fas fa-clock"></i>
                                        <%= formattedCommentDate %>
                                    </span>
                                </div>
                                <div class="comment-content">
                                    <%= escapeHtml(comment.getCommentText()).replace("\n", "<br>") %>
                                </div>
                                <div class="comment-actions">
                                    <button class="comment-action">
                                        <i class="fas fa-thumbs-up"></i>
                                        <%= comment.getVoteCount() %>
                                    </button>
                                    <button class="comment-action" onclick="replyToComment(<%= comment.getId() %>)">
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
                    <!-- Comment Form -->
                    <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form" id="commentForm">
                        <input type="hidden" name="postId" value="<%= post.getId() %>">
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

            <!-- Related Posts -->
            <section class="related-posts">
                <div class="related-header">
                    <h2 class="related-title">
                        <i class="fas fa-link"></i>
                        Bài viết liên quan
                    </h2>
                </div>
                <div class="related-list">
                    <% 
                        List<ForumPost> relatedPosts = (List<ForumPost>) request.getAttribute("relatedPosts");
                        if (relatedPosts != null && !relatedPosts.isEmpty()) {
                            for (ForumPost relatedPost : relatedPosts) {
                                String relatedPicture = relatedPost.getPicture() != null ? relatedPost.getPicture() : "";
                                Timestamp relatedDate = relatedPost.getCreatedDate();
                                String formattedRelatedDate = relatedDate != null ? sdf.format(relatedDate) : "";
                    %>
                    <a href="<%= request.getContextPath() %>/forum/post/<%= relatedPost.getId() %>" class="related-item">
                        <div class="related-image">
                            <img src="<%= request.getContextPath() %>/<%= relatedPicture != null && !relatedPicture.isEmpty() ? escapeHtml(relatedPicture) : "assets/img/learning.jpg" %>" alt="Related post" />
                        </div>
                        <div class="related-content">
                            <h3 class="related-post-title">
                                <%= escapeHtml(relatedPost.getTitle()) %>
                            </h3>
                            <div class="related-meta">
                                <span>
                                    <i class="fas fa-clock"></i>
                                    <%= formattedRelatedDate %>
                                </span>
                                <span>
                                    <i class="fas fa-comment"></i>
                                    <%= relatedPost.getCommentCount() %> bình luận
                                </span>
                                <span>
                                    <i class="fas fa-eye"></i>
                                    <%= relatedPost.getViewCount() %> lượt xem
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
                            <i class="fas fa-link"></i>
                        </div>
                        <h3 class="empty-title">Không có bài viết liên quan</h3>
                        <p>Hiện tại chưa có bài viết nào cùng danh mục.</p>
                    </div>
                <% 
                        }
                %>
                </div>
            </section>

            <% } %>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-exclamation-triangle" style="color: var(--danger);"></i>
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

        // User menu toggle
        function toggleUserMenu() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Actions menu toggle
        function toggleActionsMenu() {
            const menu = document.getElementById('actionsMenu');
            menu.classList.toggle('show');
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(event) {
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

        // Like toggle
        function toggleLike(postId, button) {
            const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : "" %>";
            if (!userId) {
                alert("Vui lòng đăng nhập để thích bài viết!");
                window.location.href = "<%= request.getContextPath() %>/login";
                return;
            }
            
            const isLiked = button.classList.contains("liked");
            const url = "<%= request.getContextPath() %>/forum/toggleLike";
            
            // Add loading state
            button.disabled = true;
            
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
                    // Update like count in stats
                    const statsLikes = document.querySelector('.stat-item:first-child span');
                    statsLikes.textContent = `${data.voteCount} lượt thích`;
                    
                    // Update button
                    const likeCountSpan = button.querySelector(".like-count");
                    likeCountSpan.textContent = data.voteCount;
                    
                    if (isLiked) {
                        button.classList.remove("liked");
                    } else {
                        button.classList.add("liked");
                    }
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

        // Focus comment form
        function focusCommentForm() {
            const commentText = document.getElementById('commentText');
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Reply to comment
        function replyToComment(commentId) {
            const commentText = document.getElementById('commentText');
            commentText.value = `@comment-${commentId} `;
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Share post
        function sharePost() {
            if (navigator.share) {
                navigator.share({
                    title: document.title,
                    url: window.location.href
                });
            } else {
                // Fallback: copy to clipboard
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Đã sao chép liên kết vào clipboard!');
                });
            }
        }

        // Delete confirmation
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
                form.action = '<%= request.getContextPath() %>/forum/deletePost';
                
                const postIdInput = document.createElement('input');
                postIdInput.type = 'hidden';
                postIdInput.name = 'postId';
                postIdInput.value = postIdToDelete;
                
                form.appendChild(postIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Close modal on outside click
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });

        // Auto-resize textarea
        document.getElementById('commentText').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    </script>

    <%@include file="chatbox.jsp" %>
</body>
</html>
