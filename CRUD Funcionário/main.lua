-- main.lua
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local database = require("database")

-- Inicializar GTK
Gtk.init()

-- Criar janela principal
local window = Gtk.Window {
   title = "Cadastro de Funcionários",
   default_width = 600,
   default_height = 600
}

-- Criar uma caixa de layout vertical
local box = Gtk.Box {
    orientation = "VERTICAL",
    spacing = 10,
    margin = 20
}

-- Adicionar a logo acima dos botões
local logoImage = Gtk.Image {
    file = "logo.png",  -- Substitua pelo caminho real da sua logo
    halign = "CENTER",
}
box:pack_start(logoImage, false, false, 0)

-- Criar caixa de botões
local buttonBox = Gtk.Box {
    orientation = "HORIZONTAL",
    spacing = 10
}

-- Criar botões
local addButton = Gtk.Button { label = "Adicionar" }
local editButton = Gtk.Button { label = "Editar" }
local deleteButton = Gtk.Button { label = "Excluir" }
local listButton = Gtk.Button { label = "Listar" }

-- Adicionar os botões à caixa de botões
buttonBox:pack_start(addButton, true, true, 0)
buttonBox:pack_start(editButton, true, true, 0)
buttonBox:pack_start(deleteButton, true, true, 0)
buttonBox:pack_start(listButton, true, true, 0)

-- Adicionar a caixa de botões à caixa principal
box:pack_start(buttonBox, false, false, 0)

-- Adicionar labels para status
local statusLabel = Gtk.Label {
    label = "",
    halign = "START"
}
box:pack_start(statusLabel, false, false, 0)

-- Adicionar campos de entrada
local entryID = Gtk.Entry { placeholder_text = "ID" }
local entryName = Gtk.Entry { placeholder_text = "Nome" }
local entryProfession = Gtk.Entry { placeholder_text = "Profissão" }
local entryDepartment = Gtk.Entry { placeholder_text = "Setor" }
local entryGender = Gtk.Entry { placeholder_text = "Sexo" }
local entryAge = Gtk.Entry { placeholder_text = "Idade" }
local entryCPF = Gtk.Entry { placeholder_text = "CPF" }

-- Adicionar os campos de entrada à caixa principal
box:pack_start(entryID, false, false, 0)
box:pack_start(entryName, false, false, 0)
box:pack_start(entryProfession, false, false, 0)
box:pack_start(entryDepartment, false, false, 0)
box:pack_start(entryGender, false, false, 0)
box:pack_start(entryAge, false, false, 0)
box:pack_start(entryCPF, false, false, 0)

-- Adicionar área de texto para listar funcionários
local scrolledWindow = Gtk.ScrolledWindow()
local textView = Gtk.TextView {
    editable = false,
    wrap_mode = "WORD"
}
scrolledWindow:add(textView)
box:pack_start(scrolledWindow, true, true, 0)

-- Adicionar a caixa principal à janela
window:add(box)

-- Exibir todos os widgets
window:show_all()

-- Conectar evento de clique ao botão "Adicionar"
addButton.on_clicked = function()
    local id = tonumber(entryID.text)
    local name = entryName.text
    local profession = entryProfession.text
    local department = entryDepartment.text
    local gender = entryGender.text
    local age = tonumber(entryAge.text)
    local cpf = entryCPF.text

    if id and name and profession and department and gender and age and cpf then
        database.add_employee(id, name, profession, department, gender, age, cpf)
        statusLabel.label = "Funcionário adicionado com sucesso!"
    else
        statusLabel.label = "Por favor, preencha todos os campos."
    end
end

-- Conectar evento de clique ao botão "Editar"
editButton.on_clicked = function()
    local id = tonumber(entryID.text)
    local name = entryName.text
    local profession = entryProfession.text
    local department = entryDepartment.text
    local gender = entryGender.text
    local age = tonumber(entryAge.text)
    local cpf = entryCPF.text

    if id and name and profession and department and gender and age and cpf then
        database.edit_employee(id, name, profession, department, gender, age, cpf)
        statusLabel.label = "Funcionário editado com sucesso!"
    else
        statusLabel.label = "Por favor, preencha todos os campos."
    end
end

-- Conectar evento de clique ao botão "Excluir"
deleteButton.on_clicked = function()
    local id = tonumber(entryID.text)

    if id then
        database.delete_employee(id)
        statusLabel.label = "Funcionário excluído com sucesso!"
    else
        statusLabel.label = "Por favor, preencha o campo ID."
    end
end

-- Conectar evento de clique ao botão "Listar"
listButton.on_clicked = function()
    local employees = database.list_employees()
    local listText = ""

    for _, employee in ipairs(employees) do
        listText = listText .. string.format("ID: %d, Nome: %s, Profissão: %s, Setor: %s, Sexo: %s, Idade: %d, CPF: %s\n",
            employee.id, employee.name, employee.profession, employee.department,
            employee.gender, employee.age, employee.cpf)
    end

    if listText == "" then
        listText = "Nenhum funcionário cadastrado."
    end

    textView.buffer.text = listText
end

-- Conectar evento de fechar a janela
window.on_destroy = Gtk.main_quit

-- Entrar no loop principal do GTK
Gtk.main()
