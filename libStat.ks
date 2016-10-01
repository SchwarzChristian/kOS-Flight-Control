run once libCalc.
run once libSched.
run once libCalc.

parameter wCaption is 20, wValue is 20.

local fields is list().
local hRule is "+-" + fill(wCaption, "-") + "-+-" + fill(wValue, "-") + "-+".

function statClean {
	set fields to list().
	clearscreen.
}

function statAdd {
	parameter caption, value.
	
  if caption:length > wCaption {
    set caption to caption:substring(0, wCaption - 3) + "...".
  }

  if ("" + value):length > wValue {
    set value to ("" + value):substring(0, wValue - 3) + "...".
  }
	fields:add(list(caption, value)).
}

function statRefresh {
	clearscreen.
	print hRule.
	for field in fields {
		local caption is field[0] + fill(wCaption - field[0]:length, " ").
		local value is field[1]().
		set value to value + fill(wValue - value:length, " ").
		
		print "| " + caption + " | " + value + " |".
		print hRule.
	}
}

function statTime {
	parameter s, m is 0, h is 0, d is 0, y is 0.
	
	local t is y.
	set t to t * 426 + d.
	set t to t * 6 + h.
	set t to t * 60 + m.
	return t * 60 + s.
}

function statFormatTime {
	parameter t.
	
	local ret is calcMod(t, 60) + "s".
	set t to floor(t / 60).
	if t <= 0 { return ret. }

	set ret to calcMod(t, 60) + "m " + ret.
	set t to floor(t / 60).
	if t <= 0 { return ret. }
	
	set ret to calcMod(t, 6) + "h " + ret.
	set t to floor(t / 6).
	if t <= 0 { return ret. }
	
	set ret to calcMod(t, 426) + "d " + ret.
	set t to floor(t / 426).
	if t <= 0 { return ret. }
	
	return t + "y " + ret.
}

function statFuel {
	local fuel is 0.
	
	for res in ship:resources {
		if res:name = "LiquidFuel" or res:name = "Oxidizer" {
			set fuel to fuel + 0.005 * res:amount.
		}
	}
	
	return fuel.
}

function statAvgIsp {
	local isp is 0.
	local ens is 0.

	list engines in enList.

	for en in enList {
		set isp to isp + en:ispAt(0) * 9.81.
		set ens to ens + 1.
	}

	return isp / ens.
}

function statDVInStage {
	local fuel is statFuel.
	return fuel * statAvgIsp() / (ship:mass - fuel / 2).
}

function statAddSchedule {
  for cmd in schedTable() {
    statAdd(cmd[1], calcFormatTime(cmd[0])).
  }
}

local function fill {
	parameter w, c.
	
	local s is "".
	from { local i is 1. } until i > w step { set i to i + 1. } do {
		set s to s + c.
	}
	return s.
}
