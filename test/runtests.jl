using Test
using Hexdump

include("ExceptionTests.jl")

@testset "exception test" for test_val in ExceptionTests.possible_tests
    ExceptionTests.run_variant_test(test_val) 
end