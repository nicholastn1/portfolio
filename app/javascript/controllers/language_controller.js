import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switch(event) {
    const locale = event.currentTarget.dataset.locale
    document.cookie = `locale=${locale};path=/;max-age=31536000`

    // Redirect to the appropriate URL
    const currentPath = window.location.pathname
    if (locale === "en") {
      // Add /en prefix if not already present
      if (!currentPath.startsWith("/en")) {
        window.location.href = "/en" + (currentPath === "/" ? "" : currentPath)
      }
    } else {
      // Remove /en prefix
      if (currentPath.startsWith("/en")) {
        const newPath = currentPath.replace(/^\/en\/?/, "/")
        window.location.href = newPath || "/"
      } else {
        window.location.reload()
      }
    }
  }
}
