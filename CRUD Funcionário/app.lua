-- app.lua
local Gtk = require("lgi").require("Gtk", "3.0")
local main = require("main")

-- Inicializar GTK
Gtk.init()

-- Executar a aplicação principal
main()

-- Entrar no loop principal do GTK
Gtk.main()
