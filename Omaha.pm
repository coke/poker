use v6;

use Deck;
use Games::Omaha;

# in our output, show hand, then have rank of hands for high low.
# anything ranked #1 in high/low show hand in bold. Anything else,
# show numeric rank.

my $deck = Deck.new();
my @hands;
my @lows;
my @community = $deck.deal(5);
my $player-count = 11;

for 0..^$player-count -> $i {
    @hands[$i] = $deck.deal(4);
    @lows[$i] = Games::Omaha.lowScore(@hands[$i], @community);
}

say "==:=HANDS========LOW=HIGH=====";
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

for 1..$player-count -> $i {
    say $i.fmt('%2d') ~ ": " ~ join("     ", @hands[$i-1]) ~ "  " ~
    @lowranks[$i-1].fmt('%2s') ~ '??'.fmt('%4s') ;
};

say "";
say "FLOP===========TURN=RIVER";
say @community.join("   ");;
