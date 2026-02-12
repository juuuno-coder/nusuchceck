import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss() {
    this.element.remove()
  }

  connect() {
    // 5초 후 자동 숨김
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s"
      this.element.style.opacity = "0"
      setTimeout(() => this.element.remove(), 500)
    }, 5000)
  }
}
