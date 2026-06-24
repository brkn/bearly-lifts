import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tree", "exerciseTemplate", "setTemplate", "query", "results", "resultTemplate"]
  static values = { url: String }

  initialize() {
    this.searchToken = 0
    this.lastResults = []
  }

  disconnect() {
    clearTimeout(this.searchTimeout)
    this.searchToken++
  }

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

  search() {
    clearTimeout(this.searchTimeout)
    this.lastResults = []
    this.searchTimeout = setTimeout(() => this.#fetchResults(), 200)
  }

  pick(event) {
    event.preventDefault()
    this.addExercise(this.lastResults[event.params.index])
    this.#resetSearch()
  }

  pickFirst(event) {
    event.preventDefault()
    if (!this.lastResults.length) return

    this.addExercise(this.lastResults[0])
    this.#resetSearch()
  }

  closeResults() {
    clearTimeout(this.searchTimeout)
    this.searchToken++
    this.resultsTarget.replaceChildren()
    this.resultsTarget.hidden = true
  }

  addExercise(variation) {
    const card = this.exerciseTemplateTarget.content.firstElementChild.cloneNode(true)
    card.querySelector(".lift-name").textContent = variation.name
    card.querySelector(".tag").textContent = variation.muscle
    card.querySelector(".scheme").textContent = variation.weight_scheme
    card.querySelector("input[name='workout[workout_exercises][][exercise_variation_id]']").value = variation.id
    this.treeTarget.appendChild(card)
  }

  async #fetchResults() {
    const token = ++this.searchToken

    try {
      const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(this.queryTarget.value)}`, {
        headers: { Accept: "application/json" },
      })
      if (token !== this.searchToken || !response.ok) return

      const data = await response.json()
      if (token !== this.searchToken) return

      this.lastResults = data
      this.#renderResults()
    } catch {
      if (token !== this.searchToken) return

      this.lastResults = []
      this.resultsTarget.replaceChildren()
      this.resultsTarget.hidden = true
    }
  }

  #renderResults() {
    this.resultsTarget.replaceChildren()
    this.lastResults.forEach((variation, index) => {
      const row = this.resultTemplateTarget.content.firstElementChild.cloneNode(true)
      row.querySelector(".result-name").textContent = variation.name
      row.querySelector(".result-muscle").textContent = variation.muscle
      row.dataset.workoutFormIndexParam = index
      this.resultsTarget.appendChild(row)
    })
    this.resultsTarget.hidden = this.lastResults.length === 0
  }

  #resetSearch() {
    this.queryTarget.value = ""
    this.lastResults = []
    this.closeResults()
  }

  #renumber(sets) {
    sets.querySelectorAll(".idx").forEach((idx, i) => {
      idx.textContent = i + 1
    })
  }
}
