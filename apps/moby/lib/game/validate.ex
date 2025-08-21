defmodule Moby.Validate do
  @moduledoc """
  Validates a move in the game. This prevents a player trying to play a card
  that is not in their hand, targeting a player that is not active, or
  targeting a player that is protected by the Handmaid.
  """

  alias Moby.GameState

  @doc """
  Validates a move in the game. Returns a tuple with a boolean indicating if the
  move is valid and the game state.
  """
  @spec validate(GameState.t()) :: {boolean, GameState.t()}
  def validate(game) do
    is_valid? =
      has_card?(game) and
        target_valid?(game) and
        targeting_another?(game) and
        lonely_prince?(game) and
        mandatory_countess?(game) and
        named_guard?(game)

    {is_valid?, game}
  end

  @spec has_card?(GameState.t()) :: boolean
  defp has_card?(game) do
    game.latest_move.played_card in hd(game.players).current_cards
  end

  @spec target_valid?(GameState.t()) :: boolean
  defp target_valid?(%GameState{target_player: nil}), do: true
  defp target_valid?(game), do: game.target_player.active?

  @spec targeting_another?(GameState.t()) :: boolean
  defp targeting_another?(%GameState{
         players: [current_player | _],
         latest_move: %{played_card: card, target: target}
       })
       when card in ~w[king baron priest guard]a and target == current_player.name,
       do: false

  defp targeting_another?(_game), do: true

  # If all other players are protected by the Handmaid, the player who plays the
  # Prince must choose themself as a target.
  @spec lonely_prince?(GameState.t()) :: boolean
  defp lonely_prince?(%GameState{
         players: [current | others],
         latest_move: %{played_card: :prince, target: target}
       }) do
    if Enum.all?(others, fn player -> player.protected? end),
      do: current.name == target,
      else: true
  end

  defp lonely_prince?(_game), do: true

  @spec mandatory_countess?(GameState.t()) :: boolean
  defp mandatory_countess?(%GameState{
         latest_move: %{played_card: played_card},
         players: [player | _]
       })
       when played_card in ~w[prince king]a do
    :countess in player.current_cards
  end

  defp mandatory_countess?(_game), do: true

  @spec named_guard?(GameState.t()) :: boolean
  defp named_guard?(%GameState{latest_move: %{named_card: :guard}}), do: false
  defp named_guard?(_game), do: true
end
