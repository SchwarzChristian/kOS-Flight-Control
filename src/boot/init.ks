if body = Kerbin and altitude < 100 {
	list processors in p.
	p[0]:doEvent("open terminal").
  switch to 0.
  run load.
	run ascend.
} else {
	wait 3.
	list processors in p.
	p[0]:doEvent("open terminal").
}

run once "libStat".
run once "libSched".

statAddSchedule().

until schedLength() <= 0 {
  statRefresh().
  if schedDo() {
    statAddSchedule().
    sas on.
  }
  wait 0.1.
}

statClear().
print "flight plan empty".
