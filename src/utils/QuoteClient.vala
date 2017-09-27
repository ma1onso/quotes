// Move async call to API here

namespace Quotes.Utils {

	public class QuoteClient {

		protected Application app;
		protected MainWindow app_window;

		public QuoteClient (MainWindow app_window) {
			this.app_window = app_window;
			this.app = (Application)app_window.application;
		}

		public async void quote_query () {
			this.app_window.search_begin ();

			Soup.URI uri = new Soup.URI (this.app.quotes_end_points);
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

				this.app_window.search_end (root_object, null);
			}
			catch (Error error) {
				this.app_window.search_end (null, error);
			}
		}
	}

}

