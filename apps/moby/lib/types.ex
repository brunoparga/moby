defmodule Moby.Types do
  alias Moby.Player

  @type card() :: :baron | :countess | :guard | :handmaid | :king | :priest | :prince | :princess

  @type move() :: %{
          required(:played_card) => atom,
          optional(:target) => String.t(),
          optional(:named_card) => atom
        }

  @type discreet_player() :: %{
          name: String.t(),
          played_cards: [card()],
          active?: boolean(),
          protected?: boolean()
        }

  @type any_player() :: discreet_player() | Player.t()

  @type discreet_game() :: %{
          players: [any_player()],
          up_to_play?: boolean(),
          latest_move: nil | Types.move(),
          target_player: nil | Player.t()
        }

  @valid_cards ~w[baron countess guard handmaid king priest prince princess]a
  @nontargeted_cards ~w[princess countess handmaid]a
  @targeted_cards ~w[king prince baron priest]a

  def valid_cards, do: @valid_cards
  def nontargeted_cards, do: @nontargeted_cards
  def targeted_cards, do: @targeted_cards
end
