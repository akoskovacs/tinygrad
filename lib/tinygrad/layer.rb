# frozen_string_literal: true

module TinyGrad
  # Layer
  class Layer
    def initialize(nin, nout)
      @neurons = (nin..nout).map { TinyGrad::Neuron.new(nin) }
    end

    def call(inputs)
      @neurons.map { |n| n.call(inputs) }
    end
  end
end
