defmodule Moby.Server do
  use GenServer

  alias Moby.{Game, Play}

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Play.new_game()}
  end

  def handle_call({:game_state}, _from, game) do
    # Initially this shows the entire state to both players
    # (to be split later - TODO)
    {:reply, Game.state(game), game}
  end

  # def handle_call({:make_move, {:guard, target, named_card}}, _from, game) do
  #   game = Play.make_move(game, {:guard, target, named_card})
  #   {:reply, game, game}
  # end

  def handle_call({:make_move, {card, target}}, _from, game) do
    game = Play.make_move(game, {card, target})
    {:reply, game, game}
  end

  def handle_call({:make_move, card}, _from, game) do
    game = Play.make_move(game, card)
    {:reply, game, game}
  end
end
