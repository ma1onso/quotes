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

public class MainWindow : Gtk.ApplicationWindow {
	protected bool searching = false;

	// Containers
	protected Gtk.Box quote_box;
	protected Gtk.Stack quote_stack;
	protected Gtk.Grid share_grid;
	protected Gtk.Grid container_share_grid;

	// Widgets
	protected Gtk.Label quote_text;
	protected Gtk.Label quote_author;
	protected Gtk.LinkButton quote_url;
	protected Gtk.Spinner spinner;
	protected Gtk.Clipboard clipboard;

	// Toolbar widgets
	protected Gtk.HeaderBar toolbar;
	protected Gtk.ToolButton refresh_tool_button;
	protected Gtk.ToolButton copy_to_clipboard_button;
	protected Gtk.ToolButton share_button;
	protected Gtk.Popover popover;
	protected Gtk.Button facebook_button;
	protected Gtk.Button twitter_button;
	protected Gtk.Button google_button;

	// Gdk
	protected Gdk.Display display;

    // Signals
    public signal void search_begin ();
    public signal void search_end (Json.Object? url, Error? e);

	public MainWindow (Application application) {
		Object (
			application: application,
			title: "Quotes",
			default_width: 800,
			default_height: 600
		);
		this.set_border_width (12);
		this.set_position (Gtk.WindowPosition.CENTER);
		// weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
		// default_theme.add_resource_path ("com/github/alons45/quotes/icons");

		this.connect_signals ();
		this.initialize_gdk_vars ();
		this.initialize_gtk_vars ();
		this.button_events ();
		this.share_button_events ();
		this.complete_grid ();
		this.load_css ();

		this.show_all();

		quote_query.begin ();
	}

    protected void on_search_begin () {
		this.refresh_tool_button.sensitive = false;
		this.copy_to_clipboard_button.sensitive = false;

    	if (!this.quote_stack.visible) {
    		this.quote_stack.set_visible (true);
    	}
    	this.quote_stack.set_visible_child_name ("spinner");
    	this.spinner.start ();
	    this.searching = true;
    }

    protected void on_search_end (Json.Object? quote, Error? error) {
		this.refresh_tool_button.sensitive = true;
		this.copy_to_clipboard_button.sensitive = true;
    	this.searching = false;

	    if (error != null) {
	    	return;
	    }

	    // Set quote text
	    this.quote_text.set_text (
	    	"\"" + quote.get_string_member ("quoteText")._chomp () + "\""
	    );
	    // Set quote author
		if (quote.get_string_member ("quoteAuthor") != "") {
			this.quote_author.set_text (quote.get_string_member ("quoteAuthor"));
		} else {
			this.quote_author.set_text ("Anonymous author");
		}
		// Set quote uri
	    this.quote_url.set_uri (quote.get_string_member ("quoteLink"));

	    this.quote_stack.set_visible_child_name ("quote_box");
    }
	// End signals

	private void initialize_gtk_vars () {
		this.quote_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		quote_box.set_spacing (10);

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

		this.quote_stack = new Gtk.Stack ();
		this.quote_stack.set_visible (false);

		this.spinner = new Gtk.Spinner ();
		this.spinner.halign = Gtk.Align.CENTER;

		this.toolbar = new Gtk.HeaderBar ();
		this.toolbar.set_title ("Quotes");
		this.set_titlebar (this.toolbar);
		this.toolbar.show_close_button = true;
		this.initialize_toolbar ();

		this.clipboard = Gtk.Clipboard.get_for_display (
			display, Gdk.SELECTION_CLIPBOARD
		);
	}

	private void initialize_gdk_vars () {
		this.display = this.get_display ();
	}

