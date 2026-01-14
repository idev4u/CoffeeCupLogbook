import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Pop in (next tick)
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "scale-75", "translate-y-2")
      this.element.classList.add("opacity-100", "scale-100", "-translate-y-1")
    })

    // Soft float for a premium feel.
    this.floatTimer = setTimeout(() => {
      this.element.classList.remove("opacity-100", "scale-100", "-translate-y-1")
      this.element.classList.add("opacity-0", "scale-95", "-translate-y-6", "rotate-2")
    }, 700)

    // Remove from DOM
    this.removeTimer = setTimeout(() => {
      this.element.remove()
    }, 1000)
  }

  disconnect() {
    clearTimeout(this.floatTimer)
    clearTimeout(this.removeTimer)
  }
}
