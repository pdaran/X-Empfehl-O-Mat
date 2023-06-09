import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  select() {
    this.element.requestSubmit()
  }
  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 100)
  }
}