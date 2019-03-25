defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  alias Moby.{Game, Victory}

  defstruct name: "", current_cards: [], played_cards: [], active?: true
  # TODO: include score key in the struct, once many-round play is implemented

    update(game, &lose/2)
  def move(game, :princess) do
  end

    update(game, &play_card/2, played_card)
  def move(game, played_card) do
  end

  #   update(game, &play_card/2, :king)
  #   |> remove_own_card()
  #   |> # ....
  # end
  def move(game, :king, target) do

  def next(game = %Game{deck: []}), do: Victory.round_over(game)

  def next(game) do
    [drawn_card | new_deck] = game.deck

    update(game, &draw_card/2, drawn_card)
    |> Map.put(:deck, new_deck)
    |> Moby.Countess.check()
  end

  defp update(game, function, args \\ nil) do
    updated_player = hd(game.players) |> function.(args)
    new_players = [updated_player] ++ tl(game.players)
    %Game{game | players: new_players}
  end

  defp play_card(player, played_card) do
    player
    |> remove_from_hand(played_card)
    |> add_to_discarded(played_card)
  end

  defp draw_card(player, drawn_card) do
    Map.put(player, :current_cards, player.current_cards ++ [drawn_card])
  end

  defp lose(player, _) do
    Map.put(player, :active?, false)
  end

  defp remove_from_hand(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  defp add_to_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
