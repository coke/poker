class Rank is Int {
    has Int $.value;
    
    method Str {
        return "TYPE OBJECT" unless defined($.value);
        given $.value {
            when 1  { return "A" }
            when 13 { return "K" }
            when 12 { return "Q" }
            when 11 { return "J" }
            when 10 { return "T" }
            default { return $_ }
        }
    }
}
