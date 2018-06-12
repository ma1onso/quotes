using Quotes.Utils;


public class QuoteClientTest : TestCase {

    public QuoteClientTest () {
        base ("QuoteClient");

        add_test ("test_quote_client_init", test_quote_client_init);
    }

    public override void set_up () {
    }

    public override void tear_down () {
    }

    public void test_quote_client_init () {
        new QuoteClient ();
        assert (1 == 1);
    }

}
