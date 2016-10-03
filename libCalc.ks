function calcMod {
	parameter x, m.
	
	return round((x / m - floor(x / m)) * m).
}

function listMin {
  parameter l.

  local m is l[0].
  for val in l {
    set m to min(m, val).
  }
  return m.
}

function listMax {
  parameter l.

  local m is l[0].
  for val in l {
    set m to max(m, val).
  }
  return m.
}

function calcValueToInterval {
	parameter value, vMin, vMax, iMin is 0, iMax is 1.
	
	local dv is vMax - vMin.
	local di is iMax - iMin.
	
	return min(iMax, max(iMin, (value - vMin) / dv * di + iMin)).
}

function calcLimitThrustByDirection {
	parameter dir.
	
	return 1 - calcvalueToInterval(
		vang(dir():vector, ship:facing:vector),
		3, 5
	).
}

function calcLimitThrustForBurn {
  parameter vec.

	return min(
	  ship:mass * vec:mag / ship:maxThrust,
    calcLimitThrustByDirection({ return vec:direction. })
	).
}
function calcLimitThrustByQ {
	return calcValueToInterval(ship:q, 0.2, 0.19).
}

function calcGroundPrograde {
	return vcrs(ship:up:forevector, ship:retrograde:starvector):direction.
}

function calcGroundRetrograde {
	return vcrs(ship:retrograde:starvector, ship:up:forevector):direction.
}

function calcBurnTime {
	parameter dv is -1.

  if dv < 0 {
    if hasNode { set dv to nextNode:burnvector:mag. }
    else { set dv to 0. }
  }
  
	return dv * ship:mass / ship:availableThrust.
}
