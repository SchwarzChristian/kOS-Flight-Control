parameter targetAlt is 100000.

run once libCtl.
run once libStat.
run once libCalc.

local step is 1.
local stepNames is list(
  "done",
  "waiting for take off",
  "error",
  "ascending"
).

lock steerTarget to facing.
lock steering to ctlSmoothRotate({ return steerTarget. }).

statClear().
statAdd("step", { return stepNames[step]. }).
statAdd("apoapsis", { return round(apoapsis). }).
statAdd("periapsis", { return round(periapsis). }).
statAdd("pressure", { return round(ship:q * 100, 1). }).
statAdd("steer error", { return round(vang(facing:foreVector, steerTarget:foreVector), 1). }).

until step = 0 {
  sas off.
  statRefresh().

  if step = 1 {
    if ship:maxThrust > 0 { set step to 2. }
  }
  if step = 2 {
    ctlAutoStage(true).
    lock steerTarget to heading(90, calcValueToInterval(2 * altitude / targetAlt, 1, 0, 0, 90)).
    lock throttle to listMin(list(
      calcValueToInterval(apoapsis, 1.1 * targetAlt, 0.9 * targetAlt),
      calcLimitThrustByQ(),
      targetAlt - apoapsis
    )).
    set step to 3.
  }
  if step = 3 {
    if apoapsis > targetAlt and ship:q <= 0 {
      ctlAutoStage(false).
      ctlHomannTransfer().
      set step to 0.
    }
  }

  wait 0.1.
}

schedAddManuever().
