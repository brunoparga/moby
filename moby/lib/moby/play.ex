defmodule Moby.Play do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Game, Player}

  def new_game do
    Game.initialize()
  end

  end

  def make_move(game, %{player: :player1, card: card}) do
    # Assumes move is a Map with either :player1 or :player2 as the value of
    # the :player key. Assumes the player actually has that card.
    new_player_state = Moby.Player.update_card(game.player1, card)
    %Moby.Game{game | player1: new_player_state}
    |> IO.inspect
  end

  def make_move(game, %{player: :player2, card: card}) do
    # Assumes move is a Map with either :player1 or :player2 as the value of
    # the :player key. Assumes the player actually has that card.
    new_player_state = Moby.Player.update_card(game.player2, card)
    %Moby.Game{game | player2: new_player_state}
    |> IO.inspect
  end
end
