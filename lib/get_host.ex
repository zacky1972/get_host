defmodule GetHost do
  @moduledoc """
  Documentation for `GetHost`.
  """

  @doc """
  Finds the path to the `hostname` executable in the system.

  ## Returns

    * `{:ok, path}` - Returns the full `path` to the hostname executable if found
    * `{:error, reason}` - Returns an error tuple with a `reason` if the executable is not found
  """
  @spec hostname_executable() :: {:ok, binary()} | {:error, binary()}
  def hostname_executable do
    case System.find_executable("hostname") do
      nil -> {:error, "Not found \"hostname\""}
      hostname_cmd -> {:ok, hostname_cmd}
    end
  end
end
