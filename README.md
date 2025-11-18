# age-edit

Manage your secrets within your editor using [age](https://github.com/FiloSottile/age).

## Introduction

`age-edit` is a small bash command-line that encrypts content with [age](https://github.com/FiloSottile/age) but decrypts content for editing within your preferred editor and then saves back as encrypted content with `age`.

## Installation

Download the standalone `age-edit` script:

```bash
version="main" # or specify a tag/branch
install_dir="$HOME/.local/bin" # customize as needed, must be in your PATH
curl -o "$install_dir/age-edit" "https://raw.githubusercontent.com/surgiie/age-edit/$version/age-edit"
chmod +x "$install_dir/age-edit"
```

### Encryption Methods

By default this CLI uses `age` with `--passphrase` when encrypting and decrypting. If you want to use key pair encryption identity file instead, use `--key` flags when calling commands.

#### Passphrase Encryption (Default)

```bash
# Create a secret with passphrase encryption
age-edit new my-secret
```

You'll be prompted for a passphrase when encrypting and decrypting.

#### Key-Based Encryption

First, generate an age key pair if you don't have one:

```bash
age-keygen -o ~/.age/key.txt
```

Then use the `--key` flag with commands:

```bash
# Create a secret with key-based encryption (using identity file)
age-edit new my-secret --key ~/.age/key.txt

# Or use a public key directly
age-edit new my-secret --key age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p

# Edit an existing secret with key-based decryption
age-edit edit my-secret --key ~/.age/key.txt

# Get a secret with key-based decryption
age-edit get my-secret --key ~/.age/key.txt
```

## Dependencies

- [age](https://github.com/FiloSottile/age) - Required for encryption/decryption

### For Developers

This project uses [bashly](https://bashly.dannyb.co/) to generate the CLI. If you want to modify the code:

1. Clone the repository
2. Make your changes to `bashly.yml` or files in the `app/` directory
3. Generate the CLI:

```bash
./generate.sh

```

## Usage

### Quick Reference

```bash
# Basic operations
age-edit new my-secret              # Create a new secret
age-edit edit my-secret             # Edit an existing secret
age-edit get my-secret              # View a secret
age-edit ls                         # List all secrets
age-edit rm my-secret               # Remove a secret

# With namespaces
age-edit new db-pass --namespace prod
age-edit ls --namespace prod

# With file extensions (for syntax highlighting)
age-edit new config --ext yaml
age-edit new script --ext sh

# With key-based encryption
age-edit new secret --key ~/.age/key.txt
age-edit get secret --key ~/.age/key.txt
```

### Specify CLI Context

Optionally specify the cli context:

```bash
# specify the cli context
export AGE_EDIT_CONTEXT=my-vault
```

**Note**: The context is simply a namespacing mechanism for managing multiple sets of secrets. If not specified, the default context is `default`.

### Create Secret
To create a new secret, run the `new` command:

```bash
age-edit new my-secret-name
```

This will open your editor for you to write the content of the secret within your editor. For example, if you wanted to save some yaml data as a secret:

```yaml
mysecret: my secret data
mysecret2: my secret data 2
```

Once you close your editor session, your secret will be written automatically to your secrets directory.


### Data Location

All secrets and data is written to the `$HOME/.age-edit` directory.

### Get Secret

To output secret decrypted, run the `get` command:

```bash
age-edit get my-secret
```

### Update Secret

To edit and update a secret in your editor, run the `edit` command:

```bash
age-edit edit my-secret-name
```

Just as the `new` command, this command will also open your editor and once session is closed, your secret should be updated.


### List Secrets
To list out secrets run the `ls` command:

```bash
age-edit ls
```

### Remove Secret

To remove a secret, run the `rm` command:

```bash

age-edit rm my-secret # will prompt
age-edit rm my-secret --force # no prompt and force remove.
```

### Namespaces

Namespaces are a way to group secrets. By default, all secrets are created in the `default` namespace. To create a secret in a different namespace, use the `--namespace` option when calling commands:

```bash
# Create a secret in a different namespace
age-edit new mysecret --namespace work

# List secrets in a specific namespace
age-edit ls --namespace work

# Get a secret from a specific namespace
age-edit get mysecret --namespace work

# Edit a secret in a specific namespace
age-edit edit mysecret --namespace work

# Remove a secret from a specific namespace
age-edit rm mysecret --namespace work
```

### File Extensions for Syntax Highlighting

You can specify a file extension when creating or editing secrets to enable syntax highlighting in your editor:

```bash
# Create a YAML secret with syntax highlighting
age-edit new db-config --ext yaml

# Create a JSON secret
age-edit new api-keys --ext json

# Edit with a different extension
age-edit edit my-script --ext sh
```

## Security Considerations

- Always use strong passphrases or properly secured identity files
- Identity files should have restricted permissions (e.g., `chmod 600 ~/.age/key.txt`)
- Temporary decrypted files are automatically cleaned up on exit
- The `~/.age-edit` directory stores encrypted secrets - ensure proper filesystem permissions
- Consider using key-based encryption for better security in automated environments

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## License

See [LICENSE.md](LICENSE.md) for details.
