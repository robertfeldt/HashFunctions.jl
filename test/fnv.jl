using HashFunctions, Test

# from http://www.isthe.com/chongo/src/fnv/test_fnv.c
@testset "FNV1a 32" begin
    hf = FNV1A(32)
    @test calc(hf, "")        == 0x811c9dc5
    @test calc(hf, "a")       == 0xe40c292c
    @test calc(hf, "b")       == 0xe70c2de5
    @test calc(hf, "c")       == 0xe60c2c52
    @test calc(hf, "d")       == 0xe10c2473
    @test calc(hf, "e")       == 0xe00c22e0
    @test calc(hf, "f")       == 0xe30c2799
    @test calc(hf, "fo")      == 0x6222e842
    @test calc(hf, "foo")     == 0xa9f37ed7
    @test calc(hf, "foob")    == 0x3f5076ef
    @test calc(hf, "fooba")   == 0x39aaa18a
    @test calc(hf, "foobar")  == 0xbf9cf968
end

# from http://www.isthe.com/chongo/src/fnv/test_fnv.c
@testset "FNV1 32" begin
    hf = FNV1(32)
    @test calc(hf, "")        == 0x811c9dc5
    @test calc(hf, "a")       == 0x050c5d7e
    @test calc(hf, "b")       == 0x050c5d7d
    @test calc(hf, "c")       == 0x050c5d7c
    @test calc(hf, "d")       == 0x050c5d7b
    @test calc(hf, "e")       == 0x050c5d7a
    @test calc(hf, "f")       == 0x050c5d79
    @test calc(hf, "fo")      == 0x6b772514
    @test calc(hf, "foo")     == 0x408f5e13
    @test calc(hf, "foob")    == 0xb4b1178b
    @test calc(hf, "fooba")   == 0xfdc80fb0
    @test calc(hf, "foobar")  == 0x31f0b262
end

@testset "calcwithoffset equals calc on full string" begin
    for HT in [FNV1, FNV1A]
        hf = HT(32)
        @test calc(hf, "ba", 1, 1) == calc(hf, "a")
        @test calc(hf, "ab", 0, 1) == calc(hf, "a")
        @test calc(hf, "foobar", 0, 1) == calc(hf, "f")
        @test calc(hf, "foobar", 1, 3) == calc(hf, "oob")
        @test calc(hf, "foobar", 2, 2) == calc(hf, "ob")
        @test calc(hf, "foobar", 3, 2) == calc(hf, "ba")
        @test calc(hf, "foobar", 4, 2) == calc(hf, "ar")
        @test_throws AssertionError calc(hf, "foobar", 4, 3)
    end
end