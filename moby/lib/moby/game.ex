defmodule Moby.Game do
  @moduledoc """
  Represents a Love Letter game.
  """

  defstruct player1: %Moby.Player{},
            player2: %Moby.Player{},
  alias Moby.Player

            deck: [],
            removed_card: nil

  # TODO: extract out the information about the card of the
  # opposing player
  def state(game), do: game

  def initialize() do
    [removed, player1_1, player1_2, player2 | deck] = shuffle_deck()
    joe = %Moby.Player{current_cards: [player1_1, player1_2]}
    ann = %Moby.Player{current_cards: [player2]}
    %__MODULE__{player1: joe, player2: ann, deck: deck, removed_card: removed}
  end

  defp shuffle_deck() do
    ~w[princess countess king prince prince handmaid handmaid
       baron baron priest priest guard guard guard guard guard]a
    |> Enum.shuffle
  end
end
