# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Bash completion script for better command-line experience
- CONTRIBUTING.md with guidelines for contributors
- Security considerations section in README
- .gitignore file for common editor and temporary files
- Enhanced documentation with key-based encryption examples
- File extension examples for syntax highlighting

### Fixed
- Typo in README: 'secreti' -> 'secret'
- Typo in helpers: 'Dispalys' -> 'Displays'
- Bug in commands/new: incorrect tmp_path cleanup
- Bug in commands/edit: incorrect tmp_path cleanup
- Improved error handling consistency across commands
- Variable quoting consistency in helpers and commands

### Changed
- Improved EDITOR environment variable validation
- Enhanced README with more comprehensive examples
- Better documentation for namespaces and file extensions

## [0.1.0] - Initial Release

### Added
- Basic secret management (new, edit, get, ls, rm)
- Support for passphrase-based encryption
- Support for key-based encryption with age identity files
- Namespace support for organizing secrets
- Context support for managing multiple vaults
- File extension support for syntax highlighting in editors
