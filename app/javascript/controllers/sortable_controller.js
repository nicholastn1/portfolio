import { Controller } from "@hotwired/stimulus"

// Native HTML5 drag & drop for admin list tables. Drag is armed from the
// handle cell only, so links/buttons in the row keep their own drag behavior.
export default class extends Controller {
  static values = { url: String }

  start(event) {
    this.dragged = event.currentTarget.closest("tr")
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", "") // Firefox needs some payload
    event.dataTransfer.setDragImage(this.dragged, 0, 0)
    this.dragged.classList.add("opacity-40")
  }

  over(event) {
    if (!this.dragged) return
    event.preventDefault()

    const row = event.target.closest("tr")
    if (!row || row === this.dragged || row.parentElement !== this.element) return

    const { top, height } = row.getBoundingClientRect()
    const after = event.clientY > top + height / 2
    this.element.insertBefore(this.dragged, after ? row.nextSibling : row)
  }

  drop(event) {
    event.preventDefault()
  }

  end() {
    if (!this.dragged) return
    this.dragged.classList.remove("opacity-40")
    this.dragged = null
    this.save()
  }

  save() {
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
      },
      body: JSON.stringify({
        ids: [...this.element.children].map((row) => row.dataset.id)
      })
      // 204 is the only success; an expired session redirects to login and
      // comes back as a 200, so reload rather than fake a saved order.
    }).then((response) => { if (response.status !== 204) location.reload() })
  }
}
