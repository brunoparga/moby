# Moby-Letty

A clone of Z-Man Games' "Love Letter".

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

### TO DO

Adding a third and fourth player

Keeping track of Tokens of Affection

Extracting the text client

Separating the info that gets sent to each player

Implementing the Priest

Single-page Phoenix app with LiveView
