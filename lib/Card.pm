use Rank;
use Suit;

class Card {
    has Rank $.rank;
    has Suit $.suit;
    
    method Str {
        return ~$.rank ~ $.suit;
    }
} 
