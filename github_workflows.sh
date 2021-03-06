#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-02-12 16:21:52 +0000 (Wed, 12 Feb 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

# shellcheck source=".bash.d/git.sh"
. "$srcdir/.bash.d/git.sh"

usage(){
    cat <<EOF

Script to get GitHub Workflows via the API

If no repo arg is given and is inside a git repo then takes determines the repo from the first git remote listed

Optional workflow id as second parameter will filter to just that workflow

\$REPO and \$WORKFLOW_ID environment variables are also supported with positional args taking precedence

usage: ${0##*/} <repo> [<workflow_id>]

EOF
    exit 3
}

repo="${1:-${REPO:-}}"

workflow_id="${2:-${WORKFLOW_ID:-}}"
if [ -n "$workflow_id" ]; then
    workflow_id="/$workflow_id"
fi

if [ -z "$repo" ]; then
    repo="$(git_repo)"
fi

if [ -z "$repo" ]; then
    usage "repo not specified and couldn't determine from git remote command"
fi

for arg; do
    case "$arg" in
        -*)     usage
                ;;
    esac
done

USER="${GITHUB_USER:-${USERNAME:-${USER}}}"
PASSWORD="${GITHUB_PASSWORD:-${GITHUB_TOKEN:-${PASSWORD:-}}}"

if ! [[ $repo =~ / ]]; then
    repo="$USER/$repo"
fi

"$srcdir/github_api.sh" "/repos/$repo/actions/workflows$workflow_id"  # | jq -r '.workflows[].path' | sed 's|.github/workflows/||;s|\.yaml$||'
