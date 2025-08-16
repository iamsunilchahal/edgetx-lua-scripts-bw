-- Field Notes (one-page, scroll + edit) – debounced save + exit on save
-- /SCRIPTS/TOOLS/fieldnotes.lua

-- -------- Event aliases (covering multiple EdgeTX builds) --------
local EVT_NEXT = EVT_VIRTUAL_NEXT or 0x0305
local EVT_PREV = EVT_VIRTUAL_PREV or 0x0304
local EVT_INC  = EVT_VIRTUAL_INC  or 0x0307
local EVT_DEC  = EVT_VIRTUAL_DEC  or 0x0306
local EVT_ENT  = EVT_ENTER_BREAK  or 0x0059
local EVT_EXT  = EVT_EXIT_BREAK   or 0x005B
local EVT_ROT_R = (rawget(_G,"EVT_ROT_RIGHT") and EVT_ROT_RIGHT) or 0x0101
local EVT_ROT_L = (rawget(_G,"EVT_ROT_LEFT")  and EVT_ROT_LEFT)  or 0x0100

-- -------------------- Model --------------------
local fields = {
  { key="Pack #",    type="number", val=1,  min=1,  max=99, step=1 },
  { key="Pack Cond", type="enum",   opts={"New","Good","Tired","Bad"}, idx=2 },
  { key="Prop",      type="enum",   opts={"5146","5040","6032","7035"}, idx=1 },
  { key="Prop Cond", type="enum",   opts={"New","Chipped","Damaged"},  idx=1 },
  { key="Note",      type="enum",   opts={"Smooth","Wobbly","Yaw drift","Crash","Fast","Tuned"}, idx=1 },
  { key="[ Save ]",  type="save" }
}

local sel = 1           -- focused row
local editing = false   -- edit mode flag

-- Scrolling window
local ROW_H = 9
local HEADER_Y = 2
local LIST_START_Y = 18
local VISIBLE_ROWS = 5
local top = 1           -- first visible row

-- Debounce / exit flags
local lastEnterTick = 0
local shouldExit = false
local DEBOUNCE_TICKS = 18  -- ~180ms (getTime() is 10ms ticks)

-- -------------------- Helpers --------------------
local function clamp(v, a, b) if v<a then return a elseif v>b then return b else return v end end

local function fmtRow(i)
  local f = fields[i]
  if f.type == "number" then
    return string.format("%s: %d", f.key, f.val)
  elseif f.type == "enum" then
    return string.format("%s: %s", f.key, f.opts[f.idx])
  else
    return f.key
  end
end

local function ensureVisible()
  if sel < top then
    top = sel
  elseif sel > top + VISIBLE_ROWS - 1 then
    top = sel - (VISIBLE_ROWS - 1)
  end
  if top < 1 then top = 1 end
  local maxTop = math.max(1, #fields - VISIBLE_ROWS + 1)
  if top > maxTop then top = maxTop end
end

local function draw()
  lcd.clear()
  lcd.drawText(2,HEADER_Y,"FIELD NOTES", MIDSIZE)
  local y = LIST_START_Y
  local last = math.min(#fields, top + VISIBLE_ROWS - 1)
  for i = top, last do
    local line = fmtRow(i)
    if i == sel then
      lcd.drawText(2,y, line .. (editing and "  <edit>" or ""), INVERS)
    else
      lcd.drawText(2,y, line, 0)
    end
    y = y + ROW_H
  end
  -- tiny scroll markers
  if top > 1 then lcd.drawText(120, LIST_START_Y-8, "^", 0) end
  if last < #fields then lcd.drawText(120, LIST_START_Y + VISIBLE_ROWS*ROW_H - 1, "v", 0) end
end

local function saveLog()
  local packNum, packCond, prop, propCond, note = 1,"?","?","?","?"
  for _,f in ipairs(fields) do
    if f.key=="Pack #"    then packNum = f.val end
    if f.key=="Pack Cond" then packCond = f.opts[f.idx] end
    if f.key=="Prop"      then prop = f.opts[f.idx] end
    if f.key=="Prop Cond" then propCond = f.opts[f.idx] end
    if f.key=="Note"      then note = f.opts[f.idx] end
  end

  local dt = getDateTime()
  local date = string.format("%04d-%02d-%02d", dt.year, dt.mon, dt.day)
  local time = string.format("%02d:%02d", dt.hour, dt.min)
  local line = string.format("%s %s | Pack: %d (%s) | Prop: %s (%s) | Note: %s\n",
                              date, time, packNum, packCond, prop, propCond, note)

  local f = io.open("/LOGS/fieldnotes.txt","a")
  if f then
    io.write(f, line)
    io.close(f)
    playTone(1200, 60, 0, 0)     -- success chirp
  else
    playTone(300, 200, 0, 0)     -- error tone
  end
end

local function changeValue(dir)
  local f = fields[sel]
  if not f then return end
  if f.type == "number" then
    local v = (f.val or 0) + (dir * (f.step or 1))
    f.val = clamp(v, f.min or -32768, f.max or 32767)
  elseif f.type == "enum" then
    local n = #f.opts
    local idx = (f.idx or 1) + dir
    while idx < 1 do idx = idx + n end
    while idx > n do idx = idx - n end
    f.idx = idx
  end
end

local function onEvent(event)
  -- Normalize wheel events
  if event == EVT_ROT_R then event = EVT_NEXT end
  if event == EVT_ROT_L then event = EVT_PREV end

  if event == EVT_EXT then
    if editing then editing = false end
    return
  end

  if event == EVT_ENT then
    -- Debounce ENTER to avoid multiple triggers
    local now = getTime()
    if now - lastEnterTick < DEBOUNCE_TICKS then return end
    lastEnterTick = now

    local f = fields[sel]
    if editing then
      editing = false
    else
      if f.type == "save" then
        saveLog()
        shouldExit = true      -- exit the tool after saving
      else
        editing = true
      end
    end
    return
  end

  if event == EVT_NEXT or event == EVT_INC then
    if editing then
      changeValue(1)
    else
      if sel < #fields then sel = sel + 1 end
      ensureVisible()
    end
  elseif event == EVT_PREV or event == EVT_DEC then
    if editing then
      changeValue(-1)
    else
      if sel > 1 then sel = sel - 1 end
      ensureVisible()
    end
  end
end

local function run(event)
  if shouldExit then return 1 end   -- close tool after save
  onEvent(event)
  draw()
  return 0
end

return { run=run }
