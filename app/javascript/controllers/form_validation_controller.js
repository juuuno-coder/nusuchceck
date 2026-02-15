import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  connect() {
    this.element.setAttribute("novalidate", "")
  }

  validate(event) {
    const field = event.target
    this._validateField(field)
  }

  submit(event) {
    let firstError = null
    const fields = this.element.querySelectorAll("input, select, textarea")

    fields.forEach(field => {
      if (!this._validateField(field) && !firstError) {
        firstError = field
      }
    })

    if (firstError) {
      event.preventDefault()
      firstError.scrollIntoView({ behavior: "smooth", block: "center" })
      firstError.focus()
    }
  }

  _validateField(field) {
    const wrapper = field.closest("div")
    if (!wrapper) return true

    this._clearError(wrapper)

    if (field.required && !field.value.trim()) {
      this._showError(wrapper, "필수 입력 항목입니다.")
      return false
    }

    if (field.type === "email" && field.value.trim()) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(field.value)) {
        this._showError(wrapper, "올바른 이메일 형식을 입력해 주세요.")
        return false
      }
    }

    if (field.type === "tel" && field.value.trim()) {
      const phoneRegex = /^[\d\-+() ]{9,}$/
      if (!phoneRegex.test(field.value)) {
        this._showError(wrapper, "올바른 전화번호 형식을 입력해 주세요.")
        return false
      }
    }

    if (field.minLength > 0 && field.value.trim().length < field.minLength) {
      this._showError(wrapper, `최소 ${field.minLength}자 이상 입력해 주세요.`)
      return false
    }

    if (field.value.trim()) {
      wrapper.classList.add("field-success")
    }

    return true
  }

  _showError(wrapper, message) {
    wrapper.classList.add("field-error")
    wrapper.classList.remove("field-success")

    const existing = wrapper.querySelector(".validation-message")
    if (existing) existing.remove()

    const msg = document.createElement("p")
    msg.className = "validation-message mt-1 text-xs text-red-600"
    msg.textContent = message
    msg.setAttribute("role", "alert")
    wrapper.appendChild(msg)
  }

  _clearError(wrapper) {
    wrapper.classList.remove("field-error", "field-success")
    const msg = wrapper.querySelector(".validation-message")
    if (msg) msg.remove()
  }
}
