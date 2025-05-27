# GetHost

A cross-platform Elixir library for retrieving the fully qualified hostname of a system. This library provides a unified interface for getting hostname information across different operating systems (macOS, Linux, and Windows).

## Features

- Platform-specific hostname resolution
- IPv6 address expansion support
- Cross-platform compatibility (macOS, Linux, Windows)
- Simple and consistent API

## Usage

```elixir
# Get the fully qualified hostname
{:ok, hostname} = GetHost.name()
```

The library handles platform-specific behavior:
- On macOS: Returns the fully qualified domain name of the localhost
- On Linux and Windows: Returns the IPv4 address or the expanded IPv6 address of the localhost

## Installation

The package can be installed by adding `get_host` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:get_host, "~> 1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/get_host>.

## Tested Platforms

* Ubuntu 22.04 / Elixir 1.18 / OTP 27
* Ubuntu 22.04 / Elixir 1.17 / OTP 27
* Ubuntu 22.04 / Elixir 1.16 / OTP 26
* Ubuntu 22.04 / Elixir 1.15 / OTP 25
* Windows 2022 / Elixir 1.18 / OTP 27
* Windows 2019 / Elixir 1.18 / OTP 27

## License

Copyright (c) 2025 University of Kitakyushu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

