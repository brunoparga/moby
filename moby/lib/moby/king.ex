defmodule Moby.King do
  alias Moby.Player

  def play(game, target_player) do
    own_card = hd(hd(game.players).current_cards)
    target_card = hd(target_player.current_cards)

    temp_game = Player.update_current(game, &replace_card/2, target_card)
    Player.update(target_player, temp_game, &replace_card/2, own_card)
  end

  def replace_card(player, card) do
    Map.put(player, :current_cards, [card])
  end
end
