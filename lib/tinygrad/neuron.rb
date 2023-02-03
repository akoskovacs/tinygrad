# frozen_string_literal: true

module TinyGrad
  # Perceptron neuron
  class Neuron
    def initialize(nin)
      @w = (1..nin).map { TinyGrad::Value.new(Random.new.rand(-1.0..1.0)) }
      @b = TinyGrad::Value.new(Random.new.rand(-1.0..1.0))
    end

    def call(inputs)
      act = inputs.zip(@w).map { |xi, wi| xi * wi + @b }
      act.reduce(:+).tanh
    end
  end
end
