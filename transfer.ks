parameter alti is -1, t is -1.

run once libCtl.
run once libSched.

if t = "apoapsis" {
  set t to eta:apoapsis.
}
else if t = "periapsis" {
  set t to eta:periapsis.
}

until not hasNode {
  remove nextNode.
  wait 1.
}

ctlHomannTransfer(alti, t).

schedAddManuever().
schedDo().
