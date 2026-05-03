import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["messagesContainer", "input", "form", "submitButton", "typingIndicator"]
  static values = { requestId: Number, currentUserId: Number }

  connect() {
    this.scrollToBottom()
    this.subscribeToChannel()
    this.adjustTextareaHeight()
    this._typingTimer = null
    this._isTyping = false
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
    clearTimeout(this._typingTimer)
  }

  subscribeToChannel() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "ChatChannel",
        request_id: this.requestIdValue
      },
      {
        connected: () => {
          console.log("Connected to ChatChannel")
        },
        disconnected: () => {
          console.log("Disconnected from ChatChannel")
        },
        received: (data) => {
          if (data.type === "typing") {
            this.handleTypingIndicator(data)
            return
          }
          if (data.type === "read_receipt") {
            this.handleReadReceipt(data)
            return
          }
          // 내가 보낸 메시지는 Turbo Stream이 이미 추가했으므로 중복 방지
          if (data.sender_id && parseInt(data.sender_id) === parseInt(this.currentUserIdValue)) {
            this.scrollToBottom()
            return
          }
          if (data.type === "new_message") {
            this.appendMessage(data)
          }
        }
      }
    )
  }

  appendMessage(data) {
    const messagesContainer = this.messagesContainerTarget
    const isMyMessage = data.sender_id === this.currentUserIdValue
    const html = this.buildMessageHtml(data, isMyMessage)
    messagesContainer.insertAdjacentHTML("beforeend", html)
    this.scrollToBottom()
    this.hideTypingIndicator()
  }

  buildMessageHtml(data, isMyMessage) {
    const time = data.created_at || ""
    const content = (data.content || "").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\n/g, "<br>")
    const senderName = (data.sender_name || "").replace(/</g, "&lt;")
    const alignClass = isMyMessage ? "justify-end" : "justify-start"
    const bubbleClass = isMyMessage
      ? "bg-primary-500 text-white rounded-2xl rounded-br-md"
      : "bg-white text-gray-900 rounded-2xl rounded-bl-md border border-gray-200/80"
    const avatarInitial = senderName ? senderName.charAt(0) : "?"

    const avatarHtml = isMyMessage
      ? `<div class="w-8 flex-shrink-0"></div>`
      : `<div class="w-8 h-8 rounded-full bg-gradient-to-br from-gray-400 to-gray-600 flex items-center justify-center text-white text-xs font-bold flex-shrink-0 mb-0.5">${avatarInitial}</div>`

    const senderNameHtml = isMyMessage ? "" : `<div class="text-xs text-gray-500 mb-1 ml-1 font-medium">${senderName}</div>`

    return `
      <div class="flex ${alignClass} mb-1.5 items-end gap-2">
        ${!isMyMessage ? avatarHtml : ""}
        <div class="max-w-[70%]">
          ${senderNameHtml}
          <div class="${bubbleClass} px-4 py-2.5 shadow-sm">
            <div class="text-sm break-words leading-relaxed">${content}</div>
          </div>
          <div class="flex items-center gap-1 mt-0.5 ${isMyMessage ? "justify-end" : "justify-start"}">
            <span class="text-[10px] text-gray-400">${time}</span>
          </div>
        </div>
        ${isMyMessage ? avatarHtml : ""}
      </div>`
  }

  handleKeydown(event) {
    // Enter 키로 전송 (Shift+Enter는 줄바꿈)
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submitForm()
      return
    }
    // 텍스트 영역 높이 자동 조절
    this.adjustTextareaHeight()
    // 타이핑 중 알림 전송
    this.sendTypingIndicator()
  }

  submitForm() {
    const content = this.inputTarget.value.trim()
    if (content.length === 0) return
    if (this._submitting) return
    this._submitting = true
    this.formTarget.requestSubmit()
    // 0.5초 후 다시 전송 가능
    setTimeout(() => { this._submitting = false }, 500)
  }

  resetForm(event) {
    // Turbo 제출 완료 후 폼 리셋
    if (event.detail.success) {
      this.inputTarget.value = ""
      this.inputTarget.style.height = "auto"
      this.inputTarget.focus()
      this.scrollToBottom()
      this._isTyping = false
      // 이모지 캐릭터 팝업 즉시 숨김
      if (this._emojiPopupTimer) {
        clearTimeout(this._emojiPopupTimer)
        this._emojiPopupTimer = null
      }
      const popup = document.getElementById("emoji-char-popup")
      if (popup) { popup.classList.add("hidden"); popup.classList.remove("pop-in", "pop-out") }
    }
  }

  adjustTextareaHeight() {
    const textarea = this.inputTarget
    textarea.style.height = "auto"
    textarea.style.height = Math.min(textarea.scrollHeight, 120) + "px"
  }

  detectEmoji() {
    const text = this.inputTarget.value
    const emojiRegex = /\p{Emoji_Presentation}|\p{Extended_Pictographic}/u
    if (!emojiRegex.test(text)) return

    const popup = document.getElementById("emoji-char-popup")
    if (!popup) return

    // 이미 팝업 표시 중이면 타이머만 리셋
    if (this._emojiPopupTimer) {
      clearTimeout(this._emojiPopupTimer)
    } else {
      popup.classList.remove("hidden", "pop-out")
      popup.classList.add("pop-in")
    }

    this._emojiPopupTimer = setTimeout(() => {
      popup.classList.remove("pop-in")
      popup.classList.add("pop-out")
      setTimeout(() => {
        popup.classList.add("hidden")
        popup.classList.remove("pop-out")
        this._emojiPopupTimer = null
      }, 250)
    }, 1500)
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      const container = this.messagesContainerTarget
      container.scrollTop = container.scrollHeight
    })
  }

  // ── 타이핑 인디케이터 ───────────────────────────────────────
  sendTypingIndicator() {
    if (!this._isTyping) {
      this._isTyping = true
      this.subscription.perform("typing", { typing: true })
    }
    clearTimeout(this._typingTimer)
    this._typingTimer = setTimeout(() => {
      this._isTyping = false
      this.subscription.perform("typing", { typing: false })
    }, 2000)
  }

  handleTypingIndicator(data) {
    // 내 타이핑은 표시 안 함
    if (data.user_id === this.currentUserIdValue) return
    if (data.typing) {
      this.showTypingIndicator(data.user_name)
    } else {
      this.hideTypingIndicator()
    }
  }

  showTypingIndicator(userName) {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.textContent = `${userName}님이 입력 중...`
      this.typingIndicatorTarget.classList.remove("hidden")
      this.scrollToBottom()
    }
  }

  hideTypingIndicator() {
    if (this.hasTypingIndicatorTarget) {
      this.typingIndicatorTarget.classList.add("hidden")
    }
  }

  // ── 읽음 처리 ──────────────────────────────────────────────
  handleReadReceipt(data) {
    // 상대방이 읽은 메시지에 읽음 표시 업데이트
    if (data.reader_id === this.currentUserIdValue) return
    document.querySelectorAll("[data-message-id]").forEach(el => {
      const readStatus = el.querySelector(".read-status")
      if (readStatus) {
        readStatus.textContent = "읽음"
        readStatus.classList.remove("hidden")
      }
    })
  }
}
