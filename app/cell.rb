class Cell
  class << self
    def start_alive?
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

  SIZE = 7
  LEFT_MARGIN = 150

  def initialize(col, row)
    @col = col
    @row = row
    @x = col * SIZE + LEFT_MARGIN
    @y = row * SIZE
    @w = SIZE
    @h = SIZE
    @r = 0
    @g = 0
    @b = 0
    @a = 255
    @alive = self.class.start_alive?
    @was_alive = @alive
  end

  BLACK_SQUARE = 'sprites/black_square.png'.freeze

  def draw_override(ffi)
    ffi.draw_sprite(@x, @y, @w, @h, BLACK_SQUARE) if (@was_alive = @alive)
  end

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
    @neighbors.each { |n| return false if n.was_alive? && (neighbor_count += 1) > MAX_NEIGHBORS }
    @was_alive && neighbor_count == 2 || neighbor_count == 3
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
    above_row = @row + 1
    below_row = @row - 1
    left_col = @col - 1
    right_col = @col + 1
    [[[@row, left_col], [nil, -1]],
     [[above_row, left_col], [0, -1]],
     [[above_row, @col], [0, nil]],
     [[above_row, right_col], [0, 0]],
     [[@row, right_col], [nil, 0]],
     [[below_row, right_col], [-1, 0]],
     [[below_row, @col], [-1, nil]],
     [[below_row, left_col], [-1, -1]]]
  end

  def serialize
    {}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
