<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập & Đăng ký - Học Tiếng Nhật Online</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
    />
    <link href="${pageContext.request.contextPath}/assets/css/main-login.css" rel="stylesheet" />
  </head>
  <body>
    <div class="bg-decor">
      <span>🌸</span>
      <span>⛩️</span>
      <span>🎌</span>
      <span>🗻</span>
    </div>
    <div class="auth-wrapper">
      <!-- Side Inspiration -->
      <div class="auth-side">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="logo-img" />
        <div class="logo">HiKARI</div>
        <div class="slogan">
          <b>“Học hôm nay, làm chủ tương lai!”</b><br />
          <span>Chinh phục tiếng Nhật cùng hàng ngàn học viên mỗi ngày.</span>
        </div>
        <div class="quote">
          <div class="japanese" id="quoteJapanese">千里の道も一歩から</div>
          <div class="romaji" id="quoteRomaji">Senri no michi mo ippo kara</div>
          <div class="vi" id="quoteVietnamese">
            "Hành trình ngàn dặm bắt đầu từ một bước chân"
          </div>
        </div>
        <div class="stats">
          <div class="stat">
            +2000<br /><span style="font-size: 0.9em; font-weight: 400"
              >Từ vựng</span
            >
          </div>
          <div class="stat">
            +100<br /><span style="font-size: 0.9em; font-weight: 400"
              >Bài học</span
            >
          </div>
          <div class="stat">
            24/7<br /><span style="font-size: 0.9em; font-weight: 400"
              >Hỗ trợ</span
            >
          </div>
        </div>
      </div>
      <!-- Form Section -->
      <div class="auth-form-section">
        <div class="auth-form-container">
          <% 
            String formType = request.getParameter("formType");
            boolean isSignUp = "signup".equals(formType);
            String error = (String) request.getAttribute("error");
          %>
          <div class="form-title" id="formTitle"><%= isSignUp ? "Đăng ký" : "Đăng nhập" %></div>
          <div class="form-desc" id="formDesc">
            <%= isSignUp 
              ? "Khởi đầu hành trình mới! <br>“Không có con đường tắt đến thành công, chỉ có sự kiên trì.”"
              : "Chào mừng bạn quay lại! <br>“Mỗi ngày một bước tiến, tiếng Nhật sẽ là của bạn.”" %>
          </div>
          <% if (error != null) { %>
            <div class="error-message"><%= error %></div>
          <% } %>
          <form id="authForm" action="<%= request.getContextPath() %>/auth" method="post">
            <input type="hidden" name="action" value="<%= isSignUp ? "signup" : "login" %>" />
            <div class="form-group <%= isSignUp ? "" : "hidden" %>" id="emailGroup">
              <label class="form-label" for="email">Email</label>
              <div class="input-wrapper">
                <i class="fa fa-envelope input-icon"></i>
                <input
                  class="input"
                  id="email"
                  name="email"
                  type="email"
                  placeholder="your@email.com"
                  <%= isSignUp ? "required" : "" %>
                />
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="username">Tên đăng nhập</label>
              <div class="input-wrapper">
                <i class="fa fa-user input-icon"></i>
                <input
                  class="input"
                  id="username"
                  name="username"
                  type="text"
                  placeholder="Nhập tên đăng nhập"
                  required
                />
              </div>
            </div>
            <div class="form-group">
              <label class="form-label" for="password">Mật khẩu</label>
              <div class="input-wrapper">
                <i class="fa fa-lock input-icon"></i>
                <input
                  class="input"
                  id="password"
                  name="password"
                  type="password"
                  placeholder="Nhập mật khẩu"
                  required
                />
                <button
                  type="button"
                  class="password-toggle"
                  onclick="togglePassword('password')"
                >
                  <i class="fa fa-eye" id="passwordEye"></i>
                </button>
              </div>
            </div>
            <div class="form-group <%= isSignUp ? "" : "hidden" %>" id="confirmPasswordGroup">
              <label class="form-label" for="confirmPassword"
                >Xác nhận mật khẩu</label
              >
              <div class="input-wrapper">
                <i class="fa fa-lock input-icon"></i>
                <input
                  class="input"
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  placeholder="Nhập lại mật khẩu"
                  <%= isSignUp ? "required" : "" %>
                />
                <button
                  type="button"
                  class="password-toggle"
                  onclick="togglePassword('confirmPassword')"
                >
                  <i class="fa fa-eye" id="confirmPasswordEye"></i>
                </button>
              </div>
            </div>
            <div class="remember-forgot <%= isSignUp ? "hidden" : "" %>" id="rememberForgot">
              <label>
                <input type="checkbox" name="remember" style="accent-color: #ff835d" />
                <span class="checkbox-label">Ghi nhớ đăng nhập</span>
              </label>
              <a href="forgot-password.jsp" class="forgot-link">Quên mật khẩu?</a>
            </div>
            <button type="submit" class="submit-btn" id="submitBtn">
              <%= isSignUp ? "Đăng ký" : "Đăng nhập" %>
            </button>
            <div class="divider"><span>hoặc</span></div>
            <button type="button" class="google-btn" onclick="window.location.href='<%= request.getContextPath() %>/auth/google'">
              <svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                <path fill="#4285F4" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                <path fill="#34A853" d="M46.98 24.55c0-1.7-.15-3.34-.43-4.91H24v9.28h12.84c-.56 2.98-2.24 5.51-4.78 7.2l7.73 6.01c4.5-4.15 7.19-10.28 7.19-17.58z"/>
                <path fill="#FBBC05" d="M10.54 28.28l-7.98-6.19C1.02 25.67 0 29.74 0 34c0 4.26 1.02 8.33 2.56 11.91l7.98-6.19c-1.11-3.49-1.11-7.31 0-10.74z"/>
                <path fill="#EA4335" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6.01c-2.19 1.47-4.97 2.34-8.16 2.34-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
                <path fill="none" d="M0 0h48v48H0z"/>
              </svg>
              Đăng nhập với Google
            </button>
            <div class="switch-form">
              <span id="switchText"><%= isSignUp ? "Đã có tài khoản?" : "Chưa có tài khoản?" %></span>
              <a href="login.jsp?formType=<%= isSignUp ? "login" : "signup" %>" class="switch-link" id="switchLink">
                <%= isSignUp ? "Đăng nhập" : "Đăng ký" %>
              </a>
            </div>
          </form>
        </div>
      </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main-login.js"></script>
  </body>
</html>