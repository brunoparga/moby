defmodule Moby.Guard do
  def play(game, target, named_card) do
    target_player = Moby.Player.find(game, target)
    if hd(target_player.current_cards) == named_card do
      Moby.Action.execute(game, target, {Moby.Action, :lose, []})
    else
      game
    end
  end
end
