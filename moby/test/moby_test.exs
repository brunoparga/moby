defmodule MobyTest do
  use ExUnit.Case
  doctest Moby

  test "greets the world" do
    assert Moby.hello() == :world
  end
end
