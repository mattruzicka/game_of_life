
Cell.random_seed = 100
Cell.start_alive_rate = 0.1

# $render_method = :render_cells_as_solids # The average FPS was 42.46666666666666.
# $render_method = :render_cells_as_target_of_solids # The average FPS was 41.33333333333333
# $render_method = :render_cells_as_sprites # The average FPS was 42.33333333333334
# $render_method = :render_cells_as_target_of_sprites #The average FPS was 41.66666666666667.

# rend_solid_methods = [:render_cells_as_sprites, :render_cells_as_target_of_sprites]
# if rend_solid_methods.include?($render_method)
#   Cell.include Cell::Sprite
# else
#   Cell.include Cell::Solid
# end

# def tick(args)
#   # args.gtk.slowmo! 20
#   world = args.state.world ||= World.new
#   world.send($render_method, args)
#   args.outputs.debug << args.gtk.framerate_diagnostics_primitives
# end

Cell.include Cell::StaticSprite

def tick(args)
  if args.state.tick_count.zero?
    args.state.world = World.new
    args.outputs.static_sprites << args.state.world.cells
  end

  args.state.world.cells.each(&:assign_alive)
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
