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

my %iters;
sub iterate($num, @array) {
    # we only need to calculate all possible combinations once. 
    my $len = @array.elems;
    %iters{$num}{$len} //= do {
        my @positions = 1..$len;
        combine($num, @positions);
    }
   
    return %iters{$num}{$len}.map({@array[$_]});
}

proto combine (Int, @) {*}
 multi combine (0,  @)  { [] }
 multi combine ($,  []) { () }
 multi combine ($n, [$head, *@tail]) {
         map( { [$head, @^others] },
                     combine($n-1, @tail) ),
                         combine($n, @tail);
 }
  
# Lower the score, better the low. 0 means no low.
sub lowScore($hand, $community) {
    # Best low score with two from your hand + the community.
 
    my $low = Inf; 
    for iterate(2, $hand) -> $mycards {
        for iterate(3, $community) -> $tablecards {
            # unique by rank, in order.
            my @ranks = ($mycards.list, $tablecards.list).map(-> $x {$x.rank.value}).grep(-> $x { $x <= 8 }).sort.uniq;
            next if +@ranks < 5;
            $low = min($low, [+] 1,10,100,1000,10000 Z* @ranks[0..^5]);
        }
    }
    $low = 0 if $low == Inf;
    return $low;
}

my $deck = Deck.new();
my @hands;
my @lows;
# ASSUME DEAL ORDER IS IRRELEVANT
my @community = $deck.deal(5);
for 0..^11 -> $i {
    @hands[$i] = $deck.deal(4);
    @lows[$i] = lowScore(@hands[$i], @community);
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
say @community;
