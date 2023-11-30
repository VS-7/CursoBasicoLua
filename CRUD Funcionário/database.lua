-- database.lua
local sqlite3 = require("lsqlite3")

local db = sqlite3.open("employees.db")

-- Criar tabela se não existir
db:exec[[
  CREATE TABLE IF NOT EXISTS employees (
    id INTEGER PRIMARY KEY,
    name TEXT,
    profession TEXT,
    department TEXT,
    gender TEXT,
    age INTEGER,
    cpf TEXT UNIQUE
  );
]]

-- Função para adicionar um funcionário
function add_employee(id, name, profession, department, gender, age, cpf)
  local stmt = db:prepare("INSERT INTO employees (id, name, profession, department, gender, age, cpf) VALUES (?, ?, ?, ?, ?, ?, ?)")
  stmt:bind_values(id, name, profession, department, gender, age, cpf)
  stmt:step()
  stmt:finalize()
end

-- Função para listar todos os funcionários
function list_employees()
  local employees = {}

  for row in db:nrows("SELECT * FROM employees") do
    table.insert(employees, row)
  end

  return employees
end

-- Função para editar um funcionário
function edit_employee(id, name, profession, department, gender, age, cpf)
  local stmt = db:prepare("UPDATE employees SET name=?, profession=?, department=?, gender=?, age=?, cpf=? WHERE id=?")
  stmt:bind_values(name, profession, department, gender, age, cpf, id)
  stmt:step()
  stmt:finalize()
end

-- Função para excluir um funcionário
function delete_employee(id)
  local stmt = db:prepare("DELETE FROM employees WHERE id=?")
  stmt:bind_values(id)
  stmt:step()
  stmt:finalize()
end

-- Fechar o banco de dados ao sair
function close_database()
  db:close()
end

return {
  add_employee = add_employee,
  list_employees = list_employees,
  edit_employee = edit_employee,
  delete_employee = delete_employee,
  close_database = close_database
}
