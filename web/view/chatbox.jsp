<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="chatbox" style="display: none;">
    <div class="chatbox-container">
        <div class="chatbox-header">
            <div class="chatbox-title">
                <i class="fas fa-robot"></i>
                <span>AI Assistant</span>
            </div>
            <button onclick="toggleChatbox()" class="chatbox-close">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="chatbox-history" id="chatbox-history">
            <%
                List<String[]> chatboxHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatboxHistory != null) {
                    for (String[] chat : chatboxHistory) {
            %>
            <div class="chat-message user-message">
                <div class="message-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="message-content">
                    <div class="message-text"><%= chat[0]%></div>
                </div>
            </div>
            <div class="chat-message ai-message">
                <div class="message-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="message-content">
                    <div class="message-text"><%= chat[1]%></div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="welcome-message">
                <div class="welcome-icon">
                    <i class="fas fa-robot"></i>
                </div>
                <h3>Xin chào! 👋</h3>
                <p>Tôi là AI Assistant, sẵn sàng hỗ trợ bạn học tiếng Nhật. Hãy đặt câu hỏi bất kỳ!</p>
            </div>
            <%
                }
            %>
        </div>
        <div class="chatbox-input">
            <div class="input-wrapper">
                <textarea 
                    id="userInput" 
                    rows="1" 
                    placeholder="Nhập câu hỏi của bạn..." 
                    onkeypress="submitOnEnter(event)"
                    ></textarea>
                <button onclick="sendMessage()" class="send-btn">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<button id="chatbox-toggle" onclick="toggleChatbox()">
    <i class="fas fa-comments"></i>
    <span class="toggle-text">AI Chat</span>
</button>

<style>
    #chatbox-toggle {
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        border-radius: 50px;
        padding: 1rem 1.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
        z-index: 1001;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        min-width: 60px;
        justify-content: center;
    }

    #chatbox-toggle:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 35px rgba(59, 130, 246, 0.4);
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
    }

    #chatbox-toggle .toggle-text {
        display: none;
    }

    #chatbox-toggle:hover .toggle-text {
        display: inline;
        animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateX(10px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .chatbox-container {
        position: fixed;
        bottom: 6rem;
        right: 2rem;
        width: 380px;
        max-height: 600px;
        background: white;
        border-radius: 1rem;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        display: flex;
        flex-direction: column;
        z-index: 1000;
        animation: slideUp 0.3s ease-out;
        border: 1px solid #e2e8f0;
        overflow: hidden;
    }

    @keyframes slideUp {
        from {
            transform: translateY(100px) scale(0.9);
            opacity: 0;
        }
        to {
            transform: translateY(0) scale(1);
            opacity: 1;
        }
    }

    .chatbox-header {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 1rem 1rem 0 0;
    }

    .chatbox-title {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 1rem;
    }

    .chatbox-close {
        background: none;
        border: none;
        color: white;
        font-size: 1.125rem;
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 0.5rem;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
    }

    .chatbox-close:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: scale(1.1);
    }

    .chatbox-history {
        flex: 1;
        max-height: 400px;
        overflow-y: auto;
        padding: 1.5rem;
        background: #f8fafc;
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .chatbox-history::-webkit-scrollbar {
        width: 6px;
    }

    .chatbox-history::-webkit-scrollbar-track {
        background: #f1f5f9;
    }

    .chatbox-history::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 3px;
    }

    .chatbox-history::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
    }

    .welcome-message {
        text-align: center;
        padding: 2rem 1rem;
        color: #64748b;
    }

    .welcome-icon {
        font-size: 3rem;
        color: #3b82f6;
        margin-bottom: 1rem;
    }

    .welcome-message h3 {
        color: #1e293b;
        margin-bottom: 0.5rem;
        font-size: 1.125rem;
    }

    .welcome-message p {
        line-height: 1.6;
        font-size: 0.875rem;
    }

    .chat-message {
        display: flex;
        gap: 0.75rem;
        align-items: flex-start;
        animation: messageSlide 0.3s ease-out;
    }

    @keyframes messageSlide {
        from {
            transform: translateY(20px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.875rem;
        flex-shrink: 0;
        margin-top: 0.25rem;
    }

    .user-message .message-avatar {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        order: 2;
    }

    .ai-message .message-avatar {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
    }

    .message-content {
        flex: 1;
        max-width: calc(100% - 48px);
    }

    .user-message .message-content {
        order: 1;
    }

    .message-text {
        background: white;
        padding: 0.75rem 1rem;
        border-radius: 1rem;
        font-size: 0.875rem;
        line-height: 1.5;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border: 1px solid #e2e8f0;
        word-wrap: break-word;
    }

    .user-message .message-text {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        margin-left: auto;
        border-radius: 1rem 1rem 0.25rem 1rem;
    }

    .ai-message .message-text {
        border-radius: 1rem 1rem 1rem 0.25rem;
    }

    .chatbox-input {
        padding: 1rem 1.5rem;
        background: white;
        border-top: 1px solid #e2e8f0;
    }

    .input-wrapper {
        display: flex;
        gap: 0.75rem;
        align-items: flex-end;
    }

    .input-wrapper textarea {
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: 1rem;
        resize: none;
        font-size: 0.875rem;
        font-family: inherit;
        outline: none;
        transition: all 0.2s;
        max-height: 100px;
        min-height: 40px;
        line-height: 1.5;
    }

    .input-wrapper textarea:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .send-btn {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        flex-shrink: 0;
    }

    .send-btn:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }

    .send-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
    }

    /* Loading animation */
    .typing-indicator {
        display: flex;
        gap: 0.25rem;
        padding: 1rem;
        align-items: center;
    }

    .typing-dot {
        width: 8px;
        height: 8px;
        background: #94a3b8;
        border-radius: 50%;
        animation: typing 1.4s infinite ease-in-out;
    }

    .typing-dot:nth-child(2) {
        animation-delay: 0.2s;
    }

    .typing-dot:nth-child(3) {
        animation-delay: 0.4s;
    }

    @keyframes typing {
        0%, 60%, 100% {
            transform: translateY(0);
            opacity: 0.4;
        }
        30% {
            transform: translateY(-10px);
            opacity: 1;
        }
    }

    /* Responsive */
    @media (max-width: 768px) {
        .chatbox-container {
            width: calc(100vw - 2rem);
            right: 1rem;
            bottom: 5rem;
            max-height: 70vh;
        }

        #chatbox-toggle {
            right: 1rem;
            bottom: 1rem;
        }

        .chatbox-history {
            padding: 1rem;
        }

        .chatbox-input {
            padding: 1rem;
        }
    }
