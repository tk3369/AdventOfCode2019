# old code -- pretty convoluted due to the use of sparse array

export parse_line, make_board, solve, main, visualize

using Test
using SparseArrays
using Plots
using UnicodePlots

struct Op
    direction::Symbol
    distance::Int
end

mutable struct Board
    M::SparseMatrixCSC{Int,Int}
    curr_x::Int
    curr_y::Int
    orig_x::Int
    orig_y::Int
end

"Parse a single operation e.g. R80 => Op(:R, 80)"
parse_command(str) = Op(Symbol(str[1]), parse(Int, str[2:end]))

"Parse a single line instructions into a vector of Op's"
parse_line(str) = parse_command.(split(str, ","))

"Parse a file into an array of line instructions"
parse_file(path) = parse_line.(readlines(path))

function make_board(x = 50_000, y = 50_000)
    M = spzeros(100_000, 100_000)
    M[x,y] = 1
    return Board(M, x, y, x, y)
end

function go_home!(board)
    board.curr_x = board.orig_x
    board.curr_y = board.orig_y
    board.M[board.orig_x, board.orig_y] += 1
end

function flood!(board, ops::Vector{Op}, val::Int)
    for op ∈ ops
        x, y, M = board.curr_x, board.curr_y, board.M
        if op.direction === :U
            for dy in 1:op.distance
                if M[x, y+dy] == 0      # marking
                    M[x, y+dy] = val
                elseif M[x, y+dy] > 0   # crossing
                    M[x, y+dy] = 99
                end
            end
            board.curr_y += op.distance
        elseif op.direction === :D
            for dy in 1:op.distance
                if M[x, y-dy] == 0      # marking
                    M[x, y-dy] = val
                elseif M[x, y-dy] > 0   # crossing
                    M[x, y-dy] = 99
                end
            end
            board.curr_y -= op.distance
        elseif op.direction === :L
            for dx in 1:op.distance
                if M[x-dx, y] == 0      # marking
                    M[x-dx, y] = val
                elseif M[x-dx, y] > 0   # crossing
                    M[x-dx, y] = 99
                end
            end
            board.curr_x -= op.distance
        elseif op.direction === :R
            for dx in 1:op.distance
                if M[x+dx, y] == 0      # marking
                    M[x+dx, y] = val
                elseif M[x+dx, y] > 0   # crossing
                    M[x+dx, y] = 99
                end
            end
            board.curr_x += op.distance
        else
            error("Bad direction: $(op.direction)")
        end
    end
end

function visualize(board)
    I, J, V = findnz(board.M)
    scatterplot(I, J)
end

function flood!(board, ops1, ops2)
    flood!(board, ops1, 1)
    go_home!(board)
    flood!(board, ops2, 2)
    return board
end

function intersection_points(board)
    I, J, V = findnz(board.M)
    P = V .== 99
    return [I[P] J[P]]
end

function distances(board)
    ip = intersection_points(board)
    println(ip)
    [abs(board.orig_x - v[1]) + abs(board.orig_y - v[2]) for v in eachrow(ip)]
end

function solve(board)
    @show sorted_distances = distances(board) |> sort
    return sorted_distances[2]   # not sure why we need the 2nd one :-(
end

main(ops1::String, ops2::String) = main(parse_line(ops1), parse_line(ops2))

function main(ops1::Vector{Op}, ops2::Vector{Op})
    board = make_board()
    flood!(board, ops1, ops2)
    @show solve(board)
    return board
end

function main()
    ops1, ops2 = parse_file("input.txt")
    main(ops1, ops2)
end

