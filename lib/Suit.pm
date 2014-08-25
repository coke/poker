use Term::ANSIColor;

enum Color <red black>;

enum Swuit <♣ ♦ ♥ ♠>;

class Suit {
    has Color $.color;
    has   Str $.name;
    has   Str $.icon;
    has   Int $.order;

    method Str {
        return color("bold " ~ $.color) ~ color('bold') ~ $.icon ~ RESET;
    }

    method all() {
        return 
            Suit.new(:order(1),:color(black),:name("Club"),:icon('♣')),
            Suit.new(:order(2),:color(red),:name("Diamond"),:icon('♦')),
            Suit.new(:order(3),:color(red),:name("Heart"),:icon('♥')),
            Suit.new(:order(4),:color(black),:name("Spade"),:icon('♠'));
    }
}
