// this is the timer that pop up disappear
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.element.remove(), 2000)
  }


  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    // Flug nach rechts + leicht nach oben, Rotation
      this.element.classList.add(
        "translate-x-16",
        "-translate-y-3",
        "rotate-6",
        "opacity-0"
      )

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
