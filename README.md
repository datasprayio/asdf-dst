<div align="center">

# asdf-app [![Build](https://github.com/datasprayio/asdf-dst/actions/workflows/build.yml/badge.svg)](https://github.com/datasprayio/asdf-dst/actions/workflows/build.yml)

[app](https://dataspray.io) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add app
# or
asdf plugin add app https://github.com/datasprayio/asdf-dst.git
```

app:

```shell
# Show all installable versions
asdf list-all app

# Install specific version
asdf install app latest

# Set a version globally (on your ~/.tool-versions file)
asdf global app latest

# Now app commands are available
app --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.
