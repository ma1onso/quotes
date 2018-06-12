using Quotes.Configs;


public class ConstantsTest : TestCase {

    public ConstantsTest () {
        base ("Constants");

        add_test ("constants", constans);
    }

    public override void set_up () {
    }

    public override void tear_down () {
    }

    public void constans () {
        assert (Constants.ID == "com.github.alonsoenrique.quotes");
    }
}
