#load "cpp_transpiler_runtime.jai";

K_MAX_PSNR: s32;

CC2: s64;

CC1: s64;

K_CPU_INITIALIZED: s32;

K_CPU_HAS_ARM: s32;

K_CPU_HAS_NEON: s32;

K_CPU_HAS_NEON_DOT_PROD: s32;

K_CPU_HAS_NEON_I8_MM: s32;

K_CPU_HAS_SVE: s32;

K_CPU_HAS_SVE2: s32;

K_CPU_HAS_SME: s32;

K_CPU_HAS_SME2: s32;

K_CPU_HAS_SVEF32_MM: s32;

K_CPU_HAS_RISCV: s32;

K_CPU_HAS_RVV: s32;

K_CPU_HAS_RVVZVFH: s32;

K_CPU_HAS_X86: s32;

K_CPU_HAS_SSE2: s32;

K_CPU_HAS_SSSE3: s32;

K_CPU_HAS_SSE41: s32;

K_CPU_HAS_SSE42: s32;

K_CPU_HAS_AVX: s32;

K_CPU_HAS_AVX2: s32;

K_CPU_HAS_ERMS: s32;

K_CPU_HAS_FSMR: s32;

K_CPU_HAS_FMA3: s32;

K_CPU_HAS_F16_C: s32;

K_CPU_HAS_AVX512_BW: s32;

K_CPU_HAS_AVX512_VL: s32;

K_CPU_HAS_AVX512_VNNI: s32;

K_CPU_HAS_AVX512_VBMI: s32;

K_CPU_HAS_AVX512_VBMI2: s32;

K_CPU_HAS_AVX512_VBITALG: s32;

K_CPU_HAS_AVX10: s32;

K_CPU_HAS_AVX10_2: s32;

K_CPU_HAS_AVXVNNI: s32;

K_CPU_HAS_AVXVNNIINT8: s32;

K_CPU_HAS_AMXINT8: s32;

K_CPU_HAS_AVX512_BMM: s32;

K_CPU_HAS_LOONGARCH: s32;

K_CPU_HAS_LSX: s32;

K_CPU_HAS_LASX: s32;

