require_relative 'cashier'
require_relative 'transaction'
require 'terminal-table'
require 'sqlite3'

opt = 0

puts "Entre com a quantidade de reais do caixa:"
r = gets().to_f()
puts "Entre com a quantidade de dolares do caixa:"
d = gets().to_f()
puts "Entre com a cotação do dolar de hoje:"
c = gets().to_f()

cashier = Cashier.new(r, d, c)

db = SQLite3::Database.open "cambio.db"

while opt != 7

    cashier.show_menu

    opt = gets().to_i()

    case opt
    when 1
        puts "Quantos dolares deseja comprar?"
        amount = gets().to_f()
        transaction = Transaction.new("Compra", "U$D", amount, cashier.quotation)
        #db.execute("insert into transactions values(#{operation.type}, #{operation.currency}, #{operation.amount}, #{operation.quotation});")
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
        db.close
    end
end

