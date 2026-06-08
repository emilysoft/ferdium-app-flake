#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"

get_latest_version() {
  curl -sL https://api.github.com/repos/ferdium/ferdium-app/releases/latest \
    | jq -r '.tag_name' \
    | sed 's/^v//'
}

update_hash() {
  local arch="$1"
  local version="$2"
  local sri_hash

  echo "  Fetching hash for ${arch}..."
  url="https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb"
  sri_hash=$(nix store prefetch-file --json "$url" 2>/dev/null | jq -r '.hash')

  if [[ -z "$sri_hash" || "$sri_hash" == "null" ]]; then
    echo "  ERROR: Failed to fetch hash for ${arch}"
    return 1
  fi

  echo "  New hash for ${arch}: $sri_hash"

  if [[ "$arch" == "amd64" ]]; then
    sed -i "s|x86_64-linux = \".*\"|x86_64-linux = \"$sri_hash\"|" "$PACKAGE_FILE"
  else
    sed -i "s|aarch64-linux = \".*\"|aarch64-linux = \"$sri_hash\"|" "$PACKAGE_FILE"
  fi
}

CURRENT_VERSION=$(grep 'version =' "$PACKAGE_FILE" | sed 's/.*version = "\(.*\)";/\1/')
LATEST_VERSION=$(get_latest_version)

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
  echo "Already up to date."
  exit 0
fi

echo "Updating version to $LATEST_VERSION..."
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$PACKAGE_FILE"

update_hash "amd64" "$LATEST_VERSION"
update_hash "arm64" "$LATEST_VERSION"

echo ""
echo "Updated to v${LATEST_VERSION}. Verify with: git diff $PACKAGE_FILE"
