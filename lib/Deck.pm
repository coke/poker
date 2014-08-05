use Card;

class Deck {
    has @.cards;

    submethod BUILD() {
        for Suit.all X 1...13 -> $suit, $pips {
            my $rank = Rank.new(:value($pips)); 
            my $card = Card.new(:$rank, :$suit);
            @!cards.push($card);
        }
        
        @!cards = @!cards.pick(*);
    }

    method deal(Int $count) {
        @!cards.splice(0, $count);
    }
}
