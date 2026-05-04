# mpv-accessibility

An accessible enhancement suite for the **mpv** media player, designed specifically for screen reader users (e.g., NVDA). This project bridges the gap between high-performance video playback and seamless assistive technology integration.

---

## 🚀 Features

* **Screen Reader Integration**: Direct communication with NVDA via high-speed DLL binding (FFI).

* **Intelligent Announcement**: 

* **Progress Reporting**: Press `o` to hear the current timestamp, total duration, and percentage.

* **Playback Status**: Real-time feedback for Play/Pause, Mute, Volume, and Speed changes.

* **Dynamic Properties**: Automatically announces changes to subtitles, fullscreen mode, looping, and more.

* **Accessible Playlist**: A dedicated mode (triggered by `F8`) that allows navigating the playlist using `j`/`k` keys with full speech feedback.

* **Subtitle Speech**: Optional support for reading text-based subtitles aloud.

* **Anti-Flood Logic**: Built-in "freeze" mechanism to prevent audio overlapping during rapid events (like file switching).

---

## 🛠 Installation

To install, you need to clone this repository directly into your mpv configuration directory.

1. **Navigate to your mpv scripts folder**:

* **Windows (Portable)**: `path_to_mpv/portable_config/scripts/`

* **Windows (Standard)**: `%APPDATA%/mpv/scripts/`

2. **Clone the repository**:

Open a terminal in that folder and run:

```powershell
git clone https://github.com/w-sx/mpv-accessibility.git
```

*(Note: Ensure the files are placed directly in the scripts folder or a subfolder that mpv can auto-load.)*

3. **NVDA Controller DLL**:

This repository includes the `nvdaControllerClient.dll`. Ensure it remains in the same directory as the scripts so the FFI module can locate it automatically.

Make sure the included nvdaControllerClient.dll matches your mpv architecture (64-bit is included by default).

---

## ⌨️ Key Bindings

| Key | Action |
| :--- | :--- |
| **`o`** | Report playback progress (Time / Duration / %) |
| **`F8`** | Toggle Accessible Playlist Mode |
| **`?`** | Toggle Accessible Keylist Mode |
| **`j` / `k`** | (In List Mode) Move selection Down / Up |
| **`h`** | (In Playlist Mode) Confirm and Play selection |
| **`Esc`** | Exit Playlist Mode |

---

## 🤝 Contributing

We are looking for help to make mpv the most accessible media player in the world! 

* **Testing**: Report issues if certain properties aren't being announced.

* **Drivers**: Help us implement drivers for other screen readers (e.g., JAWS, Narrator, ZDSR).

* **UI/UX**: Improve the logic for navigating complex menus or filters.

Feel free to open an **Issue** or submit a **Pull Request**.

---

## 📜 License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.  

See the `LICENSE` file for more details.

*Note: `nvdaControllerClient.dll` is property of NV Access and is redistributed here under their compatible terms for the purpose of enabling accessibility.*

---

*Developed with ❤️ for the global accessibility community.*
