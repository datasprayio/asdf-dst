#!/usr/bin/env bash

#
# Copyright 2024 Matus Faro
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -euo pipefail

TOOL_REPO="https://github.com/datasprayio/dataspray"
TOOL_NAME="dst"
TOOL_TEST="dst --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$TOOL_REPO" |
    grep -o 'refs/tags/cli-.*' | cut -d/ -f3- |
    sed 's/^cli-//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version="$1"
  local filename="$2"
  local url="https://github.com/datasprayio/dataspray/releases/download/cli-$version/dst-jar-$version.zip"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

extract_release() {
  local version="$1"
  local filename="$2"

  if [[ $filename == *.zip ]]
  then
    local tmp_download_dir
    tmp_download_dir=$(mktemp -d -t asdf_extract_XXXXXXX)

    (
      set -e

      cd "$tmp_download_dir"
      unzip -q "$filename"
      mv ./* "$ASDF_DOWNLOAD_PATH"
    )
  else
    tar -xvf $filename -C "$ASDF_DOWNLOAD_PATH" --strip-components=1
  fi
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    eval "$install_path/bin/$TOOL_TEST" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        eval "$install_path/bin/$TOOL_TEST"
        fail "Failed to test run tool with $install_path/bin/$TOOL_TEST"
    fi

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
