parameter schedId is -1.

run once libSched.
run once libCtl.
run once libStat.

if schedId < 0 {
  set schedId to schedAdd("run execute($ID$).").
}

sas off.

lock steerTarget to nextNode:burnVector:direction.
lock burnTime to calcBurnTime().

local states is list(
  "done",
  "wait for manuever",
  "undefined",
  "burn manuever"
).

local state is 1.
statClear().
statAdd("step", { return states[state]. }).
statAdd("manuever in", { return statFormatTime(nextNode:eta - burnTime / 2). }).
statAdd("burn time", { return statFormatTime(burnTime). }).
statAdd("dv", { return round(nextNode:burnVector:mag, 1). }).
statAdd("steer error", { return round(vang(steerTarget:foreVector, facing:foreVector), 1). }).

lock steering to ctlSmoothRotate({return steerTarget. }).
local done is false.

until state = 0 {
  statRefresh().

  if state = 1 {
    if nextNode:eta - burnTime / 2 < 0 {
      logInfo(
        "burning manuever prog: " + round(nextNode:prograde, 1) +
        ", rad: " + round(nextNode:radialOut, 1) +
        ", norm: " + round(nextNode:normal, 1) +
        ", dv: " + round(nextNode:burnVector:mag, 1)
      ).

      set state to 2.
    }
  }
  if state = 2 {
    set done to ctlBurnNextManuever().
    set state to 3.
  }
  if state = 3 {
    if done() {
      set state to 0.
      unlock all.
      statClear().
    }
  }
  
  wait 0.1.
}

schedRemove(schedId).
remove nextNode.
sas on.
