defmodule Moby.GameState do
  @moduledoc """
  Represents a Love Letter game.
  """

  alias Moby.Player

  @type t :: %__MODULE__{
          players: [Player.t()],
          winner: nil | Player.t(),
          deck: [atom],
          removed_card: atom,
          latest_move: nil | Moby.move(),
          target_player: nil | Player.t()
        }

  defstruct players: [%Player{}, %Player{}],
            winner: nil,
            deck: [],
            removed_card: nil,
            latest_move: nil,
            target_player: nil

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

  @spec set_move(t, Moby.move()) :: t
  def set_move(game, move) do
    Moby.Handmaid.end_own_protection(game)
    |> Map.put(:latest_move, move)
    |> set_target()
  end

  @spec shuffle_deck() :: [atom]
  defp shuffle_deck() do
    ~w[princess countess king prince prince handmaid handmaid
       baron baron priest priest guard guard guard guard guard]a
    |> Enum.shuffle()
  end

  @spec set_target(t) :: t
  defp set_target(game = %__MODULE__{latest_move: %{target: name}}) do
    Map.put(game, :target_player, Player.find(game, name))
  end

  defp set_target(game), do: Map.put(game, :target_player, nil)
end
