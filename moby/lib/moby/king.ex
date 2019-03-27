defmodule Moby.King do
  alias Moby.{Game, Player}

  @spec play(Game.t(), String.t()) :: Game.t()
  def play(game, target_player) do
    own_card = hd(hd(game.players).current_cards)
    player = Player.find_by_name(game, target_player)
    target_card = hd(player.current_cards)

    Player.update_current(game, &replace_card/2, target_card)
    |> Player.update(target_player, &replace_card/2, own_card)
  end

  @spec replace_card(Player.t(), atom) :: Player.t()
  def replace_card(player, card) do
    Map.put(player, :current_cards, [card])
  end
end
