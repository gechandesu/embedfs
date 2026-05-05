module main

import os
import embedfs

fn test_mymod() {
	oldpwd := os.getwd()
	expected := '{"some": "JSON data"}\n'
	os.chdir('tests/mymod')!
	gen := embedfs.generate('assets')!
	os.write_file('assets_generated.v', gen)!
	ret := os.execute('${os.quoted_path(@VEXE)} run .')
	assert ret.output == expected
	os.chdir(oldpwd)!
}
