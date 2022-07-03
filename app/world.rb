class World
  def initialize
    @cols = 183
    @rows = 103
    grid_a = build_grid
    grid_b = deep_dup_grid(grid_a)
    cells_a = assign_neighbor_cells(grid_a)
    cells_b = assign_neighbor_cells(grid_b)
    assign_swap_cells(cells_a, cells_b)
    @cell_arrays = [cells_a, cells_b]
    reset
  end

  def draw_override(ffi)
    @cell_arrays.reverse!
    @cell_arrays.first.each { |c| c.draw(ffi) }
  end

  def reset
    @cell_arrays.last.each(&:reset)
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

  def deep_dup_grid(grid)
    Array.new(@rows) do |row|
      Array.new(@cols) { |col| grid[row][col].dup }
    end
  end

  def assign_neighbor_cells(grid)
    grid.flatten.map! do |cell|
      cell.assign_neighbors(grid)
      cell
    end
  end

  def assign_swap_cells(cells_a, cells_b)
    cells_a.each_with_index do |cell_a, index|
      cell_b = cells_b[index]
      cell_a.swap_cell = cell_b
      cell_b.swap_cell = cell_a
    end
  end
end
