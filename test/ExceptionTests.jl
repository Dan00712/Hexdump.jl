module ExceptionTests
using Test
using Hexdump

SupportedVariants = Union{AbstractString, IO}

possible_tests = [
    Val(:io2io),
    Val(:io2f),
    Val(:f2f),
    Val(:f2io)
] 

function run_variants(output::SupportedVariants, input::SupportedVariants)
    @test hexdump(output, input) isa Any
    @test hexdump(output, input, 0) isa Any
    @test hexdump(output, input, 0, :all) isa Any
    @test hexdump(output, input, 0, 2) isa Any
end

function run_variant_test(::Val{:io2io})
    input = get_testbuffer()
    output = IOBuffer()

    @testset "IO to IO Tests" run_variants(output, input)
end

function run_variant_test(::Val{:f2f})
    input = tempname(@__DIR__)
    output = tempname(@__DIR__)

    open(input, write=true) do f
        write(f, rand(UInt8, 100))
    end
    @testset "File to File Tests" run_variants(output, input)
end

function run_variant_test(::Val{:io2f})
    input = get_testbuffer() 
    output = tempname(@__DIR__)

    @testset "IO to File Tests" run_variants(output, input)
end

function run_variant_test(::Val{:f2io})
    input = tempname(@__DIR__)
    output = IOBuffer()

    open(input, write=true) do f
        write(f, rand(UInt8, 100))
    end
    @testset "File to IO Tests" run_variants(output, input)
end

function get_testbuffer()
    rand(UInt8, 100) |> IOBuffer
end

end