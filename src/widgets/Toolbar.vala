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


namespace Quotes.Widgets {

	public class Toolbar : Gtk.HeaderBar {

		public Gtk.Grid share_grid;
		public Gtk.Grid container_share_grid;

		public Gtk.ToolButton refresh_tool_button;
		public Gtk.ToolButton copy_to_clipboard_button;
		public Gtk.ToolButton share_button;
		public Gtk.Popover share_popover;
		public Gtk.Button facebook_button;
		public Gtk.Button twitter_button;
		public Gtk.Button google_button;

		public Toolbar () {
			this.set_title (Properties.TITLE_HEADER_BAR);
			this.show_close_button = true;

			Gtk.Image refresh_icon = new Gtk.Image.from_icon_name (
				"view-refresh", Gtk.IconSize.SMALL_TOOLBAR
			);
			this.refresh_tool_button = new Gtk.ToolButton (refresh_icon, null);
			this.refresh_tool_button.is_important = true;
			this.refresh_tool_button.set_tooltip_text (_("Get another random quote"));
			this.add (refresh_tool_button);

			Gtk.Image copy_icon = new Gtk.Image.from_icon_name (
				"edit-copy", Gtk.IconSize.SMALL_TOOLBAR
			);
			this.copy_to_clipboard_button = new Gtk.ToolButton (copy_icon, null);
			this.copy_to_clipboard_button.set_tooltip_text (_("Copy to clipboard"));
			this.add (this.copy_to_clipboard_button);

			Gtk.Image share_icon = new Gtk.Image.from_icon_name (
				"emblem-shared", Gtk.IconSize.SMALL_TOOLBAR
			);
			this.share_button = new Gtk.ToolButton (share_icon, null);
			this.share_button.set_tooltip_text (_("Share in social networks"));
			this.add (this.share_button);

			this.share_popover = new Gtk.Popover (this.share_button);
			this.share_popover.set_position (Gtk.PositionType.BOTTOM);

			this.facebook_button = new Gtk.Button.from_icon_name (
				"online-account-facebook", Gtk.IconSize.DND
			);
			this.facebook_button.tooltip_text = _("Facebook");
			this.facebook_button.get_style_context ().add_class (
				Gtk.STYLE_CLASS_FLAT
			);

			this.twitter_button = new Gtk.Button.from_icon_name (
				"online-account-twitter", Gtk.IconSize.DND
			);
			this.twitter_button.tooltip_text = _("Twitter");
			this.twitter_button.get_style_context ().add_class (
				Gtk.STYLE_CLASS_FLAT
			);

			this.google_button = new Gtk.Button.from_icon_name (
				"online-account-google-plus", Gtk.IconSize.DND
			);
			this.google_button.tooltip_text = _("Google Plus");
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

			this.share_popover.add (container_share_grid);
		}

		public void button_events (MainWindow main_window) {
			this.refresh_tool_button.clicked.connect ( () => {
				main_window.quote_client.quote_query.begin();
			});

			this.copy_to_clipboard_button.clicked.connect ( () => {
				main_window.quote_stack.clipboard.set_text (
					main_window.quote_stack.quote_data (), -1
				);
			});

			this.share_button.clicked.connect ( () => {
				this.share_popover.set_visible (true);
			});
		}

		public void open_url (string social_network_url, string quote_data) {
		    try {
		        AppInfo.launch_default_for_uri (social_network_url.printf (quote_data), null);
		    } catch (Error e) {
		        warning ("%s", e.message);
		    }
		    this.share_popover.hide ();
		}

		public void open_facebook_url (string social_network_url, string quote_uri, string quote_data) {
			try {
				AppInfo.launch_default_for_uri (
					social_network_url.printf(
						quote_uri, quote_data
					),
					null
				);
			} catch (Error e) {
				warning ("%s", e.message);
			}
			this.share_popover.hide ();
		}

		public void social_network_events (MainWindow main_window) {
			this.facebook_button.clicked.connect (() => {
				this.open_facebook_url ("https://www.facebook.com/dialog/share?app_id=145634995501895&dialog=popup&redirect_uri=https://facebook.com&href=%s&quote=%s", main_window.quote_stack.quote_url.get_uri(), main_window.quote_stack.quote_data ());
			});

			this.twitter_button.clicked.connect (() => {
				this.open_url ("http://twitter.com/home/?status=%s", main_window.quote_stack.quote_data ());
			});

			this.google_button.clicked.connect (() => {
				this.open_url ("https://plus.google.com/share?text=%s", main_window.quote_stack.quote_data ());
			});
		}

	}

}

