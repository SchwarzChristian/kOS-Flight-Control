function calcMod {
	parameter x, m.
	
	return round((x / m - floor(x / m)) * m).
}

function calcValueToInterval {
	parameter value, vMin, vMax, iMin is 0, iMax is 1.
	
	local dv is vMax - vMin.
	local di is iMax - iMin.
	
	return min(1, max(0, (value - vMin) / dv * di + iMin)).
}

function calcLimitThrustByDirection {
	parameter dir.
	
	return 1 - ctlvalueToInterval(
		vang(dir():vector, ship:facing:vector),
		3, 5
	).
}

function calcLimitThrustByQ {
	return 1 - ctlvalueToInterval(ship:q, 0.18, 0.2).
}

function calcGroundPrograde {
	return vcrs(ship:up:forevector, ship:retrograde:starvector):direction.
}

function calcGroundRetrograde {
	return vcrs(ship:retrograde:starvector, ship:up:forevector):direction.
}

function calcBurnTime {
	parameter dv.
	
	return dv * ship:mass / ship:availableThrust.
}
