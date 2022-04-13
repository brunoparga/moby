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

  @spec initialize(list(String.t())) :: t
  def initialize([player1_name, player2_name | _tail]) do
    # TODO: improve dealing cards (in a separate function)
    # TODO: ensure 2, 3 or 4 people can play
    [removed_card, player1_first_card, player1_second_card, player2_card | deck] = shuffle_deck()
    player1 = %Player{name: player1_name, current_cards: [player1_first_card, player1_second_card]}
    player2 = %Player{name: player2_name, current_cards: [player2_card]}
    %__MODULE__{players: [player1, player2], deck: deck, removed_card: removed_card}
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
