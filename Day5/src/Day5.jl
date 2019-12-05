module Day5

export part1, part2

using OffsetArrays
using Test

# numer of args for each op code
oplen = Dict(
    1 => 3, 2 => 3, 3 => 1, 4 => 1,   # part1
    5 => 2, 6 => 2, 7 => 3, 8 => 3,   # part2
)

function read_code(s)
    code = parse.(Int, split(s, ","))
    return OffsetArray(code, 0:length(code)-1)
end

function run(code, input, output = [], i = 0)
    instruction = code[i]
    
    op = instruction % 100      # rightmost two digits
    opmode = instruction ÷ 100  # shift right by two digits

    # Exit program and return collected output numbers
    op == 99 && return join(output, "")

    argc = oplen[op]
    if op ∈ (5,6)
        j = shouldjump(Val(op), Val(opmode), code, code[i+1], code[i+2])
        j[1] == :jump ?
            run(code, input, output, j[2]) :
            run(code, input, output, i + argc + 1)
    else
        execute!(Val(op), Val(opmode), input, output, code, code[i+1:i+argc]...)
        run(code, input, output, i + argc + 1)
    end
end

execute!(::Val{1}, ::Val{000}, input, output, code, p1, p2, p3) = code[p3] = code[p1] + code[p2]
execute!(::Val{1}, ::Val{001}, input, output, code, p1, p2, p3) = code[p3] = p1       + code[p2]
execute!(::Val{1}, ::Val{010}, input, output, code, p1, p2, p3) = code[p3] = code[p1] + p2
execute!(::Val{1}, ::Val{011}, input, output, code, p1, p2, p3) = code[p3] = p1       + p2

execute!(::Val{2}, ::Val{000}, input, output, code, p1, p2, p3) = code[p3] = code[p1] * code[p2]
execute!(::Val{2}, ::Val{001}, input, output, code, p1, p2, p3) = code[p3] = p1       * code[p2]
execute!(::Val{2}, ::Val{010}, input, output, code, p1, p2, p3) = code[p3] = code[p1] * p2
execute!(::Val{2}, ::Val{011}, input, output, code, p1, p2, p3) = code[p3] = p1       * p2

execute!(::Val{3}, ::Val{000}, input, output, code, p1) = code[p1] = input

execute!(::Val{4}, ::Val{000}, input, output, code, p1) = push!(output, code[p1])
execute!(::Val{4}, ::Val{001}, input, output, code, p1) = push!(output, p1)

# part2
shouldjump(::Val{5}, ::Val{000}, code, p1, p2) = code[p1] != 0 ? (:jump, code[p2]) : (:next,)
shouldjump(::Val{5}, ::Val{001}, code, p1, p2) = p1 != 0       ? (:jump, code[p2]) : (:next,)
shouldjump(::Val{5}, ::Val{010}, code, p1, p2) = code[p1] != 0 ? (:jump, p2)       : (:next,)
shouldjump(::Val{5}, ::Val{011}, code, p1, p2) = p1 != 0 ?       (:jump, p2)       : (:next,)

shouldjump(::Val{6}, ::Val{000}, code, p1, p2) = code[p1] == 0 ? (:jump, code[p2]) : (:next,)
shouldjump(::Val{6}, ::Val{001}, code, p1, p2) = p1 == 0       ? (:jump, code[p2]) : (:next,)
shouldjump(::Val{6}, ::Val{010}, code, p1, p2) = code[p1] == 0 ? (:jump, p2)       : (:next,)
shouldjump(::Val{6}, ::Val{011}, code, p1, p2) = p1 == 0       ? (:jump, p2)       : (:next,)

execute!(::Val{7}, ::Val{000}, input, output, code, p1, p2, p3) = code[p3] = code[p1] < code[p2] ? 1 : 0
execute!(::Val{7}, ::Val{001}, input, output, code, p1, p2, p3) = code[p3] = p1       < code[p2] ? 1 : 0
execute!(::Val{7}, ::Val{010}, input, output, code, p1, p2, p3) = code[p3] = code[p1] < p2       ? 1 : 0
execute!(::Val{7}, ::Val{011}, input, output, code, p1, p2, p3) = code[p3] = p1       < p2       ? 1 : 0

execute!(::Val{8}, ::Val{000}, input, output, code, p1, p2, p3) = code[p3] = code[p1] == code[p2] ? 1 : 0
execute!(::Val{8}, ::Val{001}, input, output, code, p1, p2, p3) = code[p3] = p1       == code[p2] ? 1 : 0
execute!(::Val{8}, ::Val{010}, input, output, code, p1, p2, p3) = code[p3] = code[p1] == p2       ? 1 : 0
execute!(::Val{8}, ::Val{011}, input, output, code, p1, p2, p3) = code[p3] = p1       == p2       ? 1 : 0

part1() = run(read_code(readline("input.txt")), 1)

part2_test1() = let s = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
    @test run.(Ref(read_code(s)), 1:7) == repeat(["999"], 7)
    @test run(read_code(s), 8) == "1000"
    @test run.(Ref(read_code(s)), 9:10) == repeat(["1001"], 2)
end

part2() = run(read_code(readline("input.txt")), 5)

end