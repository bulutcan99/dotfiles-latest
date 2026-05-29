#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This installer currently supports Arch Linux only." >&2
  exit 1
fi

exec "$repo_dir/scripts/linux/arch/bootstrap.sh" "$@"
