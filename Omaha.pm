# Bits of a card.  use v6;

use v6;
BEGIN @*INC.push("lib");

use Card;

my @Suits =
    Suit.new(:order(1),:color(black),:name("Club"),:icon('♣')),
    Suit.new(:order(2),:color(red),:name("Diamond"),:icon('♦')),
    Suit.new(:order(3),:color(red),:name("Heart"),:icon('♥')),
    Suit.new(:order(4),:color(black),:name("Spade"),:icon('♠'));

class Deck {
    has @.cards;

    submethod BUILD() {
        for @Suits -> $suit {
            for 1..13 -> $pips {
                my $rank = Rank.new(:value($pips)); 
                my $card = Card.new(:$rank, :$suit);
                @!cards.push($card);
            }
        }
        
        @!cards = @!cards.pick(*);
    }

    method deal(Int $count) {
        @!cards.splice(0, $count);
    }
}

# Writeup Card Ranker - sort by high, sort by low.
# Low - best 5 unique low cards rank only - if max > 8, no low
# High - Named ranks:
# Royal Flush / Straight Flush / 4 of a Kind / Full House /
# Flush / Straight / 3 of a Kind / 2 Pair / Pair / High Card
# Compare ranks first; 2 hands of same rank then compare by
# cards in hand.
#   properties - Any straight or flush - highest card wins
#   full house - highest top card wins , then highest bottom card.
#   3 of a kind - best Value card, then kicker1, then kicker2
#   2 pair - best top card, then best bottom card, then best kicker
#   1 pair - best pair card, best kicker1..3
#   high card - best card, best kicker1..4

# could do it by simple card ordering, but we need names like:
# "set of threes with a king queen kicker"

# in our output, show hand, then have rank of hands for high low.
# anything ranked #1 in high/low show hand in bold. Anything else,
# show numeric rank.

my $deck = Deck.new();
say "HANDS";
say "=====";
my @hands;
for 1..11 -> $i { @hands[$i] = $deck.deal(4) };
for 1..11 -> $i { say "$i".fmt('%02d') ~ ": " ~ join("     ", @hands[$i]) };
say "\n\nCOMMUNITY";
say "=========";
my @community = $deck.deal(5);
say @community;
