cd("/Users/tomkwong/iCloudDocs/AdventOfCode2019")

# read code page
code = parse.(Int, split(readline("day02_input.txt"), ","))

# use 0-based indexing
using OffsetArrays
code = OffsetArray(code, 0:length(code)-1)

# replace the values from these two positions per instruction
code[1] = 12
code[2] = 2

# part 1
function run(code)
    for i in 0:4:length(code)-1
        op = code[i]
        # println("executing $op at position $i")
        if op == 1
            p1, p2, p3 = code[i+1], code[i+2], code[i+3]
            code[p3] = code[p1] + code[p2]
        elseif op == 2
            p1, p2, p3 = code[i+1], code[i+2], code[i+3]
            code[p3] = code[p1] * code[p2]
        elseif op == 99
            return code[0]
        else
            error("unknown op code $op")
        end
    end
    error("ending program without op code 99... :-(")
end
run(code)

# part 2
function make_code(orig_code, noun, verb)
    c = OffsetArray(copy(orig_code), 0:length(code)-1)
    c[1] = noun
    c[2] = verb
    return c
end

function find_solution(code, target) 
    for noun = 0:99, verb = 0:99
        result = make_code(code, noun, verb) |> run
        if result == target 
            return (noun = noun, verb = verb)
        end
    end
    error("Cannot find any solution for target $target")
end

code = parse.(Int, split(readline("day02_input.txt"), ","))
n, v = find_solution(code, 19690720)
println("Solution: ", n * 100 + v)

# ------------------------------------------------
# Part 1 - recursion + dispatch

function run(code, i = 0)
    op = code[i]
    op == 99 && return code[0]
    execute!(Val(op), code, code[i+1:i+3]...)
    run(code, i+4)
end

execute!(::Val{1}, code, p1, p2, p3) =
    code[p3] = code[p1] + code[p2]

execute!(::Val{2}, code, p1, p2, p3) =
    code[p3] = code[p1] * code[p2]

code = parse.(Int, split(readline("day02_input.txt"), ","))
make_code(code, 12, 2) |> run

# Iterative version

function run_iteratively(code)
    i = 0
    while code[i] != 99
        op = code[i]
        execute!(Val(op), code, code[i+1:i+3]...)
        i += 4
    end
    return code[0]
end

code = make_code(12, 2)
run_iteratively(code)
