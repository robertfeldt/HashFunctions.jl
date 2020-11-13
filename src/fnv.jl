# From https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function
#algorithm fnv-1 is
# hash := FNV_offset_basis
#    for each byte_of_data to be hashed do
#        hash := hash × FNV_prime
#        hash := hash XOR byte_of_data
#    return hash
#and fnv-1a is the same but with switched order of statements
#in loop body.

const FNV_Primes = Dict(
    32 => UInt32(0x01000193),
    64 => UInt64(0x00000100000001B3),
    128 => UInt128(0x0000000001000000000000000000013B)
)    
#const FNV_Prime_256 = parse(BigInt, "374144419156711147060143317175368453031918731002211")

const FNV_Offsets = Dict(
    32 => UInt32(0x811c9dc5),
    64 => UInt64(0xcbf29ce484222325),
    128 => UInt128(0x6c62272e07bb014262b821756295c58d)
)

abstract type AbstractHashFunction{B} end

@inline unsafe_calcwithoffset(hf::AbstractHashFunction, unp::Ptr, len::Integer, offset::Integer = 0) =
    unsafe_calc(hf, reinterpret(Ptr{UInt8}, unp) + offset, len)

@inline calc(hf::AbstractHashFunction, bytes::Vector{UInt8}) =
    unsafe_calc(hf, pointer(bytes), length(bytes))

@inline calc(hf::AbstractHashFunction, s::String) =
    unsafe_calc(hf, pointer(s), length(s))

@inline unsafe_calc(hf::AbstractHashFunction, s::String, offset::Integer, len::Integer) =
    unsafe_calcwithoffset(hf, pointer(s), len, offset)

@inline function calc(hf::AbstractHashFunction, s::String, offset::Integer, len::Integer)
    @assert (offset + len) <= length(s)
    unsafe_calc(hf, s, offset, len)
end

const HashLenToType = Dict(
    32 => UInt32,
    64 => UInt64,
    128 => UInt128
)

struct FNV1A{B,T} <: AbstractHashFunction{B}
    offset::T
    prime::T
end

function unsafe_calc(hf::FNV1A, pnt::Ptr{UInt8}, len::Integer, hash = hf.offset)
    for i in 1:len
        hash = xor(hash, unsafe_load(pnt))
        hash = hash * hf.prime
        pnt += 1
    end
    hash
end

struct FNV1{B,T} <: AbstractHashFunction{B}
    offset::T
    prime::T
end

function unsafe_calc(hf::FNV1, pnt::Ptr{UInt8}, len::Integer, hash = hf.offset)
    for i in 1:len
        hash = hash * hf.prime
        hash = xor(hash, unsafe_load(pnt))
        pnt += 1
    end
    hash
end

function FNVHash(HT, hlen::Integer)
    @assert in(hlen, keys(HashLenToType))
    T = HashLenToType[hlen]
    HT{hlen, T}(FNV_Offsets[hlen], FNV_Primes[hlen])
end

FNV1A(hlen::Integer) = FNVHash(FNV1A, hlen)
FNV1(hlen::Integer) = FNVHash(FNV1, hlen)