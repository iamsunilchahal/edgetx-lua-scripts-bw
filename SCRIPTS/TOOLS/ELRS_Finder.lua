-- finder.lua  (EdgeTX/Boxer B/W friendly)
-- ELRS/CRSF RSSI-based lost model finder (Geiger style)
local lastBeep = 0
local avg = -120
local have = { rssi=false, snr=false, rql=false }

--Optimization - Accessing these fields later with id removes the internal need for lookup
local rssi_id = getFieldInfo("1RSS").id
local batt_id = getFieldInfo("RxBt").id


local function readSignal()
  local rssi = getValue(rssi_id)  -- typically negative dBm, eg -95..-40
  if rssi and rssi ~= 0 then have.rssi=true; return rssi, "dBm" end
  return -120, "NA"
end

local function readBattery()
	local battery = getValue(batt_id)
	if battery then return battery else return 0 end
end

local function clamp(x,a,b) if x<a then return a elseif x>b then return b else return x end end

local function run_func(event)
  local now = getTime() -- 10ms ticks
  local raw, kind = readSignal()
  -- Exponential moving average for stability
  avg = 0.7*avg + 0.3*(raw)

  -- Map avg (~-110..-30) to 0..100 “strength”
  local strength = clamp( (avg + 110) * 1.25, 0, 100 )  -- -110→0, -30→100

  -- Beep cadence: stronger ⇒ shorter interval
  local period = clamp( 110 - strength, 10, 110 )  -- ticks (10ms each): 120→1.2s, 10→0.1s
  if now - lastBeep >= period then
    playTone(600 + (strength*6), 30, 0, 0)
    lastBeep = now
  end

  -- UI
  lcd.clear()
  lcd.drawText(2,2,"ELRS Finder", MIDSIZE)
  lcd.drawText(2,18,string.format("Src: %s", kind), 0)
  lcd.drawText(60,18,string.format("Raw: %d", raw) .. kind, 0)
  lcd.drawRectangle(2,29,125,12)
  lcd.drawFilledRectangle(3,30,math.floor(strength*1.23),10, 0)
  lcd.drawText(2,44,string.format("Battery: %.2fV", readBattery()),0)
  lcd.drawText(2,54,string.format("Transmit Pwr: %dmW", getValue("TPWR")),0)
  return 0
end

return { run=run_func }
