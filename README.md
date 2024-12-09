<div align="center">

# asdf-dst [![Build](https://github.com/datasprayio/asdf-dst/actions/workflows/build.yml/badge.svg)](https://github.com/datasprayio/asdf-dst/actions/workflows/build.yml)

[dst](https://dataspray.io) plugin for the [asdf version manager](https://asdf-vm.com).

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
asdf plugin add dst
# or
asdf plugin add dst https://github.com/datasprayio/asdf-dst.git
```

dst:

```shell
# Show all installable versions
asdf list-all dst

# Install specific version
asdf install dst latest

# Set a version globally (on your ~/.tool-versions file)
asdf global dst latest

# Now dst commands are available
dst --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.
