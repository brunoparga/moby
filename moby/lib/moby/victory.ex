defmodule Moby.Victory do
  @moduledoc """
  Functions related to a player winning a round.
  TODO: round victory
  """

  alias Moby.{Game, Player}

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

  @spec check(Game.t) :: Game.t
  def check(game) do
    active_players = remove_inactive_players(game)

    case length(active_players) do
      1 ->
        Map.put(game, :winner, hd(active_players))

      _ ->
        game
    end
  end

  @spec somebody_won(Game.t) :: none
  def somebody_won(game) do
    IO.puts("#{game.winner.name} won!")
    exit(:normal)
  end

  @spec round_over(Game.t) :: none
  def round_over(game) do
    winner =
      game.players
      |> Enum.map(&player_score/1)
      |> Enum.max_by(fn {_, x} -> x end)
      |> (fn {player, _score} -> player end).()

    Map.put(game, :winner, winner)
    |> somebody_won()
  end

  @spec player_score(Player.t) :: {Player.t, pos_integer}
  defp player_score(player = %Player{current_cards: [card]}) do
    {player, @card_values[card]}
  end

  @spec remove_inactive_players(Game.t) :: [Player.t]
  defp remove_inactive_players(game) do
    game.players |> Enum.filter(fn player -> player.active? end)
  end
end
