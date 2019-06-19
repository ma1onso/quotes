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

namespace Quotes.Widgets {

	public class QuoteStack : Gtk.Stack {

		protected Gtk.Overlay quote_overlay;

		public Granite.Widgets.Toast copied_toast;
		public Gtk.Label quote_text;
		public Gtk.Label quote_author;
		public Gtk.LinkButton quote_url;
		public Gtk.Spinner spinner;
		public Gtk.Box quote_box;
		public Gtk.Clipboard clipboard;

		public QuoteStack () {
			this.set_visible (false);

			this.quote_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
			this.quote_box.set_spacing (10);

			this.copied_toast = new Granite.Widgets.Toast (_("Copied to clipboard!"));

			this.quote_text = new Gtk.Label ("...");
			this.quote_text.set_selectable (true);
			this.quote_text.set_line_wrap (true);
			this.quote_text.set_justify (Gtk.Justification.CENTER);
			this.quote_text.get_style_context ().add_class ("quote-text");

			this.quote_author = new Gtk.Label ("...");
			this.quote_author.set_selectable (true);
			this.quote_author.get_style_context ().add_class ("quote-author");

			this.quote_url = new Gtk.LinkButton.with_label ("", "Link to quote");
			this.quote_url.get_style_context ().add_class ("quote-url");
			this.quote_url.halign = Gtk.Align.CENTER;
			this.quote_url.valign = Gtk.Align.CENTER;

			this.spinner = new Gtk.Spinner ();
			this.spinner.halign = Gtk.Align.CENTER;

			// Add widgets to Quote Box
			quote_box.pack_start (this.quote_text);
			quote_box.pack_start (this.quote_author);
			quote_box.pack_start (this.quote_url);

			this.quote_overlay = new Gtk.Overlay ();
			this.quote_overlay.add_overlay (quote_box);
			this.quote_overlay.add_overlay (copied_toast);

			// Add widgets to Stack
			this.add_named (this.spinner, "spinner");
			this.add_named (this.quote_overlay, "quote_overlay");
		}

		public void set_clipboard (Gdk.Display display) {
			this.clipboard = Gtk.Clipboard.get_for_display (
				display, Gdk.SELECTION_CLIPBOARD
			);
		}

		public void set_quote_text (string quote_text) {
			// TODO: recovery quote_text.chomp () implementation when warning... runaway :D
			this.quote_text.set_text (
				"\"" + quote_text + "\""
			);
		}

		public void set_quote_author (string author) {
			if (author != "") {
				this.quote_author.set_text (author);
			} else {
				this.quote_author.set_text ("Anonymous author");
			}
		}

		public void set_quote_url (string url) {
			this.quote_url.set_uri (url);
		}

		public string quote_data () {
			string quote_data = this.quote_text.get_text () + " " +
									this.quote_author.get_text () + " " +
									this.quote_url.get_uri ();

			return quote_data;
		}

	}

}

