defmodule Moby.Prince do
  alias Moby.{Action, GameState}

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    target_card = hd(game.target_player.current_cards)

    Action.execute(game, game.target_player.name, {Action, :play_card, [target_card]})
    |> check_deck()
  end

  @spec check_deck(GameState.t()) :: GameState.t() | no_return
  def check_deck(game) do
    if length(game.deck) == 0,
      do: resolve_empty_deck(game),
      else: resolve_nonempty_deck(game)
  end

  @spec resolve_empty_deck(GameState.t()) :: no_return
  defp resolve_empty_deck(game) do
    Action.execute(game, game.target_player.name, {Action, :draw_card, [game.removed_card]})
    |> Map.put(:removed_card, nil)
    |> Moby.Victory.round_over()
  end

  @spec resolve_nonempty_deck(GameState.t()) :: GameState.t()
  defp resolve_nonempty_deck(game) do
    [drawn_card | new_deck] = game.deck

    Action.execute(game, game.target_player.name, {Action, :draw_card, [drawn_card]})
    |> Map.put(:deck, new_deck)
  end
end
