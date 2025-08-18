defmodule Moby.Display do
  @moduledoc """
  Functions that display the game state to the player.
  """

  alias Moby.{GameState, Player, Types}

  @doc """
  Return a map that shows only what the given player can see.
  """
  @spec state_for_player(GameState.t(), Player.t()) :: Types.discreet_game()
  def state_for_player(game, requester) do
    game
    |> Map.from_struct()
    |> Map.update!(:players, &hide_players(&1, requester))
    |> Map.drop(~w[winner deck removed_card latest_move target_player]a)
    |> Map.put(:up_to_play?, requester == hd(game.players))
  end

  @spec hide_players([Player.t()], Player.t()) :: [Types.any_player()]
  defp hide_players(players, requester) do
    Enum.map(players, fn player ->
      if player.name == requester.name, do: player, else: hide_player(player)
    end)
  end

  @spec hide_player(Player.t()) :: Types.discreet_player()
  defp hide_player(player) do
    player
    |> Map.from_struct()
    |> Map.delete(:current_cards)
  end
end
