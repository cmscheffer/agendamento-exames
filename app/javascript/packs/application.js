import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Bootstrap
import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/dist/css/bootstrap'

// Estilos personalizados
import '../stylesheets/application'