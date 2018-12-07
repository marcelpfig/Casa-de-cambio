require_relative 'cashier'
require_relative 'transaction'
require 'terminal-table'
require 'sqlite3'

db = SQLite3::Database.open "cambio.db"
db.results_as_hash = true
opt = 0

puts "Entre com o nome de operador:"
user = gets().chomp

last_cashier = Cashier.check_cashier(user, db)

#Se o array não estiver vazio
if(!last_cashier.empty?)
    cashier = Cashier.new(last_cashier[0]['user'], last_cashier[0]['reais'], last_cashier[0]['dolares'], last_cashier[0]['quotation'])
    cashier.id = last_cashier[0]['id']
    puts "Caixa na data atual encontrado.."
    cashier.print()

    puts "Deseja atualizar os valores? (y/n)"
    update = gets().chomp
    if update == "y"
        puts "Entre com a quantidade de reais do caixa:"
        cashier.reais = gets().to_f()
        puts "Entre com a quantidade de dolares do caixa:"
        cashier.dolares = gets().to_f()
        puts "Entre com a cotação do dolar de hoje:"
        cashier.quotation = gets().to_f()

        cashier.update_to_db(db)
    end
else
    puts "Nenhum caixa em aberto.."
    puts "Criando novo caixa.."
    puts "Entre com o nome do operador do caixa:"
    u = gets().chomp
    puts "Entre com a quantidade de reais do caixa:"
    r = gets().to_f()
    puts "Entre com a quantidade de dolares do caixa:"
    d = gets().to_f()
    puts "Entre com a cotação do dolar de hoje:"
    c = gets().to_f()

    cashier = Cashier.new(u, r, d, c)
    cashier.new_to_db(db)
    teste = db.execute("select id from cashiers where date = '#{cashier.date}' and user = '#{cashier.user}'")
    cashier.id = teste[0]["id"]
end

while opt != 7

    cashier.show_menu

    opt = gets().to_i()

    case opt
    when 1
        puts "Quantos dolares deseja comprar?"
        amount = gets().to_f()
        transaction = Transaction.new("Compra", "U$D", amount, cashier.quotation)
        cashier.buy_dollars(transaction, db)

    when 2
        puts "Quantos dolares deseja vender?"
        amount = gets().to_f()
        transaction = Transaction.new("Venda", "U$D", amount, cashier.quotation)
        cashier.sell_dollars(transaction, db)
    when 3
        puts "Quantos reais deseja comprar?"
        amount = gets().to_i()
        transaction = Transaction.new("Compra", "BRL", amount, cashier.quotation)
        cashier.buy_reais(transaction, db)
    when 4
        puts "Quantos reais deseja vender?"
        amount = gets().to_i()
        transaction = Transaction.new("Venda", "BRL", amount, cashier.quotation)
        cashier.sell_reais(transaction, db)    
    when 5
        cashier.print_transactions(db)
    when 6
        cashier.print()
    when 7
        #cashier.save_transactions_to_file()
        cashier.update_to_db(db)
        db.close
    end
end

