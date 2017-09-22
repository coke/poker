use Card;
use Score;

class Hand::Omaha {
    has Card @.cards;

    # lower the better; Inf means no low
    method low-score {
        my $score = 0;
        my $count = 0;
        my @values = @.cards.map(*.rank).sort.grep(* < 8).unique;
        return Score.new(:values(Inf)) if @values < 5;
        return Score.new(:values(@values));
    }

    # higher the better;
    method high-score {
        my $base; my $modifier;

        # straight/royal flush.
        my $straight = self!is-straight;
        my $flush    = self!is-flush;
        if $straight && $flush {
            return Score.new(:values(8, $straight));
        }

        # 4 of a kind
        $base = 7;

        # full house
        $base = 6;

        # flush
        if $flush {
            return Score.new(:values(5, |self!rank(@.cards)));
        }

        # straight     
        if $straight {
            return Score.new(:values(4, $straight));
        }

        # 3 of a kind
        $base = 3;

        # 2 pair
        $base = 2;

        # 1 pair
        $base = 1;

        # 0: high card
        Score.new(:values(0, |self!rank(@.cards)));
    }
 
    method !rank(@cards) {
        @cards.map(*.rank).map({$_==1??14!!$_}).sort(-*);
    }
  
    method !is-flush(--> Bool) {
        [eq] @.cards.map(*.suit.name);
    }

    method !is-straight(--> Int) {
        sub ordered(@ranks) {
           [&&] @ranks.sort.rotor(2 => -1).map({$_[0]+1==$_[1]});
        }
 
        # 0 means no straight.
        # Positive value indicates the highest card in the straight.

        # with A low, are all our ranks sequential?
        # if they are sequential, we can reverse the list, add the index
        # at each point to the value, and they will all have the same sum

        my @ranks = @.cards.map(*.rank);
        return @ranks[0] if ordered(@ranks);
        
        # what about with A high? 
        return 14 if ordered(@.cards.map(*.rank).map({$_==1??14!!$_}));

        return 0;
    }
} 
