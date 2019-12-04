module Day3

export part1, part2
export closest_point, shortest_distance

struct Op
    direction::Symbol
    distance::Int
end

"Parse a single operation e.g. R80 => Op(:R, 80)"
parse_command(str) = Op(Symbol(str[1]), parse(Int, str[2:end]))

"Parse a single line instructions into a vector of Op's"
parse_line(str) = parse_command.(split(str, ","))

"Parse a file into an array of line instructions"
parse_file(path) = parse_line.(readlines(path))

function points(ops::Vector{Op})
    d = Dict{Tuple{Int,Int}, Int}()
    x = 0
    y = 0
    steps = 0
    for op in ops
        if op.direction === :U
            for i in 1:op.distance
                steps += 1
                d[(x,y+i)] = steps
            end
            y += op.distance
        elseif op.direction === :D
            for i in 1:op.distance
                steps += 1
                d[(x,y-i)] = steps
            end
            y -= op.distance
        elseif op.direction === :L
            for i in 1:op.distance
                steps += 1
                d[(x-i,y)] = steps
            end
            x -= op.distance
        elseif op.direction === :R
            for i in 1:op.distance
                steps += 1
                d[(x+i,y)] = steps
            end
            x += op.distance
        end
    end
    return d
end

closest_point(s1::String, s2::String) = 
    closest_point(parse_line(s1), parse_line(s2))

function closest_point(ops1::Vector{Op}, ops2::Vector{Op})
    p1 = points(ops1)
    p2 = points(ops2)
    cross = intersect(keys(p1), keys(p2))
    # @show cross
    minimum([abs(v[1]) + abs(v[2]) for v in cross])
end

shortest_distance(s1::String, s2::String) = 
    shortest_distance(parse_line(s1), parse_line(s2))

function shortest_distance(ops1::Vector{Op}, ops2::Vector{Op})
    p1 = points(ops1)
    p2 = points(ops2)
    cross = intersect(keys(p1), keys(p2))
    minimum([p1[k] + p2[k] for k in cross])
end

# global variables
ops1, ops2 = parse_file(joinpath(dirname(@__FILE__), "..", "input.txt"))

part1() = closest_point(ops1, ops2)
part2() = shortest_distance(ops1, ops2)

end # module
