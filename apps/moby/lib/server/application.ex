defmodule Moby.Application do
  use Application

  @supervisor_name GameStarter

  @impl true
  def start(_type, _args) do
    supervisor_spec = [
      {Phoenix.PubSub, name: Moby.PubSub},
      {DynamicSupervisor, strategy: :one_for_one, name: @supervisor_name}
    ]

    Supervisor.start_link(supervisor_spec, strategy: :one_for_one, name: Moby.Supervisor)
  end

  def start_game(player_names) do
    DynamicSupervisor.start_child(@supervisor_name, {Moby.Server, player_names})
  end
end
