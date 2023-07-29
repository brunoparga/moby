# Moby

A clone of Z-Man Games' "Love Letter". Run `mix manual_test` to "play" a
version of the game on the terminal. There are only two players (when the
actual game plays up to 4), both share the same terminal and the full state
of the game is shown. But it works!

## Development roadmap

### DONE

The first step will be run only on IEx, directly calling the game functions.
It will feature the game cards being dealt to two players only; players will
draw and play cards, without effects, and the winner is the one who has the
highest value card at the end.

Then card effects will be implemented. Initially, all cards can only have the
other player as the target of their effects.

Next steps include allowing for the player to target themself (e.g. with the
Prince)

There is a very basic text interface, currently embedded within the server
application

Keeping track of Tokens of Affection

Testing all characters (except the Priest)

Testing the game mechanics for a single round

Separating the info that gets sent to each player
### TO DO

Multi-round play

Adding a third and fourth player

Extracting the text client


Implementing and testing the Priest

Single-page Phoenix app with LiveView
