class Operacao
    attr_accessor :id, :type, :currency, :total

    def initialize(id, type, currency, total)
        @id = id
        @type = type
        @currency = currency
        @total = total
    end
end