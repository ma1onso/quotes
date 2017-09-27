
namespace Quotes.Widgets {

	public class QuoteStack : Gtk.Stack {

		protected Gtk.Box quote_box;

		// TODO: use set and get methods
		public Gtk.Label quote_text;
		public Gtk.Label quote_author;
		public Gtk.LinkButton quote_url;
		public Gtk.Spinner spinner;
		public Gtk.Clipboard clipboard;

		public QuoteStack () {
			this.set_visible (false);

			this.quote_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
			this.quote_box.set_spacing (10);

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

			this.spinner = new Gtk.Spinner ();
			this.spinner.halign = Gtk.Align.CENTER;

			// Add widgets to Main Box
			quote_box.pack_start (this.quote_text);
			quote_box.pack_start (this.quote_author);
			quote_box.pack_start (this.quote_url);

			// Add widgets to Stack
			this.add_named (this.spinner, "spinner");
			this.add_named (quote_box, "quote_box");

		}

		public void set_clipboard (Gdk.Display display) {
			this.clipboard = Gtk.Clipboard.get_for_display (
				display, Gdk.SELECTION_CLIPBOARD
			);
		}

		public string complete_quote () {
			string complete_quote = this.quote_text.get_text () + " " +
									this.quote_author.get_text () + " " +
									this.quote_url.get_uri ();

			return complete_quote;
		}

	}
}

