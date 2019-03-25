defmodule Moby.Play do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Game, Player, Victory}

  def new_game do
    Game.initialize() |> Moby.Cards.check_countess()
  end

  def make_move(game, card) do
    # Assumes the player actually has the given card.
    game
    |> Player.execute_move(card)
    |> Victory.check()
    |> is_over()
  end

  # def make_move(game, card, target) do
  #   # Assumes the player actually has the given card.
  #   game
  #   |> Player.execute_move(card, target)
  #   |> Victory.check()
  #   |> is_over()
  # end

  defp is_over(game) do
    if game.winner, do: Victory.somebody_won(game), else: continue_game(game)
  end

  defp continue_game(game) do
    game
    |> update_order()
    |> Player.next()
  end

  defp update_order(game) do
    new_order = tl(game.players) ++ [hd(game.players)]
    %Game{game | players: new_order}
  end
end
