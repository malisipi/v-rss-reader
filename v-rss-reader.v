module main

import ui
import gx
import net.http
import vxml

const (
	window_width  = 800
	window_height = 600
)

[heap]
struct App {
mut:
	window &ui.Window
}

fn main() {
	mut app := &App{
		window: 0
	}

	app.window = ui.window(
		width: window_width
		height: window_height
		title: 'RSS Reader'
		mode: .resizable
		children: [
			ui.column(
				spacing: 5
				margin_: 5
				children: [
					ui.textbox(
						id: 'textbox_url'
						placeholder: 'RSS URL'
					),
					ui.button(
						text: 'Load'
						radius: 0
						border_color: gx.gray
						bg_color: gx.light_gray
						on_click: app.on_add_url
					),
					ui.listbox(
						id: 'listbox_titles'
						selection: 0
						height: 400
					),
				]
			),
		]
	)

	ui.run(app.window)
}

fn (mut app App) on_add_url(_ &ui.Button) {
	mut list_widget := app.window.listbox('listbox_titles')
	url_widget := app.window.textbox('textbox_url')

	response := http.fetch(url: url_widget.text) or {
		ui.message_box(err.msg())

		return
	}

	if response.status_code != 200 {
		ui.message_box(response.status_msg)
	}

	root := vxml.parse(response.body)
	items := root.get_elements_by_tag_name('title')

	for index, item in items {
		title := item.get_cdata().trim_space()

		if title.len > 0 {
			list_widget.add_item(index.str(), item.get_cdata())
		}
	}
}
