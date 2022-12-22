module main

import ui
import gx

const (
	config_path   = './config.json'
	window_width  = 800
	window_height = 600
	window_title  = 'RSS Reader'
)

fn main() {
	mut app := &App{
		window: 0
		urls: read_config(config_path) or { panic(err.str()) }
	}

	app.window = ui.window(
		width: window_width
		height: window_height
		title: window_title
		mode: .resizable
		on_init: app.on_init
		children: [
			ui.column(
				spacing: 5
				margin_: 5
				stretch: true
				children: [
					ui.textbox(
						id: 'textbox_url'
						placeholder: 'RSS URL'
					),
					ui.button(
						text: 'Add and reload'
						radius: 0
						border_color: gx.gray
						bg_color: gx.light_gray
						on_click: app.on_add_url
					),
					ui.listbox(
						id: 'listbox_titles'
						selection: 0
						height: 500
						on_change: app.on_change
					),
				]
			),
		]
	)

	ui.run(app.window)
}
