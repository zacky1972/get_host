defmodule GetHost do
  @moduledoc """
  A cross-platform Elixir library for retrieving the fully qualified hostname of a system.

  This module provides a unified interface for getting hostname information across different
  operating systems (macOS, Linux, and Windows). It handles platform-specific behavior and
  provides consistent results regardless of the underlying operating system.

  ## Platform-Specific Behavior

  The module handles hostname resolution differently based on the operating system:

  * On macOS: Returns the fully qualified domain name of the localhost
  * On Linux, Windows: Returns the IPv4 address or the expanded IPv6 address of the localhost

  ## Examples

      > GetHost.name()
      {:ok, "example.com"}  # On macOS
      {:ok, "192.168.1.1"}  # On Linux/Windows

  ## Error Handling

  The module returns error tuples in case of failures:

      > GetHost.name()
      {:error, "Not found \"hostname\""}  # When hostname command is not available
      {:error, "Fail to execute the \"hostname\" command."}  # When command execution fails

  ## Dependencies

  The module requires the following system commands to be available:
  * `hostname` - For getting the system hostname
  * `ping` - For resolving hostname on Windows systems
  """

  require Logger

  @doc """
  Gets the fully qualified hostname of the system.

  The function handles platform-specific behavior:
  * On macOS: Returns the fully qualified domain name of the localhost
  * On Linux and Windows: Returns the IPv4 address or the expanded IPv6 address of the localhost

  ## Returns

    * `{:ok, hostname}` - Returns the fully qualified hostname as a string if successful
    * `{:error, reason}` - Returns an error tuple with a `reason` if any step fails
  """
  @spec name() :: {:ok, binary()} | {:error, binary()}
  def name() do
    case GetHost.Util.short_name() do
      {:error, reason} ->
        {:error, reason}

      {:ok, short_name} ->
        case GetHost.Util.to_fully_qualified_hostname(:os.type(), short_name) do
          {:error, reason} ->
            {:error, reason}

          {:ok, result} ->
            result = GetHost.Util.expand_ipv6(result)
            Logger.debug("fully qualified hostname: #{result}")
            {:ok, result}
        end
    end
  end
end
