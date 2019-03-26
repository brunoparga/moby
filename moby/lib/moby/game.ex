defmodule Moby.Game do
  @moduledoc """
  Represents a Love Letter game.
  """

  alias Moby.Player

  @type t :: %__MODULE__{
          players: [Player.t()],
          winner: nil | Player.t(),
          deck: [atom],
          removed_card: atom
        }
  defstruct players: [%Player{}, %Player{}],
            winner: nil,
            deck: [],
            removed_card: nil

  # TODO: extract out the information about the card of the opposing player
  @spec state(t) :: t
  def state(game), do: game

  @spec initialize() :: t
  def initialize() do
    [removed, player1_1, player1_2, player2 | deck] = shuffle_deck()
    joe = %Player{name: "Joe", current_cards: [player1_1, player1_2]}
    ann = %Player{name: "Ann", current_cards: [player2]}
    %__MODULE__{players: [joe, ann], deck: deck, removed_card: removed}
  end

  @spec shuffle_deck() :: [atom]
  defp shuffle_deck() do
    ~w[princess countess king prince prince handmaid handmaid
       baron baron priest priest guard guard guard guard guard]a
    |> Enum.shuffle()
  end
end
