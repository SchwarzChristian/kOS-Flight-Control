local schedFile is "schedule.data".
local schedule is list().

if exists(schedFile) {
  set schedule to jsonRead(schedFile).
}

function schedAdd {
  parameter time, cmd.

  schedule:add(list(time, cmd)).
  jsonWrite(schedFile, schedule).
}

function schedTable {
  return schedule.
}

