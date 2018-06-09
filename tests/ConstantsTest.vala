using Quotes;
// using Quotes.Config;


public class ConstantsTest : Gee.TestCase {

    public ConstantsTest () {
        base ("ConstantsTest");

        add_test ("foo", test_foo);
        add_test ("constants", constans);
    }

    public override void set_up () {
    }

    public override void tear_down () {
    }

    public void test_foo () {
        assert (1 == 1);
    }

    public void constans () {
        // assert (Constants.ID == "com.github.alonsoenrique.quotes");
    }
}
