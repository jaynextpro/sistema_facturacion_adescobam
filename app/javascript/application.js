// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "jquery"
import Rails from '@rails/ujs';

Rails.start();

import "@popperjs/core"
import "bootstrap"
import "flatpickr"
import "flatpickr_es"

document.addEventListener('DOMContentLoaded', function() {
    flatpickr('.datepicker', {
        dateFormat: "d-m-Y",
        locale: "es"
    });

    flatpickr('.datepicker_with_time', {
      dateFormat: "d-m-Y H:i",
      locale: "es",
      enableTime: true,
      time_24hr: true
  });
})