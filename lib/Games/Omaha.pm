use Utils;

class Games::Omaha {
    # Lower the score, better the low, except 0 means no low.
    method lowScore($hand, $community) {
        # Best low score with two from your hand + the community.
        my $low = Inf; 
        my $handRanks = $hand.list.map(-> $x {$x.rank.value}).grep(-> $x { $x <= 8 }).sort.uniq;
        # need at least 2 lows in your hand for a low. 
        return 0 if $handRanks < 2; 

        my $communityRanks = $community.list.map(-> $x {$x.rank.value}).grep(-> $x { $x <= 8 }).sort.uniq;
        # need at least 3 lows in the community for a low.
        return 0 if $communityRanks < 3; 

        for iterate(2, $handRanks).lol -> $mycards {
            for iterate(3, $communityRanks).lol -> $tablecards {
                my @ranks = ($mycards.list, $tablecards.list).flat.sort.uniq;
                # we might have been counterfeited
                next if +@ranks < 5; 
                $low = min($low, [+] 1,10,100,1000,10000 Z* @ranks[0..^5]);
            }
        }
        $low = 0 if $low == Inf;
        return $low;
    }
}
