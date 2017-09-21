use Hand::Omaha;
use Score;

class Games::Omaha {
    method low-score($hand, $community --> Score) {
        # Best low score with two from your hand + the community.
        my $best;
        for $hand.combinations(2) -> $mycards {
            for $community.combinations(3) -> $tablecards {
                my $hand = Hand::Omaha.new(:cards(|$mycards, |$tablecards));
                $best = $hand if !$best.defined or Score.cmp($hand.low-score,$best.low-score) == Order::Less
            }
        }
        $best.low-score;
    }
    method high-score($hand, $community --> Score) {
        # Best high score with two from your hand + the community.
        my $best;
        for $hand.combinations(2) -> $mycards {
            for $community.combinations(3) -> $tablecards {
                my $hand = Hand::Omaha.new(:cards(|$mycards, |$tablecards));
                $best = $hand if !$best.defined or Score.cmp($hand.high-score,$best.high-score) == Order::More;
            }
        }
        $best.high-score;
    }
}

# could do it by simple card ordering, but we need names like:
# "set of threes with a king queen kicker"
