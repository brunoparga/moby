defmodule Moby.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [worker(Moby.Server, [])]
    # TODO: replace :simple_one_for_one with DynamicSupervisor
    options = [name: Moby.Supervisor, strategy: :simple_one_for_one]
    Supervisor.start_link(children, options)
  end
end
