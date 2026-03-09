#!/bin/bash
set -euo pipefail

# record-demo.sh — Record a demo GIF of the Claude Usage Widget
# Prerequisites: ffmpeg (brew install ffmpeg)
# Output: assets/demo.gif

APP_NAME="ClaudeUsage"
OUTPUT_DIR="assets"
FRAME_DIR="/tmp/claude-widget-frames"
GIF_FILE="${OUTPUT_DIR}/demo.gif"
PALETTE_FILE="/tmp/claude-widget-palette.png"

FRAME_COUNT=24
FPS=2
PADDING=15

# --- Dependency check ---
if ! command -v ffmpeg &>/dev/null; then
    echo "Error: ffmpeg not found. Install with: brew install ffmpeg"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# --- Ensure widget is running ---
if ! pgrep -x "$APP_NAME" >/dev/null; then
    echo "Widget not running. Launching..."
    if [ -d "/Applications/${APP_NAME}.app" ]; then
        open "/Applications/${APP_NAME}.app"
    elif [ -d "build/${APP_NAME}.app" ]; then
        open "build/${APP_NAME}.app"
    else
        echo "Error: Cannot find ${APP_NAME}.app. Run ./build.sh first."
        exit 1
    fi
    sleep 3
fi

# --- Get screen height in POINTS (not pixels) for coordinate conversion ---
# screencapture uses points, not pixels. On Retina displays, pixel height ≠ point height.
# NSScreen.main.frame.size.height gives the correct point-based value.
SCREEN_H=$(osascript -e 'tell application "Finder" to get bounds of window of desktop' 2>/dev/null | awk -F', ' '{print $4}')
if [ -z "$SCREEN_H" ] || [ "$SCREEN_H" = "0" ]; then
    # Fallback: use python to query AppKit
    SCREEN_H=$(python3 -c "from AppKit import NSScreen; print(int(NSScreen.mainScreen().frame().size.height))" 2>/dev/null)
fi
if [ -z "$SCREEN_H" ]; then
    echo "Error: Could not detect screen resolution in points"
    exit 1
fi
echo "Screen height: ${SCREEN_H} points"

# --- Get widget window position from UserDefaults ---
POS_X=$(defaults read com.claude.usage widgetPositionX 2>/dev/null | cut -d. -f1 || echo "")
POS_Y=$(defaults read com.claude.usage widgetPositionY 2>/dev/null | cut -d. -f1 || echo "")
IS_COMPACT=$(defaults read com.claude.usage widgetCompactMode 2>/dev/null || echo "0")

if [ "$IS_COMPACT" = "1" ]; then
    W_WIDTH=76
    W_HEIGHT=76
else
    W_WIDTH=140
    W_HEIGHT=170
fi

if [ -z "$POS_X" ] || [ -z "$POS_Y" ]; then
    echo "Warning: Could not read widget position from defaults."
    echo "Using fallback: bottom-right corner."
    SCREEN_W=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -m1 Resolution | awk '{print $2}')
    POS_X=$((SCREEN_W - W_WIDTH - 20))
    POS_Y=$((W_HEIGHT + 20))
fi

# --- Convert AppKit coords (origin bottom-left) to screencapture (origin top-left) ---
CAPTURE_X=$((POS_X - PADDING))
CAPTURE_Y=$((SCREEN_H - POS_Y - W_HEIGHT - PADDING))
CAPTURE_W=$((W_WIDTH + PADDING * 2))
CAPTURE_H=$((W_HEIGHT + PADDING * 2))

# Clamp to screen bounds
[ "$CAPTURE_X" -lt 0 ] && CAPTURE_X=0
[ "$CAPTURE_Y" -lt 0 ] && CAPTURE_Y=0

echo ""
echo "Recording widget at (${CAPTURE_X}, ${CAPTURE_Y}) ${CAPTURE_W}x${CAPTURE_H}"
echo "Duration: ${RECORD_SECONDS}s"
echo ""
echo "TIP: During recording, try these interactions:"
echo "  1. Watch the widget update (auto-refreshes every 30s)"
echo "  2. Double-click to toggle compact mode"
echo "  3. Right-click to show context menu"
echo ""
echo "Capturing starts in 3 seconds..."
sleep 3

# --- Capture frames via screencapture (no Screen Recording permission needed) ---
rm -rf "$FRAME_DIR" && mkdir -p "$FRAME_DIR"
INTERVAL=$(echo "scale=2; 1 / $FPS" | bc)

echo "Capturing ${FRAME_COUNT} frames at ${FPS}fps..."
for i in $(seq -w 1 "$FRAME_COUNT"); do
    screencapture -R "${CAPTURE_X},${CAPTURE_Y},${CAPTURE_W},${CAPTURE_H}" "${FRAME_DIR}/frame_${i}.png"
    sleep "$INTERVAL"
done

CAPTURED=$(ls "$FRAME_DIR"/*.png 2>/dev/null | wc -l | tr -d ' ')
if [ "$CAPTURED" -eq 0 ]; then
    echo "Error: No frames captured"
    exit 1
fi
echo "Captured ${CAPTURED} frames. Converting to GIF..."

# --- Two-pass ffmpeg: palette generation + GIF creation ---
# Pass 1: Generate optimal 256-color palette
ffmpeg -y -framerate "$FPS" -i "${FRAME_DIR}/frame_%02d.png" \
    -vf "scale=220:-1:flags=lanczos,palettegen=stats_mode=diff" \
    "$PALETTE_FILE" 2>/dev/null

# Pass 2: Apply palette for high-quality GIF
ffmpeg -y -framerate "$FPS" -i "${FRAME_DIR}/frame_%02d.png" -i "$PALETTE_FILE" \
    -lavfi "scale=220:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=3" \
    "$GIF_FILE" 2>/dev/null

# --- Cleanup ---
rm -rf "$FRAME_DIR" "$PALETTE_FILE"

# --- Report ---
GIF_SIZE=$(ls -lh "$GIF_FILE" | awk '{print $5}')
echo ""
echo "Demo GIF created: ${GIF_FILE} (${GIF_SIZE})"
echo ""
if [ "$(stat -f%z "$GIF_FILE")" -gt 5242880 ]; then
    echo "Warning: GIF is over 5MB. Consider reducing RECORD_SECONDS or adjusting fps."
fi
