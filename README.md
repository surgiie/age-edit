# age-edit

Manage your secrets within your editor using [age](https://github.com/FiloSottile/age).

## Introduction

`age-edit` is a small bash command-line that encrypts content with [age](https://github.com/FiloSottile/age) but decrypts content for editing within your preferred editor and then saves back as encrypted content with `age`.

### Encryption Methods

By default this cli uses `age` with `--passphrase` when encrypting and decrypting. If you want to use key pair encryption identity file instead, use `--key` flags when calling commands.

## Dependencies

- [age](https://github.com/FiloSottile/age)

## Installation

Clone repository:

```bash
version="main"
install_dir="$HOME/.local/bin/age-edit" # edit to liking.
git clone -b $version https://github.com/surgiie/age-edit.git "$install_dir"
```

Then add `$install_dir/age-edit` to `$PATH`.

## Usage

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

To edit and update a secreti in your editor, run the `edit` command:

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
```

