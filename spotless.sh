#!/usr/bin/env zsh

contents=$(cat -)

exec 3>&1                    # Save the place that stdout (1) points to.
output=$(echo $contents | gradle spotlessApply \
  --quiet \
  -PspotlessIdeHook="$1" \
  -PspotlessIdeHookUseStdIn \
  -PspotlessIdeHookUseStdOut 2>&1 1>&3)  # Run command.  stderr is captured.
exec 3>&-                    # Close FD #3.

if [[ "$output" != "IS DIRTY" ]]; then
  echo $contents
fi
