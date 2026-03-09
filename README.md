# Claude Usage Widget

A lightweight macOS desktop widget that tracks your Claude usage limits and rate limits in real time. Know exactly when you're about to hit Claude's API usage cap — before it happens.

<p align="center">
  <img src="assets/demo.gif" width="220" alt="Claude Usage Widget demo — live usage tracking" />
</p>

<p align="center">
  <img src="assets/widget-on-track.png" width="180" alt="Widget — on track" />
  &nbsp;&nbsp;&nbsp;
  <img src="assets/widget-compact.png" width="80" alt="Widget — compact mode" />
  &nbsp;&nbsp;&nbsp;
  <img src="assets/widget-still-usable.png" width="180" alt="Widget — still usable" />
  &nbsp;&nbsp;&nbsp;
  <img src="assets/widget-session-expired.png" width="180" alt="Widget — session expired" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13%2B-black" />
  <img src="https://img.shields.io/badge/Swift-5.9+-orange" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
  <img src="https://img.shields.io/badge/No_Dependencies-lightgrey" />
  <img src="https://img.shields.io/badge/Homebrew-available-blue" />
  <img src="https://img.shields.io/github/stars/rishi-banerjee1/claude-usage-widget?style=flat&label=Stars" />
</p>

---

## Why This Exists

Claude usage limits are easy to hit without noticing. This widget keeps the important signals visible at all times:

- **Current usage** percentage
- **Pace** vs time elapsed
- **Reset countdown** timer
- **Clear status color** (green / orange / red)

No tab switching. No guesswork.

---

## Features

<table>
<tr>
<td width="25%">

<img src="assets/widget-on-track.png" width="160" alt="Widget showing on-track status" />

</td>
<td width="25%">

<img src="assets/widget-compact.png" width="80" alt="Widget in compact mode" />

</td>
<td width="25%">

<img src="assets/widget-still-usable.png" width="160" alt="Widget showing still usable" />

</td>
<td width="25%">

<img src="assets/widget-session-expired.png" width="160" alt="Widget showing session expired" />

</td>
</tr>
<tr>
<td align="center"><em>On track — plenty of room</em></td>
<td align="center"><em>Compact mode</em></td>
<td align="center"><em>Window full — still usable</em></td>
<td align="center"><em>Session expired — re-authenticate</em></td>
</tr>
</table>

- **Live progress ring** with usage %
- **Pace tracking** — actual vs expected usage
- **Reset countdown** timer
- **Compact mode** — double-click to shrink to a frameless ring; background appears on hover
- **Always-on-top** floating panel (all Spaces)
- **Draggable** — remembers position
- **Auto-refresh** every 30 seconds
- **Session expiry detection** with red border alert
- **Cloudflare-aware** — won't falsely show "Session Expired"
- **Multi-limit aware** — when one window is full, shows remaining capacity on other limits
- **Self-updating** — checks for updates every 24h, one-click update via Settings
- **Plain-English status** messages
- **Minimal**, translucent macOS-native UI

---

## Install

Four ways to get the widget — pick the one that fits:

### Option 1: Homebrew (Recommended)

```bash
brew install --cask rishi-banerjee1/ai-tools/claude-usage-widget
```

> Don't have Homebrew? Install it first: [brew.sh](https://brew.sh)

### Option 2: One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/rishi-banerjee1/claude-usage-widget/main/install.sh | bash
```

Downloads the pre-built app, installs to `/Applications`, removes Gatekeeper quarantine, and launches it. No build tools needed.

### Option 3: Download from GitHub Releases

1. Go to [**Releases**](https://github.com/rishi-banerjee1/claude-usage-widget/releases/latest)
2. Download `ClaudeUsage.app.zip`
3. Unzip and move `ClaudeUsage.app` to `/Applications`
4. Double-click to launch

> **macOS says "unidentified developer"?** Right-click the app → **Open** → click **Open** again. That's it — you only need to do this once.

### Option 4: Build from Source

Requires macOS 13+ and Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/rishi-banerjee1/claude-usage-widget.git
cd claude-usage-widget
chmod +x build.sh run.sh setup.sh generate-icon.sh
./build.sh
./setup.sh          # Interactive credential setup
open build/ClaudeUsage.app
```

