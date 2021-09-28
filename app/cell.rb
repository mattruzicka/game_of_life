class Cell
  class << self
    def alive?
      random.rand < start_alive_rate
    end

    attr_writer :start_alive_rate, :random_seed

    def start_alive_rate
      @start_alive_rate ||= 0.1
    end

    def random_seed
      @random_seed ||= Time.now.to_i
    end

    private

    def random
      @random ||= Random.new(random_seed)
    end
  end

  module Sprite
    def primitive_marker
      :sprite
    end

    def draw_override(ffi)
      ffi.draw_sprite(@x + 150, @y, w, h, "sprites/black_square.png") if @alive
      @was_alive = @alive
    end
  end

  module Solid
    def primitive_marker
      :solid
    end

    def draw_override(ffi)
      ffi.draw_solid(@x + 150, @y, w, h, r, g, b, a) if @alive
      @was_alive = @alive
    end
  end

  include Solid

  def initialize(col, row)
    @col = col
    @row = row
    @x = col * SIZE
    @y = row * SIZE
    @was_alive = self.class.alive?
  end

  attr_accessor :col,
                :row,
                :neighbors,
                :x,
                :y

  def assign_alive
    @alive = compute_alive
  end

  def alive?
    @alive
  end

  def was_alive?
    @was_alive
  end

  MAX_NEIGHBORS = 3

  def compute_alive
    neighbor_count = 0
    neighbors.each { |n| return false if n.was_alive? && (neighbor_count += 1) > MAX_NEIGHBORS }
    if was_alive?
      neighbor_count == 2 || neighbor_count == 3
    else
      neighbor_count == 3
    end
  end

  SIZE = 7

  def w
    SIZE
  end

  def h
    SIZE
  end

  def r
    alive? ? 0 : 255
  end

  alias g r
  alias b r

  def a
    alive? ? 255 : 0
  end

  def assign_neighbors(grid)
    @neighbors = find_neighbors(grid)
  end

  def find_neighbors(grid)
    neighbor_coordinates.map! do |pair1, pair2|
      neighbor_row = grid[pair1[0]] || grid[pair2[0]]
      neighbor_row[pair1[1]] || neighbor_row[pair2[1]]
    end
  end

  def neighbor_coordinates
    above_row = row + 1
    below_row = row - 1
    left_col = col - 1
    right_col = col + 1
    [[[left_col, above_row], [-1, 0]],
     [[col, above_row], [nil, 0]],
     [[right_col, above_row], [0, 0]],
     [[left_col, row], [-1, nil]],
     [[right_col, row], [0, nil]],
     [[left_col, below_row], [-1, -1]],
     [[col, below_row], [nil, -1]],
     [[right_col, below_row], [0, -1]]]
  end
end

