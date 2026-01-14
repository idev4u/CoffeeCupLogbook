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
    // Soft glide for a more premium feel.
      this.element.classList.add(
        "translate-x-10",
        "-translate-y-2",
        "rotate-2",
        "opacity-0"
      )

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
