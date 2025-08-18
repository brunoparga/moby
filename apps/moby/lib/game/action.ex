defmodule Moby.Action do
  @moduledoc """
  Functions that update the game with the running of a given action by a player.
  This is only default actions like drawing and discarding; specialized actions
  are dealt with by the character modules in the characters directory.
  """

  alias Moby.{GameState, Player}

  @type mfargs() :: {module(), atom(), [atom]}

  @doc """
  Run the given action on the current player. Return a game.
  """
  @spec execute_current(GameState.t(), mfargs()) :: GameState.t()
  def execute_current(game, mfa) do
    execute(game, hd(game.players).name, mfa)
  end

  @doc """
  Run the given action on the given player. Return a game.
  """
  # TODO: DO SOMETHING ABOUT THIS TAKING A NAME OR A PLAYER STRUCT
  @spec execute(GameState.t(), String.t(), mfargs()) :: GameState.t()
  def execute(game, player_name, mfa) do
    updated_players = new_players(game.players, player_name, mfa)
    Map.put(game, :players, updated_players)
  end

  @spec new_players([Player.t()], String.t(), mfargs()) :: [Player.t()]
  defp new_players(players, player_name, mfa) do
    Enum.map(players, &build_player(&1, player_name, mfa))
  end

  @spec build_player(Player.t(), String.t(), mfargs()) :: Player.t()
  defp build_player(player, player_name, mfa) do
    if player.name == player_name, do: new_player(player, mfa), else: player
  end

  @spec new_player(Player.t(), mfargs()) :: Player.t()
  defp new_player(player, {module, function, args}) do
    apply(module, function, [player] ++ args)
  end

  # Card-playing actions

  @spec play_card(Player.t(), atom) :: Player.t()
  def play_card(player, :princess), do: lose(player)

  def play_card(player, played_card) do
    player
    |> remove_from_hand(played_card)
    |> add_to_discarded(played_card)
  end

  @spec draw_card(Player.t(), atom) :: Player.t()
  def draw_card(player, drawn_card) do
    Map.put(player, :current_cards, player.current_cards ++ [drawn_card])
  end

  @spec lose(Player.t()) :: Player.t()
  def lose(player) do
    current_cards =
      case player.current_cards do
        [other_card, :princess] -> [:princess, other_card]
        _ -> player.current_cards
      end

    %Player{
      player
      | active?: false,
        current_cards: [],
        played_cards: player.played_cards ++ current_cards
    }
  end

  @spec remove_from_hand(Player.t(), atom) :: Player.t()
  defp remove_from_hand(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  @spec add_to_discarded(Player.t(), atom) :: Player.t()
  defp add_to_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
