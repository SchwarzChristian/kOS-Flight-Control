run once libCalc.
run once libSched.
run once libCalc.

parameter wCaption is 20, wValue is 20.

local fields is list().
local hRule is "+-" + fill(wCaption, "-") + "-+-" + fill(wValue, "-") + "-+".
local redrawFrame is true.

function statClear {
	set fields to list().
	clearscreen.
}

function statAdd {
	parameter caption, value.
	
	fields:add(list(caption, value)).
  set redrawFrame to true.
}

function statRefresh {
  if redrawFrame {
    clearscreen.
    print hRule.
	  for field in fields {
		  local caption is field[0].

      if caption:length > wCaption {
        set caption to caption:substring(0, wCaption - 3) + "...".
      }

		  print "| " + caption:padRight(wCaption) + " | " + "":padRight(wValue) + " |".
		  print hRule.
    }
    set redrawFrame to false.
  }
  
  local line is 1.
	for field in fields {
		local value is "" + field[1]().

    if ("" + value):length > wValue {
      set value to ("" + value):substring(0, wValue - 3) + "...".
    }
		
		print value:padRight(wValue) at (wCaption + 5, line).
    set line to line + 2.
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
  local ret is "".

  if t < 0 {
    set t to -t.
    set ret to "-".
  }
  
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
  local schedule is schedTable().
  for k in schedule:keys {
    local cmd is schedule[k].
    statAdd(k + ": " + cmd[1], { return statFormatTime(cmd[0] - time:seconds). }).
  }
  set redrawFrame to true.
}

function schedLength {
  return schedule:length.
}

local function fill {
	parameter w, c.
	
	local s is "".
	from { local i is 1. } until i > w step { set i to i + 1. } do {
		set s to s + c.
	}
	return s.
}
