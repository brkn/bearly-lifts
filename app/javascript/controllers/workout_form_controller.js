import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tree", "exerciseTemplate", "setTemplate"]

  removeExercise(event) {
    event.currentTarget.closest(".lift").remove()
  }

  addSet(event) {
    const sets = event.currentTarget.closest(".lift").querySelector(".sets")
    sets.appendChild(this.setTemplateTarget.content.firstElementChild.cloneNode(true))
    this.#renumber(sets)
  }

  removeSet(event) {
    const sets = event.currentTarget.closest(".sets")
    event.currentTarget.closest(".grid").remove()
    this.#renumber(sets)
  }

  addExercise(variation) {
    const card = this.exerciseTemplateTarget.content.firstElementChild.cloneNode(true)
    card.querySelector(".lift-name").textContent = variation.name
    card.querySelector(".tag").textContent = variation.tag
    card.querySelector(".scheme").textContent = variation.scheme
    card.querySelector("input[name='workout[workout_exercises][][exercise_variation_id]']").value = variation.variation_id
    this.treeTarget.appendChild(card)
  }

  #renumber(sets) {
    sets.querySelectorAll(".idx").forEach((idx, i) => {
      idx.textContent = i + 1
    })
  }
}
