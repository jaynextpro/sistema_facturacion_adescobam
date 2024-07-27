# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery", to: "jquery.min.js"
pin "custom"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "bootstrap", to: "bootstrap.min.js"
pin "@popperjs/core", to: "popper.min.js"