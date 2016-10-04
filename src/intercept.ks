parameter dist is 0, isBody is false.

run once libCtl.

until not hasNode {
  remove nextNode.
}

ctlIntercept(dist).

schedAddManuever().
schedDo().

