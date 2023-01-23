# rubocop:disable all
# Run this program with `ruby simple_expression.rb` (after installing dependencies)

require_relative '../lib/tinygrad'

# Create the DAG of expression 'l' out of simple components
a = TinyGrad::Value.new(2, label: 'a')
b = TinyGrad::Value.new(-3, label: 'b')
c = TinyGrad::Value.new(10, label: 'c')
e = a * b ; e.label = 'e'
d = e + c ; d.label = 'd'
f = TinyGrad::Value.new(-2, label: 'f')
l = d * f ; l.label = 'L'

# Draw the DAG into an SVG file
$graph = TinyGrad::Graph.new
$graph.draw(l, file_name: 'simple_expression.svg')

# rubocop:enable all
