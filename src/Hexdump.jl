module Hexdump

export hexdump

const AbstractStrOrIO = Union{AbstractString, IO}

hexdump(input::AbstractStrOrIO, offset::Int = 0, line_count = :all) = hexdump(stdout, input, offset, line_count)

function hexdump(output::AbstractString, input::AbstractStrOrIO, offset::Int = 0, line_count = :all)
    open(output, write = true) do f
        hexdump(f, input, offset, line_count)
    end
end

function hexdump(output::IO, input::AbstractString, offset::Int, line_count = :all)
    open(input) do f
        hexdump(output, f, offset, line_count)
    end
end

function hexdump(output::IO, f::IO, offset::Int, line_count::Symbol)
    read(f, offset)
        
        position = offset
        lineC = 0
        while !eof(f)
            buffer = read(f, 16)
            __print_line(output, position, buffer)

            lineC += 1
            position += 16
        end
end

function hexdump(output::IO, f::IO, offset::Int, line_count::Int)
    read(f, offset)
        
        position = offset
        lineC = 0
        while !eof(f) && (lineC < line_count || line_count == :all)
            buffer = read(f, 16)
            __print_line(output, position, buffer)

            lineC += 1
            position += 16
        end
end

function __print_line(out::IO, adr::Integer, bytes::Vector{UInt8})
    adr_hex = string(adr, base=16) |>
        x-> lpad(x, 8, "0") |>
        x-> "0x" * x

    eof_reached = length(bytes) < 16
    last_length = length(bytes)
    while length(bytes) < 16
        push!(bytes, 0)
    end

    print(out, "$adr_hex    ")


    str_line = ""
    for (i, byte) in enumerate(bytes)
        byte_hex = __convert_byte(byte)
        
        if i < last_length
            print(out, "$byte_hex ")
        else
            print(out, ".. ")
        end
        if(i == 8)
            print(out, "  ")
        end

        str_line *= __filterbyte(byte)
    end

    println(out, "    $str_line")
end

__filterbyte(byte::UInt8) = if byte > 32 String([byte]) else "." end
__convert_byte(byte::UInt8) = 
    string(byte, base=16) |> 
        x-> lpad(x, 2, "0")

end
