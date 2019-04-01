defmodule Moby.Victory do
  @moduledoc """
  Functions related to a player winning a round.
  TODO: round victory
  """

  alias Moby.{GameState, Player}

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

  @spec check(GameState.t()) :: GameState.t() | no_return
  def check(game) do
    active_players = remove_inactive_players(game)

    case length(active_players) do
      1 ->
        Map.put(game, :winner, hd(active_players))
        |> won()

      _ ->
        Moby.GameFlow.continue(game)
    end
  end

  @spec won(GameState.t()) :: no_return
  def won(game) do
    IO.puts("#{game.winner.name} won!")
    exit(:normal)
  end

  @spec round_over(GameState.t()) :: no_return
  def round_over(game) do
    Map.put(game, :winner, find_winner(game))
    |> won()
  end

  @spec player_score(Player.t()) :: {Player.t(), pos_integer}
  def player_score(player = %Player{current_cards: [card]}) do
    {player, @card_values[card]}
  end

  @spec remove_inactive_players(GameState.t()) :: [Player.t()]
  defp remove_inactive_players(game) do
    Enum.filter(game.players, fn player -> player.active? end)
  end

  @spec find_winner(GameState.t()) :: Player.t()
  # TODO: handle tie?
  defp find_winner(game) do
    game.players
    |> Enum.map(&player_score/1)
    |> Enum.max_by(fn {_, x} -> x end)
    |> remove_score()
  end

  @spec remove_score({Player.t(), pos_integer}) :: Player.t()
  defp remove_score({player, _score}), do: player
end
