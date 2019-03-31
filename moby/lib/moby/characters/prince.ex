defmodule Moby.Prince do
  alias Moby.{Action, GameState}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_player) do
    player = Moby.Player.find(game, target_player)
    target_card = hd(player.current_cards)

    Action.execute(game, target_player, {Action, :play_card, [target_card]})
    |> check_deck(target_player)
  end

  @spec check_deck(GameState.t(), String.t()) :: GameState.t() | no_return
  defp check_deck(game, target_player) do
    case length(game.deck) do
      0 ->
        resolve_empty_deck(game, target_player)

      _ ->
        resolve_nonempty_deck(game, target_player)
    end
  end

  @spec resolve_empty_deck(GameState.t(), String.t()) :: no_return
  defp resolve_empty_deck(game, target_player) do
    Action.execute(game, target_player, {Action, :draw_card, [game.removed_card]})
    |> Map.put(:removed_card, nil)
    |> Moby.Victory.round_over()
  end

  @spec resolve_nonempty_deck(GameState.t(), String.t()) :: GameState.t()
  defp resolve_nonempty_deck(game, target_player) do
    [drawn_card | new_deck] = game.deck

    Action.execute(game, target_player, {Action, :draw_card, [drawn_card]})
    |> Map.put(:deck, new_deck)
  end
end
