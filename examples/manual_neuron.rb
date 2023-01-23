# rubocop:disable all
# Run this program with `ruby manual_neuron.rb` (after installing dependencies)

require_relative '../lib/tinygrad'

# Inputs x1, x2
x1 = TinyGrad::Value.new(2, label: 'x1')
x2 = TinyGrad::Value.new(0, label: 'x2')

# Weights w1, w2
w1 = TinyGrad::Value.new(-3, label: 'w1')
w2 = TinyGrad::Value.new(1, label: 'w2')

# Bias of the neuron
b = TinyGrad::Value.new(6.8813735870195432, label: 'b')

# x1*w1 + x2*w2 + b
x1w1 = x1*w1 ; x1w1.label = 'x1*w1'
x2w2 = x2*w2 ; x2w2.label = 'x2*w2'

x1w1x2w2 = x1w1 + x2w2 ; x1w1x2w2.label = 'x1*w1 + x2*w2'
n = x1w1x2w2 + b ; n.label = 'n'
o = n.tanh ; o.label = 'o'

# Draw the DAG into an SVG file
$graph = TinyGrad::Graph.new
$graph.draw(o, file_name: 'manual_neuron.svg')

# rubocop:enable all
