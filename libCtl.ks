function ctlSteerNextManuever {
	set s to "asd".
  lock steering to ctlSmoothRotate({ return nextNode:burnvector:direction. }).
}

function ctlBurnNextManuever {
	parameter tolerance is 0.2.
  
  lock burnTime to ctlBurnTime(nextNode).
  
	lock throttle to min(
	  ship:mass * nextNode:burnVector:mag) / ship:maxThrust, 
	  ctlLimitThrustByDirection({ return nextNode:burnVector:direction. })
	).
	return { 
    return
    nextNode:burnVector:mag < tolerance or
    vang(nextNode:burnVector, ship:facing:vector) > 90.
  }.
}

function ctlTriggerEvent {
	parameter parts, event.
	
	for part in parts {
		for modname in part:modules {
			local mod is part:getModule(modname).
			for ev in mod:allEventNames {
				if ev = event {
					mod:doEvent(event).
	      }
      }
    }
  }
}

function ctlSmoothRotate {
	parameter getDir.
	
	local dir is getDir().
	local spd is max(ship:angularmomentum:mag/10,3).
	local curf is facing:forevector.
	local curr is facing:topvector.
	local rotr is r(0,0,0).
	if vang(dir:forevector,curf) < 90.
	set rotr to angleaxis(min(0.5,vang(dir:topvector,curr)/spd),vcrs(curr,dir:topvector)).
	local ret is lookdirup(angleaxis(min(2,vang(dir:forevector,curf)/spd),vcrs(curf,dir:forevector))*curf,rotr*curr).
	return ret.
}

function ctlCircularizeAtApoapsis {
	ctlChangePeriapsis(apoapsis - 1, { return eta:apoapsis. }).
}

function ctlCircularizeAtPeriapsis {
	ctlChangePeriapsis(periapsis + 1, { return eta:periapsis. }).
}

function ctlAddChangeApoapsisManuever {
	parameter alti.
	parameter timeToMan is { return min(eta:apoapsis, eta:periapsis). }.
	
	local dir is 1.
	local manuever is node(0, 0, 0, 0).
	add manuever.
	
	if alti < apoapsis {
    set dir to -1.
  }
	
	until dir * manuever:orbit:apoapsis >= dir * alti {
		set manuever:prograde to manuever:prograde + dir * 100.
		set manuever:eta to timeToMan().
  }

  until dir * manuever:orbit:apoapsis < dir * alti {
	  set manuever:prograde to manuever:prograde - dir.
	  set manuever:eta to timeToMan().
  }
}
