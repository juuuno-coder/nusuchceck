import { Controller } from "@hotwired/stimulus"

// Turbo 페이지 전환 시 로딩 프로그레스 바
export default class extends Controller {
  static targets = ["bar"]

  connect() {
    // Turbo 이벤트 리스너 등록
    document.addEventListener("turbo:before-fetch-request", this.showProgress.bind(this))
    document.addEventListener("turbo:before-fetch-response", this.completeProgress.bind(this))
    document.addEventListener("turbo:frame-load", this.completeProgress.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.showProgress.bind(this))
    document.removeEventListener("turbo:before-fetch-response", this.completeProgress.bind(this))
    document.removeEventListener("turbo:frame-load", this.completeProgress.bind(this))
  }

  showProgress() {
    this.barTarget.style.width = "0%"
    this.barTarget.classList.remove("hidden")

    // 애니메이션으로 70%까지 진행
    setTimeout(() => {
      this.barTarget.style.width = "70%"
    }, 10)
  }

  completeProgress() {
    // 100%로 완료
    this.barTarget.style.width = "100%"

    // 완료 후 숨김
    setTimeout(() => {
      this.barTarget.classList.add("hidden")
      this.barTarget.style.width = "0%"
    }, 300)
  }
}
