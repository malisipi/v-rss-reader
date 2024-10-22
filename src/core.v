module main

import vxml
import time
import net.http

fn fetch(url string) !string {
	response := http.fetch(url: url)!

	if response.status_code != 200 {
		return error(response.status_msg)
	}

	return response.body
}

struct RSSItem {
	url         string
	title       string
	description string
	author      string
	pub_date    time.Time
}

fn (r &RSSItem) preview() string {
	title := if r.title != '' { r.title } else { '...' }
	description := if r.description != '' { r.description } else { '...' }

	return '${title}\n\n${description}'
}

fn fetch_and_parse(url string) !vxml.Node {
	content := fetch(url)!

	return vxml.parse(content)
}

fn fetch_and_parse_with_chans(result_chan chan vxml.Node, error_chan chan IError, url string) {
	result := fetch_and_parse(url) or {
		error_chan <- err

		return
	}

	result_chan <- result
}