hash_djb2 :: (src: *u8, count: u64, seed: u32) -> u32 {
    K_BLOCK_SIZE: s32 = (cast(s32) 1) << 15;

    hash_djb2_sse: #type (_: *u8, _: s32, _: u32) -> u32 =
        cast,no_check(#type (_: *u8, _: s32, _: u32) -> u32) HashDjb2_C;

    while count >= cast,no_check(u64) K_BLOCK_SIZE {
        seed = hash_djb2_sse(src, K_BLOCK_SIZE, seed);
        src += K_BLOCK_SIZE;
        count -= cast,no_check(u64) K_BLOCK_SIZE;
    }
    remainder := (cast,no_check(s32) count) & ~(cast(s32) 15);
    if remainder != 0 {
        seed = hash_djb2_sse(src, remainder, seed);
        src += remainder;
        count -= cast,no_check(u64) remainder;
    }
    remainder = (cast,no_check(s32) count) & 15;
    if remainder != 0 {
        seed = HashDjb2_C(src, remainder, seed);
    }
    return seed;
}

compute_hamming_distance :: (src_a: *u8, src_b: *u8, count: s32) -> u64 {
    K_BLOCK_SIZE: s32 = (cast(s32) 1) << 15;
    K_SIMD_SIZE: s32 = 64;

    remainder := count & (K_BLOCK_SIZE - 1) & ~(K_SIMD_SIZE - 1);
    diff: u64 = 0;

    hamming_distance: #type (_: *u8, _: *u8, _: s32) -> u32 =
        cast,no_check(#type (_: *u8, _: *u8, _: s32) -> u32) HammingDistance_C;

    i: s32 = 0;
    while i < count - (K_BLOCK_SIZE - 1) {
        diff += cast,no_check(u64) hamming_distance(src_a + i, src_b + i, K_BLOCK_SIZE);
        i += K_BLOCK_SIZE;
    }
    src_a += count & ~(K_BLOCK_SIZE - 1);
    src_b += count & ~(K_BLOCK_SIZE - 1);
    if remainder != 0 {
        diff += cast,no_check(u64) hamming_distance(src_a, src_b, remainder);
        src_a += remainder;
        src_b += remainder;
    }
    remainder = count & (K_SIMD_SIZE - 1);
    if remainder != 0 {
        diff += cast,no_check(u64) HammingDistance_C(src_a, src_b, remainder);
    }
    return diff;
}

argb_detect :: (argb: *u8, stride_argb: s32, width: s32, height: s32) -> u32 {
    fourcc: u32 = 0;

    if argb == null || width <= 0 || height <= 0 {
        return fourcc;
    }

    if stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        stride_argb = 0;
    }
    h: s32 = 0;
    while h < height && fourcc == 0 {
        fourcc = argb_detect_row_c(argb, width);
        argb += stride_argb;
        h += 1;
    }
    return fourcc;
}

argb_detect_row_c :: (argb: *u8, width: s32) -> u32 {
    x: s32 = 0;
    while x < width - 1 {
        if argb[0] != 255 {
            return cast,no_check(u32) FOURCC_BGRA;
        }
        if argb[3] != 255 {
            return cast,no_check(u32) FOURCC_ARGB;
        }
        if argb[4] != 255 {
            return cast,no_check(u32) FOURCC_BGRA;
        }
        if argb[7] != 255 {
            return cast,no_check(u32) FOURCC_ARGB;
        }
        argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        if argb[0] != 255 {
            return cast,no_check(u32) FOURCC_BGRA;
        }
        if argb[3] != 255 {
            return cast,no_check(u32) FOURCC_ARGB;
        }
    }
    return 0;
}

compute_sum_square_error :: (src_a: *u8, src_b: *u8, count: s32) -> u64 {
    K_BLOCK_SIZE: s32 = 65536;
    remainder := count & (K_BLOCK_SIZE - 1) & ~(cast(s32) 31);
    sse: u64 = 0;

    sum_square_error: #type (_: *u8, _: *u8, _: s32) -> u32 =
        cast,no_check(#type (_: *u8, _: *u8, _: s32) -> u32) SumSquareError_C;

    i: s32 = 0;
    while i < count - (K_BLOCK_SIZE - 1) {
        sse += cast,no_check(u64) sum_square_error(src_a + i, src_b + i, K_BLOCK_SIZE);
        i += K_BLOCK_SIZE;
    }
    src_a += count & ~(K_BLOCK_SIZE - 1);
    src_b += count & ~(K_BLOCK_SIZE - 1);
    if remainder != 0 {
        sse += cast,no_check(u64) sum_square_error(src_a, src_b, remainder);
        src_a += remainder;
        src_b += remainder;
    }
    remainder = count & 31;
    if remainder != 0 {
        sse += cast,no_check(u64) SumSquareError_C(src_a, src_b, remainder);
    }
    return sse;
}

compute_sum_square_error_plane :: (
    src_a: *u8,
    stride_a: s32,
    src_b: *u8,
    stride_b: s32,
    width: s32,
    height: s32
) -> u64 {
    sse: u64 = 0;

    if src_a == null || src_b == null || width <= 0 || height <= 0 {
        return sse;
    }

    if stride_a == width && stride_b == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        stride_b = 0;
        stride_a = stride_b;
    }
    if 0 < height {
        for h: 0..height - 1 {
            sse += compute_sum_square_error(src_a, src_b, width);
            src_a += stride_a;
            src_b += stride_b;
        }
    }
    return sse;
}

sum_square_error_to_psnr :: (sse: u64, count: u64) -> float64 {
    psnr: float64 = ---;
    if sse > 0 {
        mse := (cast,no_check(float64) count) / cast,no_check(float64) sse;
        psnr = 10.0 * c_transpiler_math_log10(65025.0 * mse);
    } else {
        psnr = 128.0;
    }

    if c_transpiler_float_greater(psnr, 128.0) {
        psnr = 128.0;
    }

    return psnr;
}

calc_frame_psnr :: (src_a: *u8, stride_a: s32, src_b: *u8, stride_b: s32, width: s32, height: s32) -> float64 {
    SAMPLES := (cast,no_check(u64) width) * cast,no_check(u64) height;
    SSE := compute_sum_square_error_plane(src_a, stride_a, src_b, stride_b, width, height);
    return sum_square_error_to_psnr(SSE, SAMPLES);
}

i420_psnr :: (
    src_y_a: *u8,
    stride_y_a: s32,
    src_u_a: *u8,
    stride_u_a: s32,
    src_v_a: *u8,
    stride_v_a: s32,
    src_y_b: *u8,
    stride_y_b: s32,
    src_u_b: *u8,
    stride_u_b: s32,
    src_v_b: *u8,
    stride_v_b: s32,
    width: s32,
    height: s32
) -> float64 {
    SSE_Y := compute_sum_square_error_plane(src_y_a, stride_y_a, src_y_b, stride_y_b, width, height);
    WIDTH_UV := (width + 1) >> 1;
    HEIGHT_UV := (height + 1) >> 1;
    SSE_U := compute_sum_square_error_plane(src_u_a, stride_u_a, src_u_b, stride_u_b, WIDTH_UV, HEIGHT_UV);
    SSE_V := compute_sum_square_error_plane(src_v_a, stride_v_a, src_v_b, stride_v_b, WIDTH_UV, HEIGHT_UV);
    SAMPLES :=
        ((cast,no_check(u64) width) * cast,no_check(u64) height) +
            2 * ((cast,no_check(u64) WIDTH_UV) * cast,no_check(u64) HEIGHT_UV);
    SSE := SSE_Y + SSE_U + SSE_V;
    return sum_square_error_to_psnr(SSE, SAMPLES);
}

calc_frame_ssim :: (src_a: *u8, stride_a: s32, src_b: *u8, stride_b: s32, width: s32, height: s32) -> float64 {
    samples: s32 = 0;
    ssim_total: float64 = 0.0;
    ssim8x8: #type (_: *u8, _: s32, _: *u8, _: s32) -> float64 =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32) -> float64) ssim8x8_c;

    i: s32 = 0;
    while i < height - 8 {
        j: s32 = 0;
        while j < width - 8 {
            ssim_total += ssim8x8(src_a + j, stride_a, src_b + j, stride_b);
            samples += 1;
            j += 4;
        }

        src_a += stride_a * 4;
        src_b += stride_b * 4;
        i += 4;
    }

    ssim_total /= cast,no_check(float64) samples;
    return ssim_total;
}

ssim8x8_c :: (src_a: *u8, stride_a: s32, src_b: *u8, stride_b: s32) -> float64 {
    sum_a: s64 = 0;
    sum_b: s64 = 0;
    sum_sq_a: s64 = 0;
    sum_sq_b: s64 = 0;
    sum_axb: s64 = 0;

    for i: 0..cast(s32) 8 - 1 {
        for j: 0..cast(s32) 8 - 1 {
            sum_a += cast,no_check(s64) src_a[j];
            sum_b += cast,no_check(s64) src_b[j];
            sum_sq_a += cast,no_check(s64) ((cast(s32) src_a[j]) * cast(s32) src_a[j]);
            sum_sq_b += cast,no_check(s64) ((cast(s32) src_b[j]) * cast(s32) src_b[j]);
            sum_axb += cast,no_check(s64) ((cast(s32) src_a[j]) * cast(s32) src_b[j]);
        }

        src_a += stride_a;
        src_b += stride_b;
    }

    {
        COUNT: s64 = 64;

        C1 := ((cast(s64) 26634) * COUNT * COUNT) >> 12;
        C2 := ((cast(s64) 239708) * COUNT * COUNT) >> 12;

        SUM_A_X_SUM_B := sum_a * sum_b;

        SSIM_N := (2 * SUM_A_X_SUM_B + C1) * (2 * COUNT * sum_axb - 2 * SUM_A_X_SUM_B + C2);

        SUM_A_SQ := sum_a * sum_a;
        SUM_B_SQ := sum_b * sum_b;

        SSIM_D := (SUM_A_SQ + SUM_B_SQ + C1) * (COUNT * sum_sq_a - SUM_A_SQ + COUNT * sum_sq_b - SUM_B_SQ + C2);

        if SSIM_D == 0 {
            return 1.7976931348623157e308;
        }
        return (cast,no_check(float64) SSIM_N) / cast,no_check(float64) SSIM_D;
    }
}

i420_ssim :: (
    src_y_a: *u8,
    stride_y_a: s32,
    src_u_a: *u8,
    stride_u_a: s32,
    src_v_a: *u8,
    stride_v_a: s32,
    src_y_b: *u8,
    stride_y_b: s32,
    src_u_b: *u8,
    stride_u_b: s32,
    src_v_b: *u8,
    stride_v_b: s32,
    width: s32,
    height: s32
) -> float64 {
    SSIM_Y := calc_frame_ssim(src_y_a, stride_y_a, src_y_b, stride_y_b, width, height);
    WIDTH_UV := (width + 1) >> 1;
    HEIGHT_UV := (height + 1) >> 1;
    SSIM_U := calc_frame_ssim(src_u_a, stride_u_a, src_u_b, stride_u_b, WIDTH_UV, HEIGHT_UV);
    SSIM_V := calc_frame_ssim(src_v_a, stride_v_a, src_v_b, stride_v_b, WIDTH_UV, HEIGHT_UV);
    return SSIM_Y * 0.8 + 0.1 * (SSIM_U + SSIM_V);
}

test_cpu_flag :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_compare: u32;
initialize_globals_for_compare :: () {
    {
        state := atomic_load(*globals_initialization_state_for_compare);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_compare, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_compare) != 2 {}
            return;
        }
    }
    K_MAX_PSNR = 128;
    K_CPU_INITIALIZED = 0x1;
    K_CPU_HAS_ARM = 0x2;
    K_CPU_HAS_NEON = 0x100;
    K_CPU_HAS_NEON_DOT_PROD = 0x200;
    K_CPU_HAS_NEON_I8_MM = 0x400;
    K_CPU_HAS_SVE = 0x800;
    K_CPU_HAS_SVE2 = 0x1000;
    K_CPU_HAS_SME = 0x2000;
    K_CPU_HAS_SME2 = 0x4000;
    K_CPU_HAS_SVEF32_MM = 0x8000;
    K_CPU_HAS_RISCV = 0x4;
    K_CPU_HAS_RVV = 0x100;
    K_CPU_HAS_RVVZVFH = 0x200;
    K_CPU_HAS_X86 = 0x8;
    K_CPU_HAS_SSE2 = 0x100;
    K_CPU_HAS_SSSE3 = 0x200;
    K_CPU_HAS_SSE41 = 0x400;
    K_CPU_HAS_SSE42 = 0x800;
    K_CPU_HAS_AVX = 0x1000;
    K_CPU_HAS_AVX2 = 0x2000;
    K_CPU_HAS_ERMS = 0x4000;
    K_CPU_HAS_FSMR = 0x8000;
    K_CPU_HAS_FMA3 = 0x10000;
    K_CPU_HAS_F16_C = 0x20000;
    K_CPU_HAS_AVX512_BW = 0x40000;
    K_CPU_HAS_AVX512_VL = 0x80000;
    K_CPU_HAS_AVX512_VNNI = 0x100000;
    K_CPU_HAS_AVX512_VBMI = 0x200000;
    K_CPU_HAS_AVX512_VBMI2 = 0x400000;
    K_CPU_HAS_AVX512_VBITALG = 0x800000;
    K_CPU_HAS_AVX10 = 0x1000000;
    K_CPU_HAS_AVX10_2 = 0x2000000;
    K_CPU_HAS_AVXVNNI = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8 = 0x8000000;
    K_CPU_HAS_AMXINT8 = 0x10000000;
    K_CPU_HAS_AVX512_BMM = 0x20000000;
    K_CPU_HAS_LOONGARCH = 0x20;
    K_CPU_HAS_LSX = 0x100;
    K_CPU_HAS_LASX = 0x200;
    CC1 = 26634;
    CC2 = 239708;
    atomic_store(*globals_initialization_state_for_compare, 2);
}

