defmodule Mix.Tasks.ManualTest do
  @moduledoc """
  Run the manual test, where one can play as both players in the terminal.
  The full state of the game is shown.
  """
  use Mix.Task

  @shortdoc "Calls the Moby.test function to manually test the game."
  def run(_args) do
    Mix.Task.run("app.start")
    Moby.test()
  end
end
