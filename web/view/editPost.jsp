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
    <link href="${pageContext.request.contextPath}/assets/css/forum_css/editPost.css" rel="stylesheet" />

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
