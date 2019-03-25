defmodule Moby.Countess do
  def check(game = %Moby.Game{players: [player | _]}) do
    play(game, must_play?(player.current_cards))
  end

  defp must_play?(hand) do
    :countess in hand and (:king in hand or :prince in hand)
  end

  defp play(game, _must_play_countess = true) do
    # TODO: This should change to alert the player of the countess situation
    Moby.Play.make_move(game, :countess)
  end

  defp play(game, _must_play_countess = false), do: game
end
