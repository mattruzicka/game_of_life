

def boot(args)
  Cell.start_alive_rate = 0.11
  world = World.new
  args.state.world = world
  args.outputs.static_sprites << world.cells
end

def tick(args)
  world = args.state.world
  if args.inputs.keyboard.keys[:down].any? { |k| [:enter, :space].include?(k) }
    world.reset
  elsif args.state.tick_count.positive?
    world.compute_cells
  end

  # args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
