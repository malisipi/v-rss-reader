module main

import json
import os

fn read_config(path string) ![]string {
	config_content := os.read_file(path)!

	return json.decode([]string, config_content)!
}

fn write_config(path string, urls []string) ! {
	encoded := json.encode(urls)

	os.write_file(path, encoded)!
}
