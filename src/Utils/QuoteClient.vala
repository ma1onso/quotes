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

namespace Quotes.Utils {

	public class QuoteClient {

		protected Application app;
		protected MainWindow main_window;

		public QuoteClient (MainWindow main_window) {
			this.main_window = main_window;
			this.app = (Application) main_window.application;
		}

		public async void quote_query () {
			this.main_window.search_begin ();

			Soup.URI uri = new Soup.URI (this.app.quotes_end_points);
			Json.Parser parser = new Json.Parser();
			Json.Object json_quotes;

			try {
				Soup.Request request = app.session.request(uri.to_string (false));
				BufferedInputStream stream_quotes = new BufferedInputStream (
					yield request.send_async (null)
				);

				// Read the JSON data and extract its root.
				yield parser.load_from_stream_async(stream_quotes, null);
				json_quotes = parser.get_root().get_object();

				this.main_window.search_end (json_quotes, null);
			}
			catch (Error error) {
				this.main_window.search_end (null, error);
			}
		}

	}

}
