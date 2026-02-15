import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 },
    type: { type: String, default: "info" }
  }

  connect() {
    this.element.classList.add("toast-enter")
    this.remaining = this.durationValue
    this.startTimer()
  }

  disconnect() {
    this.stopTimer()
  }

  startTimer() {
    this.startTime = Date.now()
    this.timer = setTimeout(() => this.dismiss(), this.remaining)
  }

  stopTimer() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.remaining -= Date.now() - this.startTime
    }
  }

  pause() {
    this.stopTimer()
  }

  resume() {
    if (this.remaining > 0) {
      this.startTimer()
    }
  }

  dismiss() {
    this.stopTimer()
    this.element.classList.remove("toast-enter")
    this.element.classList.add("toast-exit")
    this.element.addEventListener("animationend", () => {
      this.element.remove()
    }, { once: true })
  }
}
