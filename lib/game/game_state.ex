defmodule Moby.GameState do
  @moduledoc """
  Represents a Love Letter game.
  """

  alias Moby.{Player, Types}

  @type t :: %__MODULE__{
          players: [Player.t()],
          winner: nil | Player.t(),
          deck: [Types.card()],
          removed_card: Types.card(),
          latest_move: nil | Types.move(),
          target_player: nil | Player.t()
        }

  defstruct players: [%Player{}, %Player{}],
            winner: nil,
            deck: [],
            removed_card: nil,
            latest_move: nil,
            target_player: nil

  @spec state(t) :: t
  def state(game = %__MODULE__{players: [active_player | _other_players]}) do
    state(game, active_player)
  end

  @doc """
  Return a map that shows only what the given player can see.
  """
  @spec state(t, Player.t()) :: Types.discreet_game()
  def state(game, requester) do
    game
    |> Map.from_struct()
    |> Map.update!(:players, &hide_players(&1, requester))
    |> Map.drop([:winner, :deck, :removed_card])
    |> Map.put(:up_to_play?, requester == hd(game.players))
  end

  @spec initialize(list(String.t())) :: t
  def initialize([player1_name, player2_name | _tail]) do
    # TODO: improve dealing cards (in a separate function)
    # TODO: ensure 2, 3 or 4 people can play
    [removed_card, player1_first_card, player1_second_card, player2_card | deck] = shuffle_deck()

    player1 = %Player{
      name: player1_name,
      current_cards: [player1_first_card, player1_second_card]
    }

    player2 = %Player{name: player2_name, current_cards: [player2_card]}
    %__MODULE__{players: [player1, player2], deck: deck, removed_card: removed_card}
  end

  @spec set_move(t, Types.move()) :: t
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

  @spec hide_players([Player.t()], Player.t()) :: [Types.any_player()]
  defp hide_players(players, requester) do
    other_players = List.delete(players, requester)
    [requester | Enum.map(other_players, &hide_player/1)]
  end

  @spec hide_player(Player.t()) :: Types.discreet_player()
  defp hide_player(player) do
    player
    |> Map.from_struct()
    |> Map.delete(:current_cards)
  end

  @spec set_target(t) :: t
  defp set_target(game = %__MODULE__{latest_move: %{target: name}}) do
    Map.put(game, :target_player, Player.find(game, name))
  end

  defp set_target(game), do: Map.put(game, :target_player, nil)
end
