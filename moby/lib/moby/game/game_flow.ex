defmodule Moby.GameFlow do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Action, GameState, Victory}

  @doc """
  Sets up the game for the first player to play. If they must play the Countess,
  they do so and the turn passes to the next player.
  """
  @spec new_game(list(String.t())) :: GameState.t()
  def new_game(player_names) do
    GameState.initialize(player_names)
    |> Moby.Countess.check()
  end

  @doc """
  Inserts the move into the game state and checks if it's a valid move.
  """
  @spec make_move(GameState.t(), Moby.move()) :: GameState.t() | no_return
  def make_move(game, move) do
    game
    |> GameState.set_move(move)
    |> Moby.Validate.validate()
  end

  def move_is_valid(game) do
    game
    |> Moby.Dispatch.move()
    |> Victory.check()
  end

  @spec continue(GameState.t()) :: GameState.t()
  def continue(game = %GameState{deck: []}), do: Victory.round_over(game)

  def continue(game) do
    game
    |> update_order()
    |> next()
  end

  @spec reset_move(GameState.t()) :: GameState.t()
  def reset_move(game) do
    %GameState{game | latest_move: nil, target_player: nil}
  end

  @spec update_order(GameState.t()) :: GameState.t()
  defp update_order(game) do
    new_order = tl(game.players) ++ [hd(game.players)]
    %GameState{game | players: new_order}
  end

  @spec next(GameState.t()) :: GameState.t()
  defp next(game) do
    [drawn_card | new_deck] = game.deck

    Action.execute_current(game, {Action, :draw_card, [drawn_card]})
    |> Map.put(:deck, new_deck)
    |> reset_move()
    |> Moby.Countess.check()
  end
end
