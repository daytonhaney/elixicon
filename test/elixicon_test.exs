defmodule ElixiconTest do
  use ExUnit.Case
  doctest Elixicon

  test "greets the world" do
    assert Elixicon.hello() == :world
  end
end
