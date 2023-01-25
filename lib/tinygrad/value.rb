# frozen_string_literal: true

module TinyGrad
  # Base value object for the DAG
  class Value
    FLOAT_FORMAT = '%.4f'

    attr_reader :data, :children, :op
    attr_accessor :label, :backward, :grad

    # rubocop:disable Naming/MethodParameterName
    # Unfortunately, we have to wrap the operation into a proper object, to avoid
    # problems with the GraphViz ID creation
    def initialize(data, children: [], op: Operation.new, label: '')
      @data = data.to_f

      @children = children
      @grad = 0.0
      @op = op
      @label = label
      @backward = -> {}
    end
    # rubocop:enable Naming/MethodParameterName

    def +(other)
      raise_error_if_not_value(other, '+')

      out = Value.new(@data + other.data, children: [self, other], op: Operation.new('+'))
      out.backward = lambda do
        @grad = out.grad
        other.grad = out.grad
      end
      out
    end

    def *(other)
      raise_error_if_not_value(other, '*')

      out = Value.new(@data * other.data, children: [self, other], op: Operation.new('*'))
      out.backward = lambda do
        @grad = other.data * out.grad
        other.grad = data * out.grad
      end
      out
    end

    def tanh
      # Also: (Math.exp(2 * @data) - 1)/(Math.exp(2 * @data) + 1)
      t = Math.tanh(@data)
      out = Value.new(t, children: [self], op: Operation.new('tanh'))
      out.backward = lambda do
        self.grad = (1 - t**2) * out.grad
      end
      out
    end

    def graphviz_label
      format_data('', ' | ')
    end

    def topological_sort(visited = Set.new, topo = [])
      build_topo = lambda do |node|
        unless visited.include?(node)
          visited.add(node)
          node.children.each { |child| build_topo.call(child) }
          topo.push(node)
        end
      end
      build_topo.call(self)
      topo
    end

    def backpropagate!
      @grad = 1.0
      topological_sort.reverse.each do |node|
        node.backward.call
      end
    end

    def to_s
      "Value(#{format_data('label: ')})"
    end

    private

    def format_data(name = '', separator = ', ')
      format_label(name, separator) +
        %i[data grad]
        .map { |member| "#{member}: #{FLOAT_FORMAT % send(member)}" }
        .join(separator)
    end

    def format_label(name, separator = ', ')
      return '' if @label.empty?

      "#{name}#{@label}#{separator}"
    end

    def raise_error_if_not_value(other, operator)
      raise ArgumentError, "right value of '#{operator}' is not a Value" unless other.is_a?(Value)
    end
  end
end
