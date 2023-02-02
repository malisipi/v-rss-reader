module main

import net.html

fn convert_html_to_text(value string) string {
	document := html.parse(value)

	return document.get_root().text()
}
