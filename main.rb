require_relative 'caixa'
require_relative 'operacao'

opt = 0
caixa = Caixa.new(2000, 1000, 3.80)

while opt != 7
    puts "Bem-vindo a casa de cambio."
    puts "Escolha uma das opções abaixo:"

    puts "[1] Comprar dolares"
    puts "[2] Vender dolares"
    puts "[3] Comprar reais"
    puts "[4] Vender reais"
    puts "[5] Ver operações do dia"
    puts "[6] Ver situação do caixa"
    puts "[7] Sair"

    opt = gets().to_i()

    case opt
    when 1
        puts "Quantos dolares deseja comprar?"
        dolares = gets().to_i()
        if !caixa.check_dollars(dolares)
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        else
            operation = Operacao.new(1,"Compra", "U$", dolares)
            caixa.transaction(operation)
            #caixa.buy_dollars(operation)
        end
    when 2
        puts "Quantos dolares deseja vender?"
        dolares = gets().to_i()
        if !caixa.check_dollars(dolares)
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        else
            operation = Operacao.new(1,"Venda", "U$", dolares)
            #caixa.buy_dollars(operation)
            caixa.transaction(operation)
        end
    when 3
        puts "Quantos reais deseja comprar?"
        reais = gets().to_i()
        if !caixa.check_reais(reais)
            puts "Não é possível realizar a transação. REAIS insuficientes no caixa ou quantia invalida."
        else
            operation = Operacao.new(1,"Compra", "BRL", reais)
            caixa.transaction(operation)
        end
    when 5
        caixa.print_operations()
    when 6
        caixa.print()
    end
end

