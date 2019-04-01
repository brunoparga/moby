defmodule Moby.King do
  alias Moby.{Action, GameState, Player}

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    own_card = hd(hd(game.players).current_cards)
    target_card = hd(game.target_player.current_cards)

    Action.execute_current(game, {__MODULE__, :replace_card, [target_card]})
    |> Action.execute(game.target_player.name, {__MODULE__, :replace_card, [own_card]})
  end

  @spec replace_card(Player.t(), atom) :: Player.t()
  def replace_card(player, card) do
    Map.put(player, :current_cards, [card])
  end
end
