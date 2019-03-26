defmodule Moby.Play do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Game, Player, Victory}

  @doc """
  Sets up the game for the first player to play. If they must play the Countess,
  they do so and the turn passes to the next player.
  """
  @spec new_game() :: Game.t
  def new_game() do
    Game.initialize() |> Moby.Countess.check()
  end

  @doc """
  Makes a move and continues the game, unless the move caused someone to win the
  round.
  """
  @spec make_move(Game.t, (atom | {atom, String.t} | {:guard, String.t, atom})) :: Game.t
  def make_move(game, {card, target}) do
    # Assumes the player actually has the given card.
    game
    |> Player.move(card, target)
    |> Victory.check()
    |> is_over()
  end

  def make_move(game, card) do
    # Assumes the player actually has the given card.
    game
    |> Player.move(card)
    |> Victory.check()
    |> is_over()
  end

  @spec is_over(Game.t) :: Game.t
  defp is_over(game) do
    if game.winner, do: Victory.somebody_won(game), else: continue_game(game)
  end

  @spec continue_game(Game.t) :: Game.t
  defp continue_game(game) do
    game
    |> update_order()
    |> Player.next()
  end

  @spec update_order(Game.t) :: Game.t
  defp update_order(game) do
    new_order = tl(game.players) ++ [hd(game.players)]
    %Game{game | players: new_order}
  end
end
