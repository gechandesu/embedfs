module main

import os
import v.util.diff
import embedfs

fn test_mymod() {
	oldpwd := os.getwd()
	expected_out := os.read_file('tests/mymod_test.out')!
	os.chdir('tests/mymod')!
	gen := embedfs.CodeGenerator{
		path: 'assets'
	}
	os.write_file('assets_generated.v', gen.generate())!
	ret := os.execute('${os.quoted_path(@VEXE)} run .')
	dump(diff.compare_text(ret.output, expected_out)!)
	assert ret.output == expected_out
	os.chdir(oldpwd)!
}

fn test_mymod_bare_map() {
	oldpwd := os.getwd()
	expected_out := os.read_file('tests/mymod_test_bare_map.out')!
	os.chdir('tests/mymod')!
	gen := embedfs.CodeGenerator{
		path:     'assets'
		bare_map: true
	}
	os.write_file('assets_generated.v', gen.generate())!
	ret := os.execute('${os.quoted_path(@VEXE)} -d bare_map run .')
	dump(diff.compare_text(ret.output, expected_out)!)
	assert ret.output == expected_out
	os.chdir(oldpwd)!
}
