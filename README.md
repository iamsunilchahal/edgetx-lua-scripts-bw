# EdgeTX Lua Scripts (B/W Screen Optimized)

A growing collection of **EdgeTX Lua scripts** for Radiomaster, Jumper, and other OpenTX/EdgeTX radios.  
All scripts here are **optimized for black-and-white displays** like the Radiomaster Boxer’s 128×64 screen.

## 📂 Repository Structure

SCRIPTS/
├── TOOLS/ # Tools accessible via the SYS → Tools menu
├── MIXES/ # Model-specific scripts
└── TELEMETRY/ # Telemetry screen scripts


Copy the relevant folders directly to your radio’s **SD card root**.

---

## 📜 Available Scripts

### 1. [ELRS_Finder.lua](SCRIPTS/TOOLS/ELRS_Finder.lua)
**Type:** Tool (`/SCRIPTS/TOOLS/`)  
**Purpose:**  
An **RSSI-based quad finder** using ELRS/CRSF telemetry.  
- Shows live signal strength (dBm)  
- Displays a bar graph and numeric value  
- Plays faster beeps as you point toward the quad

**Installation:**
1. Copy `ELRS_Finder.lua` into `/SCRIPTS/TOOLS/` on your SD card.
2. On your radio:  
   - Long-press `SYS` → **Tools** tab → run **ELRS Finder**
3. For best results:  
   - Set **fixed low TX power** (10–25 mW) in ELRS menu  
   - Sweep the radio slowly to locate signal peaks

---

## 📥 Installation for All Scripts
1. Download this repository:
   - **Option A:** Click the green **Code** button → **Download ZIP**
   - **Option B:** Clone via Git (`git clone https://github.com/<your-username>/edgetx-lua-scripts-bw.git`)
2. Extract and copy the `SCRIPTS` folder to the root of your EdgeTX SD card.
3. Access scripts from:
   - **Tools menu** (for `/SCRIPTS/TOOLS/`)
   - **Model scripts** (for `/SCRIPTS/MIXES/`)
   - **Telemetry screens** (for `/SCRIPTS/TELEMETRY/`)

---

## 📄 License
This project is licensed under the [MIT License](LICENSE) — feel free to use, modify, and share, but please credit this repository.

---

✈️ **More scripts coming soon!** Stay tuned for new tools, telemetry screens, and helpers for your EdgeTX radio.
