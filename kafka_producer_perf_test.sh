#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2019-07-30 15:16:58 +0100 (Tue, 30 Jul 2019)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -u
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

# sources heap, kerberos, brokers, zookeepers etc
# shellcheck disable=SC1090
. "$srcdir/.bash.d/kafka.sh"

kafka-producer-perf-test.sh "$@"
