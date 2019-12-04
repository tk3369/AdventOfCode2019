module Day4

export part1, part2, part2b, part2c, part1d
export check, rules1, rules2

# Variable naming convention
#
# v: the number to be evaluated
# d: array of digits, most significant digit in lower index

# 1. at least two adjacent digits are the same.
function two_adj_digits_are_same(d)
    (d[1] == d[2] || d[2] == d[3] || d[3] == d[4] ||
     d[4] == d[5] || d[5] == d[6])
end

# 2. from left to right, the digits never decrease.
function never_decrease(d)
    d[1] <= d[2] <= d[3] <= d[4] <= d[5] <= d[6]
end

# 3. two adjacent same digits are not part of a larger group
function exactly_two(d)
    (d[1] == d[2] && d[2] != d[3]) ||
    (d[1] != d[2] && d[2] == d[3] && d[3] != d[4]) ||
    (d[2] != d[3] && d[3] == d[4] && d[4] != d[5]) ||
    (d[3] != d[4] && d[4] == d[5] && d[5] != d[6]) ||
    (d[4] != d[5] && d[5] == d[6])
end

# Count how many passwords satisfy the provided rules
function count_passwords(i, j, rules)
    count = 0
    for v in i:j
        d = reverse(digits(v))
        if all(f(d) for f in rules)
            count += 1
        end
    end
    return count
end

# define rule sets
rules1 = (two_adj_digits_are_same, never_decrease)
rules2 = (two_adj_digits_are_same, never_decrease, exactly_two)

# run program
part1() = count_passwords(138307, 654504, rules1)
part2() = count_passwords(138307, 654504, rules2)

# for unit testing only
check(v, rules) = count_passwords(v, v, rules) > 0

# alternative implementation

# uses generator comprehension... slower than for-loop though.
count_passwords_b(i, j, rules) = 
    count(true 
        for v in i:j 
        if all(f(reverse(digits(v))) for f in rules))
    
part2b() = count_passwords_b(138307, 654504, rules2) 

count_passwords_c(i, j, rules) = 
    count(v -> all(f(reverse(digits(v))) for f in rules), i:j)
    
part2c() = count_passwords_c(138307, 654504, rules2) 

# d) Michael K. Borregaard
ispass(dif) = any(==(0), dif) && all(>=(0), dif)
ispassword(num) = ispass(diff(reverse(digits(num))))
part1d() = count(ispassword, 138307:654504)

end # module
