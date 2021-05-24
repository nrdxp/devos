#!/usr/bin/env bash
format="$(mktemp "${TMPDIR:-/tmp}"/kak-formatter-XXXXXX.cue)"
cat > $format
cue fmt $format || exit 1
cat $format
rm -f $format
