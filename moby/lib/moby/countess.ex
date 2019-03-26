defmodule Moby.Countess do
  alias Moby.Game

  @spec check(Game.t) :: Game.t
  def check(game = %Moby.Game{players: [player | _]}) do
    play(game, must_play?(player.current_cards))
  end

  @spec must_play?([atom]) :: boolean
  defp must_play?(hand) do
    :countess in hand and (:king in hand or :prince in hand)
  end

  @spec play(Game.t, boolean) :: Game.t
  defp play(game, _must_play_countess = true) do
    # TODO: This should change to alert the player of the countess situation
    Moby.Play.make_move(game, :countess)
  end

  defp play(game, _must_play_countess = false), do: game
end
