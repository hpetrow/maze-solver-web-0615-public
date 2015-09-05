class MazeSolver
require 'pry'
  attr_accessor :maze, :traveled_path, :visited_nodes, :node_queue

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
  end

  def maze_array
    @maze.split("\n").collect { |row|
      row.split("")
    }
  end

  def x_dimensions
    self.maze_array.first.length
  end

  def y_dimensions
    self.maze_array.length
  end

  def start_coordinates
    coordinates("→")
  end

  def end_coordinates
    coordinates("@")
  end

  def coordinates(str)
    result = search_row(str)
    result = search_col_start(0, str) if !result
    result = search_col_start(max_array.length, str) if !result
    result
  end

  def search_row(str)
    result = nil
    self.maze_array.each.with_index { |row, i|
      if row.first == str
        result = [0, i]
      elsif row.last == str
        result = [row.length-1, i]
      end
      break if result
    }
    result
  end

  def search_col(row_index, str)
    result = nil
    self.maze_array[row_index].each.with_index { |col, i|
      if col == str
        result = [row_index, i]
        break
      end
    }
    result
  end

  def node_value(node)
    self.maze_array[node.last][node.first] if self.maze_array[node.last] && self.maze_array[node.last][node.first]
  end

  def valid_node?(node)
    self.maze_array[node.last] && self.maze_array[node.last][node.first] && self.maze_array[node.last][node.first] != "#"
  end

  def neighbors(node)
    up = [node.first, node.last-1]
    down = [node.first, node.last+1]
    left = [node.first-1, node.last]
    right = [node.first+1, node.last]

    [up, down, left, right].select { |node|
      valid_node?(node)
    }
  end

  def add_to_queues(*nodes)
    self.traveled_path << nodes
    self.visited_nodes << nodes.first
    self.node_queue << nodes.first
  end

  def move
    node = self.node_queue.shift
    neighbors(node).each { |neighbor|
      add_to_queues(neighbor, node) if !visited_nodes.include?(neighbor)
      break if node_value(neighbor) == "@"
    }
  end

  def solve
    add_to_queues(start_coordinates)
    while node_value(visited_nodes.last) != "@"
      move
    end
  end

  def solution_path
    [].tap { |solution|
      last_node = visited_nodes.last
      self.traveled_path.reverse_each { |nodes|
        if nodes.first == last_node
          solution << last_node
          last_node = nodes.last
        end
      }
    }
  end

  def solution_array
    maze_copy = maze_array
    solution_path[1..-2].each_with_object(maze_copy) { |node, arr|
      arr[node.last][node.first] = "."
    }
  end

  def display_solution_path
    puts solution_array.each_with_object("") { |row, str|
      row.each { |col|
        str << col
      }
      str << "\n"
    }.chop
  end
end