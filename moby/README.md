# Moby

A clone of Z-Man Games' "Love Letter".

## Development roadmap

The first step will be run only on IEx, directly calling the game functions.
It will feature the game cards being dealt to two players only; players will
draw and play cards, without effects, and the winner is the one who has the
highest value card at the end.

Then card effects will be implemented. Initially, all cards can only have the
other player as the target of their effects.

Next steps include allowing for the player to target themself (e.g. with the
Prince), a third and fourth player, and keeping track of Tokens of Affection.

Then a text client will be developed, to allow for easier terminal interaction,
then a single-page Phoenix app.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `moby` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:moby, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/moby](https://hexdocs.pm/moby).
