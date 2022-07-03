class World
  def initialize
    @cols = 183
    @rows = 103
    @grid = build_grid
    @cells = build_cells
  end

  attr_reader :cells

  def compute_cells
    cells.each(&:compute)
  end

  def reset
    cells.each(&:reset)
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

  private

  def build_grid
    Array.new(@rows) do |row|
      Array.new(@cols) { |col| Cell.new(col, row) }
    end
  end

  def build_cells
    @grid.flatten.map! do |cell|
      cell.assign_neighbors(@grid)
      cell
    end
  end
end
