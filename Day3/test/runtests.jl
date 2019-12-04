using Day3
using Test

@testset "Day3.jl" begin

    # part 1
    @test closest_point("R8,U5,L5,D3", "U7,R6,D4,L4") === 6

    @test closest_point(
        "R75,D30,R83,U83,L12,D49,R71,U7,L72", 
        "U62,R66,U55,R34,D71,R55,D58,R83") === 159

    @test closest_point(
        "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", 
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7") === 135

    # part 2
    @test shortest_distance(
        "R75,D30,R83,U83,L12,D49,R71,U7,L72",
        "U62,R66,U55,R34,D71,R55,D58,R83") === 610 

    @test shortest_distance(
        "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7") === 410 
    
end
