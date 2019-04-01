defmodule Moby.Guard do
  alias Moby.{Action, GameState}

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    if hd(game.target_player.current_cards) == game.latest_move.named_card,
      do: Action.execute(game, game.target_player.name, {Action, :lose, []}),
      else: game
  end
end
