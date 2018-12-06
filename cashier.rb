class Cashier
    attr_accessor :reais, :dolares, :quotation, :all_operations

    def initialize(reais, dolares, quotation)
        @reais = reais
        @dolares = dolares
        @quotation = quotation
        @all_operations = Array.new
    end

    def show_menu
        puts "Bem-vindo a casa de cambio."
        puts "Escolha uma das opções abaixo:"

        puts "[1] Comprar dolares"
        puts "[2] Vender dolares"
        puts "[3] Comprar reais"
        puts "[4] Vender reais"
        puts "[5] Ver operações do dia"
        puts "[6] Ver situação do caixa"
        puts "[7] Sair"
    end

    def print
        rows = []
        rows << ["Reais:", self.reais]
        rows << ["Dolares:", self.dolares]
        rows << ["Cotação:", self.quotation]
        table = Terminal::Table.new :title => "Caixa Atual", :rows => rows
        puts table
    end

    def print_transactions
        self.all_operations.each do |item|
            rows =[]
            rows << ["Operação:", item.id]
            rows << ["Tipo:", item.type]
            rows << ["Moeda:", item.currency]
            rows << ["Total:", "#{item.total} U$D"]
            
            table = Terminal::Table.new :rows => rows
            puts table
        end
    end

    def buy_dollars(operation)
        if operation.amount > (self.reais/self.quotation) or operation.amount <= 0
            puts "Não é possível realizar a transação. Reais insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(operation)
            self.dolares += operation.amount
            self.reais -= (operation.amount * self.quotation)
            self.all_operations << operation
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def sell_dollars(operation)
        if operation.amount > self.dolares or operation.amount <= 0
            puts "Não é possível realizar a transação. Reais insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(operation)
            self.dolares -= operation.amount
            self.reais += (operation.amount * self.quotation)
            self.all_operations << operation
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def buy_reais(operation)
        if operation.amount > (self.dolares * self.quotation) or operation.amount <= 0
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(operation)
            self.dolares -= (operation.amount/self.quotation)
            self.reais += operation.amount
            self.all_operations << operation
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def sell_reais(operation)
        if operation.amount > self.reais or operation.amount <= 0
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(operation)
            self.dolares += (operation.amount/self.quotation)
            self.reais -= operation.amount
            self.all_operations << operation
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def confirm_transaction(operation)
        puts "Operação de #{operation.type} de #{operation.amount} de #{operation.currency}."
        puts "Total de #{operation.total} U$D"
        puts "Deseja confirmar a transação? (y/n)"
        opt = gets().chomp()
        if opt == "y"
            true
        else
            false
        end
    end

    def save_transactions_to_file
        File.open('./operations.txt', 'w+') do |file|
            self.all_operations.each do |item|
                file.write("Operação #{item.id}, #{item.type}, #{item.currency}, #{item.quotation}, #{item.total}\n")
            end
        end
    end

end