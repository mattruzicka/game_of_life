
Cell.random_seed = 100
Cell.start_alive_rate = 0.1

$render_method = :render_cells_as_solids # The average FPS was 36.8235294117647.
# $render_method = :render_cells_as_target_of_solids # The average FPS was 37.11111111111111.
# $render_method = :render_cells_as_sprites # The average FPS was 35.44444444444444
# $render_method = :render_cells_as_target_of_sprites #The average FPS was 35.27777777777778.

rend_solid_methods = [:render_cells_as_solids, :render_cells_as_target_of_solids]
if rend_solid_methods.include?($render_method)
  Cell.include Cell::Solid
else
  Cell.include Cell::Sprite
end

def tick(args)
  # args.gtk.slowmo! 20
  world = args.state.world ||= World.new
  world.send($render_method, args)
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
