class Operacao
    attr_accessor :id, :type, :currency, :amount, :cotacao, :total

    @@last_id = 0

    def initialize(type, currency, amount, cotacao)
        @id = @@last_id + 1
        @type = type
        @currency = currency
        @amount = amount
        @cotacao = cotacao
        if currency == "BRL"
            @total = (amount/cotacao)
        else
            @total = amount
        end
        @@last_id = @id
    end
end