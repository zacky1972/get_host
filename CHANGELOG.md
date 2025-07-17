# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-07-17

### Added
- macOS CI workflow support with Sonoma on Apple Silicon
- CHANGELOG.md to documentation extras

### Changed
- Cleaned up mix.exs by removing commented dependency examples

### Dependencies
- Bumped erlef/setup-beam from 1.20.3 to 1.20.4
- Bumped igniter from 0.6.10 to 0.6.19

## [1.0.1] - 2025-06-28

### Added
- Comprehensive development tooling and quality assurance
- Credo for code analysis
- Dialyxir for static analysis
- Spellweaver for spell checking
- ExDoc for documentation generation
- NStandard for code formatting
- Igniter for development utilities

### Changed
- Removed old LICENSE file and updated docs configuration
- Updated CI workflow to remove Windows 2019 support

### Dependencies
- Bumped erlef/setup-beam from 1.20.1 to 1.20.3
- Bumped igniter from 0.6.9 to 0.6.10
- Various dependency updates for security and compatibility

### Fixed
- Various dependency updates and security patches

## [1.0.0] - 2025-05-27

### Added
- Initial release of GetHost library
- Cross-platform hostname resolution support
- Platform-specific hostname resolution for macOS, Linux, and Windows
- IPv6 address expansion support
- Simple and consistent API for hostname retrieval

### Features
- `GetHost.name/0` function for retrieving fully qualified hostname
- Automatic platform detection and appropriate hostname resolution
- Support for macOS, Linux, and Windows platforms

### Dependencies
- Initial dependencies for cross-platform hostname resolution
