class Transaction
    attr_accessor :id, :type, :currency, :amount, :quotation, :total

    @@last_id = 0

    def initialize(type, currency, amount, quotation)
        @id = @@last_id + 1
        @type = type
        @currency = currency
        @amount = amount
        @quotation = quotation
        if currency == "BRL"
            @total = (amount/quotation)
        else
            @total = amount
        end
        @@last_id = @id
    end
end