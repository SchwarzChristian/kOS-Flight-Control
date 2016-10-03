run once libCtl.
run once libCalc.
run once libStat.

local stepNames is lexicon(
  2, "kill horizontal velocity",
  4, "waiting for final burn",
  5, "final burn",
  6, "waiting for touch down"
).
local step is 1.
local targetSpeed is -0.5.
local hFinalBurn is 0.
lock targetSteering to ship:facing.
lock steering to ctlSmoothRotate({ return targetSteering. }).

statClear().
statAdd("step", {
  if stepNames:hasKey(step) { return stepNames[step]. }
  return "error".
}).
statAdd("height", { return round(alt:radar). }).
statAdd("height final burn", { return round(hFinalBurn). }).
statAdd("h_speed", { return round(groundSpeed, 1). }).
statAdd("v_speed", { return round(-verticalSpeed, 1). }).
statAdd("steering error", { return round(vang(facing:forevector, targetSteering:forevector), 1). }).

until step = 0 {
  statRefresh().

  if step = 1 {
    sas off.
    lock targetSteering to calcGroundRetrograde().
    lock throttle to calcLimitThrustForBurn(targetSteering:foreVector * groundSpeed).
    set step to 2.
  }
  if step = 2 {
    if groundSpeed < 3 { set step to 3. }
  }
  if step = 3 {
    lock throttle to 0.
    lock targetSteering to srfRetrograde.
    set step to 4.
  }
  local F_g is body:mu / (body:radius + altitude - alt:radar)^2.
  set hFinalBurn to 1.1 * mass * verticalSpeed^2 / 2 / (maxThrust - F_g).
  
  if step = 4 {
    if alt:radar < hFinalBurn {
      lock throttle to 1.
      set step to 5.
    }
  }
  if step = 5 {
    if verticalSpeed > targetSpeed {
      lock targetSteering to heading(0, 90).
      lock throttle to calcValueToInterval(verticalSpeed, targetSpeed, 2 * targetSpeed).
      set step to 6.
    }
  }
  if step = 6 {
    if ship:status = "LANDED" {
      sas on.
      statClear().
      set sasmode to "RADIALOUT".
      set step to 0.
    }
  }
}
