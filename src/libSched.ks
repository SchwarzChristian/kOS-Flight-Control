local schedFile is "/schedule.data".
local doFile is "/sched.do".
local schedule is lexicon().

if exists(schedFile) {
  set schedule to readJson(schedFile).
}

function schedClear {
  set schedule to lexicon().
  write().
}

function schedAdd {
  parameter cmd, t is 0.

  local id is 0.
  until not schedule:hasKey(id) {
    set id to id + 1.
  }

  schedule:add(id, list(time:seconds + t, cmd:replace("$ID$", "" + id))).
  write().
  return id.
}

function schedAddManuever {
  schedAdd("run execute($ID$).", nextNode:eta - calcBurnTime() / 2 - 60).
}

function schedDo {
  local idx is -1.
  local ret is false.
  for k in schedule:keys {
    local cmd is schedule[k].
    if cmd[0] < time:seconds {
      set idx to k.
      deletepath(doFile).
      log cmd[1] to doFile.
      runPath(doFile).
      deletepath(doFile).
      break.
    }
  }
  if idx >= 0 {
    schedule:remove(idx).
    write().
    return true.
  }
  return false.
}

function schedRemove {
  parameter idx.

  if schedule:hasKey(idx) {
    schedule:remove(idx).
    write().
    return true.
  }
  return false.
}

function schedTable {
  return schedule.
}

local function write {
  writeJson(schedule, schedFile).
}
