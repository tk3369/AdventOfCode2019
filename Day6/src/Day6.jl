module Day6

using Test

export part1, part2
export objects, build_sys, orbits, total_orbits, paths, distance, test_objects, part2_test

# Part 1

"Read file.  Split lines by ) character"
read_file(filename) = split.(readlines(filename), ")")

"Read a set of objects from the input file."
objects() = read_file("input.txt")

"Build the orbit system, which is just a dictionary."
build_sys(objects) = Dict(x[2] => x[1] for x in objects)

"Is it the center of mass?"
is_center(s) = s == "COM"

"Number of orbits from object `s`"
orbits(s, sys, acc=0) = haskey(sys, s) ? orbits(sys[s], sys, acc+1) : acc

"Total number of objects in the system."
total_orbits(sys) = sum(orbits(s, sys) for s in keys(sys) if !is_center(s))

"Calculate total number of orbits in the system."
part1() = total_orbits(build_sys(objects()))

# Part 2

"Obtain a path of orbits from object `s` in system `sys`."
paths(s, sys, acc=String[]) = haskey(sys, s) ? paths(sys[s], sys, push!(acc, sys[s])) : acc

"Return distance of object `s` from the beginning of a path."
distance(s, path) = findfirst(isequal(s), path)

"Find minimum number of transfers such that YOU to SAN are in the same orbit."
function transfers(you="YOU", san="SAN", sys=build_sys(objects()))
    pyou = paths(you, sys)
    psan = paths(san, sys)
    z = typemax(Int)
    for (i, object) in enumerate(pyou)
        d = distance(object, psan)
        z = d !== nothing ? min(z, d + i - 2) : z   # minuns 2 edges 
    end
    return z
end

part2() = transfers()

# test cases
test_objects() = read_file("input_test2.txt")
part2_test() = @test 4 == transfers("YOU", "SAN", build_sys(test_objects()))

end # module