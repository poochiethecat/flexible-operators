module FlexibleOperators
    class Operator
        attr_reader :symbol, :classes, :pre_operations, :post_operations
        attr_accessor :overriden_operator

        def initialize(symbol, &overriden_operator)
            @symbol = symbol
            @classes = {}
            @overriden_operator = overriden_operator
            @pre_operations = []
            @post_operations = []
        end

        alias_method :old_double_equal, :==
        def ==(value)
            return symbol.to_s == value if value.class == String
            return symbol == value if value.class == Symbol
            return symbol == value.symbol if value.class == Operator
            old_double_equal(value)
        end

        alias_method :old_triple_equal, :===
        def ===(value)
            return self == value if value.class == String || value.class == Operator || value.class == Symbol
            old_triple_equal(value)
        end

        def add_class(klass, &operation)
            @classes[klass] = operation
        end

        def calculate(left_operand, right_operand)
            raise ArgumentError, "No Operator for '#{left_operand.class} #{@symbol} #{right_operand.class} defined!" unless classes.include? right_operand.class
            call = proc { |op| op.call(left_operand, right_operand) }
            pre_operations.each &call
            classes[right_operand.class].call(left_operand, right_operand)
            post_operations.each &call
            overriden_operator.call(right_operand) if overriden_operator
        end
    end
end
