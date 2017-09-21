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
        $base = 8;

        # 4 of a kind
        $base = 7;

        # full house
        $base = 6;

        # flush
        if self!is-flush {
            return Score.new(:values(5, |self!rank(@.cards)));
        }

        # straight     
        $base = 4;

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
  
    method !is-flush {
        [eq] @.cards.map(*.suit.name);
    }

    method !is-straight {
        
    }
} 
