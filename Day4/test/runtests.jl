using Day4
using Test

@testset "part1" begin
    @test check(111111, rules1) === true
    @test check(223450, rules1) === false
    @test check(123789, rules1) === false
end

@testset "part2" begin
    @test check(112233, rules2) === true
    @test check(123444, rules2) === false
    @test check(111122, rules2) === true
end

@testset "alternative" begin
    @test part2() === part2b()
end

