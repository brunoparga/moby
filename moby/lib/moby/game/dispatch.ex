defmodule Moby.Dispatch do
  @moduledoc """
  Functions that call the appropriate actions for the card being played.
  """

  alias Moby.{Action, GameState}

  @doc """
  Make the given move: play a card, targetting one player (except for the
  Princess, Countess and Handmaid) and naming a card (for the Guard).
  """
  @spec move(GameState.t(), {atom, String.t()}) :: GameState.t()
  def move(game, {:king, target}) do
    Action.execute_current(game, {Action, :play_card, [:king]})
    |> Moby.King.play(target)
  end

  def move(game, {:prince, target}) do
    Action.execute_current(game, {Action, :play_card, [:prince]})
    |> Moby.Prince.play(target)
  end

  def move(game, {:baron, target}) do
    Action.execute_current(game, {Action, :play_card, [:baron]})
    |> Moby.Baron.play(target)
  end

  @spec move(GameState.t(), atom) :: GameState.t()
  def move(game, played_card) when is_atom(played_card) do
    Action.execute_current(game, {Action, :play_card, [played_card]})
  end
end