defmodule Moby.Prince do
  alias Moby.{Action, GameState}

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    # this can't be just game.target_player because of self-targeting
    target_player = Moby.Player.find(game, game.latest_move.target)
    target_card = hd(target_player.current_cards)

    Action.execute(game, game.target_player.name, {Action, :play_card, [target_card]})
    |> check_deck(target_card)
  end

  @spec check_deck(GameState.t(), atom) :: GameState.t() | no_return
  defp check_deck(game, target_card) do
    cond do
      target_card == :princess ->
        game

      length(game.deck) == 0 ->
        resolve_empty_deck(game)

      true ->
        resolve_nonempty_deck(game)
    end
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
