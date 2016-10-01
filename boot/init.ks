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

clearscreen.

if exists("1:/todo") {
	print "running todo...".
	runpath("1:/todo").
	deletepath("1:/todo").
} else {
	print "nothing to do".
}
