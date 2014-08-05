use Rank;
use Term::ANSIColor;

class Card {

    enum Color <red black>;

    class Suit {
        has Color $.color;
        has   Str $.name;
        has   Str $.icon;
        has   Int $.order;
    
        method Str {
            return color("bold " ~ $.color) ~ color('bold') ~ $.icon ~ RESET;
        }
    }
    
    method Suits() {
        return 
            Suit.new(:order(1),:color(black),:name("Club"),:icon('♣')),
            Suit.new(:order(2),:color(red),:name("Diamond"),:icon('♦')),
            Suit.new(:order(3),:color(red),:name("Heart"),:icon('♥')),
            Suit.new(:order(4),:color(black),:name("Spade"),:icon('♠'));
    }
    
    has Rank $.rank;
    has Suit $.suit;
    
    method Str {
        return ~$.rank ~ $.suit;
    }
} 
