defmodule Gutenex.Geometry.UtilsTest do
  use ExUnit.Case, async: true
  alias Gutenex.Geometry.Utils

  test "#character_list with an int" do
    assert Utils.character_list(112392093810293) == '112392093810293'
  end

  test "#character_list with a float should round two decimal places" do
    assert Utils.character_list(90123.09938021) == '90123.10'
  end

  test "#character_list with an atom" do
    assert Utils.character_list(:bubbles) == 'bubbles'
  end

  test "#character_list with list should join them with spaces" do
    assert Utils.character_list([1, 2, 3, 4]) == '1 2 3 4 '
  end

  test "#character_list with an empty list" do
    assert Utils.character_list([]) == ''
  end

  test "#move_to should move to a point" do
    assert Utils.move_to({20, 40}) == '20 40 m '
  end
end
