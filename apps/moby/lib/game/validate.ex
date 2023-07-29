defmodule Moby.Validate do
  alias Moby.{GameFlow, GameState}

  @spec validate(GameState.t()) :: GameState.t()
  def validate(game) do
    if valid_move?(game),
      do: GameFlow.move_is_valid(game),
      else: GameFlow.reset_move(game)
  end

  @spec valid_move?(GameState.t()) :: boolean
  defp valid_move?(%GameState{latest_move: %{named_card: :guard}}), do: false

  defp valid_move?(game) do
    has_card?(game) and
      target_active?(game) and
      valid_target?(game) and
      lonely_prince?(game)
  end

  @spec has_card?(GameState.t()) :: boolean
  defp has_card?(game) do
    game.latest_move.played_card in hd(game.players).current_cards
  end

  @spec target_active?(GameState.t()) :: boolean
  defp target_active?(%GameState{target_player: %Moby.Player{active?: false}}), do: false

  defp target_active?(_game), do: true

  @spec valid_target?(GameState.t()) :: boolean
  defp valid_target?(game = %GameState{latest_move: %{played_card: card, target: target}}) do
    self = hd(game.players).name
    !(self == target and card in ~w[king baron priest guard]a)
  end

  defp valid_target?(_game), do: true

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
end
