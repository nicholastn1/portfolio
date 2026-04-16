import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.menuTarget.classList.remove("hidden")
      document.body.style.overflow = "hidden"
    } else {
      this.menuTarget.classList.add("hidden")
      document.body.style.overflow = ""
    }
  }

  close() {
    this.isOpen = false
    this.menuTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }
}
