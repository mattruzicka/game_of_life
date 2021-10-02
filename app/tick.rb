Cell.start_alive_rate = 0.1

def tick(args)
  world = args.state.world ||= World.new
  if args.state.tick_count.zero?
    args.state.world = world
    args.outputs.static_sprites << world.cells
  elsif args.inputs.keyboard.key_down.space
    world.reset
  else
    world.compute_cells
  end

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
