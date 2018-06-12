using Quotes.Configs;


public class ConstantsTest : TestCase {

    public ConstantsTest () {
        base ("Constants");

        add_test ("constants", test_constants);
    }

    public override void set_up () {
    }

    public override void tear_down () {
    }

    public void test_constants () {
        assert (Constants.ID == "com.github.alonsoenrique.quotes");
        assert (Constants.VERSION == "0.5.6");
        assert (Constants.PROGRAME_NAME == "Quotes");
        assert (Constants.APP_YEARS == "2017");
        assert (Constants.APP_ICON == "com.github.alonsoenrique.quotes");
        assert (Constants.ABOUT_COMMENTS == "Quotes for daily inspiration");
        assert (Constants.TRANSLATOR_CREDITS == "Github Translators");
        assert (Constants.MAIN_URL == "https://github.com/AlonsoEnrique/Quotes");
        assert (Constants.BUG_URL == "https://github.com/AlonsoEnrique/Quotes/issues");
        assert (Constants.HELP_URL == "https://github.com/AlonsoEnrique/Quotes/wiki");
        assert (Constants.TRANSLATE_URL == "https://github.com/AlonsoEnrique/Quotes");
        assert (Constants.TEXT_FOR_ABOUT_DIALOG_WEBSITE == "Website");
        assert (Constants.TEXT_FOR_ABOUT_DIALOG_WEBSITE_URL == "https://github.com/AlonsoEnrique/");
        assert (Constants.URL_CSS == "com/github/alonsoenrique/quotes/window.css");
        assert (Constants.ABOUT_AUTHORS [0] == "Alonso Enrique <alons45@gmail.com>");
        assert (Constants.ABOUT_LICENSE_TYPE ==  Gtk.License.GPL_3_0);
    }
}
