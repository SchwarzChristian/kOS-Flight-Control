local schedFile is "schedule.data".
local schedule is list().

if exists(schedFile) {
  set schedule to readJson(schedFile).
}

function schedAdd {
  parameter time, cmd.

  schedule:add(list(time, cmd)).
  writeJson(schedFile, schedule).
}

function schedTable {
  return schedule.
}

