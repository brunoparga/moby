defmodule Moby.Victory do
  @card_values %{
    princess: 8,
    countess: 7,
    king: 6,
    prince: 5,
    handmaid: 4,
    baron: 3,
    priest: 2,
    guard: 1
  }

  def winner(game) do
    winner =
      game.players
      |> Enum.map(&player_score/1)
      |> Enum.max_by(fn {_, x} -> x end)
      |> (fn {player, _score} -> player end).()

    Map.put(game, :winner, winner)
  end

  defp player_score(player = %Moby.Player{current_cards: [card]}) do
    {player, @card_values[card]}
    |> IO.inspect()
  end
end
