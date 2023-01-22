# frozen_string_literal: true

module TinyGrad
  # Wrapper class for all operations
  class Operation
    attr_reader :name

    def initialize(operation = '')
      @name = operation
    end

    def empty?
      @name.empty?
    end

    def to_s
      @name.to_s
    end
  end
end
