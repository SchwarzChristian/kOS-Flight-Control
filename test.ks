run once libStat.
run once libSched.

parameter doit is false.

if doit {
  clearscreen.
  print done.
  wait 5.
}
else {
  schedAdd("run test(true).", statTime(60)).
  statAddSchedule().
  until false {
    statRefresh().
    wait 0.2.
  }
}

