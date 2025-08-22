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
          target_player: nil | Player.t(),
          face_up_cards: [Types.card()]
        }

  defstruct players: [],
            winner: nil,
            deck: [],
            removed_card: nil,
            latest_move: nil,
            target_player: nil,
            face_up_cards: []

  @doc """
  Let a player join a game.
  """
  @spec add_player(t, String.t(), pid) :: t
  def add_player(game, player_name, from) do
    new_player = %Player{name: player_name, pid: from}

    game
    |> Map.put(:players, game.players ++ [new_player])
  end

  @doc """
  Initialize a new game with the given player names.
  """
  @spec initialize(list({String.t(), pid})) :: t
  def initialize(players0) do
    {removed_card, deck} = deal_card(shuffle_deck())
    {face_up_cards, deck} = face_up_cards(players0, deck)
    {players1, deck} = initialize_players(players0, deck)
    {players2, deck} = deal_first_card(players1, deck)

    %__MODULE__{
      players: players2,
      deck: deck,
      removed_card: removed_card,
      face_up_cards: face_up_cards
    }
  end

  @doc """
  Updates the game state with the latest move made.
  Processing of the outcomes of the move happens elsewhere.
  """
  @spec set_move(t, Types.move()) :: t
  def set_move(game, move) do
    Moby.Handmaid.end_own_protection(game)
    |> Map.put(:latest_move, move)
    |> set_target()
  end

  @spec initialize_players(list({String.t(), pid}), list(atom)) :: {list(Player.t()), list(atom)}
  defp initialize_players(players, deck) do
    Enum.map_reduce(players, deck, fn {name, pid}, deck ->
      {card, deck} = deal_card(deck)
      {%Player{name: name, pid: pid, current_cards: [card]}, deck}
    end)
  end

  @spec face_up_cards(list({String.t(), pid}), list(atom)) :: {list(atom), list(atom)}
  defp face_up_cards(players, deck) when length(players) == 2 do
    [first_card, second_card, third_card | new_deck] = deck
    {[first_card, second_card, third_card], new_deck}
  end

  defp face_up_cards(_too_many_players_for_face_up_cards, deck), do: {[], deck}

  @spec deal_first_card(list(Player.t()), list(atom)) :: {list(Player.t()), list(atom)}
  defp deal_first_card(players, deck) do
    {next_card, deck} = deal_card(deck)

    [first_player | rest] = players
    first_player_cards = first_player.current_cards ++ [next_card]
    first_player = %Player{first_player | current_cards: first_player_cards}

    {[first_player | rest], deck}
  end

  @spec shuffle_deck() :: [atom]
  defp shuffle_deck() do
    ~w[princess countess king prince prince handmaid handmaid
       baron baron priest priest guard guard guard guard guard]a
    |> Enum.shuffle()
  end

  @spec deal_card(list(atom)) :: {atom, list(atom)}
  defp deal_card(deck) do
    [card | new_deck] = deck
    {card, new_deck}
  end

  @spec set_target(t) :: t
  defp set_target(game = %__MODULE__{latest_move: %{target: name}}) do
    Map.put(game, :target_player, Player.find(game, name))
  end

  defp set_target(game), do: Map.put(game, :target_player, nil)
end
