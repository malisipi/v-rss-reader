module main

import ui
import vxml

[heap]
struct App {
mut:
	window &ui.Window
	urls   []string
}

fn (mut app App) on_add_url(_ &ui.Button) {
	mut list_widget := app.window.listbox('listbox_titles')
	url_widget := app.window.textbox('textbox_url')

	// TODO: validate url before saving
	app.add_url(url_widget.text)
	app.save_config() or {
		ui.message_box(err.str())

		return
	}

	result_chan := chan vxml.Node{}
	error_chan := chan IError{}

	for url in app.urls {
		spawn fetch_and_parse_with_chans(result_chan, error_chan, url)
	}

	for _ in 0 .. app.urls.len {
		select {
			result := <-result_chan {
				title_els := result
					.get_elements_by_tag_name('title')
					.filter(it.get_cdata().trim_space() != '')

				for index, item in title_els {
					title := item.get_cdata().trim_space()

					list_widget.add_item(index.str(), title)
				}
			}
			error := <-error_chan {
				ui.message_box(error.str())
			}
		}
	}
}

fn (mut app App) add_url(url string) {
	// TODO: duplicates
	app.urls << url
}

fn (app &App) save_config() ! {
	write_config(config_path, app.urls)!
}
