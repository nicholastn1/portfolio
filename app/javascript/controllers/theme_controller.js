import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.applyTheme()
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.handleSystemChange = this.handleSystemChange.bind(this)
    this.mediaQuery.addEventListener("change", this.handleSystemChange)
  }

  disconnect() {
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener("change", this.handleSystemChange)
    }
  }

  toggle() {
    const html = document.documentElement
    const isDark = html.classList.contains("dark")

    if (isDark) {
      html.classList.remove("dark")
      html.classList.add("light")
      localStorage.setItem("theme", "light")
    } else {
      html.classList.remove("light")
      html.classList.add("dark")
      localStorage.setItem("theme", "dark")
    }
  }

  applyTheme() {
    const stored = localStorage.getItem("theme")
    const html = document.documentElement

    if (stored === "light") {
      html.classList.remove("dark")
      html.classList.add("light")
    } else if (stored === "dark") {
      html.classList.remove("light")
      html.classList.add("dark")
    } else {
      // Use system preference
      if (this.mediaQuery && this.mediaQuery.matches) {
        html.classList.add("dark")
      } else {
        html.classList.remove("dark")
      }
    }
  }

  handleSystemChange(e) {
    if (!localStorage.getItem("theme")) {
      const html = document.documentElement
      if (e.matches) {
        html.classList.add("dark")
      } else {
        html.classList.remove("dark")
      }
    }
  }
}
