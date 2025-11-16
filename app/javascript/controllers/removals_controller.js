import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="removals"
export default class extends Controller {
  static values = { autoremove: Boolean };

  connect() {
    if (this.autoremoveValue) {
      setTimeout(() => {
        this.remove();
      }, 5000);
    }
  }

  remove() {
    this.element.remove();
  }
}
