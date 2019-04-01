defmodule Moby.GameFlow do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Action, GameState, Victory}

  @doc """
  Sets up the game for the first player to play. If they must play the Countess,
  they do so and the turn passes to the next player.
  """
  @spec new_game() :: GameState.t()
  def new_game() do
    GameState.initialize() |> Moby.Countess.check()
  end

  @doc """
  Makes a move and continues the game, unless the move caused someone to win the
  round.
  """
  @spec make_move(GameState.t(), atom | {atom, String.t()} | {:guard, String.t(), atom}) ::
          GameState.t()
  def make_move(game, move) do
    # Assumes the player actually has the given card. TODO: validate.
    game
    |> Moby.Handmaid.end_own_protection()
    |> Moby.Handmaid.check_protected(move)
    |> Moby.Dispatch.move(move)
    |> Victory.check()
  end

  @spec continue(GameState.t()) :: GameState.t()
  def continue(game) do
    game
    |> update_order()
    |> next()
  end

  @spec update_order(GameState.t()) :: GameState.t()
  defp update_order(game) do
    new_order = tl(game.players) ++ [hd(game.players)]
    %GameState{game | players: new_order}
  end

  @spec next(GameState.t()) :: GameState.t()
  defp next(game = %GameState{deck: []}), do: Victory.round_over(game)

  defp next(game) do
    [drawn_card | new_deck] = game.deck

    Action.execute_current(game, {Action, :draw_card, [drawn_card]})
    |> Map.put(:deck, new_deck)
    |> Moby.Countess.check()
  end
end
