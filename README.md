# OWA Dataset Visualizer

Browser-based visualization tool for exploring OWAMcap datasets with synchronized playback of screen recordings and interaction events.

<div align="center">
  <img src="https://github.com/open-world-agents/owa-dataset-visualizer/blob/main/.github/assets/viewer.png" alt="OWA Dataset Visualizer"/>
</div>

## 🌐 Public Hosted Viewer

**Quick Start**: [https://huggingface.co/spaces/open-world-agents/visualize_dataset](https://huggingface.co/spaces/open-world-agents/visualize_dataset)

Usage:

1. Visit the viewer URL
2. Either drag & drop local files, or enter a Hugging Face dataset ID
3. Explore your data with synchronized video and input overlays

## Features

- **Drag & Drop**: Load local `.mcap` + `.mkv` files directly in browser
- **Hugging Face Integration**: Browse and load datasets via `?repo_id=org/dataset`
- **Synchronized Playback**: Video synced with keyboard/mouse overlays
- **Large File Support**: Uses MCAP index for seeking, never loads entire file
- **Input Overlay**: Keyboard (all keys), mouse (L/R/M buttons, scroll), cursor minimap

## 🏠 Local Development

### Prerequisites

Install Node.js via [nvm](https://github.com/nvm-sh/nvm) (recommended):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts
```

### Run

```bash
git clone https://github.com/open-world-agents/owa-dataset-visualizer
cd owa-dataset-visualizer
npm install
npm run dev
```

Open http://localhost:5173

## 📂 Local File Server

For browsing multiple recordings from a local directory:

```bash
# Serve a directory containing mcap/video pairs
python scripts/serve_local.py /path/to/recordings -p 8080

# Open visualizer with local server
# http://localhost:5173/?base_url=http://localhost:8080
```

Features:

- Auto-scans for mcap/video pairs
- HTTP Range support for streaming large videos
- Multi-threaded for concurrent requests

## URL Modes

| URL                               | Description                         |
| --------------------------------- | ----------------------------------- |
| `/`                               | Landing page with featured datasets |
| `?repo_id=org/dataset`            | Load HuggingFace dataset            |
| `?base_url=http://localhost:8080` | Load from local file server         |
| `?mcap=url&mkv=url`               | Direct file URLs                    |

## Structure

```
src/
├── main.js      # Routing, landing page
├── viewer.js    # Viewer logic, render loop
├── hf.js        # HuggingFace API, file tree
├── state.js     # StateManager, message handlers
├── mcap.js      # MCAP loading, TimeSync
├── overlay.js   # Keyboard/mouse canvas drawing
├── ui.js        # Side panel, loading indicator
├── config.js    # Featured datasets
├── constants.js # VK codes, colors, flags
└── styles.css
```

## How Seeking Works

1. Find nearest `keyboard/state` snapshot before target time
2. Replay `keyboard` events from snapshot to target
3. Find nearest `mouse/state` snapshot before target time
4. Replay mouse events from snapshot to target
5. Find latest `window` info

This enables O(snapshot interval) seek instead of O(file size).
