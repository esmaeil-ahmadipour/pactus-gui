#!/bin/bash
set -e
DIR=$(dirname "$0")

echo "📝 Available steps:"
for script in "$DIR"/0*-*.sh; do
  echo "  - $(basename "$script")"
done

echo

for script in "$DIR"/0*-*.sh; do
  STEP_NAME=$(basename "$script")

  while true; do
    read -p "▶️ Run $STEP_NAME? (y/N/Q): " CONFIRM
    case "$CONFIRM" in
      [yY])
        echo "🚀 Running $STEP_NAME..."
        if bash "$script"; then
          echo "✅ Done $STEP_NAME"
        else
          echo "❌ Error in $STEP_NAME"
        fi
        echo "⏸️ Waiting 3 seconds..."
        break
        ;;
      [nN]|"")
        echo "⏭️ Skipping $STEP_NAME"
        echo
        break
        ;;
      [qQ])
        echo "🛑 Quitting."
        exit 0
        ;;
      *)
        echo "⚠️ Please answer with y (yes), n (no), or q (quit)."
        ;;
    esac
  done
done

