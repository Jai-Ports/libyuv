// Generated directly from C++ by cpp_transpiler.
HammingDistance_C :: (src_a: *u8, src_b: *u8, count: s32) -> u32 {
    diff: u32 = 0;

    i: s32 = 0;
    while i < count - 3 {
        x := (cast(*u32) src_a).* ^ (cast(*u32) src_b).*;
        u := x - x >> 1 & 0x55555555;
        u = (u >> 2 & 0x33333333) + u & 0x33333333;
        diff += (((u + u >> 4) & 0xf0f0f0f) * 0x1010101) >> 24;
        src_a += 4;
        src_b += 4;
        i += 4;
    }

    while i < count {
        x := cast,no_check(u32) ((cast(s32) src_a.*) ^ cast(s32) src_b.*);
        u := x - x >> 1 & 0x55;
        u = (u >> 2 & 0x33) + u & 0x33;
        diff += (u + u >> 4) & 0xf;
        src_a += 1;
        src_b += 1;
        i += 1;
    }

    return diff;
}

SumSquareError_C :: (src_a: *u8, src_b: *u8, count: s32) -> u32 {
    sse: u32 = 0;

    if 0 < count {
        for i: 0..count - 1 {
            diff := (cast(s32) src_a[i]) - cast(s32) src_b[i];
            sse += cast,no_check(u32) (diff * diff);
        }
    }
    return sse;
}

HashDjb2_C :: (src: *u8, count: s32, seed: u32) -> u32 {
    hash := seed;

    if 0 < count {
        for i: 0..count - 1 {
            hash += hash << 5 + cast(u32) src[i];
        }
    }
    return hash;
}

