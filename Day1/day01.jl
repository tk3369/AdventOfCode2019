using Formatting
using Test

cd("/Users/tomkwong/iCloudDocs/AdventOfCode2019")

# functional pipe
fuel = readlines("day01_input.txt") .|>
    mass -> parse(Int, mass) .|>
    mass -> floor(mass / 3) - 2 

# Part 1
fuel_per_mass(mass) = floor(mass / 3) - 2
masses = parse.(Int, readlines("day01_input.txt"))
fuel = fuel_per_mass.(masses)
total_fuel = sum(fuel)
printfmtln("Total fuel: {:10.2f}", total_fuel)

# Part 2
function total_fuel_per_mass(mass, total=0)
    new_fuel = fuel_per_mass(mass)
    if new_fuel > 0
        return total_fuel_per_mass(new_fuel, total + new_fuel)
    else
        return total
    end
end 
@test total_fuel_per_mass(14) == 2
@test total_fuel_per_mass(1969) == 966
@test total_fuel_per_mass(100756) == 50346

fuel2 = total_fuel_per_mass.(masses)
total_fuel2 = sum(fuel2)
printfmtln("Total fuel: {:10.2f}", total_fuel2)
