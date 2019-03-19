defmodule Moby.Play do
  @moduledoc """
  Contains functions necessary to operate a Love Letter game.
  """

  alias Moby.{Game, Player, Victory}

  def new_game do
    Game.initialize()
  end

  def make_move(game, card) do
    # Assumes the player actually has the given card.
    game
    |> make_player_move(card)
    |> Victory.check()
    |> continue_game()
  end

  defp make_player_move(game, :princess) do
    updated_player = hd(game.players) |> Player.lose()
    new_players = [updated_player] ++ tl(game.players)
    %Game{game | players: new_players}
  end

  defp make_player_move(game, played_card) do
    updated_player = hd(game.players) |> Player.play_card(played_card)
    new_players = [updated_player] ++ tl(game.players)
    %Game{game | players: new_players}
  end

  defp continue_game(game) do
    if game.winner, do: Victory.somebody_won(game), else: nobody_won(game)
  end

  defp nobody_won(game) do
    game
    |> update_order()
    |> draw_card()
  end

  defp update_order(game) do
    new_order = tl(game.players) ++ [hd(game.players)]
    %Game{game | players: new_order}
  end

  defp draw_card(game = %Game{deck: []}), do: Victory.round_over(game)

  defp draw_card(game) do
    [drawn_card | new_deck] = game.deck
    updated_player = hd(game.players) |> Player.draw_card(drawn_card)
    new_players = [updated_player] ++ tl(game.players)
    %Game{game | players: new_players, deck: new_deck}
  end
end
