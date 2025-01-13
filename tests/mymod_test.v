module main

import os
import v.util.diff
import embedfs

fn test_mymod() {
	expected_out := os.read_file('tests/mymod_test.out')!
	os.chdir('tests/mymod')!
	gen := embedfs.CodeGenerator{
		path:     'assets'
		make_pub: false
	}
	os.write_file('assets_generated.v', gen.generate())!
	ret := os.execute('${os.quoted_path(@VEXE)} run .')
	dump(diff.compare_text(ret.output, expected_out)!)
	assert ret.output == expected_out
}
