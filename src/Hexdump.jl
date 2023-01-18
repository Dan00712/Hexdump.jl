module Hexdump

export hexdump

const AbstractStrOrIO = Union{AbstractString, IO}


"""
    hexdump([output = stdout,] input, offset = 0, line_count = :all)

        output      ::Union{IO, AbstractString}
        intput      ::Union{IO, AbstractString}
        offset      ::Int
        line_count  ::Union{Symbol, Int}

The `hexdump` functions reads the raw bytes of `input` and prints the hexdump output to `output`, which defaults to stdout. 
`input` can be a subtype of IO or point to a file, which will be used as the source. 
`output` may also be a subtype of IO or point to a file, if the file is not present it will be created.  

When reading the function will skip `offset` bytes, before actualy printing to `output`.  
If `line_count` is set to `:all` the `hexdump` function will not stop until eof is reached,
when setting `line_count` to an integer, the function will also stop after `line_count` lines have been printed.
"""
hexdump(input::AbstractStrOrIO, offset::Int = 0, line_count = :all)::Nothing = hexdump(stdout, input, offset, line_count)

function hexdump(output::IO, input::IO, )::IO
    return hexdump(output, input, 0, :all)
end

function hexdump(output::AbstractString, input::AbstractStrOrIO, offset::Int = 0, line_count = :all)::Nothing
    open(output, write = true) do f
        hexdump(f, input, offset, line_count)
    end
    nothing
end

function hexdump(output::IO, input::AbstractString, offset::Int=0, line_count = :all)::IO
    open(input) do f
        hexdump(output, f, offset, line_count)
    end
    return output
end


function hexdump(output::IO, f::IO, offset::Int, line_count::Symbol = :all)::IO
    read(f, offset)
        
    position = offset
    lineC = 0
    while !eof(f)
        buffer = read(f, 16)
        __print_line(output, position, buffer)

        lineC += 1
        position += 16
    end
    return output
end

function hexdump(output::IO, f::IO, offset::Int, line_count::Int)::IO
    read(f, offset)
        
    position = offset
    lineC = 0
    while !eof(f) && lineC < line_count
        buffer = read(f, 16)
        __print_line(output, position, buffer)
        lineC += 1
        position += 16
    end

    return output
end

#= Utility functions that are delegated to =#

function __print_line(out::IO, adr::Integer, bytes::Vector{UInt8})::Nothing
    __print_adrexprefix(out, adr)
    __print_midsegment(out, bytes)
    __print_endstring(out, bytes)
end

function __print_adrexprefix(out::IO, adr::Integer)
    adr_hex = string(adr, base=16) |>
        x-> lpad(x, 8, "0") |>
        x-> "0x" * x
    
    print(out, "0x$adr_hex   ")
end

function __print_midsegment(out::IO, bytes::Vector{UInt8})::Nothing
    for (i, byte) in enumerate(bytes)
        print(out, "$(__convert_byte(byte)) ")
        
        if i == 8
            print(out, " ")
        end
    end

    for i in length(bytes):16
        print(out, "   ")
        if i == 8
            print(out, " ")
        end
    end
    print(out, "  ")
end

function __print_endstring(out::IO, bytes::Vector{UInt8})::Nothing
    __filter_byte.(bytes) |> 
        String |>
        s-> println(out, s)
end

__filter_byte(byte::UInt8) = if byte > 32 && byte < 127 Char(byte) else '.' end
__convert_byte(byte::UInt8) = 
    string(byte, base=16) |> 
        x-> lpad(x, 2, "0")

end
