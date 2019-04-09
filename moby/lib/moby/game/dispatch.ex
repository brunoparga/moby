defmodule Moby.Dispatch do
  @moduledoc """
  Functions that call the appropriate actions for the card being played.
  """

  alias Moby.{Action, GameState}

  @doc """
  Make the given move: play a card, targetting one player (except for the
  Princess, Countess and Handmaid) and naming a card (for the Guard).
  """
  @spec move(GameState.t()) :: GameState.t()
  def move(game) do
    Action.execute_current(game, {Action, :play_card, [game.latest_move.played_card]})
    |> do_action()
  end

  @spec do_action(GameState.t()) :: GameState.t()
  defp do_action(game), do: if(valid_target?(game), do: send_to_module(game), else: game)

  @spec valid_target?(GameState.t()) :: boolean
  defp valid_target?(game) do
    nonmodule_card_played = game.latest_move.played_card in ~w[princess countess]a
    target_protected = Map.has_key?(game.latest_move, :target) and game.target_player.protected?
    not (nonmodule_card_played or target_protected)
  end

  @spec send_to_module(GameState.t()) :: GameState.t()
  defp send_to_module(game) do
    game.latest_move.played_card
    |> modulize_card
    |> apply(:play, [game])
  end

  @spec modulize_card(atom) :: atom
  defp modulize_card(card) do
    card
    |> Atom.to_string()
    |> String.capitalize()
    |> prepend_elixir()
    |> String.to_atom()
  end

  @spec prepend_elixir(String.t()) :: String.t()
  defp prepend_elixir(card), do: "Elixir.Moby.#{card}"
end
