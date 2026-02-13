import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  formatAmount(event) {
    const value = event.target.value.replace(/[^\d]/g, "")
    event.target.value = value
  }
}
