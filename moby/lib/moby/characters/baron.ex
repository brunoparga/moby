defmodule Moby.Baron do
  alias Moby.{GameState, Player, Victory}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_name) do
    Victory.compare(game, Player.find_by_name(game, target_name))
  end
end
