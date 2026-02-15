import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]

  select(event) {
    const value = event.currentTarget.dataset.value
    this._setValue(event.currentTarget, value)
  }

  keydown(event) {
    const current = event.currentTarget
    const group = current.closest("[data-rating-group]")
    if (!group) return

    const stars = Array.from(group.querySelectorAll("[data-star]"))
    const index = stars.indexOf(current)
    let newIndex = index

    switch (event.key) {
      case "ArrowRight":
      case "ArrowUp":
        event.preventDefault()
        newIndex = Math.min(index + 1, stars.length - 1)
        break
      case "ArrowLeft":
      case "ArrowDown":
        event.preventDefault()
        newIndex = Math.max(index - 1, 0)
        break
      case "Enter":
      case " ":
        event.preventDefault()
        this._setValue(current, current.dataset.value || current.dataset.star)
        return
      default:
        return
    }

    if (newIndex !== index) {
      stars[newIndex].focus()
      this._setValue(stars[newIndex], stars[newIndex].dataset.value || stars[newIndex].dataset.star)
    }
  }

  _setValue(element, value) {
    const group = element.closest("[data-rating-group]")
    if (!group) return

    const groupName = group.dataset.ratingGroup
    const input = group.querySelector(`input[name*="${groupName}"]`) || this.inputTarget
    if (input) input.value = value

    const stars = group.querySelectorAll("[data-star]")
    stars.forEach(star => {
      const starValue = parseInt(star.dataset.star)
      if (starValue <= parseInt(value)) {
        star.classList.add("text-yellow-400")
        star.classList.remove("text-gray-300")
      } else {
        star.classList.remove("text-yellow-400")
        star.classList.add("text-gray-300")
      }
      star.setAttribute("aria-checked", starValue <= parseInt(value) ? "true" : "false")
    })
  }
}
