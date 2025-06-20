<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ForumPost, model.User" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("&lt;", "&lt;")
                    .replace(">", "&gt;")
                    .replace("'", "&#39;");
    }
%>

<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chỉnh sửa bài viết - JLPT Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #4f8cff;
            --primary-dark: #3b82f6;
            --secondary: #1e293b;
            --accent: #f7c873;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
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

        .topbar {
            width: 100%;
            background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            height: 62px;
            box-shadow: 0 2px 12px rgba(79, 140, 255, 0.07);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .topbar .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.3rem;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .topbar .logo-icon {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            overflow: hidden;
        }
        .logo-icon .logo-img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .topbar .nav {
            display: flex;
            gap: 24px;
            align-items: center;
        }
        .topbar .nav a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            font-size: 1rem;
            padding: 8px 14px;
            border-radius: 8px;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .topbar .nav a.active,
        .topbar .nav a:hover {
            background: rgba(255, 255, 255, 0.13);
        }
        .topbar .account-dropdown {
            position: relative;
        }
        .topbar .account-btn {
            background: none;
            border: none;
            color: #fff;
            font-size: 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 8px 14px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        .topbar .account-btn:hover {
            background: rgba(255, 255, 255, 0.13);
        }
        .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 700;
            font-size: 1.25rem;
            color: white;
            text-decoration: none;
        }

        
        /* Main Container */
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 1.5rem;
            min-height: calc(100vh - 64px);
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            color: var(--text-muted);
            background: var(--bg-primary);
            padding: 0.75rem 1rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 1rem;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Form Container */
        .form-container {
            background: var(--bg-primary);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            border: 1px solid var(--border);
        }

        .form-header {
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--bg-tertiary) 0%, var(--bg-secondary) 100%);
            border-bottom: 1px solid var(--border);
            position: relative;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
        }

        .form-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .form-title i {
            color: var(--primary);
        }

        .form-subtitle {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        .form-body {
            padding: 1.5rem;
        }

        /* Form Grid Layout */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: var(--primary);
            width: 14px;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius);
            background: var(--bg-primary);
            color: var(--text-primary);
            transition: all 0.3s;
            font-size: 0.9rem;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 140, 255, 0.1);
        }

        .form-control:hover {
            border-color: var(--primary);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        .select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%234f8cff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.75rem center;
            background-repeat: no-repeat;
            background-size: 1rem;
            padding-right: 2.5rem;
        }

        /* Compact File Upload */
        .file-upload-compact {
            border: 2px dashed var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: var(--bg-tertiary);
            position: relative;
        }

        .file-upload-compact:hover {
            border-color: var(--primary);
            background: rgba(79, 140, 255, 0.05);
        }

        .file-upload-compact.has-file {
            border-color: var(--success);
            background: rgba(16, 185, 129, 0.05);
        }

        .file-upload-input {
            display: none;
        }

        .upload-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .upload-icon {
            font-size: 1.25rem;
            color: var(--primary);
        }

        .upload-text {
            color: var(--text-primary);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .upload-hint {
            color: var(--text-muted);
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }

        .current-image-preview {
            margin-top: 1rem;
            text-align: center;
        }

        .current-image-preview img {
            max-width: 100%;
            max-height: 120px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
        }

        .image-preview {
            margin-top: 1rem;
            text-align: center;
        }

        .image-preview img {
            max-width: 100%;
            max-height: 150px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
        }

        /* Character Counter */
        .character-counter {
            text-align: right;
            color: var(--text-muted);
            font-size: 0.75rem;
            margin-top: 0.25rem;
        }

        .character-counter.warning {
            color: var(--warning);
        }

        .character-counter.danger {
            color: var(--danger);
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: var(--radius);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 0.9rem;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-lg);
        }

        .btn-secondary {
            background: var(--bg-tertiary);
            color: var(--text-secondary);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--bg-secondary);
            color: var(--text-primary);
        }

        .form-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            background: var(--bg-tertiary);
            display: flex;
            gap: 0.75rem;
            justify-content: flex-end;
        }

        .alert {
            padding: 1rem;
            border-radius: var(--radius);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border: 1px solid;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-color: rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border-color: rgba(239, 68, 68, 0.2);
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: var(--radius);
            transition: all 0.3s;
            background: var(--bg-primary);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .back-button:hover {
            color: var(--primary);
            background: var(--bg-tertiary);
        }

        /* Loading State */
        .loading .btn {
            opacity: 0.7;
            pointer-events: none;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .form-body, .form-header {
                padding: 1rem;
            }

            .form-footer {
                flex-direction: column;
                padding: 1rem;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .nav-link span {
                display: none;
            }

            .form-title {
                font-size: 1.25rem;
            }
        }

        /* Animations */
        .fade-in {
            animation: fadeIn 0.4s ease-out;
        }

        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(10px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
    </style>
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

    <div class="container">
        <nav class="breadcrumb fade-in">
            <a href="<%= request.getContextPath() %>/forum">
                <i class="fas fa-comments"></i>
                Diễn đàn
            </a>
            <i class="fas fa-chevron-right"></i>
            <span>Chỉnh sửa bài viết</span>
        </nav>

        <% 
            ForumPost post = (ForumPost) request.getAttribute("post");
            if (post != null) {
        %>
        <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="back-button fade-in">
            <i class="fas fa-arrow-left"></i>
            Quay lại bài viết
        </a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/forum" class="back-button fade-in">
            <i class="fas fa-arrow-left"></i>
            Quay lại diễn đàn
        </a>
        <% } %>

        <% 
            String message = (String) session.getAttribute("message");
            if (message != null && !message.isEmpty()) {
                String alertClass = message.contains("thành công") ? "alert-success" : "alert-danger";
        %>
            <div class="alert <%= alertClass %> fade-in">
                <i class="fas fa-<%= message.contains("thành công") ? "check-circle" : "exclamation-triangle" %>"></i>
                <span><%= escapeHtml(message) %></span>
            </div>
            <% 
                session.removeAttribute("message");
            }
        %>

        <% if (post == null) { %>
            <div class="alert alert-danger fade-in">
                <i class="fas fa-exclamation-triangle"></i>
                <span>Bài viết không tồn tại hoặc bạn không có quyền chỉnh sửa!</span>
            </div>
        <% } else { %>

        <div class="form-container fade-in">
            <div class="form-header">
                <h1 class="form-title">
                    <i class="fas fa-edit"></i>
                    Chỉnh sửa bài viết
                </h1>
                <p class="form-subtitle">Cập nhật nội dung bài viết của bạn</p>
            </div>

            <form action="<%= request.getContextPath() %>/forum/editPost/<%= post.getId() %>" method="post" enctype="multipart/form-data" id="editForm">
                <input type="hidden" name="postId" value="<%= post.getId() %>">
                
                <div class="form-body">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="postTitle">
                                <i class="fas fa-heading"></i>
                                Tiêu đề bài viết
                            </label>
                            <input 
                                type="text" 
                                class="form-control" 
                                id="postTitle" 
                                name="postTitle" 
                                value="<%= escapeHtml(post.getTitle()) %>" 
                                placeholder="Nhập tiêu đề..." 
                                required 
                                maxlength="200"
                            />
                            <div class="character-counter" id="titleCounter">0/200</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="postCategory">
                                <i class="fas fa-tag"></i>
                                Danh mục
                            </label>
                            <select class="form-control select" id="postCategory" name="postCategory" required>
                                <option value="">Chọn danh mục</option>
                                <option value="N5" <%= "N5".equals(post.getCategory()) ? "selected" : "" %>>JLPT N5</option>
                                <option value="N4" <%= "N4".equals(post.getCategory()) ? "selected" : "" %>>JLPT N4</option>
                                <option value="N3" <%= "N3".equals(post.getCategory()) ? "selected" : "" %>>JLPT N3</option>
                                <option value="N2" <%= "N2".equals(post.getCategory()) ? "selected" : "" %>>JLPT N2</option>
                                <option value="N1" <%= "N1".equals(post.getCategory()) ? "selected" : "" %>>JLPT N1</option>
                                <option value="Ngữ pháp" <%= "Ngữ pháp".equals(post.getCategory()) ? "selected" : "" %>>Ngữ pháp</option>
                                <option value="Kinh nghiệm thi" <%= "Kinh nghiệm thi".equals(post.getCategory()) ? "selected" : "" %>>Kinh nghiệm thi</option>
                                <option value="Tài liệu" <%= "Tài liệu".equals(post.getCategory()) ? "selected" : "" %>>Tài liệu</option>
                                <option value="Công cụ" <%= "Công cụ".equals(post.getCategory()) ? "selected" : "" %>>Công cụ</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="postContent">
                            <i class="fas fa-align-left"></i>
                            Nội dung bài viết
                        </label>
                        <textarea 
                            class="form-control" 
                            id="postContent" 
                            name="postContent" 
                            placeholder="Chia sẻ suy nghĩ của bạn..." 
                            required
                            maxlength="5000"
                        ><%= escapeHtml(post.getContent()) %></textarea>
                        <div class="character-counter" id="contentCounter">0/5000</div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">
                            <i class="fas fa-image"></i>
                            Hình ảnh
                        </label>
                        
                        <% if (post.getPicture() != null && !post.getPicture().isEmpty()) { %>
                            <div class="current-image-preview">
                                <img src="<%= request.getContextPath() %>/<%= escapeHtml(post.getPicture()) %>" alt="Current image" />
                            </div>
                        <% } %>
                        
                        <div class="file-upload-compact" onclick="document.getElementById('imageInput').click()">
                            <input 
                                type="file" 
                                id="imageInput" 
                                name="imageInput" 
                                accept="image/*" 
                                onchange="previewImage(event)" 
                                class="file-upload-input"
                            />
                            <div class="upload-content">
                                <div class="upload-icon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                </div>
                                <div>
                                    <div class="upload-text">
                                        <%= post.getPicture() != null && !post.getPicture().isEmpty() ? "Thay đổi hình ảnh" : "Thêm hình ảnh" %>
                                    </div>
                                    <div class="upload-hint">PNG, JPG, GIF (tối đa 10MB)</div>
                                </div>
                            </div>
                        </div>
                        
                        <div id="imagePreview" class="image-preview" style="display: none;">
                            <img alt="Preview" />
                        </div>
                    </div>
                </div>

                <div class="form-footer">
                    <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy
                    </a>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-save"></i>
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>

        <% } %>
    </div>

    <script>
        // Character counters
        function updateCharacterCounter(input, counter, maxLength) {
            const current = input.value.length;
            const counterElement = document.getElementById(counter);
            counterElement.textContent = `${current}/${maxLength}`;
            
            if (current > maxLength * 0.9) {
                counterElement.className = 'character-counter danger';
            } else if (current > maxLength * 0.7) {
                counterElement.className = 'character-counter warning';
            } else {
                counterElement.className = 'character-counter';
            }
        }

        // Initialize character counters
        const titleInput = document.getElementById('postTitle');
        const contentInput = document.getElementById('postContent');

        titleInput.addEventListener('input', () => updateCharacterCounter(titleInput, 'titleCounter', 200));
        contentInput.addEventListener('input', () => updateCharacterCounter(contentInput, 'contentCounter', 5000));

        // Initial counter update
        updateCharacterCounter(titleInput, 'titleCounter', 200);
        updateCharacterCounter(contentInput, 'contentCounter', 5000);

        // Image preview
        function previewImage(event) {
            const file = event.target.files[0];
            const preview = document.getElementById('imagePreview');
            const img = preview.querySelector('img');
            const uploadArea = document.querySelector('.file-upload-compact');
            
            if (file) {
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file hình ảnh!');
                    event.target.value = '';
                    return;
                }
                
                if (file.size > 10 * 1024 * 1024) {
                    alert('Kích thước file không được vượt quá 10MB!');
                    event.target.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    img.src = e.target.result;
                    preview.style.display = 'block';
                    uploadArea.classList.add('has-file');
                    uploadArea.querySelector('.upload-text').textContent = 'Thay đổi hình ảnh';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
                uploadArea.classList.remove('has-file');
                uploadArea.querySelector('.upload-text').textContent = 'Thêm hình ảnh';
            }
        }

        // Auto-resize textarea
        function autoResize() {
            contentInput.style.height = 'auto';
            contentInput.style.height = Math.min(contentInput.scrollHeight, 200) + 'px';
        }
        
        contentInput.addEventListener('input', autoResize);
        autoResize();

        // Form submission
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const form = this;
            
            const title = titleInput.value.trim();
            const content = contentInput.value.trim();
            const category = document.getElementById('postCategory').value;
            
            if (!title || !content || !category) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }

            if (title.length > 200 || content.length > 5000) {
                e.preventDefault();
                alert('Nội dung vượt quá giới hạn cho phép!');
                return;
            }
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
            form.classList.add('loading');
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 's') {
                e.preventDefault();
                document.getElementById('editForm').submit();
            }
        });
    </script>
</body>
</html>
