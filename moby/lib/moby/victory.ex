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

  def check(game) do
    active_players = remove_inactive_players(game)

    case length(active_players) do
      1 ->
        Map.put(game, :winner, hd(active_players))

      _ ->
        game
    end
  end

  def round_over(game) do
    winner =
      game.players
      |> Enum.map(&player_score/1)
      |> Enum.max_by(fn {_, x} -> x end)
      |> (fn {player, _score} -> player end).()

    Map.put(game, :winner, winner)
    |> somebody_won()
  end

  def somebody_won(game) do
    IO.puts("#{game.winner.name} won!")
    exit(:normal)
  end

  defp player_score(player = %Moby.Player{current_cards: [card]}) do
    {player, @card_values[card]}
  end

  defp remove_inactive_players(game) do
    game.players |> Enum.filter(fn player -> player.active? end)
  end
end
