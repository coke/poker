use Hand::Omaha;

class Games::Omaha {
    method lowScore($hand, $community) {
        # Best low score with two from your hand + the community.
        my $best;
        for $hand.combinations(2) -> $mycards {
            for $community.combinations(3) -> $tablecards {
                my $hand = Hand::Omaha.new(:cards(|$mycards, |$tablecards));
                $best = $hand if !$best.defined or $hand.low-score < $best.low-score;
            }
        }
        $best.low-score;
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
