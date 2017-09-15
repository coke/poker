use Card;
use Suit;

class Deck {
    has @.cards;

    submethod BUILD() {
        for Suit.all X (1..13) -> ($suit, $pips) {
            my $card = Card.new(:$pips, :$suit);
            @!cards.push($card);
        }
        
        @!cards = @!cards.pick(*);
    }

    method deal(Int $count) {
        @!cards.splice(0, $count);
    }
}