</style>

<script>
    let isTyping = false;

    function toggleChatbox() {
        var chatbox = document.getElementById("chatbox");
        var toggle = document.getElementById("chatbox-toggle");

        if (chatbox.style.display === "none") {
            chatbox.style.display = "block";
            toggle.innerHTML = '<i class="fas fa-times"></i>';
            scrollToBottom();

            // Auto-resize textarea
            autoResizeTextarea();
        } else {
            chatbox.style.display = "none";
            toggle.innerHTML = '<i class="fas fa-comments"></i><span class="toggle-text">AI Chat</span>';
        }
    }

    function submitOnEnter(event) {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        } else if (event.key === "Enter" && event.shiftKey) {
            // Allow new line with Shift+Enter
            return true;
        }
    }

    function sendMessage() {
        var userInput = document.getElementById("userInput").value.trim();
        if (!userInput || isTyping)
            return;

        // Add user message
        addMessage(userInput, 'user');

        // Clear input
        document.getElementById("userInput").value = "";
        autoResizeTextarea();

        // Show typing indicator
        showTypingIndicator();

        // Send AJAX request
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "gemini", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                hideTypingIndicator();

                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        addMessage(response.text, 'ai');
                    } catch (e) {
                        addMessage("Xin lỗi, có lỗi xảy ra khi xử lý phản hồi.", 'ai');
                    }
                } else {
                    addMessage("Xin lỗi, không thể kết nối đến server. Vui lòng thử lại sau.", 'ai');
                }
            }
        };
        xhr.send("userInput=" + encodeURIComponent(userInput));
    }

    function addMessage(text, type) {
        var history = document.getElementById("chatbox-history");

        // Remove welcome message if exists
        var welcomeMsg = history.querySelector('.welcome-message');
        if (welcomeMsg) {
            welcomeMsg.remove();
        }

        var messageDiv = document.createElement("div");
        messageDiv.className = "chat-message " + type + "-message";

        var avatarDiv = document.createElement("div");
        avatarDiv.className = "message-avatar";
        avatarDiv.innerHTML = type === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';

        var contentDiv = document.createElement("div");
        contentDiv.className = "message-content";

        var textDiv = document.createElement("div");
        textDiv.className = "message-text";
        textDiv.textContent = text;

        contentDiv.appendChild(textDiv);
        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);

        history.appendChild(messageDiv);
        scrollToBottom();
    }

    function showTypingIndicator() {
        if (isTyping)
            return;
        isTyping = true;

        var history = document.getElementById("chatbox-history");
        var typingDiv = document.createElement("div");
        typingDiv.className = "chat-message ai-message";
        typingDiv.id = "typing-indicator";

        typingDiv.innerHTML = `
            <div class="message-avatar">
                <i class="fas fa-robot"></i>
            </div>
            <div class="message-content">
                <div class="message-text">
                    <div class="typing-indicator">
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
                    </div>
                </div>
            </div>
        `;

        history.appendChild(typingDiv);
        scrollToBottom();
    }

    function hideTypingIndicator() {
        isTyping = false;
        var typingIndicator = document.getElementById("typing-indicator");
        if (typingIndicator) {
            typingIndicator.remove();
        }
    }

    function scrollToBottom() {
        var history = document.getElementById("chatbox-history");
        setTimeout(() => {
            history.scrollTop = history.scrollHeight;
        }, 100);
    }

    function autoResizeTextarea() {
        var textarea = document.getElementById("userInput");
        textarea.style.height = 'auto';
        textarea.style.height = Math.min(textarea.scrollHeight, 100) + 'px';
    }

    // Auto-resize textarea on input
    document.getElementById("userInput").addEventListener('input', autoResizeTextarea);

    // Initialize
    window.onload = function () {
        if (document.getElementById("chatbox").style.display === "block") {
            scrollToBottom();
        }
    };

    // Close chatbox when clicking outside
    document.addEventListener('click', function (event) {
        var chatbox = document.getElementById("chatbox");
        var toggle = document.getElementById("chatbox-toggle");

        if (chatbox.style.display === "block" &&
                !chatbox.contains(event.target) &&
                !toggle.contains(event.target)) {
            // Don't auto-close for better UX
            // toggleChatbox();
        }
    });
</script>
