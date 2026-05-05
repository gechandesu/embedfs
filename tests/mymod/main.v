module main

fn main() {
	json_file := unsafe { embed_files['assets/example.json'] }
	println(json_file.to_string().trim_space())
}