### Connect to Your Claude Account

The widget needs two pieces of info from your Claude account (one-time setup, takes ~2 minutes):

1. **Launch the app** — a small widget appears on your desktop
2. **Right-click the widget → Settings**
3. Paste your **Session Key** and **Organization ID** (see [How to Get Your Credentials](#how-to-get-your-credentials) for step-by-step)
4. Click **Save**

That's it — the widget shows your live usage data.

> **Session key expired?** The widget shows a red border when this happens. Just right-click → Settings → paste a fresh key. Your Org ID never expires.

---

## Usage

| Action | How |
|--------|------|
| Open Settings | Right-click → **Settings** |
| Refresh | Right-click → **Refresh** |
| Quit | Right-click → **Quit** |
| Move widget | Click + drag |
| Compact / Full Size | Double-click widget, or right-click → **Compact** / **Full Size** |
| Change metric | Settings → **Display Metric** |

### Choosing a Metric

| Metric | Best For |
|--------|----------|
| **5-Hour** (Recommended) | Daily pacing — tells you if you can keep chatting right now |
| **7-Day (All Models)** | Weekly budgeting — tracks total weekly allowance |
| **7-Day (Sonnet Only)** | Heavy Sonnet usage tracking |

---

## How to Get Your Credentials

You need two things from your browser. Here's how to find them:

### Session Key

1. Open **[claude.ai](https://claude.ai)** in Chrome (make sure you're logged in)
2. Press **`Cmd + Option + I`** to open Developer Tools
3. Click the **Application** tab at the top
4. In the left sidebar, expand **Cookies** → click **https://claude.ai**
5. Find the row named **`sessionKey`** → double-click the **Value** column → copy it

> Session keys expire every few days. When the widget shows a red border, just paste a fresh key in Settings.

### Organization ID

1. Still in Developer Tools, click the **Network** tab at the top
2. Send any message in a Claude chat
3. Look at the request URLs that appear — find one containing `/organizations/`
4. The long code after `/organizations/` is your Org ID (looks like `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

> Your Org ID **never expires** — you only need to do this once.

---

## Security & Privacy

| Principle | Detail |
|-----------|--------|
| **No browser access** | The app never reads your cookies or browser data — you paste the key yourself |
| **Masked input** | Session key is hidden when you type it and never logged |
| **Keychain storage** | Session key stored securely in macOS Keychain — no repeated password prompts |
| **No telemetry** | Zero analytics, zero tracking. The app only talks to `claude.ai` |
| **Cloudflare-aware** | Handles Cloudflare security checks gracefully — won't falsely report your session as expired |
| **Smart polling** | Pauses API calls when session expires — resumes when you save fresh credentials |
| **Open source** | Read every line of `setup.sh` and `ClaudeUsageApp.swift` |

---

<details>
<summary><strong>Understanding Claude Limits</strong></summary>

<br>

Claude enforces two independent limits:

### 5-Hour Rolling Window

- Tracks the last 5 hours of usage
- Recovers automatically as time passes
- Most useful for daily pacing
- If it hits 100% — you're locked out until older messages age past the 5-hour mark

### 7-Day Weekly Limit

- Total weekly allowance across all models
- Hard reset once per week
- If it hits 100% — you're done until the weekly reset regardless of the 5-hour limit

There's also a **7-Day Sonnet-only** metric for tracking that model separately.

### Status Colors (Pace Tracking)

The widget compares your actual usage vs expected usage based on elapsed time:

| Color | Meaning | Example |
|-------|---------|---------|
| 🟢 Green | More than 5% **below** expected pace | 2h into 5h window, at 30% (expected: 40%) |
| 🟠 Orange | Within **±5%** of expected pace | 2h into 5h window, at 38% (expected: 40%) |
| 🔴 Red | More than 5% **above** expected pace | 2h into 5h window, at 60% (expected: 40%) |

### Status Messages

| Message | Meaning |
|---------|---------|
| Plenty of room | Under 30%, on track |
| On track — you're good | On track, above 30% |
| On pace — be mindful | Roughly at expected pace |
| Above pace — slow down | Burning faster than expected |
| Almost out — slow down | Above 90%, exceeding pace |
| Limit reached — wait for reset | 100% — rate-limited |

</details>

---

<details>
<summary><strong>What Happens When setup.sh Can't Auto-Fetch</strong></summary>

<br>

Sometimes `setup.sh` can't automatically fetch your org ID. Here's why and what to do:

### Cloudflare Blocks

The Claude API sits behind Cloudflare, which occasionally challenges `curl` requests with a 403 page. **This does NOT mean your session key is invalid.**

- `setup.sh` will detect the Cloudflare block and tell you
- It will ask you to enter your org ID manually instead (with step-by-step instructions)
- The widget app itself uses macOS `URLSession` which passes through Cloudflare — so the widget will work fine even if `curl` was blocked

### Expired Session Key

If the session key you pasted has already expired:

- `setup.sh` will detect the 401/403 error and tell you it's expired
- You'll be prompted to paste a fresh key and try again
- If it still fails, you can save anyway — the widget will show "Session Expired" and prompt you to update later

### Network Issues

If your network is down or the API is unreachable:

- `setup.sh` offers manual entry as a fallback
- The widget retries with exponential backoff (1s → 2s → 4s) up to 3 times

</details>

---

<details>
<summary><strong>Manual Setup (Alternative to setup.sh)</strong></summary>

<br>

If you prefer not to use the setup script:

1. **Right-click** the widget → **Settings...**
2. Paste your **Session Key** (from browser cookies — see [How to Get Your Credentials](#how-to-get-your-credentials))
3. Paste your **Organization ID** (from DevTools Network tab, or env var)
4. Select which metric to display
5. Click **Save**

### Environment Variable Fallback

```bash
export CLAUDE_SESSION_KEY="sk-ant-sid01-..."
export CLAUDE_ORGANIZATION_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
open build/ClaudeUsage.app
```

</details>

---

<details>
<summary><strong>How It Works (Technical)</strong></summary>

<br>

The widget polls the Claude API every 30 seconds:

```
GET https://claude.ai/api/organizations/{orgId}/usage
Cookie: sessionKey={key}
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ClaudeUsageWidget/1.0
```

**Architecture:** Single-file Swift app (`ClaudeUsageApp.swift`, ~1610 lines) — no Xcode project, no dependencies, no package manager. Compiles with `swiftc` directly.

**Key components:**
- `FloatingWidgetPanel` — borderless `NSPanel` (always-on-top, all Spaces, draggable)
- `WidgetView` — SwiftUI with 4 states + compact/full mode, data, setup needed, session expired, loading
- `WidgetPanelController` — manages lifecycle, persists position, handles compact toggle + panel resize
- `AppDelegate` — fetching, 30s timer, retry logic, Cloudflare detection

</details>

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| **"Setup Needed"** | Right-click the widget → Settings → enter your credentials |
| **"Session Expired"** (red border) | Right-click → Settings → paste a fresh session key. Your Org ID is remembered. |
| **Widget not visible** | The app has no dock or menubar icon — just the floating widget. Try relaunching the app. |
| **Widget too big** | Double-click to switch to compact mode (just the ring). Double-click again to restore. |
| **Data not loading** | Usually an expired session key — right-click → Settings → paste a fresh one |
| **Stuck at same %** | That's accurate — usage recovers gradually over the time window. Try switching metrics via right-click. |
| **macOS blocks the app** | Right-click the app → **Open** → click **Open** again |
| **Build fails (SwiftBridging)** | `sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install` |
| **Widget gone after restart** | Launch at Login is enabled by default. If you disabled it, re-enable via right-click → Settings |

---

## Roadmap

- [x] Keychain storage for session key — migrated from UserDefaults
- [x] Launch at Login — enabled by default via `SMAppService`, toggleable in Settings
- [x] In-app update notifications — blue dot indicator + one-click self-update via Settings
- [x] Compact mode — frameless ring, double-click or right-click to toggle
- [x] One-command installer + GitHub Releases distribution
- [ ] Optional usage history graph
- [ ] Signed / notarized build
- [x] Homebrew cask — `brew install --cask rishi-banerjee1/ai-tools/claude-usage-widget`

---

## Credits

Built by [@rishi-banerjee1](https://github.com/rishi-banerjee1).

## License

MIT
