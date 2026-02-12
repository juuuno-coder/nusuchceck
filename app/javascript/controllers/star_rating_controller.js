import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]

  select(event) {
    const value = event.currentTarget.dataset.value
    const group = event.currentTarget.closest("[data-rating-group]")
    if (!group) return

    const groupName = group.dataset.ratingGroup
    const input = group.querySelector(`input[name*="${groupName}"]`) || this.inputTarget
    if (input) input.value = value

    // 별 표시 업데이트
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
    })
  }
}
