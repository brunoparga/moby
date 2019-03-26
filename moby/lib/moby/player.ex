defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  alias Moby.{Game, Victory}

  @type cards :: [atom]
  @type t :: %__MODULE__{name: String.t,
                         current_cards: cards,
                         played_cards: cards,
                         active?: boolean}

  defstruct name: "", current_cards: [], played_cards: [], active?: true
  # TODO: include score key in the struct, once many-round play is implemented

  @doc """
  Make the given move: play a card, targetting one player (except for the
  Princess, Countess and Handmaid) and naming a card (for the Guard).
  """
  @spec move(Game.t, atom) :: Game.t
  def move(game, :princess) do
    update_current(game, &lose/2)
  end

  def move(game, played_card) do
    update_current(game, &play_card/2, played_card)
  end

  @spec move(Game.t, atom, String.t) :: Game.t
  def move(game, :king, target) do
    target_player = find(game, target)
    update_current(game, &play_card/2, :king)
    |> Moby.King.play(target_player)
  end

  @spec find(Game.t, String.t) :: __MODULE__.t
  defp find(game, player_name) do
    Enum.find(game.players, fn x -> x.name == player_name end)
  end

  @doc """
  If a move does not cause someone to win, see if there are any cards left
  to draw. If so, set up the next player; otherwise, determine a winner.
  """
  @spec next(Game.t) :: Game.t
  def next(game = %Game{deck: []}), do: Victory.round_over(game)

  def next(game) do
    [drawn_card | new_deck] = game.deck

    update_current(game, &draw_card/2, drawn_card)
    |> Map.put(:deck, new_deck)
    |> Moby.Countess.check()
  end

  @doc """
  Update the current player with the given function.
  """
  @spec update_current(Game.t, (__MODULE__.t, atom -> __MODULE__.t), (nil | atom)) :: Game.t
  def update_current(game, function, args \\ nil) do
    hd(game.players) |> update(game, function, args)
  end

  @doc """
  Update a given player with a given function; return a game.
  """
  @spec update(__MODULE__.t, Game.t, (__MODULE__.t, (nil | atom) -> __MODULE__.t), (nil | atom)) :: Game.t
  def update(player, game, function, args \\ nil) do
    players = build_new_players(player, game.players, function, args)
    %Game{game | players: players}
  end

  # Helper functions for update/4
  @spec build_new_players(__MODULE__.t,
                          [__MODULE__.t],
                          (__MODULE__.t, (nil | atom) -> __MODULE__.t),
                          (nil | atom)) :: [__MODULE__.t]
  defp build_new_players(player, players, function, args) do
    index = find_index(players, player)
    List.update_at(players, index, fn _ -> function.(player, args) end)
  end

  @spec find_index([__MODULE__.t], __MODULE__.t) :: non_neg_integer() | nil
  defp find_index(players, player) do
    Enum.find_index(players, fn x -> x == player end)
  end

  @spec play_card(__MODULE__.t, atom) :: __MODULE__.t
  defp play_card(player, played_card) do
    player
    |> remove_from_hand(played_card)
    |> add_to_discarded(played_card)
  end

  @spec draw_card(__MODULE__.t, atom) :: __MODULE__.t
  defp draw_card(player, drawn_card) do
    Map.put(player, :current_cards, player.current_cards ++ [drawn_card])
  end

  @spec lose(__MODULE__.t, nil) :: __MODULE__.t
  defp lose(player, _) do
    Map.put(player, :active?, false)
  end

  @spec remove_from_hand(__MODULE__.t, atom) :: __MODULE__.t
  defp remove_from_hand(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  @spec add_to_discarded(__MODULE__.t, atom) :: __MODULE__.t
  defp add_to_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
