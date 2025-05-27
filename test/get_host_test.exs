defmodule GetHostTest do
  use ExUnit.Case
  doctest GetHost

  test "succeed name/0 always" do
    assert GetHost.name() |> elem(0) == :ok
  end
end
