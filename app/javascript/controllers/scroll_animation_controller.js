import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element"]

  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.showAllElements()
      return
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry, index) => {
          if (entry.isIntersecting) {
            const delay = entry.target.dataset.animationDelay || index * 100
            setTimeout(() => {
              entry.target.classList.add("animate-visible")
              entry.target.classList.remove("animate-hidden")
            }, delay)
            this.observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.1, rootMargin: "0px 0px -50px 0px" }
    )

    this.elementTargets.forEach((el) => {
      el.classList.add("animate-hidden")
      this.observer.observe(el)
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  showAllElements() {
    this.elementTargets.forEach((el) => {
      el.classList.remove("animate-hidden")
      el.classList.add("animate-visible")
    })
  }
}
