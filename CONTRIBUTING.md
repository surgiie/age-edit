# Contributing to age-edit

Thank you for your interest in contributing to age-edit! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/age-edit.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes: `git commit -m "Description of changes"`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Open a Pull Request

## Code Style

- Follow existing bash scripting conventions used in the project
- Use `set -euo pipefail` at the beginning of scripts
- Quote variables properly to prevent word splitting
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and single-purpose

## Testing

Before submitting a pull request:

1. Test all commands with both passphrase and key-based encryption
2. Test error handling (missing files, invalid inputs, etc.)
3. Verify that existing functionality still works
4. Test with different editors (vim, nano, etc.)

## Pull Request Guidelines

- Provide a clear description of what your PR does
- Reference any related issues
- Keep PRs focused on a single feature or bug fix
- Update documentation if needed
- Ensure your code follows the existing style

## Bug Reports

When reporting bugs, please include:

- Steps to reproduce
- Expected behavior
- Actual behavior
- Your environment (OS, bash version, age version)
- Relevant error messages

## Feature Requests

Feature requests are welcome! Please:

- Check if the feature has already been requested
- Clearly describe the feature and its use case
- Explain why it would be useful to others

## Questions

If you have questions about contributing, feel free to open an issue with the "question" label.

Thank you for contributing to age-edit!
