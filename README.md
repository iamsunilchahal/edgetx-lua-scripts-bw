# EdgeTX Lua Scripts (B/W Screen Optimized)

A growing collection of **EdgeTX Lua scripts** for Radiomaster, Jumper, and other OpenTX/EdgeTX radios.  
All scripts here are **optimized for black-and-white displays** like the Radiomaster Boxer’s 128×64 screen.

## 📂 Repository Structure

SCRIPTS/  
├── TOOLS/        # Tools accessible via the SYS → Tools menu  
├── MIXES/        # Model-specific scripts  
└── TELEMETRY/    # Telemetry screen scripts  

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

### 2. [FieldNotes.lua](SCRIPTS/TOOLS/FieldNotes.lua)
**Type:** Tool (`/SCRIPTS/TOOLS/`)  
**Purpose:**  
A **quick logging tool** for recording flight details directly from your radio.  
Perfect for keeping track of pack health, prop condition, and flight notes between packs.  
- Single-page list of editable fields (scroll & press-to-edit)  
- Saves timestamped entries to `/LOGS/fieldnotes.txt`  
- Exits automatically after saving  

**Logged fields:**
- Pack number & condition  
- Prop type & condition  
- Flight notes/tags  

**Installation:**
1. Copy `FieldNotes.lua` into `/SCRIPTS/TOOLS/` on your SD card.
2. On your radio:  
   - Long-press `SYS` → **Tools** tab → run **Field Notes**
3. After editing, select **[ Save ]** at the bottom to store your entry.

**Example log file:**
