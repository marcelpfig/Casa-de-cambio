require_relative 'caixa'
require_relative 'operacao'
require 'terminal-table'

opt = 0

puts "Entre com a quantidade de reais do caixa:"
r = gets().to_f()
puts "Entre com a quantidade de dolares do caixa:"
d = gets().to_f()
puts "Entre com a cotação do dolar de hoje:"
c = gets().to_f()

caixa = Caixa.new(r, d, c)

while opt != 7

    caixa.show_menu

    opt = gets().to_i()

    case opt
    when 1
        puts "Quantos dolares deseja comprar?"
        amount = gets().to_f()
        operation = Operacao.new("Compra", "U$D", amount, caixa.cotacao)
        caixa.buy_dollars(operation)

    when 2
        puts "Quantos dolares deseja vender?"
        amount = gets().to_f()
        operation = Operacao.new("Venda", "U$D", amount, caixa.cotacao)
        caixa.sell_dollars(operation)
    when 3
        puts "Quantos reais deseja comprar?"
        amount = gets().to_i()
        operation = Operacao.new("Compra", "BRL", amount, caixa.cotacao)
        caixa.buy_reais(operation)
    when 4
        puts "Quantos reais deseja vender?"
        amount = gets().to_i()
        operation = Operacao.new("Venda", "BRL", amount, caixa.cotacao)
        caixa.sell_reais(operation)    
    when 5
        caixa.print_operations()
    when 6
        caixa.print()
    when 7
        caixa.save_operations_to_file()
    end
end

