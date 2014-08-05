use v6;
BEGIN @*INC.push("lib");

use Card;
use Utils;
use Games::Omaha;

my @Suits =
    Suit.new(:order(1),:color(black),:name("Club"),:icon('♣')),
    Suit.new(:order(2),:color(red),:name("Diamond"),:icon('♦')),
    Suit.new(:order(3),:color(red),:name("Heart"),:icon('♥')),
    Suit.new(:order(4),:color(black),:name("Spade"),:icon('♠'));

class Deck {
    has @.cards;

    submethod BUILD() {
        for @Suits X 1...13 -> $suit, $pips {
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

# in our output, show hand, then have rank of hands for high low.
# anything ranked #1 in high/low show hand in bold. Anything else,
# show numeric rank.

my $deck = Deck.new();
my @hands;
my @lows;
my @community = $deck.deal(5);
for 0..^11 -> $i {
    @hands[$i] = $deck.deal(4);
    @lows[$i] = Games::Omaha.lowScore(@hands[$i], @community);
}

say "HANDS";
say "==: CARDS========LOW=HIGH=====";
my @loworder = @lows.pairs.sort(+*.value)>>.key;
my $rank = 0;
my @lowranks;
my $lastScore = 0;
for @loworder -> $index {
    my $score = @lows[$index];
    if $score == 0 {
        @lowranks[$index] = "";
    } else {
        if $lastScore != $score {
            $rank++;
        }
        @lowranks[$index] = $rank;
        $lastScore = $score;
    }
}

for 1..11 -> $i {
    say $i.fmt('%2d') ~ ": " ~ join("     ", @hands[$i-1]) ~ "  " ~
    @lowranks[$i-1].fmt('%2s') ~ '??'.fmt('%4s') ;
};

say "\n\nCOMMUNITY";
say "=========";
say ~@community;
