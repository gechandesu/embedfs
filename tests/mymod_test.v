module main

import os
import v.util.diff
import embedfs

fn test_mymod() {
	oldpwd := os.getwd()
	expected_out := os.read_file('tests/mymod_test.out')!
	os.chdir('tests/mymod')!
	gen := embedfs.generate('assets')!
	os.write_file('assets_generated.v', gen)!
	ret := os.execute('${os.quoted_path(@VEXE)} run .')
	dump(diff.compare_text(ret.output, expected_out)!)
	assert ret.output == expected_out
	os.chdir(oldpwd)!
}
