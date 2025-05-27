defmodule GetHost do
  @moduledoc """
  Documentation for `GetHost`.
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
  def name do
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
