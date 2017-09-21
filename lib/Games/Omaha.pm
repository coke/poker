class Games::Omaha {
    # Lower the score, better the low, except 0 means no low.
    method lowScore($hand, $community) {
        # Best low score with two from your hand + the community.
        my $low = Inf; 
        my $handRanks = $hand.list.map(-> $x {$x.rank}).grep(-> $x { $x <= 8 }).sort.unique;
        # need at least 2 lows in your hand for a low. 
        return 0 if $handRanks < 2; 

        my $communityRanks = $community.list.map(-> $x {$x.rank}).grep(-> $x { $x <= 8 }).sort.unique;
        # need at least 3 lows in the community for a low.
        return 0 if $communityRanks < 3; 

        for $handRanks.combinations(2) -> $mycards {
            for $communityRanks.combinations(3) -> $tablecards {
                my @ranks = ($mycards.list, $tablecards.list).flat.sort.unique;
                # we might have been counterfeited
                next if +@ranks < 5; 
                $low = min($low, [+] 1,10,100,1000,10000 Z* @ranks[0..^5]);
            }
        }
        $low = 0 if $low == Inf;
        $low;
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