	private void initialize_toolbar () {
		Gtk.Image refresh_icon = new Gtk.Image.from_icon_name (
			"view-refresh", Gtk.IconSize.SMALL_TOOLBAR
		);
		this.refresh_tool_button = new Gtk.ToolButton (refresh_icon, null);
		this.refresh_tool_button.is_important = true;
		this.refresh_tool_button.set_tooltip_text ("Get another random quote");
		this.toolbar.add (refresh_tool_button);

		Gtk.Image copy_icon = new Gtk.Image.from_icon_name (
			"edit-copy", Gtk.IconSize.SMALL_TOOLBAR
		);
		this.copy_to_clipboard_button = new Gtk.ToolButton (copy_icon, null);
		this.copy_to_clipboard_button.set_tooltip_text ("Copy to clipboard");
		this.toolbar.add (this.copy_to_clipboard_button);

		Gtk.Image share_icon = new Gtk.Image.from_icon_name (
			"emblem-shared", Gtk.IconSize.SMALL_TOOLBAR
		);
		this.share_button = new Gtk.ToolButton (share_icon, null);
		this.share_button.set_tooltip_text ("Share in social networks");
		this.toolbar.add (this.share_button);

		this.popover = new Gtk.Popover (this.share_button);
		this.popover.set_position (Gtk.PositionType.BOTTOM);

		this.facebook_button = new Gtk.Button.from_icon_name (
			"online-account-facebook", Gtk.IconSize.DND
		);
		this.facebook_button.tooltip_text = "Facebook";
		this.facebook_button.get_style_context ().add_class (
			Gtk.STYLE_CLASS_FLAT
		);

		this.twitter_button = new Gtk.Button.from_icon_name (
			"online-account-twitter", Gtk.IconSize.DND
		);
		this.twitter_button.tooltip_text = "Twitter";
		this.twitter_button.get_style_context ().add_class (
			Gtk.STYLE_CLASS_FLAT
		);

		this.google_button = new Gtk.Button.from_icon_name (
			"online-account-google-plus", Gtk.IconSize.DND
		);
		this.google_button.tooltip_text = "Google Plus";
		this.google_button.get_style_context ().add_class (
			Gtk.STYLE_CLASS_FLAT
		);

		share_grid = new Gtk.Grid ();
		share_grid.margin = 6;
		share_grid.add (this.facebook_button);
		share_grid.add (this.twitter_button);
		share_grid.add (this.google_button);

		container_share_grid = new Gtk.Grid ();
		container_share_grid.orientation = Gtk.Orientation.VERTICAL;
		container_share_grid.add (share_grid);
		container_share_grid.show_all ();

		this.popover.add (container_share_grid);
	}

	private void complete_grid () {
		// Add widgets to Main Box
		quote_box.pack_start (this.quote_text);
		quote_box.pack_start (this.quote_author);
		quote_box.pack_start (this.quote_url);

		// Add widgets to Stack
		this.quote_stack.add_named (this.spinner, "spinner");
		this.quote_stack.add_named (quote_box, "quote_box");

		// Add widgets to Window
		this.add(quote_stack);
	}

	private void load_css () {
		Gtk.CssProvider css_provider = new Gtk.CssProvider ();
		css_provider.load_from_resource ("com/github/alonsoenrique/quotes/window.css");
		Gtk.StyleContext.add_provider_for_screen (
			Gdk.Screen.get_default (),
			css_provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
	}

	private void button_events () {
		this.refresh_tool_button.clicked.connect ( () => {
			quote_query.begin();
		});

		this.copy_to_clipboard_button.clicked.connect ( () => {
			this.clipboard.set_text (this.complete_quote (), -1);
		});

		this.share_button.clicked.connect ( () => {
			popover.set_visible (true);
		});
	}

	private void share_button_event (string url) {
        try {
            AppInfo.launch_default_for_uri (url.printf (this.complete_quote ()), null);
        } catch (Error e) {
            warning ("%s", e.message);
        }
        this.popover.hide ();
	}

	private void share_button_events () {
		this.facebook_button.clicked.connect (() => {
	        try {
	            AppInfo.launch_default_for_uri (
	            	"https://www.facebook.com/dialog/share?app_id=145634995501895&dialog=popup&redirect_uri=https://facebook.com&href=%s&quote=%s".printf(
	            		this.quote_url.get_uri(), this.complete_quote()
            		),
            		null
        		);
	        } catch (Error e) {
	            warning ("%s", e.message);
	        }
	        this.popover.hide ();
		});

		this.twitter_button.clicked.connect (() => {
			this.share_button_event ("http://twitter.com/home/?status=%s");
		});

		this.google_button.clicked.connect (() => {
			this.share_button_event ("https://plus.google.com/share?text=%s");
		});
	}

	private void connect_signals () {
		this.search_begin.connect (this.on_search_begin);
		this.search_end.connect (this.on_search_end);
	}

	private string complete_quote () {
		string complete_quote = this.quote_text.get_text () + " " +
								this.quote_author.get_text () + " " +
								this.quote_url.get_uri ();

		return complete_quote;
	}

	// TODO: Move this to QuoteClient
	protected async void quote_query () {
		// TODO: Include another api source: http://quotesondesign.com/wp-json/posts
		this.search_begin ();

		Application app = (Application)this.application;
		Soup.URI uri = new Soup.URI (app.quote_host);
		Json.Parser parser = new Json.Parser();
		Json.Object root_object;

		try {
			Soup.Request request = app.session.request(uri.to_string (false));
			BufferedInputStream stream = new BufferedInputStream (
				yield request.send_async (null)
			);

			// Read the JSON data and extract its root.
			yield parser.load_from_stream_async(stream, null);
			root_object = parser.get_root().get_object();

			this.search_end (root_object, null);
		}
		catch (Error error) {
			this.search_end (null, error);
		}
	}
}
