defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  alias Moby.{GameState, Types}

  @type t :: %__MODULE__{
          name: String.t(),
          pid: pid,
          current_cards: [Types.card()],
          played_cards: [Types.card()],
          active?: boolean,
          protected?: boolean
        }

  defstruct name: "",
            pid: nil,
            current_cards: [],
            played_cards: [],
            active?: true,
            protected?: false

  # TODO: include score key in the struct, once many-round play is implemented

  @spec find(GameState.t(), String.t()) :: t()
  def find(game, player_name) do
    Enum.find(game.players, fn x -> x.name == player_name end)
  end
end
