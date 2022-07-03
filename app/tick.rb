

def boot(args)
  Cell.start_alive_rate = 0.11
  world = World.new
  args.state.world = world
  args.outputs.static_sprites << world.cells
  @slow_fps_count = 0
end

def tick(args)
  world = args.state.world
  if args.inputs.keyboard.keys[:down].any? { |k| [:enter, :space].include?(k) }
    world.reset
  elsif args.state.tick_count.positive?
    world.compute_cells
  end

  if args.gtk.current_framerate < 55 && args.state.tick_count > 100
    if (@slow_fps_count += 1) > 10
      fps = args.gtk.current_framerate.round
      args.outputs.labels << { x: 1274,
                               y: 19,
                               r: 255 - (fps * 2),
                               g: 77,
                               b: 77,
                               alignment_enum: 2,
                               size_enum: -3,
                               text: "#{fps} FPS" }
    end
  else
    @slow_fps_count = 0
  end

  # args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
