import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    max: { type: Number, default: 8 },
    speed: { type: Number, default: 400 },
    scale: { type: Number, default: 1.02 }
  }

  connect() {
    if (this.isTouchDevice()) return

    this.handleMouseMove = this.handleMouseMove.bind(this)
    this.handleMouseLeave = this.handleMouseLeave.bind(this)

    this.element.addEventListener("mousemove", this.handleMouseMove)
    this.element.addEventListener("mouseleave", this.handleMouseLeave)
    this.element.style.transition = `transform ${this.speedValue}ms cubic-bezier(0.03, 0.98, 0.52, 0.99)`
    this.element.style.transformStyle = "preserve-3d"
  }

  disconnect() {
    this.element.removeEventListener("mousemove", this.handleMouseMove)
    this.element.removeEventListener("mouseleave", this.handleMouseLeave)
  }

  handleMouseMove(e) {
    const rect = this.element.getBoundingClientRect()
    const x = e.clientX - rect.left
    const y = e.clientY - rect.top
    const centerX = rect.width / 2
    const centerY = rect.height / 2

    const rotateX = ((y - centerY) / centerY) * -this.maxValue
    const rotateY = ((x - centerX) / centerX) * this.maxValue

    this.element.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(${this.scaleValue}, ${this.scaleValue}, ${this.scaleValue})`
  }

  handleMouseLeave() {
    this.element.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)"
  }

  isTouchDevice() {
    return "ontouchstart" in window || navigator.maxTouchPoints > 0
  }
}
