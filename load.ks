local allFiles is list(
  "boot/init",
  "ascend",
  "cancel",
  "execute",
  "intercept",
  "land",
  "libCalc",
  "libCtl",
  "libSched",
  "libStat",
  "plan",
  "transfer"
).

local copyFiles is list(
  "boot/init",
  "ascend",
  "cancel",
  "execute",
  "intercept",
  "land",
  "libCalc",
  "libCtl",
  "libSched",
  "libStat",
  "plan",
  "transfer"
).

for filename in allFiles {
  local fullname is "1:" + filename + ".ks".
  if exists(fullname) {
    print "delete " + filename.
    deletepath(fullname).
  }
}

for filename in copyFiles {
  print "copy " + filename.
  copypath("0:" + filename + ".ks", "1:" + filename + ".ks").
}

switch to 1.
