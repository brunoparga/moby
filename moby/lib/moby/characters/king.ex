defmodule Moby.King do
  alias Moby.{Action, GameState, Player}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_player) do
    own_card = hd(hd(game.players).current_cards)
    player = Player.find_by_name(game, target_player)
    target_card = hd(player.current_cards)

    Action.execute_current(game, {__MODULE__, :replace_card, [target_card]})
    |> Action.execute(target_player, {__MODULE__, :replace_card, [own_card]})
  end

  @spec replace_card(Player.t(), atom) :: Player.t()
  def replace_card(player, card) do
    Map.put(player, :current_cards, [card])
  end
end
