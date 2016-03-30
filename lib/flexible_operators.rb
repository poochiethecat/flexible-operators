require "flexible_operators/version"
require "flexible_operators/operator"

module FlexibleOperatorsUtils
    RUBY_OPERATORS = {
        :+ => 'plus',
        :+@ => 'unary_plus',
        :- => 'minus',
        :-@ => 'unary_minus',
        :* => 'multiply',
        :/ => 'divide',
        :% => 'modulo',
        :! => 'not',
        :~ => 'complement',
        :** => 'exponentiate',
        :[] => 'element',
        :[]= => 'set_element',
        :<< => 'leftshift',
        :>> => 'rightshift',
        :& => 'bitwise_and',
        :| => 'bitwise_or',
        :^ => 'bitwise_xor',
        :<= => 'less_or_equal_than',
        :== => 'double_equal',
        :=== => 'triple_equal',
        :>= => 'greater_or_equal_than',
        :< => 'less_than',
        :> => 'greater_than',
        :<=> => 'spaceship'
    }.freeze

end

module FlexibleOperators
    module ClassMethods
        @@operators ||= []
        def operators
            @@operators
        end

        def ruby_operators
            FlexibleOperatorsUtils::RUBY_OPERATORS
        end

        def add_operator(symbol, other_class, &operation)
            symbol = symbol.to_sym if symbol.class == String
            raise ArgumentError, "#{symbol} is not a ruby default operator or cannot be overridden!" unless ruby_operators.include? symbol
            create_operator symbol unless operators.include? symbol
            # handle multiple other_classes with the same operation passed as Array
            other_class.each { |e| self.add_operator(symbol, e, operation) } if other_class.class == Array
            # handle multiple other_classes with different operations passed as Hash
            other_class.each { |key, value| self.add_operator(symbol, key, value) } if other_class.class == Hash && operation == nil
            operators[symbol].add_class other_class, operation if other_class.class == Class
        end

        def create_operator(symbol)
            operator = operators[symbol] = Operator.new(symbol)
            operator.overriden_operator = symbol.to_proc if instance_methods.include? symbol
            define_method(symbol) do |value|
                operator.calculate(self, value) if operators.include?(symbol) && operator.classes.include?(value.class)
            end
        end

        private :create_operator
    end

    def self.included(includer)
        includer.extend ClassMethods
    end
end
