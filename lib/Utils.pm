my %iters;
sub iterate($num, @array) is export {
    # we only need to calculate all possible combinations once. 
    my $len = @array.elems;
    %iters{$num}{$len} //= [combine($num, [0..^$len])];

    # now use the index lists to figure out this particular set of combos
    my $retval = [];
    for %iters{$num}{$len}.flat -> $a {
        $retval.push([@array[@$a]]);
    }
    $retval;
}

proto combine (Int, @) {*}

multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    map( { [$head, @^others] }, combine($n-1, @tail)), combine($n, @tail);
}
