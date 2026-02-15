import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "iconOpen", "iconClose"]

  connect() {
    this.isOpen = false
    this._onKeydown = this._onKeydown.bind(this)
    this._onTurboNav = this.close.bind(this)
    document.addEventListener("keydown", this._onKeydown)
    document.addEventListener("turbo:before-visit", this._onTurboNav)
  }

  disconnect() {
    document.removeEventListener("keydown", this._onKeydown)
    document.removeEventListener("turbo:before-visit", this._onTurboNav)
    document.body.style.overflow = ""
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.isOpen = true
    this.panelTarget.classList.remove("hidden")
    this.iconOpenTarget.classList.add("hidden")
    this.iconCloseTarget.classList.remove("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    this.buttonTarget.setAttribute("aria-label", "메뉴 닫기")
    document.body.style.overflow = "hidden"
  }

  close() {
    if (!this.isOpen) return
    this.isOpen = false
    this.panelTarget.classList.add("hidden")
    this.iconOpenTarget.classList.remove("hidden")
    this.iconCloseTarget.classList.add("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    this.buttonTarget.setAttribute("aria-label", "메뉴 열기")
    document.body.style.overflow = ""
  }

  _onKeydown(event) {
    if (event.key === "Escape" && this.isOpen) {
      this.close()
    }
  }
}
