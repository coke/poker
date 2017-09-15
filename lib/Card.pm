use Suit;

class Card {
    has int $.rank;
    has Suit $.suit;
    
    method Str {
        do given $.rank {
            when 1  { "A" }
            when 13 { "K" }
            when 12 { "Q" }
            when 11 { "J" }
            when 10 { "T" }
            default { $_ }
        } ~ $.suit;
    }
} 
