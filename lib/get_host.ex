defmodule GetHost do
  @moduledoc """
  Documentation for `GetHost`.
  """

  require Logger

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

  @doc """
  Gets the short hostname of the system using platform-specific options.

  This function executes the `hostname` command with different options based on the operating system:
  * On macOS (Darwin): Uses `-f` option to get the fully qualified domain name
  * On Linux: Uses `-i` option to get the IP address
  * On Windows: Uses default `hostname` command without options

  ## Returns

    * `{:ok, hostname}` - Returns the hostname as a string if successful
    * `{:error, reason}` - Returns an error tuple with a `reason` if the command fails or executable is not found
  """
  @spec short_name() :: {:ok, binary()} | {:error, binary()}
  def short_name do
    case hostname_executable() do
      {:error, reason} -> {:error, reason}

      {:ok, hostname_cmd} -> 
        Logger.debug("os.type: #{inspect(:os.type())}")

        case run_hostname_with_suitable_option(:os.type(), hostname_cmd) do
          {result, 0} ->
            hostname = String.trim(result)
            Logger.debug("short hostname: #{hostname}")
            {:ok, hostname}

          _ -> {:error, "Fail to execute the \"hostname\" command."}
        end
    end
  end   

  defp run_hostname_with_suitable_option({:unix, :darwin}, hostname_cmd) do
    System.cmd(hostname_cmd, ["-f"])
  end

  defp run_hostname_with_suitable_option({:unix, :linux}, hostname_cmd) do
    System.cmd(hostname_cmd, ["-i"])
  end

  defp run_hostname_with_suitable_option({:win32, _}, hostname_cmd) do
    System.cmd(hostname_cmd, [])
  end
end
