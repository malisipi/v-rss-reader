module main

import vxml

fn get_title_from_item(item &vxml.Node) ?string {
	link_el := item.get_element_by_tag_name('title') or { return none }

	return get_text_or_cdata(link_el)
}

fn get_link_from_item(item &vxml.Node) ?string {
	link_el := item.get_element_by_tag_name('link') or { return none }

	return get_text_or_cdata(link_el)
}

fn get_description_from_item(item &vxml.Node) string {
	description_el := item.get_element_by_tag_name('description') or { return '' }

	return get_text_or_cdata(description_el)
}

fn get_text_or_cdata(item &vxml.Node) string {
	content := if item.get_text() != '' {
		item.get_text()
	} else {
		item.get_cdata()
	}

	return content.trim_space()
}
