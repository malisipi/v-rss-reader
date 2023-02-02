module main

import net.html
import regex

fn convert_html_to_text(value string) string {
	document := html.parse(value)

	return document.get_root().text()
}

fn decode_html_char_codes(value string) string {
	mut codes_re := regex.regex_opt(r'&#(\d+);') or { panic(err) }

	return codes_re.replace_by_fn(value, html_char_code_replacer)
}

fn html_char_code_replacer(re regex.RE, in_txt string, _ int, _ int) string {
	code := re.get_group_by_id(in_txt, 0).int()

	return rune(code).str()
}