Four_CC :: s32;
FOURCC_I420 : Four_CC : 808596553;
FOURCC_I422 : Four_CC : 842150985;
FOURCC_I444 : Four_CC : 875836489;
FOURCC_I400 : Four_CC : 808465481;
FOURCC_NV21 : Four_CC : 825382478;
FOURCC_NV12 : Four_CC : 842094158;
FOURCC_NV16 : Four_CC : 909203022;
FOURCC_NV24 : Four_CC : 875714126;
FOURCC_YUY2 : Four_CC : 844715353;
FOURCC_UYVY : Four_CC : 1498831189;
FOURCC_I010 : Four_CC : 808529993;
FOURCC_I210 : Four_CC : 808530505;
FOURCC_M420 : Four_CC : 808596557;
FOURCC_ARGB : Four_CC : 1111970369;
FOURCC_BGRA : Four_CC : 1095911234;
FOURCC_ABGR : Four_CC : 1380401729;
FOURCC_AR30 : Four_CC : 808669761;
FOURCC_AB30 : Four_CC : 808665665;
FOURCC_AR64 : Four_CC : 875975233;
FOURCC_AB64 : Four_CC : 875971137;
FOURCC_24BG : Four_CC : 1195521074;
FOURCC_RAW : Four_CC : 544694642;
FOURCC_RGBA : Four_CC : 1094862674;
FOURCC_RGBP : Four_CC : 1346520914;
FOURCC_RGBO : Four_CC : 1329743698;
FOURCC_R444 : Four_CC : 875836498;
FOURCC_MJPG : Four_CC : 1196444237;
FOURCC_YV12 : Four_CC : 842094169;
FOURCC_YV16 : Four_CC : 909203033;
FOURCC_YV24 : Four_CC : 875714137;
FOURCC_YU12 : Four_CC : 842093913;
FOURCC_J420 : Four_CC : 808596554;
FOURCC_J422 : Four_CC : 842150986;
FOURCC_J444 : Four_CC : 875836490;
FOURCC_J400 : Four_CC : 808465482;
FOURCC_F420 : Four_CC : 808596550;
FOURCC_F422 : Four_CC : 842150982;
FOURCC_F444 : Four_CC : 875836486;
FOURCC_H420 : Four_CC : 808596552;
FOURCC_H422 : Four_CC : 842150984;
FOURCC_H444 : Four_CC : 875836488;
FOURCC_U420 : Four_CC : 808596565;
FOURCC_U422 : Four_CC : 842150997;
FOURCC_U444 : Four_CC : 875836501;
FOURCC_F010 : Four_CC : 808529990;
FOURCC_H010 : Four_CC : 808529992;
FOURCC_U010 : Four_CC : 808530005;
FOURCC_F210 : Four_CC : 808530502;
FOURCC_H210 : Four_CC : 808530504;
FOURCC_U210 : Four_CC : 808530517;
FOURCC_P010 : Four_CC : 808530000;
FOURCC_P210 : Four_CC : 808530512;
FOURCC_IYUV : Four_CC : 1448433993;
FOURCC_YU16 : Four_CC : 909202777;
FOURCC_YU24 : Four_CC : 875713881;
FOURCC_YUYV : Four_CC : 1448695129;
FOURCC_YUVS : Four_CC : 1937143161;
FOURCC_HDYC : Four_CC : 1129923656;
FOURCC_2VUY : Four_CC : 2037741106;
FOURCC_JPEG : Four_CC : 1195724874;
FOURCC_DMB1 : Four_CC : 828534116;
FOURCC_BA81 : Four_CC : 825770306;
FOURCC_RGB3 : Four_CC : 859981650;
FOURCC_BGR3 : Four_CC : 861030210;
FOURCC_CM32 : Four_CC : 536870912;
FOURCC_CM24 : Four_CC : 402653184;
FOURCC_L555 : Four_CC : 892679500;
FOURCC_L565 : Four_CC : 892745036;
FOURCC_5551 : Four_CC : 825570613;
FOURCC_I411 : Four_CC : 825308233;
FOURCC_Q420 : Four_CC : 808596561;
FOURCC_RGGB : Four_CC : 1111967570;
FOURCC_BGGR : Four_CC : 1380403010;
FOURCC_GRBG : Four_CC : 1195528775;
FOURCC_GBRG : Four_CC : 1196573255;
FOURCC_H264 : Four_CC : 875967048;
FOURCC_ANY : Four_CC : -1;

