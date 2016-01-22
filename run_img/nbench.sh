#!/bin/sh

export_top_env()
{
	export testcase='nbench'
	export category='benchmark'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup $LKP_SRC/setup/nr_threads '200%'

	run_setup $LKP_SRC/setup/iterations '5x'

	nbench()
	{
		export duration='10s'
	}
	nbench &

	wait
}

extract_stats()
{
	$LKP_SRC/stats/wrapper time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper last_state
}

"$@"
