class Caixa
    attr_accessor :reais, :dolares, :cotacao, :every_operation

    def initialize(reais, dolares, cotacao)
        @reais = reais
        @dolares = dolares
        @cotacao = cotacao
        @every_operation = Array.new
    end

    def print
        puts "O caixa atual é de:\n
        Reais: #{self.reais}\n
        Dolares: #{self.dolares}\n
        Cotação: #{self.cotacao}"
    end

    def print_operations
        self.every_operation.each do |item|
            puts item.id
            puts item.currency
            puts item.total
        end
    end

    def check_dollars(amount)
        if amount > self.dolares or amount <= 0
            false
        else
            true
        end
    end

    def check_reais(amount)
        if amount > self.reais or amount <= 0
            false
        else
            true
        end
    end

    def buy_dollars(operation)
        self.dolares += operation.total
        self.reais -= (operation.total * self.cotacao)
        self.every_operation << operation
        puts "transacao concluida"
    end

    def transaction(operation)
        if operation.type == "Compra" && operation.currency == "U$"
            self.dolares += operation.total
            self.reais -= (operation.total * self.cotacao)
            puts "transacao concluida"
        elsif operation.type == "Venda" && operation.currency == "U$"
            self.dolares -= operation.total
            self.reais += (operation.total * self.cotacao)
            puts "transacao concluida"
        elsif operation.type == "Compra" && operation.currency == "BRL"
            self.reais += operation.total
            self.dolares -= (operation.total/self.cotacao)
            puts "transacao concluida"
        elsif operation.type == "Venda" && operation.currency == "BRL"
            self.reais -= operation.total
            self.dolares += (operation.total/self.cotacao)
        end
        
        self.every_operation << operation
    end
end