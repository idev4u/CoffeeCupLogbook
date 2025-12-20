// this is the timer that pop up disappear
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.element.remove(), 2000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
