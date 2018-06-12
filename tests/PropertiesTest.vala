using Quotes.Configs;


public class PropertiesTest : TestCase {

    public PropertiesTest () {
        base ("Properties");

        add_test ("test_properties", test_properties);
    }

    public override void set_up () {
    }

    public override void tear_down () {
    }

    public void test_properties () {
        assert (Properties.TITLE_HEADER_BAR == "Quotes");
        assert (Properties.CLOSE == "Close");
        assert (Properties.WELCOME == "Welcome");
    }

}
