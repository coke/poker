use v6;

use Deck;
use Games::Omaha;
use Score;

# in our output, show hand, then have rank of hands for high low.
# anything ranked #1 in high/low show hand in bold. Anything else,
# show numeric rank.

my $deck = Deck.new();
my @hands;
my @lows;
my @highs;
my @community = $deck.deal(5);
my $player-count = 11;

for 0..^$player-count -> $i {
    @hands[$i] = $deck.deal(4);
    @lows[$i] = Games::Omaha.low-score(@hands[$i], @community);
    @highs[$i] = Games::Omaha.high-score(@hands[$i], @community);
}

say "==:=HANDS========LOW=HIGH=====";
my @loworder = @lows.pairs.sort({Score.cmp($^a.value,$^b.value)})>>.key;
my @highorder = @highs.pairs.sort({Score.cmp($^b.value,$^a.value)})>>.key;
my $rank = 0;
my @lowranks;
my @highranks;
my $lastScore = 0;
for @loworder -> $index {
    my $score = @lows[$index];
    if $score.is-inf {
        @lowranks[$index] = "";
    } else {
        if $lastScore ne ~$score {
            $rank++;
        }
        @lowranks[$index] = $rank;
        $lastScore = ~$score;
    }
}

$lastScore=0;
$rank =0;
for @highorder -> $index {
    my $score = @highs[$index];
    if $lastScore ne ~$score {
        $rank++;
    }
    @highranks[$index] = $rank;
    $lastScore = ~$score;
}

for 1..$player-count -> $i {
    say $i.fmt('%2d') ~ ": " ~ join("     ", @hands[$i-1]) ~ "  " ~
    @lowranks[$i-1].fmt('%2s') ~ @highranks[$i-1].fmt('%4s');
};

say "";
say "FLOP===========TURN=RIVER";
say @community.join("   ");;
