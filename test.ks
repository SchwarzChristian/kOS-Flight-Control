run once libStat.

statAdd("test", { return 23. }).
statAdd("more testing", { return statFormatTime(time:seconds). }).

until false {
	statRefresh().
	wait 1.
}
