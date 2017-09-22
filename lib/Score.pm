class Score {
    has @.values;

    method cmp(Score $a, Score $b) {
        ($a.values «<=>» $b.values).first({$_ != Same}) // Same; 
    }

    method is-inf {
       return False unless @.values;
       @.values[0] == Inf;
    }

    method Str {
        @.values.join(',');
    }
}
