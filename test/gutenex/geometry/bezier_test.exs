defmodule Gutenex.Geometry.BezierText do
  use ExUnit.Case, async: true

  # test "#bezier"
end

# bezier(X1, Y1, X2, Y2, X3, Y3, X4, Y4)->
#     bezier({X1, Y1}, {X2, Y2}, {X3, Y3}, {X4, Y4}).

# bezier(Point1, Point2, Point3, Point4)->
#     [move_to(Point1), bezier_c( Point2, Point3, Point4 ) ].

# bezier_c({X1, Y1}, {X2, Y2}, {X3, Y3})->
#     [n2s([X1, Y1, X2, Y2, X3, Y3]), " c\n"].

# bezier_v({X2, Y2}, {X3, Y3})->
#     [n2s([X2, Y2, X3, Y3]), " v\n"].

# bezier_y({X1, Y1}, {X3, Y3})->
#     [n2s([X1, Y1, X3, Y3]), " y\n"].
