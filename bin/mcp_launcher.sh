#!/bin/bash
# bin/mcp_launcher.sh
set -e
cd "$(dirname "$0")/.."

# rbenv の場合(mise なら: eval "$(mise activate bash)" など環境に合わせて変更)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"

exec bundle exec ruby bin/mcp
