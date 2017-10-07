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
