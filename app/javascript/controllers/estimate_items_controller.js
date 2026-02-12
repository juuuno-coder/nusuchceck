import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "total", "vat", "grandTotal"]

  connect() {
    this.calculateTotals()
  }

  addItem(event) {
    event.preventDefault()
    const index = this.containerTarget.children.length
    const template = this.templateTarget.innerHTML.replace(/NEW_INDEX/g, index)
    this.containerTarget.insertAdjacentHTML("beforeend", template)
  }

  removeItem(event) {
    event.preventDefault()
    const item = event.target.closest("[data-estimate-items-target='item']") || event.target.closest(".estimate-item")
    if (item) {
      item.remove()
      this.calculateTotals()
    }
  }

  calculateTotals() {
    let total = 0
    const rows = this.containerTarget.querySelectorAll(".estimate-item")

    rows.forEach(row => {
      const quantity = parseFloat(row.querySelector("[data-field='quantity']")?.value) || 0
      const unitPrice = parseFloat(row.querySelector("[data-field='unit_price']")?.value) || 0
      const amount = quantity * unitPrice
      const amountField = row.querySelector("[data-field='amount']")
      if (amountField) {
        amountField.value = amount
      }
      total += amount
    })

    const vat = Math.round(total * 0.1)
    const grandTotal = total + vat

    if (this.hasTotalTarget) this.totalTarget.textContent = this.formatCurrency(total)
    if (this.hasVatTarget) this.vatTarget.textContent = this.formatCurrency(vat)
    if (this.hasGrandTotalTarget) this.grandTotalTarget.textContent = this.formatCurrency(grandTotal)
  }

  loadRecommended(event) {
    event.preventDefault()
    const symptomType = event.currentTarget.dataset.symptomType || document.querySelector("[data-symptom-type]")?.dataset.symptomType

    fetch(`/api/standard_estimate_items?symptom_type=${symptomType || ""}`)
      .then(response => response.json())
      .then(items => {
        items.forEach((item, i) => {
          const index = this.containerTarget.children.length + i
          this.addItemFromData(index, item)
        })
        this.calculateTotals()
      })
  }

  addItemFromData(index, item) {
    const html = `
      <div class="estimate-item grid grid-cols-7 gap-2 items-center py-2 border-b">
        <select name="estimate[line_items][][category]" class="rounded border-gray-300 text-sm">
          <option value="trip" ${item.category === "trip" ? "selected" : ""}>출장비</option>
          <option value="detection" ${item.category === "detection" ? "selected" : ""}>탐지</option>
          <option value="construction" ${item.category === "construction" ? "selected" : ""}>공사</option>
          <option value="material" ${item.category === "material" ? "selected" : ""}>자재</option>
        </select>
        <input type="text" name="estimate[line_items][][name]" value="${item.name}" class="rounded border-gray-300 text-sm" />
        <input type="text" name="estimate[line_items][][unit]" value="${item.unit || ''}" class="rounded border-gray-300 text-sm" />
        <input type="number" name="estimate[line_items][][quantity]" value="1" min="1" data-field="quantity" data-action="input->estimate-items#calculateTotals" class="rounded border-gray-300 text-sm" />
        <input type="number" name="estimate[line_items][][unit_price]" value="${item.default_price || 0}" data-field="unit_price" data-action="input->estimate-items#calculateTotals" class="rounded border-gray-300 text-sm" />
        <input type="number" name="estimate[line_items][][amount]" value="${item.default_price || 0}" data-field="amount" readonly class="rounded border-gray-300 text-sm bg-gray-50" />
        <button type="button" data-action="click->estimate-items#removeItem" class="text-red-600 hover:text-red-800 text-sm">삭제</button>
        <input type="hidden" name="estimate[line_items][][item_id]" value="${item.id}" />
      </div>
    `
    this.containerTarget.insertAdjacentHTML("beforeend", html)
  }

  formatCurrency(amount) {
    return "₩" + Math.round(amount).toLocaleString("ko-KR")
  }
}
