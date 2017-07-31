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

	// Widgets
	protected Gtk.Box quote_box;
	protected Gtk.Label quote_text;
	protected Gtk.Label quote_author;
	protected Gtk.LinkButton quote_url;
	protected Gtk.Stack quote_stack;
	protected Gtk.Spinner spinner;
	protected Gtk.HeaderBar toolbar;
	protected Gtk.ToolButton refresh_tool_button;
	protected Gtk.ToolButton share_tool_button;

    // signals
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

		this.connect_signals ();
		this.initialize_widgets ();
		this.button_events ();
		this.grid ();
		this.load_css ();
		
		this.show_all();		
		
		quote_query.begin ();
	}

    protected void on_search_begin () {
		this.refresh_tool_button.sensitive = false;
		this.share_tool_button.sensitive = false;

    	if (!this.quote_stack.visible) {
    		this.quote_stack.set_visible (true);
    	}
    	this.quote_stack.set_visible_child_name ("spinner");
    	this.spinner.start ();
	    this.searching = true;
    }

    protected void on_search_end (Json.Object? quote, Error? error) {
		this.refresh_tool_button.sensitive = true;
		this.share_tool_button.sensitive = true;
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

	private void initialize_widgets () {
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

		this.quote_stack = new Gtk.Stack ();
		this.quote_stack.set_visible (false);

		this.spinner = new Gtk.Spinner ();
		// Reference: https://github.com/danrabbit/nimbus/blob/master/src/MainWindow.vala
		this.spinner.halign = Gtk.Align.CENTER;

		this.toolbar = new Gtk.HeaderBar ();
		this.toolbar.set_title ("Quotes");
		this.set_titlebar (this.toolbar);
		this.toolbar.show_close_button = true;
		this.initialize_toolbar ();
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
		this.share_tool_button = new Gtk.ToolButton (copy_icon, null);
		this.toolbar.add (share_tool_button);
	}
	
	private void grid () {
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
		css_provider.load_from_resource ("com/github/alons45/quotes/Window.css");
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
	}

	private void connect_signals () {
		this.search_begin.connect (this.on_search_begin);
		this.search_end.connect (this.on_search_end);
	}

	// TODO: Move this logic method
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
