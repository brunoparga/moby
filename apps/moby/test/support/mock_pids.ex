defmodule Moby.Test.MockPids do
  def joe, do: {"Joe", spawn(fn -> :ok end)}
  def ann, do: {"Ann", spawn(fn -> :ok end)}
  def bob, do: {"Bob", spawn(fn -> :ok end)}
  def stef, do: {"Stef", spawn(fn -> :ok end)}
end
