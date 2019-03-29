defmodule Moby.Prince do
  alias Moby.{Action, GameState}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_player) do
    player = Player.find_by_name(game, target_player)
    target_card = hd(player.current_cards)
    [drawn_card | new_deck] = game.deck

    Action.execute(game, target_player, {Action, :play_card, [target_card]})
    |> Action.execute(target_player, {Action, :draw_card, [drawn_card]})
    |> Map.put(:deck, new_deck)
  end
end
