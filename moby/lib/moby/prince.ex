defmodule Moby.Prince do
  alias Moby.{Game, Player}

  @spec play(Game.t(), String.t()) :: Game.t()
  def play(game, target_player) do
    player = Player.find_by_name(game, target_player)
    target_card = hd(player.current_cards)
    [drawn_card | new_deck] = game.deck

    Player.update(game, target_player, &Player.play_card/2, target_card)
    |> Player.update(target_player, &Player.draw_card/2, drawn_card)
    |> Map.put(:deck, new_deck)
  end
end
