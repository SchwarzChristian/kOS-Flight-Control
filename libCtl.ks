run once libCalc.
run once libStat.

local autoStage is false.
local stageDelay is 1.

when autoStage and ship:availableThrust <= 0 then {
  stage.
  wait stageDelay.
  preserve.
}

function ctlAutoStage {
  parameter value, delay is stageDelay.

  set stageDelay to delay.
  set autostage to value.
}

function ctlSteerNextManuever {
	set s to "asd".
  lock steering to ctlSmoothRotate({ return nextNode:burnvector:direction. }).
}

function ctlBurnNextManuever {
  parameter tolerance is 0.1.
  lock steering to ctlSmoothRotate({ return nextNode:burnVector:direction. }).
  lock burnTime to calcBurnTime().
  
	lock throttle to calcLimitThrustForBurn(nextNode:burnVector).
	return {
    local done is hasNode and (
      vang(nextNode:burnVector, ship:facing:vector) > 90 or
      nextNode:burnVector:mag < tolerance
    ).
    if done { unlock throttle. }
    return done.
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

function ctlIntercept {
  parameter distance is 0, isBody is false.

  if isBody {
    
  }
  
  local sma_transfer is (
    altMean(target) - distance +
    altMean(ship)
  ) / 2 + ship:body:radius.
  
  local t_transfer is sqrt(4 * constant:pi^2 * sma_transfer^3 / ship:body:mu) / 2.

  local w_t is _w(target).
  local w_s is _w(ship).
  local a_st is target:longitude - ship:longitude.
  until a_st > 180 - w_t * t_transfer { set a_st to a_st + 360. }

  local t_man is (a_st - 180 + w_t * t_transfer) / (w_s - w_t).

  ctlHomannTransfer(altMean(target) - distance, t_man).
}

local function altMean {
  parameter trg.
  return (trg:apoapsis + trg:periapsis) / 2.
}

local function _w {
  parameter trg.

  local r_mean is altMean(trg) + ship:body:radius.
  local v_mean is sqrt(ship:body:mu / r_mean).
  return 180 * v_mean / (constant:pi * r_mean).
}

function ctlHomannTransfer {
	parameter alti is -1, t is -1.

  if t < 0 {
    if eta:apoapsis <= 0 { set t to periapsis. }
    else { set t to min(eta:apoapsis, eta:periapsis). }
  }
  
	local manuever is node(time:seconds + t, 0, 0, 0).
  local r is (positionAt(ship, time:seconds + t) - ship:body:position):mag.

  if alti < 0 { set alti to r. }
  else { set alti to alti + ship:body:radius. }
  
  local targetSma is (r + alti) / 2.
  local sma is ship:orbit:semiMajorAxis.
  local mu is ship:body:mu.
  
  // see vis-viva-equation
  local v is sqrt(mu * (2 / r - 1 / sma)).
  local v_t is sqrt(mu * (2 / r - 1 / targetSma)).
  
	add manuever.
  set manuever:prograde to v_t - v.
}

function logError {
  parameter msg.
  writeLog("ERROR", msg).
}

function logWarn {
  parameter msg.
  writeLog("WARNING", msg).
}

function logInfo {
  parameter msg.
  writeLog("INFO", msg).
}

function logDebug {
  parameter msg.
  writeLog("DEBUG", msg).
}

local function writeLog {
  parameter severity, msg.
  log statFormatTime(time:seconds) + " - " + severity + ": " + msg to "0:log".
}
