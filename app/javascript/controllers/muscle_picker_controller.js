import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["muscle"]

  submit(event) {
    event.preventDefault()

    const slugs = this.muscleTargets
                      .filter((box) => box.checked)
                      .map((box) => encodeURIComponent(box.value))

    Turbo.visit(`${this.element.action}?muscles=${slugs.join(",")}`)
  }
}
