public class QuoteStackTest : TestCase {
    private Quotes.Widgets.QuoteStack quote_stack;

    public QuoteStackTest () {
        base ("quote_stack");
        add_test ("is_visible", test_is_visible);
    }

    public override void set_up () {
        this.quote_stack = new Quotes.Widgets.QuoteStack ();
    }

    public override void tear_down () {
    }

    public void test_is_visible () {
        assert (this.quote_stack.is_visible == false);
    }
}
