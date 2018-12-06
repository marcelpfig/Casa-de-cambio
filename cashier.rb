class Cashier
    attr_accessor :reais, :dolares, :quotation, :all_transactions

    def initialize(reais, dolares, quotation)
        @reais = reais
        @dolares = dolares
        @quotation = quotation
        @all_transactions = Array.new
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

    def print_transactions(db)
        transactions = db.execute("select * from transactions")
        transactions.each do |item|
            rows =[]
            rows << ["Operação:", item[0]]
            rows << ["Tipo:", item[1]]
            rows << ["Moeda:", item[2]]
            rows << ["Total:", "#{item[3]} U$D"]
            
            table = Terminal::Table.new :rows => rows
            puts table
        end
    end

    def buy_dollars(transaction, db)
        if transaction.amount > (self.reais/self.quotation) or transaction.amount <= 0
            puts "Não é possível realizar a transação. Reais insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(transaction)
            self.dolares += transaction.amount
            self.reais -= (transaction.amount * self.quotation)
            self.all_transactions << transaction
            db.execute("insert into transactions(type, currency, amount, quotation) values(?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation])
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def sell_dollars(transaction, db)
        if transaction.amount > self.dolares or transaction.amount <= 0
            puts "Não é possível realizar a transação. Reais insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(transaction)
            self.dolares -= transaction.amount
            self.reais += (transaction.amount * self.quotation)
            self.all_transactions << transaction
            db.execute("insert into transactions(type, currency, amount, quotation) values(?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation])
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def buy_reais(transaction, db)
        if transaction.amount > (self.dolares * self.quotation) or transaction.amount <= 0
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(transaction)
            self.dolares -= (transaction.amount/self.quotation)
            self.reais += transaction.amount
            self.all_transactions << transaction
            db.execute("insert into transactions(type, currency, amount, quotation) values(?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation])
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def sell_reais(transaction, db)
        if transaction.amount > self.reais or transaction.amount <= 0
            puts "Não é possível realizar a transação. Dolares insuficientes no caixa ou quantia invalida."
        elsif self.confirm_transaction(transaction)
            self.dolares += (transaction.amount/self.quotation)
            self.reais -= transaction.amount
            self.all_transactions << transaction
            db.execute("insert into transactions(type, currency, amount, quotation) values(?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation])
            puts "transacao concluida"
        else
            puts "transacao cancelada"
        end
    end

    def confirm_transaction(transaction)
        puts "Operação de #{transaction.type} de #{transaction.amount} de #{transaction.currency}."
        puts "Total de #{transaction.total} U$D"
        puts "Deseja confirmar a transação? (y/n)"
        opt = gets().chomp()
        if opt == "y"
            true
        else
            false
        end
    end

    def save_transactions_to_file
        File.open('./transactions.txt', 'w+') do |file|
            self.all_transactions.each do |item|
                file.write("Operação #{item.id}, #{item.type}, #{item.currency}, #{item.quotation}, #{item.total}\n")
            end
        end
    end

end