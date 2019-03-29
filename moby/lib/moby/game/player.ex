defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  alias Moby.GameState

  @type cards :: [atom]
  @type t :: %__MODULE__{
          name: String.t(),
          current_cards: cards,
          played_cards: cards,
          active?: boolean
        }

  defstruct name: "", current_cards: [], played_cards: [], active?: true
  # TODO: include score key in the struct, once many-round play is implemented

  @spec find(GameState.t(), String.t()) :: __MODULE__.t()
  def find(game, player_name) do
    Enum.find(game.players, fn x -> x.name == player_name end)
  end
end
