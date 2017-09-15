use Terminal::ANSIColor;

class Suit {
    has Str $.color;
    has Str $.name;
    has Str $.icon;
    has Int $.order;

    method Str {
        color($.color) ~ color('bold') ~ $.icon ~ RESET;
    }

    method all() {
        Suit.new(:order(1),:color('black'),:name("Club"),:icon('♣')),
        Suit.new(:order(2),:color('red'),:name("Diamond"),:icon('♦')),
        Suit.new(:order(3),:color('cyan'),:name("Heart"),:icon('♥')),
        Suit.new(:order(4),:color('yellow'),:name("Spade"),:icon('♠'));
    }
}
