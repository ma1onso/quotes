void main (string[] args) {
    Test.init (ref args);

    TestSuite.get_root ().add_suite (new ConstantsTest ().get_suite ());
    TestSuite.get_root ().add_suite (new PropertiesTest ().get_suite ());

    Test.run ();
}
