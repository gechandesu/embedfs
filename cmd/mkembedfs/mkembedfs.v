module main

import os
import flag
import embedfs

fn main() {
	mut path := os.getwd()
	mut flags, no_matches := flag.to_struct[FlagConfig](os.args, skip: 1, style: .v) or {
		eprintln('cmdline parsing error, see -help for info')
		exit(2)
	}
	if no_matches.len > 1 {
		eprintln('unrecognized arguments: ${no_matches[1..]}')
		exit(2)
	} else if no_matches.len == 1 {
		path = no_matches[0]
	}
	if flags.help {
		println($embed_file('help.txt').to_string().trim_space())
		exit(0)
	}
	if flags.chdir != '' {
		os.chdir(flags.chdir) or {
			eprintln(err)
			exit(1)
		}
	}
	generator := embedfs.CodeGenerator{
		path:            path
		prefix:          flags.prefix
		ignore_patterns: flags.ignore
		module_name:     flags.module_name
		const_name:      flags.const_name
		make_pub:        if flags.no_pub { false } else { true }
		force_mimetype:  flags.force_mimetype
	}
	println(generator.generate())
}

struct FlagConfig {
	help           bool
	chdir          string
	prefix         string
	ignore         []string
	module_name    string = 'main'
	const_name     string = 'embedfs'
	no_pub         bool
	force_mimetype bool
}
