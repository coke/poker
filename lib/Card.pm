# Bits of a card.  use v6;

use v6;

use Term::ANSIColor;

enum Color <red black>;

class Suit {
    has Color $.color;
    has   Str $.name;
    has   Str $.icon;
    has   Int $.order;

    method Str {
        return color("bold " ~ $.color) ~ $.icon ~ RESET;
    }
}

#my @Suits =
    #Suit.new(:color(black),:name("Club"),:icon('♣')),
    #Suit.new(:color(red),:name("Diamond"),:icon('♦')),
    #Suit.new(:color(red),:name("Heart"),:icon('♥')),
    #Suit.new(:color(black),:name("Spade"),:icon('♠'));
#
class Rank is Int {
    has Int $.value;
    
    method Str {
        return "TYPE OBJECT" unless defined($.value);
        given $.value {
            when 1  { return "A" }
            when 13 { return "K" }
            when 12 { return "Q" }
            when 11 { return "J" }
            when 10 { return "T" }
            default { return $_ }
        }
    }
}

class Card {
    has Rank $.rank;
    has Suit $.suit;

    method Str {
        return ~$.rank ~ $.suit;
    }
}
