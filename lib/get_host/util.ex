defmodule GetHost.Util do
  @moduledoc """
  Utility functions for hostname and network operations.
  """

  require Logger

  @doc """
  Expands an IPv6 address to its full form.

  This function handles two types of IPv6 addresses:
  * Fully specified addresses (e.g., "2001:db8:1:2:3:4:5:6")
  * Compressed addresses with "::" (e.g., "2001:db8::1")

  The function expands compressed addresses by:
  1. Splitting the address at "::"
  2. Calculating the number of missing segments
  3. Inserting "0000" for each missing segment
  4. Padding each segment to 4 characters with leading zeros

  ## Parameters

    * `hostname` - The IPv6 address to expand

  ## Returns

    * `binary()` - The expanded IPv6 address, or the original string if not an IPv6 address

  ## Examples

      iex> GetHost.Util.expand_ipv6("2001:db8::1")
      "2001:0db8:0000:0000:0000:0000:0000:0001"

      iex> GetHost.Util.expand_ipv6("2001:db8:1:2:3:4:5:6")
      "2001:0db8:0001:0002:0003:0004:0005:0006"

      iex> GetHost.Util.expand_ipv6("not-an-ipv6")
      "not-an-ipv6"
  """
  @spec expand_ipv6(binary()) :: binary()
  def expand_ipv6(hostname) do
    cond do
      Regex.match?(~r/^([0-9a-f]{1,4}:){7}[0-9a-f]{1,4}$/, hostname) ->
        hostname
        |> String.split(":")
        |> Enum.map(&"000#{&1}")
        |> Enum.map_join(":", &String.slice(&1, -4..-1))

      Regex.match?(~r/^([0-9a-f]{1,4}[:]{1,2})+[0-9a-f]{1,4}$/, hostname) ->
        hostname
        |> String.split("::")
        |> Enum.map(&String.split(&1, ":"))
        |> Enum.map(&{&1, Enum.count(&1)})
        |> Enum.unzip()
        |> then(fn {l, n} ->
          [
            Enum.at(l, 0),
            1..(8 - Enum.sum(n))
            |> Enum.map(fn _ -> "0" end),
            Enum.at(l, 1)
          ]
        end)
        |> List.flatten()
        |> Enum.join(":")
        |> expand_ipv6()

      true ->
        hostname
    end
  end

  @doc """
  Finds the path to the `hostname` executable in the system.

  ## Returns

    * `{:ok, path}` - Returns the full `path` to the hostname executable if found
    * `{:error, reason}` - Returns an error tuple with a `reason` if the executable is not found
  """
  @spec hostname_executable() :: {:ok, binary()} | {:error, binary()}
  def hostname_executable() do
    case System.find_executable("hostname") do
      nil -> {:error, "Not found \"hostname\""}
      hostname_cmd -> {:ok, hostname_cmd}
    end
  end

  @doc """
  Finds the path to the `ping` executable in the system.

  ## Returns

    * `{:ok, path}` - Returns the full `path` to the ping executable if found
    * `{:error, reason}` - Returns an error tuple with a `reason` if the executable is not found
  """
  @spec ping_executable() :: {:ok, binary()} | {:error, binary()}
  def ping_executable() do
    case System.find_executable("ping") do
      nil -> {:error, "Not found \"ping\""}
      ping_cmd -> {:ok, ping_cmd}
    end
  end

  @doc """
  Executes a single ping to the specified hostname without DNS resolution.

  This function executes the `ping` command with different options based on the operating system:
  * On Unix-like systems (macOS, Linux): Uses `-n -c 1` options to prevent DNS resolution and send one packet
  * On Windows: Uses `/a /n 1` options for address resolution and a single ping

  ## Parameters

    * `hostname` - The hostname or IP address to ping

  ## Returns

    * `{:ok, result}` - Returns the ping command output as a string if successful
    * `{:error, reason}` - Returns an error tuple with a `reason` if the command fails or executable is not found
  """
  @spec ping_raw_oneshot(binary()) :: {:ok, binary()} | {:error, binary()}
  def ping_raw_oneshot(hostname), do: ping_raw_oneshot_sub(:os.type(), hostname)

  defp ping_raw_oneshot_sub({:unix, _}, hostname) do
    case ping_executable() do
      {:error, reason} ->
        {:error, reason}

      {:ok, ping_cmd} ->
        case System.cmd(ping_cmd, ["-n", "-c", "1", hostname]) do
          {result, 0} -> {:ok, result}
          _ -> {:error, "Fail to execute the \"ping\" command."}
        end
    end
  end

  defp ping_raw_oneshot_sub({:win32, _}, hostname) do
    case ping_executable() do
      {:error, reason} ->
        {:error, reason}

      {:ok, ping_cmd} ->
        case System.cmd(ping_cmd, ["/a", "/n", "1", hostname]) do
          {result, 0} -> {:ok, result}
          _ -> {:error, "Fail to execute the \"ping\" command."}
        end
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
  def short_name() do
    case hostname_executable() do
      {:error, reason} ->
        {:error, reason}

      {:ok, hostname_cmd} ->
        Logger.debug("os.type: #{inspect(:os.type())}")

        case run_hostname_with_suitable_option(:os.type(), hostname_cmd) do
          {result, 0} ->
            hostname = String.trim(result)
            Logger.debug("short hostname: #{hostname}")
            {:ok, hostname}

          _ ->
            {:error, "Fail to execute the \"hostname\" command."}
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

  @doc """
  Converts a hostname to its fully qualified form based on the platform.

  This function handles hostname resolution differently based on the operating system:
  * On Unix-like systems (macOS, Linux): Returns the hostname as is
  * On Windows: Uses `ping` command to resolve the hostname to its IP address

  ## Parameters

    * `platform` - The platform tuple `{:unix, _}` or `{:win32, _}`
    * `hostname` - The hostname to convert

  ## Returns

    * `{:ok, ip}` - Returns the IP address as a string if successful
    * `{:error, reason}` - Returns an error tuple with a `reason` if the resolution fails
  """
  @spec to_fully_qualified_hostname({atom(), atom()}, binary()) ::
          {:ok, binary()} | {:error, binary()}
  def to_fully_qualified_hostname({:unix, _}, hostname), do: {:ok, hostname}

  def to_fully_qualified_hostname({:win32, _}, hostname) do
    case ping_raw_oneshot(hostname) do
      {:error, reason} ->
        {:error, reason}

      {:ok, result} ->
        result
        |> String.trim()
        |> String.split("\n")
        |> Enum.at(1)
        |> then(&Regex.named_captures(~r/Reply from (?<ip>[0-9a-f:.]+)/, &1))
        |> Map.get("ip")
        |> then(&{:ok, &1})
    end
  end
end
