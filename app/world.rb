class World
  def initialize
    @cols = 140
    @rows = 80
    @grid = build_grid
    @cells = build_cells
  end

  attr_reader :rows,
              :cols,
              :grid,
              :cells

  def render_cells_as_solids(args)
    cells.each(&:assign_alive)
    args.outputs.solids << cells
  end

  def render_cells_as_sprites(args)
    cells.each(&:assign_alive)
    args.outputs.sprites << cells
  end

  def render_cells_as_target_of_sprites(args)
    cells.each(&:assign_alive)
    args.render_target(:world).sprites << cells
    args.outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: :world }
  end

  def render_cells_as_target_of_solids(args)
    cells.each(&:assign_alive)
    args.render_target(:world).solids << cells
    args.outputs.sprites << { x: 0, y: 0, w: 1280, h: 720, path: :world }
  end

  private

  def build_grid
    Array.new(cols) do |col|
      Array.new(rows) { |row| Cell.new(col, row) }
    end
  end

  def build_cells
    grid.flatten.map! do |cell|
      cell.assign_neighbors(grid)
      cell
    end
  end
end
