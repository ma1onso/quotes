/*
* Copyright (c) 2017 APP Developers (http://github.com/alons45/quotes)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Author <alons45@gmail.com>
*/

using Quotes.Configs;
using Quotes.Widgets;
using Quotes.Utils;


namespace Quotes {

	public class MainWindow : Gtk.ApplicationWindow {

		private bool searching = false;
		private Gdk.Display display;

		public QuoteClient quote_client;
		public QuoteStack quote_stack;
		public HeaderBar headerbar;

		public signal void search_begin ();
		public signal void search_end (Json.Object? url, Error? e);

		public MainWindow (Application application) {
			Object (
				application: application,
				title: Properties.TITLE_HEADER_BAR,
				default_width: 800,
				default_height: 600
			);

			this.set_border_width (12);
			this.set_position (Gtk.WindowPosition.CENTER);

			this.connect_signals ();
			this.initialize_gdk_vars ();

			this.quote_client = new QuoteClient (this);

			this.quote_stack = new QuoteStack ();
			this.quote_stack.set_clipboard (this.display);

			this.headerbar = new HeaderBar ();
			this.set_titlebar (this.headerbar);
			this.headerbar.button_events (this);
			this.headerbar.social_network_events (this);

			this.add(this.quote_stack);

			this.style_provider ();

			this.show_all ();

			// First api call
			this.quote_client.quote_query.begin ();
		}

		private void initialize_gdk_vars () {
			this.display = this.get_display ();
		}

		private void style_provider () {
			Gtk.CssProvider css_provider = new Gtk.CssProvider ();
			css_provider.load_from_resource ("com/github/ma1onso/quotes/Application.css");
			Gtk.StyleContext.add_provider_for_screen (
				Gdk.Screen.get_default (),
				css_provider,
				Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
			);
		}

		protected void on_search_begin () {
			this.headerbar.refresh_tool_button.sensitive = false;
			this.headerbar.copy_to_clipboard_button.sensitive = false;

			if (!this.quote_stack.visible) {
				this.quote_stack.set_visible (true);
			}
			this.quote_stack.set_visible_child_name ("spinner");
			this.quote_stack.spinner.start ();
			this.searching = true;
		}

		protected void on_search_end (Json.Object? quote, Error? error) {
			this.headerbar.refresh_tool_button.sensitive = true;
			this.headerbar.copy_to_clipboard_button.sensitive = true;
			this.searching = false;

			if (error != null) {
				return;
			}

			this.quote_stack.set_quote_text (quote.get_string_member ("quoteText"));
			this.quote_stack.set_quote_author (quote.get_string_member ("quoteAuthor"));
			this.quote_stack.set_quote_url (quote.get_string_member ("quoteLink"));

			this.quote_stack.set_visible_child_name ("quote_overlay");
		}

		private void connect_signals () {
			this.search_begin.connect (this.on_search_begin);
			this.search_end.connect (this.on_search_end);
		}

	}

}
