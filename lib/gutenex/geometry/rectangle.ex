defmodule Gutenex.Geometry.Rectangle do
  import Gutenex.Geometry


# def rectangle({height_x, height_y}, {width_x, width_y})do
#   rectangle(height_x, height_y, width_x, width_y)
# end

# def rectangle({height_x, height_y}, {width_x, width_y}, stroke_type) do
#   rectangle(height_x, height_y, width_x, width_y, stroke_type)
# end

# def rectangle(height_x, height_y, width_x, width_y) do
#   [n2s([X,Y,WX,WY])," re "].

# def rectangle(x,y,wx,wy,stroketype)do
#   [rectangle(X,Y,WX,WY), path(StrokeType) ].


# def round_rect({x,y}, {w, h}, r) do
#   [ move_to({X+R,Y}),
#     line_append({X+W-R, Y}),
#     bezier_c( {X+W-R+R*mpo(), Y}, {X+W, Y+R*mpo()}, {X+W,Y+R} ),
#     line_append({X+W,Y+H-R}),
#     bezier_c( {X+W, Y+H-R+R*mpo()}, {X+W-R+R*mpo(), Y+H}, {X+W-R, Y+H}),
#     line_append({X+R, Y+H}),
#     bezier_c( {X+R*mpo(), Y+H}, {X, Y+H-R+R*mpo()}, {X, Y+H-R} ),
#     line_append({X, Y+R}),
#     bezier_c( {X, Y+R*mpo()}, {X+R*mpo(), Y}, {X+R, Y} )
#    ].

# def round_top_rect({x,y}, {w, h}, r) do
#   [ move_to({X,Y}),
#     line_append({X+W, Y}),
#     line_append({X+W,Y+H-R}),
#     bezier_c( {X+W, Y+H-R+R*mpo()}, {X+W-R+R*mpo(), Y+H}, {X+W-R, Y+H}),
#     line_append({X+R, Y+H}),
#     bezier_c( {X+R*mpo(), Y+H}, {X, Y+H-R+R*mpo()}, {X, Y+H-R} ),
#     line_append({X, Y})
#    ].

end
