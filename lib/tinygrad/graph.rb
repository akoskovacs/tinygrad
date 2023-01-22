# frozen_string_literal: true

module TinyGrad
  # Generates an SVG Digraph visualization for an expression tree via GraphViz
  class Graph
    attr_reader :nodes, :edges

    def draw(root, file_name:)
      raise ArgumentError, 'No output file is given' if file_name.empty?

      @graph = GraphViz.new(:G, type: :digraph, rankdir: 'LR')
      trace(root)
      @graph.output(svg: file_name)
      @graph
    end

    private

    def trace(root)
      @nodes = Set.new
      @edges = Set.new

      build_children_of(root)

      @nodes.each { |node| draw_node_for(node) }

      @edges.each do |edge|
        start = id_of(edge[0])
        stop  = id_of(edge[1].op)
        @graph.add_edge(start, stop)
      end

      @graph
    end

    def build_children_of(node)
      @nodes.add(node) unless @nodes.include?(node)

      node.children.each do |child|
        @edges.add([child, node])
        build_children_of(child)
      end
    end

    def draw_node_for(node)
      node_id = id_of(node)
      @graph.add_node(node_id, label: "#{node.label} | data: #{node.data}", shape: 'record')

      return if node.op.empty?

      op_id = id_of(node.op)
      @graph.add_node(op_id, label: node.op)
      @graph.add_edge(op_id, node_id)
    end

    def id_of(node_or_edge)
      node_or_edge.object_id.to_s
    end
  end
end
