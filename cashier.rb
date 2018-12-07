class Cashier
    attr_accessor :id, :user, :date, :reais, :dolares, :quotation

    def initialize(user, reais, dolares, quotation)
        @user = user
        @date = DateTime.now.strftime('%Y-%m-%d')
        @reais = reais
        @dolares = dolares
        @quotation = quotation
    end

    def self.check_cashier(user, db)
        now = DateTime.now.strftime('%Y-%m-%d')
        result = db.execute("select id, user, reais, dolares, quotation from cashiers where date = '#{now}' and user = '#{user}';")
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
        rows << ["Operador:", self.user]
        rows << ["Reais:", self.reais]
        rows << ["Dolares:", self.dolares]
        rows << ["Cotação:", self.quotation]
        table = Terminal::Table.new :title => "Caixa Atual", :rows => rows
        puts table
    end

    def print_transactions(db)
        transactions = db.execute("select * from transactions where cashier_id = #{self.id}")
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
            db.execute("insert into transactions(type, currency, amount, quotation, cashier_id) values(?, ?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation, self.id])
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
            db.execute("insert into transactions(type, currency, amount, quotation, cashier_id) values(?, ?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation, self.id])
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
            db.execute("insert into transactions(type, currency, amount, quotation, cashier_id) values(?, ?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation, self.id])
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
            db.execute("insert into transactions(type, currency, amount, quotation, cashier_id) values(?, ?, ?, ?, ?)", [transaction.type, transaction.currency, transaction.amount, transaction.quotation, self.id])
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

    def new_to_db(db)
        db.execute("insert into cashiers(user, date, reais, dolares, quotation) values(?, ?, ?, ?, ?)", [self.user, self.date, self.reais, self.dolares, self.quotation])
    end

    def update_to_db(db)
        db.execute("update cashiers set reais = #{self.reais}, dolares = #{self.dolares}, quotation = #{self.quotation} where id = #{self.id}")
    end

    def save_transactions_to_file
        File.open('./transactions.txt', 'w+') do |file|
            self.all_transactions.each do |item|
                file.write("Operação #{item.id}, #{item.type}, #{item.currency}, #{item.quotation}, #{item.total}\n")
            end
        end
    end

end