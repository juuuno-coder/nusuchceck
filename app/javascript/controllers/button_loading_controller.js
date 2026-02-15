import { Controller } from "@hotwired/stimulus"

// 폼 제출 시 버튼 로딩 상태
export default class extends Controller {
  static targets = ["button", "text", "spinner"]
  static values = {
    loadingText: { type: String, default: "처리 중..." }
  }

  submit(event) {
    // 이미 로딩 중이면 중복 제출 방지
    if (this.hasButtonTarget && this.buttonTarget.disabled) {
      event.preventDefault()
      return
    }

    this.setLoading()
  }

  setLoading() {
    if (this.hasButtonTarget) {
      // 버튼 비활성화
      this.buttonTarget.disabled = true
      this.buttonTarget.classList.add("opacity-75", "cursor-not-allowed")

      // 텍스트 변경
      if (this.hasTextTarget) {
        this.originalText = this.textTarget.textContent
        this.textTarget.textContent = this.loadingTextValue
      }

      // 스피너 표시
      if (this.hasSpinnerTarget) {
        this.spinnerTarget.classList.remove("hidden")
      }
    }
  }

  reset() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
      this.buttonTarget.classList.remove("opacity-75", "cursor-not-allowed")

      if (this.hasTextTarget && this.originalText) {
        this.textTarget.textContent = this.originalText
      }

      if (this.hasSpinnerTarget) {
        this.spinnerTarget.classList.add("hidden")
      }
    }
  }
}
