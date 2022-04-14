defmodule Moby.Types do
  @type card() :: :baron | :countess | :guard | :handmaid | :king | :priest | :prince | :princess

  @type move() :: %{
          required(:played_card) => atom,
          optional(:target) => String.t(),
          optional(:named_card) => atom
        }

  @valid_cards ~w[baron countess guard handmaid king priest prince princess]a
  @nontargeted_cards ~w[princess countess handmaid]a
  @targeted_cards ~w[king prince baron priest]a

  def valid_cards, do: @valid_cards
  def nontargeted_cards, do: @nontargeted_cards
  def targeted_cards, do: @targeted_cards
end
