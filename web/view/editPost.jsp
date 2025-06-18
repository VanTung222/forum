<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ForumPost, model.User" %>
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
    <title>Chỉnh sửa bài viết - JLPT Forum</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --secondary: #1e293b;
            --accent: #f59e0b;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #06b6d4;
            --bg-primary: #ffffff;
            --bg-secondary: #f9fafb;
            --bg-tertiary: #f3f4f6;
            --text-primary: #111827;
            --text-secondary: #6b7280;
            --text-muted: #9ca3af;
            --border: #e5e7eb;
            --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 8px rgba(0, 0, 0, 0.1);
            --radius: 0.75rem;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-secondary);
            color: var(--text-primary);
            line-height: 1.6;
            font-size: 16px;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: var(--shadow-md);
        }

        .header-container {
            max-width: 1280px;
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: var(--primary-dark);
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            padding: 0.75rem 1.25rem;
            border-radius: var(--radius);
            transition: all 0.3s;
            margin-bottom: 1.5rem;
        }

        .back-button:hover {
            color: var(--primary);
            background: var(--bg-tertiary);
        }

        /* Form Container */
        .form-container {
            background: var(--bg-primary);
            border-radius: var(--radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
            animation: fadeIn 0.5s ease-out;
        }

        .form-header {
            padding: 2rem;
            background: var(--bg-tertiary);
            text-align: center;
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .form-subtitle {
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .form-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.875rem;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            background: var(--bg-primary);
            color: var(--text-primary);
            transition: all 0.3s;
            font-size: 0.875rem;
            font-family: inherit;
            box-shadow: var(--shadow-sm);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }

        .select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 1rem center;
            background-repeat: no-repeat;
            background-size: 1.25rem;
            padding-right: 2.5rem;
        }

        /* File Upload */
        .file-upload-area {
            border: 2px dashed var(--border);
            border-radius: var(--radius);
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: var(--bg-tertiary);
        }

        .file-upload-area:hover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.05);
        }

        .file-upload-area.dragover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.1);
            transform: scale(1.01);
        }

        .file-upload-input {
            display: none;
        }

        .upload-icon {
            font-size: 2.5rem;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
        }

        .upload-text {
            color: var(--text-primary);
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .upload-hint {
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .current-image {
            margin-bottom: 1rem;
            padding: 1rem;
            background: var(--bg-tertiary);
            border-radius: var(--radius);
            text-align: center;
        }

        .current-image-label {
            display: block;
            margin-bottom: 0.75rem;
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-weight: 500;
        }

        .current-image img {
            max-width: 100%;
            max-height: 200px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
        }

        .image-preview {
            margin-top: 1rem;
            text-align: center;
        }

        .image-preview img {
            max-width: 100%;
            max-height: 250px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
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
            font-size: 0.875rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: var(--shadow-sm);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
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
            padding: 1.5rem 2rem;
            border-top: 1px solid var(--border);
            background: var(--bg-tertiary);
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        /* Alert */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: var(--shadow-sm);
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Character Counter */
        .character-counter {
            text-align: right;
            color: var(--text-muted);
            font-size: 0.75rem;
            margin-top: 0.5rem;
        }

        .character-counter.warning {
            color: var(--warning);
        }

        .character-counter.danger {
            color: var(--danger);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .form-body, .form-header {
                padding: 1.5rem;
            }

            .form-footer {
                flex-direction: column;
                padding: 1.5rem;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .nav-link span {
                display: none;
            }

            .form-title {
                font-size: 1.5rem;
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
                <a href="<%= request.getContextPath() %>/forum" class="nav-link active">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/contact" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Liên hệ</span>
                </a>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="<%= request.getContextPath() %>/forum">
                <i class="fas fa-comments"></i>
                Diễn đàn
            </a>
            <i class="fas fa-chevron-right"></i>
            <span>Chỉnh sửa bài viết</span>
        </nav>

        <!-- Back Button -->
        <% 
            ForumPost post = (ForumPost) request.getAttribute("post");
            if (post != null) {
        %>
        <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại bài viết
        </a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/forum" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại diễn đàn
        </a>
        <% } %>

        <!-- Alert -->
        <% 
            String message = (String) session.getAttribute("message");
            if (message != null && !message.isEmpty()) {
                String alertClass = message.contains("thành công") ? "alert-success" : "alert-danger";
        %>
            <div class="alert <%= alertClass %>">
                <i class="fas fa-<%= message.contains("thành công") ? "check-circle" : "exclamation-triangle" %>"></i>
                <%= escapeHtml(message) %>
            </div>
            <% 
                session.removeAttribute("message");
            }
        %>

        <% if (post == null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                Bài viết không tồn tại hoặc bạn không có quyền chỉnh sửa!
            </div>
        <% } else { %>

        <!-- Form Container -->
        <div class="form-container">
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
                            placeholder="Nhập tiêu đề bài viết..." 
                            required 
                            maxlength="200"
                        />
                        <div class="character-counter" id="titleCounter">0/200 ký tự</div>
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

                    <div class="form-group">
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
                        <div class="character-counter" id="contentCounter">0/5000 ký tự</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-image"></i>
                            Hình ảnh
                        </label>
                        
                        <% if (post.getPicture() != null && !post.getPicture().isEmpty()) { %>
                            <div class="current-image">
                                <span class="current-image-label">Hình ảnh hiện tại:</span>
                                <img src="<%= request.getContextPath() %>/<%= escapeHtml(post.getPicture()) %>" alt="Current image" />
                            </div>
                        <% } %>
                        
                        <div class="file-upload-area" onclick="document.getElementById('imageInput').click()">
                            <input 
                                type="file" 
                                id="imageInput" 
                                name="imageInput" 
                                accept="image/*" 
                                onchange="previewImage(event)" 
                                class="file-upload-input"
                            />
                            <div class="upload-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-text">
                                <%= post.getPicture() != null && !post.getPicture().isEmpty() ? "Thay đổi hình ảnh" : "Thêm hình ảnh" %>
                            </div>
                            <div class="upload-hint">Nhấp để chọn hình ảnh mới hoặc kéo thả vào đây (PNG, JPG, GIF tối đa 10MB)</div>
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
            counterElement.textContent = `${current}/${maxLength} ký tự`;
            
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
            const uploadArea = document.querySelector('.file-upload-area');
            
            if (file) {
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file hình ảnh!');
                    event.target.value = '';
                    return;
                }
                
                // Validate file size (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Kích thước file không được vượt quá 10MB!');
                    event.target.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    img.src = e.target.result;
                    preview.style.display = 'block';
                    uploadArea.querySelector('.upload-text').textContent = 'Thay đổi hình ảnh';
                    uploadArea.querySelector('.upload-hint').textContent = 'Nhấp để chọn hình ảnh khác';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
                uploadArea.querySelector('.upload-text').textContent = 'Thêm hình ảnh';
                uploadArea.querySelector('.upload-hint').textContent = 'Nhấp để chọn hình ảnh mới hoặc kéo thả vào đây (PNG, JPG, GIF tối đa 10MB)';
            }
        }

        // Auto-resize textarea
        function autoResize() {
            contentInput.style.height = 'auto';
            contentInput.style.height = contentInput.scrollHeight + 'px';
        }
        
        contentInput.addEventListener('input', autoResize);
        autoResize();

        // Form submission with loading state
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const form = this;
            
            // Validate form
            const title = document.getElementById('postTitle').value.trim();
            const content = document.getElementById('postContent').value.trim();
            const category = document.getElementById('postCategory').value;
            
            if (!title || !content || !category) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }

            if (title.length > 200) {
                e.preventDefault();
                alert('Tiêu đề không được vượt quá 200 ký tự!');
                return;
            }

            if (content.length > 5000) {
                e.preventDefault();
                alert('Nội dung không được vượt quá 5000 ký tự!');
                return;
            }
            
            // Add loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
            form.classList.add('loading');
        });

        // Drag and drop for file upload
        const uploadArea = document.querySelector('.file-upload-area');
        const fileInput = document.getElementById('imageInput');

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            uploadArea.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, unhighlight, false);
        });

        function highlight(e) {
            uploadArea.classList.add('dragover');
        }

        function unhighlight(e) {
            uploadArea.classList.remove('dragover');
        }

        uploadArea.addEventListener('drop', handleDrop, false);

        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            
            if (files.length > 0) {
                fileInput.files = files;
                previewImage({ target: fileInput });
            }
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl+S to save
            if (e.ctrlKey && e.key === 's') {
                e.preventDefault();
                document.getElementById('editForm').submit();
            }
            
            // Escape to cancel
            if (e.key === 'Escape') {
                if (confirm('Bạn có chắc chắn muốn hủy? Các thay đổi sẽ không được lưu.')) {
                    window.location.href = '<%= request.getContextPath() %>/forum/post/<%= post != null ? post.getId() : "" %>';
                }
            }
        });

        // Warn before leaving if form is dirty
        let formChanged = false;
        const formElements = document.querySelectorAll('#editForm input, #editForm textarea, #editForm select');
        
        formElements.forEach(element => {
            element.addEventListener('change', () => {
                formChanged = true;
            });
        });

        window.addEventListener('beforeunload', function(e) {
            if (formChanged) {
                e.preventDefault();
                e.returnValue = '';
            }
        });

        // Remove warning when form is submitted
        document.getElementById('editForm').addEventListener('submit', function() {
            formChanged = false;
        });

        // Auto-save draft
        let autoSaveTimer;
        function autoSaveDraft() {
            const title = titleInput.value;
            const content = contentInput.value;
            const category = document.getElementById('postCategory').value;
            
            if (title || content || category) {
                localStorage.setItem('editPostDraft', JSON.stringify({
                    title,
                    content,
                    category,
                    timestamp: Date.now()
                }));
            }
        }

        // Auto-save every 30 seconds
        formElements.forEach(element => {
            element.addEventListener('input', () => {
                clearTimeout(autoSaveTimer);
                autoSaveTimer = setTimeout(autoSaveDraft, 30000);
            });
        });

        // Load draft on page load
        window.addEventListener('load', function() {
            const draft = localStorage.getItem('editPostDraft');
            if (draft) {
                const draftData = JSON.parse(draft);
                // Only load if draft is less than 24 hours old
                if (Date.now() - draftData.timestamp < 24 * 60 * 60 * 1000) {
                    if (confirm('Có bản nháp được lưu trước đó. Bạn có muốn khôi phục không?')) {
                        if (draftData.title) titleInput.value = draftData.title;
                        if (draftData.content) contentInput.value = draftData.content;
                        if (draftData.category) document.getElementById('postCategory').value = draftData.category;
                        
                        // Update counters
                        updateCharacterCounter(titleInput, 'titleCounter', 200);
                        updateCharacterCounter(contentInput, 'contentCounter', 5000);
                        autoResize();
                    }
                }
                localStorage.removeItem('editPostDraft');
            }
        });

        // Clear draft when form is submitted successfully
        document.getElementById('editForm').addEventListener('submit', function() {
            localStorage.removeItem('editPostDraft');
        });
    </script>
</body>
</html>