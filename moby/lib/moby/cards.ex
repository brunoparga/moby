defmodule Moby.Cards do
  def check_countess(game = %Moby.Game{players: [player | _]}) do
    maybe_play_countess(game, must_play_countess?(player.current_cards))
  end

  defp must_play_countess?(hand) do
    :countess in hand and (:king in hand or :prince in hand)
  end

  defp maybe_play_countess(game, _must_play_countess = true) do
    # TODO: This should change to alert the player of the countess situation
    Moby.Play.make_move(game, :countess)
  end

  defp maybe_play_countess(game, _must_play_countess = false), do: game
end
