use Card;
use Score;

class Hand::Omaha {
    has Card @.cards;
    has Str $.name;
    has Score $.score;

    method Str {
        $!name //= "";
        $!name ~ " [" ~ $!score ~ "]";
    }

    # lower the better; Inf means no low
    method low-score {
        my $score = 0;
        my $count = 0;
        my @values = @.cards.map(*.rank).sort.grep(* < 8).unique;
        $!score = Score.new(:values(Inf)) if @values < 5;
        $!score = Score.new(:values(@values));
        self;
    }

    # higher the better;
    method high-score {
        my $base; my $modifier;

        my $straight = self!is-straight;
        my $flush    = self!is-flush;
        my $g        = self!groupings;

        if $straight && $flush {
            $!name = "straight flush";
            $!score = Score.new(:values(8, $straight));
        } elsif $g.get-count eqv [4,1] {
            $!name = "4 of a kind";
            $!score = Score.new(:values(7, |$g.get-score));
        } elsif $g.get-count eqv [3,2] {
            $!name = "full house";
            $!score = Score.new(:values(6, |$g.get-score));
        } elsif $flush {
            $!name = "flush";
            $!score = Score.new(:values(5, |$g.get-score));
        } elsif $straight {
            $!name = "straight";
            $!score = Score.new(:values(4, |$g.get-score));
        } elsif $g.get-count eqv [3,1,1] {
            $!name = "3 of a kind";
            $!score = Score.new(:values(3, |$g.get-score));
        } elsif $g.get-count eqv [2,2,1] {
            $!name = "2 pair";
            $!score = Score.new(:values(2, |$g.get-score));
        } elsif $g.get-count eqv [2,2,1] {
            $!name = "pair";
            $!score = Score.new(:values(1, |$g.get-score));
        } else {
            $!name = "high card";
            $!score = Score.new(:values(0, |$g.get-score));
        }
        self;
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

    method !groupings {
        my %counts;
        my @ranks = @.cards.map({$_.rank == 1 ?? 14 !! $_.rank});
        @ranks.map({%counts{$_}++});

        class :: {
            method get-count {
                my @counts = %counts.values.sort(-*);
            }
            method get-score {
	        my @scores;
                for self.get-count().unique -> $count {
                    my @sub-scores;
                    for %counts.keys -> $key {
                        next unless %counts{$key} == $count;
			push @sub-scores, +$key;
		    }
                    push @scores, |@sub-scores.sort(-*);
                }
                @scores;
            }
        };
    }

} 
