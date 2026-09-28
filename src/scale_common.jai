K_CPU_INITIALIZED_in_scale_common: s32;

K_CPU_HAS_ARM_in_scale_common: s32;

K_CPU_HAS_NEON_in_scale_common: s32;

K_CPU_HAS_NEON_DOT_PROD_in_scale_common: s32;

K_CPU_HAS_NEON_I8_MM_in_scale_common: s32;

K_CPU_HAS_SVE_in_scale_common: s32;

K_CPU_HAS_SVE2_in_scale_common: s32;

K_CPU_HAS_SME_in_scale_common: s32;

K_CPU_HAS_SME2_in_scale_common: s32;

K_CPU_HAS_SVEF32_MM_in_scale_common: s32;

K_CPU_HAS_RISCV_in_scale_common: s32;

K_CPU_HAS_RVV_in_scale_common: s32;

K_CPU_HAS_RVVZVFH_in_scale_common: s32;

K_CPU_HAS_X86_in_scale_common: s32;

K_CPU_HAS_SSE2_in_scale_common: s32;

K_CPU_HAS_SSSE3_in_scale_common: s32;

K_CPU_HAS_SSE41_in_scale_common: s32;

K_CPU_HAS_SSE42_in_scale_common: s32;

K_CPU_HAS_AVX_in_scale_common: s32;

K_CPU_HAS_AVX2_in_scale_common: s32;

K_CPU_HAS_ERMS_in_scale_common: s32;

K_CPU_HAS_FSMR_in_scale_common: s32;

K_CPU_HAS_FMA3_in_scale_common: s32;

K_CPU_HAS_F16_C_in_scale_common: s32;

K_CPU_HAS_AVX512_BW_in_scale_common: s32;

K_CPU_HAS_AVX512_VL_in_scale_common: s32;

K_CPU_HAS_AVX512_VNNI_in_scale_common: s32;

K_CPU_HAS_AVX512_VBMI_in_scale_common: s32;

K_CPU_HAS_AVX512_VBMI2_in_scale_common: s32;

K_CPU_HAS_AVX512_VBITALG_in_scale_common: s32;

K_CPU_HAS_AVX10_in_scale_common: s32;

K_CPU_HAS_AVX10_2_in_scale_common: s32;

K_CPU_HAS_AVXVNNI_in_scale_common: s32;

K_CPU_HAS_AVXVNNIINT8_in_scale_common: s32;

K_CPU_HAS_AMXINT8_in_scale_common: s32;

K_CPU_HAS_AVX512_BMM_in_scale_common: s32;

K_CPU_HAS_LOONGARCH_in_scale_common: s32;

K_CPU_HAS_LSX_in_scale_common: s32;

K_CPU_HAS_LASX_in_scale_common: s32;

test_cpu_flag_in_scale_common :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_scale_common :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

ScalePlaneVertical :: (
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s32,
    dst_stride: s32,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    y: s32,
    dy: s32,
    bpp: s32,
    filtering: Filter_Mode
) {
    dst_width_bytes := dst_width * bpp;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    INTERPOLATE := cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR;
    max_y: s64 = 0;
    if src_height > 1 {
        max_y = ((cast,no_check(s64) src_height) - 1) << 16;
        if INTERPOLATE {
            max_y -= 1;
        }
    }

    INTERPOLATE_STRIDE := cast,no_check(s64) ((ifx INTERPOLATE then src_stride else 0));
    y64 := cast,no_check(s64) y;

    assert(bpp >= 1 && bpp <= 4);
    assert(src_height != 0);
    assert(dst_width > 0);
    assert(dst_height > 0);
    src_argb += x >> 16 * bpp;

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            if y64 > max_y {
                y64 = max_y;
            }
            yi := cast,no_check(s32) (y64 >> 16);
            yf := (ifx INTERPOLATE then cast,no_check(s32) (y64 >> 8 & 255) else 0);
            interpolate_row(
                dst_argb,
                src_argb + (cast(s64) yi) * cast,no_check(s64) src_stride,
                INTERPOLATE_STRIDE,
                dst_width_bytes,
                yf
            );
            dst_argb += dst_stride;
            y64 += cast,no_check(s64) dy;
        }
    }
}

ScalePlaneVertical_16 :: (
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s32,
    dst_stride: s32,
    src_argb: *u16,
    dst_argb: *u16,
    x: s32,
    y: s32,
    dy: s32,
    wpp: s32,
    filtering: Filter_Mode
) {
    dst_width_words := dst_width * wpp;
    interpolate_row: #type (_: *u16, _: *u16, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s64, _: s32, _: s32)) InterpolateRow_16_C;
    INTERPOLATE := cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR;
    max_y: s64 = 0;
    if src_height > 1 {
        max_y = ((cast,no_check(s64) src_height) - 1) << 16;
        if INTERPOLATE {
            max_y -= 1;
        }
    }

    INTERPOLATE_STRIDE := cast,no_check(s64) ((ifx INTERPOLATE then src_stride else 0));
    y64 := cast,no_check(s64) y;

    assert(wpp >= 1 && wpp <= 2);
    assert(src_height != 0);
    assert(dst_width > 0);
    assert(dst_height > 0);
    src_argb += x >> 16 * wpp;

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            if y64 > max_y {
                y64 = max_y;
            }
            yi := cast,no_check(s32) (y64 >> 16);
            yf := (ifx INTERPOLATE then cast,no_check(s32) (y64 >> 8 & 255) else 0);
            interpolate_row(
                dst_argb,
                src_argb + (cast(s64) yi) * cast,no_check(s64) src_stride,
                INTERPOLATE_STRIDE,
                dst_width_words,
                yf
            );
            dst_argb += dst_stride;
            y64 += cast,no_check(s64) dy;
        }
    }
}

ScaleFilterReduce :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> Filter_Mode {
    if src_width < 0 {
        src_width = -src_width;
    }
    if src_height < 0 {
        src_height = -src_height;
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX {
        if ((cast,no_check(s64) dst_width) * 2) >= cast,no_check(s64) src_width ||
            ((cast,no_check(s64) dst_height) * 2) >= cast,no_check(s64) src_height {
            filtering = K_FILTER_BILINEAR;
        }
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR {
        if src_height == 1 {
            filtering = K_FILTER_LINEAR;
        }

        if dst_height == src_height || ((cast,no_check(s64) dst_height) * 3) == cast,no_check(s64) src_height {
            filtering = K_FILTER_LINEAR;
        }

        if src_width == 1 {
            filtering = K_FILTER_NONE;
        }
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        if src_width == 1 {
            filtering = K_FILTER_NONE;
        }

        if dst_width == src_width || ((cast,no_check(s64) dst_width) * 3) == cast,no_check(s64) src_width {
            filtering = K_FILTER_NONE;
        }
    }
    return filtering;
}

FixedDiv_C :: (num: s32, div: s32) -> s32 {
    return cast,no_check(s32) ((cast,no_check(s64) num) << 16 / cast(s64) div);
}

FixedDiv1_C :: (num: s32, div: s32) -> s32 {
    return cast,no_check(s32) (((cast,no_check(s64) num) << 16 - 0x10001) / cast(s64) (div - 1));
}

ScaleSlope :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode,
    x: *s32,
    y: *s32,
    dx: *s32,
    dy: *s32
) {
    assert(x != null);
    assert(y != null);
    assert(dx != null);
    assert(dy != null);
    assert(src_width != 0);
    assert(src_height != 0);
    assert(dst_width > 0);
    assert(dst_height > 0);

    if dst_width == 1 && src_width >= 32768 {
        dst_width = src_width;
    }
    if dst_height == 1 && src_height >= 32768 {
        dst_height = src_height;
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX {
        dx.* = FixedDiv_C(abs_in_scale_common(src_width), dst_width);
        dy.* = FixedDiv_C(src_height, dst_height);
        x.* = 0;
        y.* = 0;
    } else if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR {
        if dst_width <= abs_in_scale_common(src_width) {
            dx.* = FixedDiv_C(abs_in_scale_common(src_width), dst_width);
            x.* = ifx dx.* < 0 then -(-dx.* >> 1 + -32768) else dx.* >> 1 + -32768;
        } else if src_width > 1 && dst_width > 1 {
            dx.* = FixedDiv1_C(abs_in_scale_common(src_width), dst_width);
            x.* = 0;
        }
        if dst_height <= src_height {
            dy.* = FixedDiv_C(src_height, dst_height);
            y.* = ifx dy.* < 0 then -(-dy.* >> 1 + -32768) else dy.* >> 1 + -32768;
        } else if src_height > 1 && dst_height > 1 {
            dy.* = FixedDiv1_C(src_height, dst_height);
            y.* = 0;
        }
    } else if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        if dst_width <= abs_in_scale_common(src_width) {
            dx.* = FixedDiv_C(abs_in_scale_common(src_width), dst_width);
            x.* = ifx dx.* < 0 then -(-dx.* >> 1 + -32768) else dx.* >> 1 + -32768;
        } else if src_width > 1 && dst_width > 1 {
            dx.* = FixedDiv1_C(abs_in_scale_common(src_width), dst_width);
            x.* = 0;
        }
        dy.* = FixedDiv_C(src_height, dst_height);
        y.* = dy.* >> 1;
    } else {
        dx.* = FixedDiv_C(abs_in_scale_common(src_width), dst_width);
        dy.* = FixedDiv_C(src_height, dst_height);
        x.* = ifx dx.* < 0 then -(-dx.* >> 1 + 0) else dx.* >> 1 + 0;
        y.* = ifx dy.* < 0 then -(-dy.* >> 1 + 0) else dy.* >> 1 + 0;
    }

    if src_width < 0 {
        x.* += (dst_width - 1) * dx.*;
        dx.* = -dx.*;
    }
}

abs_in_scale_common :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

ScaleRowDown2_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = src_ptr[1];
        dst[1] = src_ptr[3];
        dst += 2;
        src_ptr += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = src_ptr[1];
    }
}

ScaleRowDown2_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = src_ptr[1];
        dst[1] = src_ptr[3];
        dst += 2;
        src_ptr += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = src_ptr[1];
    }
}

ScaleRowDown2Linear_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);

    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = cast,no_check(u8) ((((cast(s32) s[0]) + cast(s32) s[1]) + 1) >> 1);
        dst[1] = cast,no_check(u8) ((((cast(s32) s[2]) + cast(s32) s[3]) + 1) >> 1);
        dst += 2;
        s += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = cast,no_check(u8) ((((cast(s32) s[0]) + cast(s32) s[1]) + 1) >> 1);
    }
}

ScaleRowDown2Linear_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);

    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = cast,no_check(u16) ((((cast(s32) s[0]) + cast(s32) s[1]) + 1) >> 1);
        dst[1] = cast,no_check(u16) ((((cast(s32) s[2]) + cast(s32) s[3]) + 1) >> 1);
        dst += 2;
        s += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = cast,no_check(u16) ((((cast(s32) s[0]) + cast(s32) s[1]) + 1) >> 1);
    }
}

ScaleRowDown2Box_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));

    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] =
            cast,no_check(u8) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
        dst[1] =
            cast,no_check(u8) ((((((cast(s32) s[2]) + cast(s32) s[3]) + cast(s32) t[2]) + cast(s32) t[3]) +
                2) >> 2);
        dst += 2;
        s += 4;
        t += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] =
            cast,no_check(u8) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
    }
}

ScaleRowDown2Box_Odd_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));

    dst_width -= 1;
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] =
            cast,no_check(u8) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
        dst[1] =
            cast,no_check(u8) ((((((cast(s32) s[2]) + cast(s32) s[3]) + cast(s32) t[2]) + cast(s32) t[3]) +
                2) >> 2);
        dst += 2;
        s += 4;
        t += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] =
            cast,no_check(u8) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
        dst += 1;
        s += 2;
        t += 2;
    }
    dst[0] = cast,no_check(u8) ((((cast(s32) s[0]) + cast(s32) t[0]) + 1) >> 1);
}

ScaleRowDown2Box_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);
    t := cast,no_check(*u16) ((src_ptr + src_stride));

    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] =
            cast,no_check(u16) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
        dst[1] =
            cast,no_check(u16) ((((((cast(s32) s[2]) + cast(s32) s[3]) + cast(s32) t[2]) + cast(s32) t[3]) +
                2) >> 2);
        dst += 2;
        s += 4;
        t += 4;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] =
            cast,no_check(u16) ((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) +
                2) >> 2);
    }
}

ScaleRowDown4_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = src_ptr[2];
        dst[1] = src_ptr[6];
        dst += 2;
        src_ptr += 8;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = src_ptr[2];
    }
}

ScaleRowDown4_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] = src_ptr[2];
        dst[1] = src_ptr[6];
        dst += 2;
        src_ptr += 8;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] = src_ptr[2];
    }
}

ScaleRowDown4Box_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] =
            cast,no_check(u8) ((((((((((((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[3]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 3) + 0]) + cast(s32) src_ptr[(src_stride * 3) + 1]) + cast(s32) src_ptr[(src_stride * 3) + 2]) + cast(s32) src_ptr[(src_stride * 3) + 3]) +
                8) >> 4);
        dst[1] =
            cast,no_check(u8) ((((((((((((((((((cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7]) + cast(s32) src_ptr[(src_stride * 2) + 4]) + cast(s32) src_ptr[(src_stride * 2) + 5]) + cast(s32) src_ptr[(src_stride * 2) + 6]) + cast(s32) src_ptr[(src_stride * 2) + 7]) + cast(s32) src_ptr[(src_stride * 3) + 4]) + cast(s32) src_ptr[(src_stride * 3) + 5]) + cast(s32) src_ptr[(src_stride * 3) + 6]) + cast(s32) src_ptr[(src_stride * 3) + 7]) +
                8) >> 4);
        dst += 2;
        src_ptr += 8;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] =
            cast,no_check(u8) ((((((((((((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[3]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 3) + 0]) + cast(s32) src_ptr[(src_stride * 3) + 1]) + cast(s32) src_ptr[(src_stride * 3) + 2]) + cast(s32) src_ptr[(src_stride * 3) + 3]) +
                8) >> 4);
    }
}

ScaleRowDown4Box_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    x: s32 = 0;
    while x < dst_width - 1 {
        dst[0] =
            cast,no_check(u16) ((((((((((((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[3]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 3) + 0]) + cast(s32) src_ptr[(src_stride * 3) + 1]) + cast(s32) src_ptr[(src_stride * 3) + 2]) + cast(s32) src_ptr[(src_stride * 3) + 3]) +
                8) >> 4);
        dst[1] =
            cast,no_check(u16) ((((((((((((((((((cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7]) + cast(s32) src_ptr[(src_stride * 2) + 4]) + cast(s32) src_ptr[(src_stride * 2) + 5]) + cast(s32) src_ptr[(src_stride * 2) + 6]) + cast(s32) src_ptr[(src_stride * 2) + 7]) + cast(s32) src_ptr[(src_stride * 3) + 4]) + cast(s32) src_ptr[(src_stride * 3) + 5]) + cast(s32) src_ptr[(src_stride * 3) + 6]) + cast(s32) src_ptr[(src_stride * 3) + 7]) +
                8) >> 4);
        dst += 2;
        src_ptr += 8;
        x += 2;
    }
    if dst_width & 1 != 0 {
        dst[0] =
            cast,no_check(u16) ((((((((((((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[3]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 3) + 0]) + cast(s32) src_ptr[(src_stride * 3) + 1]) + cast(s32) src_ptr[(src_stride * 3) + 2]) + cast(s32) src_ptr[(src_stride * 3) + 3]) +
                8) >> 4);
    }
}

ScaleRowDown34_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        dst[0] = src_ptr[0];
        dst[1] = src_ptr[1];
        dst[2] = src_ptr[3];
        dst += 3;
        src_ptr += 4;
        x += 3;
    }
}

ScaleRowDown34_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        dst[0] = src_ptr[0];
        dst[1] = src_ptr[1];
        dst[2] = src_ptr[3];
        dst += 3;
        src_ptr += 4;
        x += 3;
    }
}

ScaleRowDown34_0_Box_C :: (src_ptr: *u8, src_stride: s64, d: *u8, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));

    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        a0 := cast,no_check(u8) (((cast(s32) s[0]) * 3 + (cast(s32) s[1]) * 1 + 2) >> 2);
        a1 := cast,no_check(u8) (((cast(s32) s[1]) * 1 + (cast(s32) s[2]) * 1 + 1) >> 1);
        a2 := cast,no_check(u8) (((cast(s32) s[2]) * 1 + (cast(s32) s[3]) * 3 + 2) >> 2);
        b0 := cast,no_check(u8) (((cast(s32) t[0]) * 3 + (cast(s32) t[1]) * 1 + 2) >> 2);
        b1 := cast,no_check(u8) (((cast(s32) t[1]) * 1 + (cast(s32) t[2]) * 1 + 1) >> 1);
        b2 := cast,no_check(u8) (((cast(s32) t[2]) * 1 + (cast(s32) t[3]) * 3 + 2) >> 2);
        d[0] = cast,no_check(u8) ((((cast(s32) a0) * 3 + cast(s32) b0) + 2) >> 2);
        d[1] = cast,no_check(u8) ((((cast(s32) a1) * 3 + cast(s32) b1) + 2) >> 2);
        d[2] = cast,no_check(u8) ((((cast(s32) a2) * 3 + cast(s32) b2) + 2) >> 2);
        d += 3;
        s += 4;
        t += 4;
        x += 3;
    }
}

ScaleRowDown34_0_Box_16_C :: (src_ptr: *u16, src_stride: s64, d: *u16, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);
    t := cast,no_check(*u16) ((src_ptr + src_stride));

    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        a0 := cast,no_check(u16) (((cast(s32) s[0]) * 3 + (cast(s32) s[1]) * 1 + 2) >> 2);
        a1 := cast,no_check(u16) (((cast(s32) s[1]) * 1 + (cast(s32) s[2]) * 1 + 1) >> 1);
        a2 := cast,no_check(u16) (((cast(s32) s[2]) * 1 + (cast(s32) s[3]) * 3 + 2) >> 2);
        b0 := cast,no_check(u16) (((cast(s32) t[0]) * 3 + (cast(s32) t[1]) * 1 + 2) >> 2);
        b1 := cast,no_check(u16) (((cast(s32) t[1]) * 1 + (cast(s32) t[2]) * 1 + 1) >> 1);
        b2 := cast,no_check(u16) (((cast(s32) t[2]) * 1 + (cast(s32) t[3]) * 3 + 2) >> 2);
        d[0] = cast,no_check(u16) ((((cast(s32) a0) * 3 + cast(s32) b0) + 2) >> 2);
        d[1] = cast,no_check(u16) ((((cast(s32) a1) * 3 + cast(s32) b1) + 2) >> 2);
        d[2] = cast,no_check(u16) ((((cast(s32) a2) * 3 + cast(s32) b2) + 2) >> 2);
        d += 3;
        s += 4;
        t += 4;
        x += 3;
    }
}

ScaleRowDown34_1_Box_C :: (src_ptr: *u8, src_stride: s64, d: *u8, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));

    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        a0 := cast,no_check(u8) (((cast(s32) s[0]) * 3 + (cast(s32) s[1]) * 1 + 2) >> 2);
        a1 := cast,no_check(u8) (((cast(s32) s[1]) * 1 + (cast(s32) s[2]) * 1 + 1) >> 1);
        a2 := cast,no_check(u8) (((cast(s32) s[2]) * 1 + (cast(s32) s[3]) * 3 + 2) >> 2);
        b0 := cast,no_check(u8) (((cast(s32) t[0]) * 3 + (cast(s32) t[1]) * 1 + 2) >> 2);
        b1 := cast,no_check(u8) (((cast(s32) t[1]) * 1 + (cast(s32) t[2]) * 1 + 1) >> 1);
        b2 := cast,no_check(u8) (((cast(s32) t[2]) * 1 + (cast(s32) t[3]) * 3 + 2) >> 2);
        d[0] = cast,no_check(u8) ((((cast(s32) a0) + cast(s32) b0) + 1) >> 1);
        d[1] = cast,no_check(u8) ((((cast(s32) a1) + cast(s32) b1) + 1) >> 1);
        d[2] = cast,no_check(u8) ((((cast(s32) a2) + cast(s32) b2) + 1) >> 1);
        d += 3;
        s += 4;
        t += 4;
        x += 3;
    }
}

ScaleRowDown34_1_Box_16_C :: (src_ptr: *u16, src_stride: s64, d: *u16, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);
    t := cast,no_check(*u16) ((src_ptr + src_stride));

    assert(dst_width % 3 == 0 && dst_width > 0);
    x: s32 = 0;
    while x < dst_width {
        a0 := cast,no_check(u16) (((cast(s32) s[0]) * 3 + (cast(s32) s[1]) * 1 + 2) >> 2);
        a1 := cast,no_check(u16) (((cast(s32) s[1]) * 1 + (cast(s32) s[2]) * 1 + 1) >> 1);
        a2 := cast,no_check(u16) (((cast(s32) s[2]) * 1 + (cast(s32) s[3]) * 3 + 2) >> 2);
        b0 := cast,no_check(u16) (((cast(s32) t[0]) * 3 + (cast(s32) t[1]) * 1 + 2) >> 2);
        b1 := cast,no_check(u16) (((cast(s32) t[1]) * 1 + (cast(s32) t[2]) * 1 + 1) >> 1);
        b2 := cast,no_check(u16) (((cast(s32) t[2]) * 1 + (cast(s32) t[3]) * 3 + 2) >> 2);
        d[0] = cast,no_check(u16) ((((cast(s32) a0) + cast(s32) b0) + 1) >> 1);
        d[1] = cast,no_check(u16) ((((cast(s32) a1) + cast(s32) b1) + 1) >> 1);
        d[2] = cast,no_check(u16) ((((cast(s32) a2) + cast(s32) b2) + 1) >> 1);
        d += 3;
        s += 4;
        t += 4;
        x += 3;
    }
}

ScaleRowUp2_Linear_C :: (src_ptr: *u8, dst_ptr: *u8, dst_width: s32) {
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            dst_ptr[2 * x + 0] =
                cast,no_check(u8) (((cast(s32) src_ptr[x + 0]) * 3 +
                    (cast(s32) src_ptr[x + 1]) * 1 + 2) >> 2);
            dst_ptr[2 * x + 1] =
                cast,no_check(u8) (((cast(s32) src_ptr[x + 0]) * 1 +
                    (cast(s32) src_ptr[x + 1]) * 3 + 2) >> 2);
        }
    }
}

ScaleRowUp2_Bilinear_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_stride: s64, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));
    d := cast,no_check(*u8) (dst_ptr);
    e := cast,no_check(*u8) ((dst_ptr + dst_stride));
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            d[2 * x + 0] =
                cast,no_check(u8) (((cast(s32) s[x + 0]) * 9 + (cast(s32) s[x + 1]) * 3 +
                    (cast(s32) t[x + 0]) * 3 + (cast(s32) t[x + 1]) * 1 + 8) >> 4);
            d[2 * x + 1] =
                cast,no_check(u8) (((cast(s32) s[x + 0]) * 3 + (cast(s32) s[x + 1]) * 9 +
                    (cast(s32) t[x + 0]) * 1 + (cast(s32) t[x + 1]) * 3 + 8) >> 4);
            e[2 * x + 0] =
                cast,no_check(u8) (((cast(s32) s[x + 0]) * 3 + (cast(s32) s[x + 1]) * 1 +
                    (cast(s32) t[x + 0]) * 9 + (cast(s32) t[x + 1]) * 3 + 8) >> 4);
            e[2 * x + 1] =
                cast,no_check(u8) (((cast(s32) s[x + 0]) * 1 + (cast(s32) s[x + 1]) * 3 +
                    (cast(s32) t[x + 0]) * 3 + (cast(s32) t[x + 1]) * 9 + 8) >> 4);
        }
    }
}

ScaleRowUp2_Linear_16_C :: (src_ptr: *u16, dst_ptr: *u16, dst_width: s32) {
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            dst_ptr[2 * x + 0] =
                cast,no_check(u16) (((cast(s32) src_ptr[x + 0]) * 3 +
                    (cast(s32) src_ptr[x + 1]) * 1 + 2) >> 2);
            dst_ptr[2 * x + 1] =
                cast,no_check(u16) (((cast(s32) src_ptr[x + 0]) * 1 +
                    (cast(s32) src_ptr[x + 1]) * 3 + 2) >> 2);
        }
    }
}

ScaleRowUp2_Bilinear_16_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_stride: s64, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);
    t := cast,no_check(*u16) ((src_ptr + src_stride));
    d := cast,no_check(*u16) (dst_ptr);
    e := cast,no_check(*u16) ((dst_ptr + dst_stride));
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            d[2 * x + 0] =
                cast,no_check(u16) (((cast(s32) s[x + 0]) * 9 + (cast(s32) s[x + 1]) * 3 +
                    (cast(s32) t[x + 0]) * 3 + (cast(s32) t[x + 1]) * 1 + 8) >> 4);
            d[2 * x + 1] =
                cast,no_check(u16) (((cast(s32) s[x + 0]) * 3 + (cast(s32) s[x + 1]) * 9 +
                    (cast(s32) t[x + 0]) * 1 + (cast(s32) t[x + 1]) * 3 + 8) >> 4);
            e[2 * x + 0] =
                cast,no_check(u16) (((cast(s32) s[x + 0]) * 3 + (cast(s32) s[x + 1]) * 1 +
                    (cast(s32) t[x + 0]) * 9 + (cast(s32) t[x + 1]) * 3 + 8) >> 4);
            e[2 * x + 1] =
                cast,no_check(u16) (((cast(s32) s[x + 0]) * 1 + (cast(s32) s[x + 1]) * 3 +
                    (cast(s32) t[x + 0]) * 3 + (cast(s32) t[x + 1]) * 9 + 8) >> 4);
        }
    }
}

ScaleCols_C :: (dst_ptr: *u8, src_ptr: *u8, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_ptr[0] = src_ptr[x >> 16];
        x += dx;
        dst_ptr[1] = src_ptr[x >> 16];
        x += dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_ptr[0] = src_ptr[x >> 16];
    }
}

ScaleCols_16_C :: (dst_ptr: *u16, src_ptr: *u16, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_ptr[0] = src_ptr[x >> 16];
        x += dx;
        dst_ptr[1] = src_ptr[x >> 16];
        x += dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_ptr[0] = src_ptr[x >> 16];
    }
}

ScaleColsUp2_C :: (dst_ptr: *u8, src_ptr: *u8, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_ptr[0] = src_ptr[0];
        dst_ptr[1] = dst_ptr[0];
        src_ptr += 1;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_ptr[0] = src_ptr[0];
    }
}

ScaleColsUp2_16_C :: (dst_ptr: *u16, src_ptr: *u16, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_ptr[0] = src_ptr[0];
        dst_ptr[1] = dst_ptr[0];
        src_ptr += 1;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_ptr[0] = src_ptr[0];
    }
}

ScaleFilterCols_C :: (dst_ptr: *u8, src_ptr: *u8, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] = cast,no_check(u8) (a + (x & 0xffff >> 9 * (b - a) + 0x40) >> 7);
        x += dx;
        xi = x >> 16;
        a = cast,no_check(s32) src_ptr[xi];
        b = cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[1] = cast,no_check(u8) (a + (x & 0xffff >> 9 * (b - a) + 0x40) >> 7);
        x += dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] = cast,no_check(u8) (a + (x & 0xffff >> 9 * (b - a) + 0x40) >> 7);
    }
}

ScaleFilterCols_16_C :: (dst_ptr: *u16, src_ptr: *u16, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((cast,no_check(s64) (x & 0xffff)) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
        x += dx;
        xi = x >> 16;
        a = cast,no_check(s32) src_ptr[xi];
        b = cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[1] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((cast,no_check(s64) (x & 0xffff)) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
        x += dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((cast,no_check(s64) (x & 0xffff)) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
    }
}

ScaleFilterCols64_C :: (dst_ptr: *u8, src_ptr: *u8, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    j: s32 = 0;
    while j < dst_width - 1 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] = cast,no_check(u8) (a + ((cast,no_check(s32) ((x & 0xffff) >> 9)) * (b - a) + 0x40) >> 7);
        x += cast,no_check(s64) dx;
        xi = x >> 16;
        a = cast,no_check(s32) src_ptr[xi];
        b = cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[1] = cast,no_check(u8) (a + ((cast,no_check(s32) ((x & 0xffff) >> 9)) * (b - a) + 0x40) >> 7);
        x += cast,no_check(s64) dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] = cast,no_check(u8) (a + ((cast,no_check(s32) ((x & 0xffff) >> 9)) * (b - a) + 0x40) >> 7);
    }
}

ScaleFilterCols64_16_C :: (dst_ptr: *u16, src_ptr: *u16, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    j: s32 = 0;
    while j < dst_width - 1 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((x & 0xffff) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
        x += cast,no_check(s64) dx;
        xi = x >> 16;
        a = cast,no_check(s32) src_ptr[xi];
        b = cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[1] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((x & 0xffff) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
        x += cast,no_check(s64) dx;
        dst_ptr += 2;
        j += 2;
    }
    if dst_width & 1 != 0 {
        xi := x >> 16;
        a := cast,no_check(s32) src_ptr[xi];
        b := cast,no_check(s32) src_ptr[xi + 1];
        dst_ptr[0] =
            cast,no_check(u16) (a +
                cast,no_check(s32) ((((x & 0xffff) * ((cast,no_check(s64) b) - cast(s64) a)) + 0x8000) >> 16));
    }
}

ScaleRowDown38_C :: (src_ptr: *u8, src_stride: s64, dst: *u8, dst_width: s32) {
    assert(dst_width % 3 == 0);
    x: s32 = 0;
    while x < dst_width {
        dst[0] = src_ptr[0];
        dst[1] = src_ptr[3];
        dst[2] = src_ptr[6];
        dst += 3;
        src_ptr += 8;
        x += 3;
    }
}

ScaleRowDown38_16_C :: (src_ptr: *u16, src_stride: s64, dst: *u16, dst_width: s32) {
    assert(dst_width % 3 == 0);
    x: s32 = 0;
    while x < dst_width {
        dst[0] = src_ptr[0];
        dst[1] = src_ptr[3];
        dst[2] = src_ptr[6];
        dst += 3;
        src_ptr += 8;
        x += 3;
    }
}

ScaleRowDown38_3_Box_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    i: s32 = 0;
    while i < dst_width {
        dst_ptr[0] =
            cast,no_check(u8) (((((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2]) *
                cast,no_check(s32) ((65536 / 9))) >> 16);
        dst_ptr[1] =
            cast,no_check(u8) (((((((((((cast(s32) src_ptr[3]) + cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 2) + 4]) + cast(s32) src_ptr[(src_stride * 2) + 5]) *
                cast,no_check(s32) ((65536 / 9))) >> 16);
        dst_ptr[2] =
            cast,no_check(u8) ((((((((cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7]) + cast(s32) src_ptr[(src_stride * 2) + 6]) + cast(s32) src_ptr[(src_stride * 2) + 7]) *
                cast,no_check(s32) ((65536 / 6))) >> 16);
        src_ptr += 8;
        dst_ptr += 3;
        i += 3;
    }
}

ScaleRowDown38_3_Box_16_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    i: s32 = 0;
    while i < dst_width {
        dst_ptr[0] =
            cast,no_check(u16) (((cast,no_check(u32) (((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) + cast(s32) src_ptr[(src_stride * 2) + 0]) + cast(s32) src_ptr[(src_stride * 2) + 1]) + cast(s32) src_ptr[(src_stride * 2) + 2])) *
                ((cast,no_check(u32) (65536)) / 9)) >> 16);
        dst_ptr[1] =
            cast,no_check(u16) (((cast,no_check(u32) (((((((((cast(s32) src_ptr[3]) + cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5]) + cast(s32) src_ptr[(src_stride * 2) + 3]) + cast(s32) src_ptr[(src_stride * 2) + 4]) + cast(s32) src_ptr[(src_stride * 2) + 5])) *
                ((cast,no_check(u32) (65536)) / 9)) >> 16);
        dst_ptr[2] =
            cast,no_check(u16) (((cast,no_check(u32) ((((((cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7]) + cast(s32) src_ptr[(src_stride * 2) + 6]) + cast(s32) src_ptr[(src_stride * 2) + 7])) *
                ((cast,no_check(u32) (65536)) / 6)) >> 16);
        src_ptr += 8;
        dst_ptr += 3;
        i += 3;
    }
}

ScaleRowDown38_2_Box_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    i: s32 = 0;
    while i < dst_width {
        dst_ptr[0] =
            cast,no_check(u8) ((((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2]) *
                cast,no_check(s32) ((65536 / 6))) >> 16);
        dst_ptr[1] =
            cast,no_check(u8) ((((((((cast(s32) src_ptr[3]) + cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5]) *
                cast,no_check(s32) ((65536 / 6))) >> 16);
        dst_ptr[2] =
            cast,no_check(u8) ((((((cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7]) *
                cast,no_check(s32) ((65536 / 4))) >> 16);
        src_ptr += 8;
        dst_ptr += 3;
        i += 3;
    }
}

ScaleRowDown38_2_Box_16_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_width: s32) {
    assert(dst_width % 3 == 0 && dst_width > 0);
    i: s32 = 0;
    while i < dst_width {
        dst_ptr[0] =
            cast,no_check(u16) (((cast,no_check(u32) ((((((cast(s32) src_ptr[0]) + cast(s32) src_ptr[1]) + cast(s32) src_ptr[2]) + cast(s32) src_ptr[src_stride + 0]) + cast(s32) src_ptr[src_stride + 1]) + cast(s32) src_ptr[src_stride + 2])) *
                ((cast,no_check(u32) (65536)) / 6)) >> 16);
        dst_ptr[1] =
            cast,no_check(u16) (((cast,no_check(u32) ((((((cast(s32) src_ptr[3]) + cast(s32) src_ptr[4]) + cast(s32) src_ptr[5]) + cast(s32) src_ptr[src_stride + 3]) + cast(s32) src_ptr[src_stride + 4]) + cast(s32) src_ptr[src_stride + 5])) *
                ((cast,no_check(u32) (65536)) / 6)) >> 16);
        dst_ptr[2] =
            cast,no_check(u16) (((cast,no_check(u32) ((((cast(s32) src_ptr[6]) + cast(s32) src_ptr[7]) + cast(s32) src_ptr[src_stride + 6]) + cast(s32) src_ptr[src_stride + 7])) *
                ((cast,no_check(u32) (65536)) / 4)) >> 16);
        src_ptr += 8;
        dst_ptr += 3;
        i += 3;
    }
}

ScaleAddRow_C :: (src_ptr: *u8, dst_ptr: *u16, src_width: s32) {
    assert(src_width > 0);
    x: s32 = 0;
    while x < src_width - 1 {
        dst_ptr[0] = cast,no_check(u16) ((cast,no_check(s32) dst_ptr[0]) + cast,no_check(s32) src_ptr[0]);
        dst_ptr[1] = cast,no_check(u16) ((cast,no_check(s32) dst_ptr[1]) + cast,no_check(s32) src_ptr[1]);
        src_ptr += 2;
        dst_ptr += 2;
        x += 2;
    }
    if src_width & 1 != 0 {
        dst_ptr[0] = cast,no_check(u16) ((cast,no_check(s32) dst_ptr[0]) + cast,no_check(s32) src_ptr[0]);
    }
}

ScaleAddRow_16_C :: (src_ptr: *u16, dst_ptr: *u32, src_width: s32) {
    assert(src_width > 0);
    x: s32 = 0;
    while x < src_width - 1 {
        dst_ptr[0] += cast,no_check(u32) src_ptr[0];
        dst_ptr[1] += cast,no_check(u32) src_ptr[1];
        src_ptr += 2;
        dst_ptr += 2;
        x += 2;
    }
    if src_width & 1 != 0 {
        dst_ptr[0] += cast,no_check(u32) src_ptr[0];
    }
}

ScaleARGBRowDown2_C :: (src_argb: *u8, src_stride: s64, dst_argb: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_argb[0] = src_argb[4];
            dst_argb[1] = src_argb[5];
            dst_argb[2] = src_argb[6];
            dst_argb[3] = src_argb[7];
            src_argb += 8;
            dst_argb += 4;
        }
    }
}

ScaleARGBRowDown2Linear_C :: (src_argb: *u8, src_stride: s64, dst_argb: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_argb[0] = cast,no_check(u8) ((((cast(s32) src_argb[0]) + cast(s32) src_argb[4]) + 1) >> 1);
            dst_argb[1] = cast,no_check(u8) ((((cast(s32) src_argb[1]) + cast(s32) src_argb[5]) + 1) >> 1);
            dst_argb[2] = cast,no_check(u8) ((((cast(s32) src_argb[2]) + cast(s32) src_argb[6]) + 1) >> 1);
            dst_argb[3] = cast,no_check(u8) ((((cast(s32) src_argb[3]) + cast(s32) src_argb[7]) + 1) >> 1);
            src_argb += 8;
            dst_argb += 4;
        }
    }
}

ScaleARGBRowDown2Box_C :: (src_argb: *u8, src_stride: s64, dst_argb: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_argb[0] =
                cast,no_check(u8) ((((((cast(s32) src_argb[0]) + cast(s32) src_argb[4]) + cast(s32) src_argb[src_stride]) + cast(s32) src_argb[src_stride + 4]) +
                    2) >> 2);
            dst_argb[1] =
                cast,no_check(u8) ((((((cast(s32) src_argb[1]) + cast(s32) src_argb[5]) + cast(s32) src_argb[src_stride + 1]) + cast(s32) src_argb[src_stride + 5]) +
                    2) >> 2);
            dst_argb[2] =
                cast,no_check(u8) ((((((cast(s32) src_argb[2]) + cast(s32) src_argb[6]) + cast(s32) src_argb[src_stride + 2]) + cast(s32) src_argb[src_stride + 6]) +
                    2) >> 2);
            dst_argb[3] =
                cast,no_check(u8) ((((((cast(s32) src_argb[3]) + cast(s32) src_argb[7]) + cast(s32) src_argb[src_stride + 3]) + cast(s32) src_argb[src_stride + 7]) +
                    2) >> 2);
            src_argb += 8;
            dst_argb += 4;
        }
    }
}

ScaleARGBRowDownEven_C :: (src_argb: *u8, src_stride: s64, src_stepx: s32, dst_argb: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_argb[0] = src_argb[0];
            dst_argb[1] = src_argb[1];
            dst_argb[2] = src_argb[2];
            dst_argb[3] = src_argb[3];
            src_argb += src_stepx * 4;
            dst_argb += 4;
        }
    }
}

ScaleARGBRowDownEvenBox_C :: (src_argb: *u8, src_stride: s64, src_stepx: s32, dst_argb: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_argb[0] =
                cast,no_check(u8) ((((((cast(s32) src_argb[0]) + cast(s32) src_argb[4]) + cast(s32) src_argb[src_stride]) + cast(s32) src_argb[src_stride + 4]) +
                    2) >> 2);
            dst_argb[1] =
                cast,no_check(u8) ((((((cast(s32) src_argb[1]) + cast(s32) src_argb[5]) + cast(s32) src_argb[src_stride + 1]) + cast(s32) src_argb[src_stride + 5]) +
                    2) >> 2);
            dst_argb[2] =
                cast,no_check(u8) ((((((cast(s32) src_argb[2]) + cast(s32) src_argb[6]) + cast(s32) src_argb[src_stride + 2]) + cast(s32) src_argb[src_stride + 6]) +
                    2) >> 2);
            dst_argb[3] =
                cast,no_check(u8) ((((((cast(s32) src_argb[3]) + cast(s32) src_argb[7]) + cast(s32) src_argb[src_stride + 3]) + cast(s32) src_argb[src_stride + 7]) +
                    2) >> 2);
            src_argb += src_stepx * 4;
            dst_argb += 4;
        }
    }
}

ScaleARGBCols_C :: (dst_argb: *u8, src_argb: *u8, dst_width: s32, x: s32, dx: s32) {
    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            src := cast,no_check(*u8) ((src_argb + x >> 16 * 4));
            dst_argb[0] = src[0];
            dst_argb[1] = src[1];
            dst_argb[2] = src[2];
            dst_argb[3] = src[3];
            dst_argb += 4;
            x += dx;
        }
    }
}

ScaleARGBCols64_C :: (dst_argb: *u8, src_argb: *u8, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            src := cast,no_check(*u8) ((src_argb + x >> 16 * 4));
            dst_argb[0] = src[0];
            dst_argb[1] = src[1];
            dst_argb[2] = src[2];
            dst_argb[3] = src[3];
            dst_argb += 4;
            x += cast,no_check(s64) dx;
        }
    }
}

ScaleARGBColsUp2_C :: (dst_argb: *u8, src_argb: *u8, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_argb[4] = src_argb[0];
        dst_argb[0] = dst_argb[4];
        dst_argb[5] = src_argb[1];
        dst_argb[1] = dst_argb[5];
        dst_argb[6] = src_argb[2];
        dst_argb[2] = dst_argb[6];
        dst_argb[7] = src_argb[3];
        dst_argb[3] = dst_argb[7];
        src_argb += 4;
        dst_argb += 8;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_argb[0] = src_argb[0];
        dst_argb[1] = src_argb[1];
        dst_argb[2] = src_argb[2];
        dst_argb[3] = src_argb[3];
    }
}

ScaleARGBFilterCols_C :: (dst_argb: *u8, src_argb: *u8, dst_width: s32, x: s32, dx: s32) {
    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            xi := x >> 16 * 4;
            xf := x >> 9 & 0x7f;
            a := cast,no_check(*u8) ((src_argb + xi));
            b := cast,no_check(*u8) ((a + 4));
            dst_argb[0] = cast,no_check(u8) (((cast(s32) a[0]) * 0x7f ^ xf + (cast(s32) b[0]) * xf) >> 7);
            dst_argb[1] = cast,no_check(u8) (((cast(s32) a[1]) * 0x7f ^ xf + (cast(s32) b[1]) * xf) >> 7);
            dst_argb[2] = cast,no_check(u8) (((cast(s32) a[2]) * 0x7f ^ xf + (cast(s32) b[2]) * xf) >> 7);
            dst_argb[3] = cast,no_check(u8) (((cast(s32) a[3]) * 0x7f ^ xf + (cast(s32) b[3]) * xf) >> 7);
            dst_argb += 4;
            x += dx;
        }
    }
}

ScaleARGBFilterCols64_C :: (dst_argb: *u8, src_argb: *u8, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            xi := x >> 16 * 4;
            xf := cast,no_check(s32) (x >> 9 & 0x7f);
            a := cast,no_check(*u8) ((src_argb + xi));
            b := cast,no_check(*u8) ((a + 4));
            dst_argb[0] = cast,no_check(u8) (((cast(s32) a[0]) * 0x7f ^ xf + (cast(s32) b[0]) * xf) >> 7);
            dst_argb[1] = cast,no_check(u8) (((cast(s32) a[1]) * 0x7f ^ xf + (cast(s32) b[1]) * xf) >> 7);
            dst_argb[2] = cast,no_check(u8) (((cast(s32) a[2]) * 0x7f ^ xf + (cast(s32) b[2]) * xf) >> 7);
            dst_argb[3] = cast,no_check(u8) (((cast(s32) a[3]) * 0x7f ^ xf + (cast(s32) b[3]) * xf) >> 7);
            dst_argb += 4;
            x += cast,no_check(s64) dx;
        }
    }
}

ScaleUVRowDown2_C :: (src_uv: *u8, src_stride: s64, dst_uv: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_uv[0] = src_uv[2];
            dst_uv[1] = src_uv[3];
            src_uv += 4;
            dst_uv += 2;
        }
    }
}

ScaleUVRowDown2Linear_C :: (src_uv: *u8, src_stride: s64, dst_uv: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_uv[0] = cast,no_check(u8) ((((cast(s32) src_uv[0]) + cast(s32) src_uv[2]) + 1) >> 1);
            dst_uv[1] = cast,no_check(u8) ((((cast(s32) src_uv[1]) + cast(s32) src_uv[3]) + 1) >> 1);
            src_uv += 4;
            dst_uv += 2;
        }
    }
}

ScaleUVRowDown2Box_C :: (src_uv: *u8, src_stride: s64, dst_uv: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_uv[0] =
                cast,no_check(u8) ((((((cast(s32) src_uv[0]) + cast(s32) src_uv[2]) + cast(s32) src_uv[src_stride]) + cast(s32) src_uv[src_stride + 2]) +
                    2) >> 2);
            dst_uv[1] =
                cast,no_check(u8) ((((((cast(s32) src_uv[1]) + cast(s32) src_uv[3]) + cast(s32) src_uv[src_stride + 1]) + cast(s32) src_uv[src_stride + 3]) +
                    2) >> 2);
            src_uv += 4;
            dst_uv += 2;
        }
    }
}

ScaleUVRowDownEven_C :: (src_uv: *u8, src_stride: s64, src_stepx: s32, dst_uv: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_uv[0] = src_uv[0];
            dst_uv[1] = src_uv[1];
            src_uv += src_stepx * 2;
            dst_uv += 2;
        }
    }
}

ScaleUVRowDownEvenBox_C :: (src_uv: *u8, src_stride: s64, src_stepx: s32, dst_uv: *u8, dst_width: s32) {
    if 0 < dst_width {
        for x: 0..dst_width - 1 {
            dst_uv[0] =
                cast,no_check(u8) ((((((cast(s32) src_uv[0]) + cast(s32) src_uv[2]) + cast(s32) src_uv[src_stride]) + cast(s32) src_uv[src_stride + 2]) +
                    2) >> 2);
            dst_uv[1] =
                cast,no_check(u8) ((((((cast(s32) src_uv[1]) + cast(s32) src_uv[3]) + cast(s32) src_uv[src_stride + 1]) + cast(s32) src_uv[src_stride + 3]) +
                    2) >> 2);
            src_uv += src_stepx * 2;
            dst_uv += 2;
        }
    }
}

ScaleUVRowUp2_Linear_C :: (src_ptr: *u8, dst_ptr: *u8, dst_width: s32) {
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            dst_ptr[4 * x + 0] =
                cast,no_check(u8) (((cast(s32) src_ptr[2 * x + 0]) * 3 +
                    (cast(s32) src_ptr[2 * x + 2]) * 1 + 2) >> 2);
            dst_ptr[4 * x + 1] =
                cast,no_check(u8) (((cast(s32) src_ptr[2 * x + 1]) * 3 +
                    (cast(s32) src_ptr[2 * x + 3]) * 1 + 2) >> 2);
            dst_ptr[4 * x + 2] =
                cast,no_check(u8) (((cast(s32) src_ptr[2 * x + 0]) * 1 +
                    (cast(s32) src_ptr[2 * x + 2]) * 3 + 2) >> 2);
            dst_ptr[4 * x + 3] =
                cast,no_check(u8) (((cast(s32) src_ptr[2 * x + 1]) * 1 +
                    (cast(s32) src_ptr[2 * x + 3]) * 3 + 2) >> 2);
        }
    }
}

ScaleUVRowUp2_Bilinear_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_stride: s64, dst_width: s32) {
    s := cast,no_check(*u8) (src_ptr);
    t := cast,no_check(*u8) ((src_ptr + src_stride));
    d := cast,no_check(*u8) (dst_ptr);
    e := cast,no_check(*u8) ((dst_ptr + dst_stride));
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            d[4 * x + 0] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 0]) * 9 + (cast(s32) s[2 * x + 2]) * 3 +
                    (cast(s32) t[2 * x + 0]) * 3 + (cast(s32) t[2 * x + 2]) * 1 + 8) >> 4);
            d[4 * x + 1] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 1]) * 9 + (cast(s32) s[2 * x + 3]) * 3 +
                    (cast(s32) t[2 * x + 1]) * 3 + (cast(s32) t[2 * x + 3]) * 1 + 8) >> 4);
            d[4 * x + 2] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 0]) * 3 + (cast(s32) s[2 * x + 2]) * 9 +
                    (cast(s32) t[2 * x + 0]) * 1 + (cast(s32) t[2 * x + 2]) * 3 + 8) >> 4);
            d[4 * x + 3] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 1]) * 3 + (cast(s32) s[2 * x + 3]) * 9 +
                    (cast(s32) t[2 * x + 1]) * 1 + (cast(s32) t[2 * x + 3]) * 3 + 8) >> 4);
            e[4 * x + 0] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 0]) * 3 + (cast(s32) s[2 * x + 2]) * 1 +
                    (cast(s32) t[2 * x + 0]) * 9 + (cast(s32) t[2 * x + 2]) * 3 + 8) >> 4);
            e[4 * x + 1] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 1]) * 3 + (cast(s32) s[2 * x + 3]) * 1 +
                    (cast(s32) t[2 * x + 1]) * 9 + (cast(s32) t[2 * x + 3]) * 3 + 8) >> 4);
            e[4 * x + 2] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 0]) * 1 + (cast(s32) s[2 * x + 2]) * 3 +
                    (cast(s32) t[2 * x + 0]) * 3 + (cast(s32) t[2 * x + 2]) * 9 + 8) >> 4);
            e[4 * x + 3] =
                cast,no_check(u8) (((cast(s32) s[2 * x + 1]) * 1 + (cast(s32) s[2 * x + 3]) * 3 +
                    (cast(s32) t[2 * x + 1]) * 3 + (cast(s32) t[2 * x + 3]) * 9 + 8) >> 4);
        }
    }
}

ScaleUVRowUp2_Linear_16_C :: (src_ptr: *u16, dst_ptr: *u16, dst_width: s32) {
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            dst_ptr[4 * x + 0] =
                cast,no_check(u16) (((cast(s32) src_ptr[2 * x + 0]) * 3 +
                    (cast(s32) src_ptr[2 * x + 2]) * 1 + 2) >> 2);
            dst_ptr[4 * x + 1] =
                cast,no_check(u16) (((cast(s32) src_ptr[2 * x + 1]) * 3 +
                    (cast(s32) src_ptr[2 * x + 3]) * 1 + 2) >> 2);
            dst_ptr[4 * x + 2] =
                cast,no_check(u16) (((cast(s32) src_ptr[2 * x + 0]) * 1 +
                    (cast(s32) src_ptr[2 * x + 2]) * 3 + 2) >> 2);
            dst_ptr[4 * x + 3] =
                cast,no_check(u16) (((cast(s32) src_ptr[2 * x + 1]) * 1 +
                    (cast(s32) src_ptr[2 * x + 3]) * 3 + 2) >> 2);
        }
    }
}

ScaleUVRowUp2_Bilinear_16_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_stride: s64, dst_width: s32) {
    s := cast,no_check(*u16) (src_ptr);
    t := cast,no_check(*u16) ((src_ptr + src_stride));
    d := cast,no_check(*u16) (dst_ptr);
    e := cast,no_check(*u16) ((dst_ptr + dst_stride));
    src_width := dst_width >> 1;

    assert(dst_width % 2 == 0 && dst_width >= 0);
    if 0 < src_width {
        for x: 0..src_width - 1 {
            d[4 * x + 0] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 0]) * 9 + (cast(s32) s[2 * x + 2]) * 3 +
                    (cast(s32) t[2 * x + 0]) * 3 + (cast(s32) t[2 * x + 2]) * 1 + 8) >> 4);
            d[4 * x + 1] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 1]) * 9 + (cast(s32) s[2 * x + 3]) * 3 +
                    (cast(s32) t[2 * x + 1]) * 3 + (cast(s32) t[2 * x + 3]) * 1 + 8) >> 4);
            d[4 * x + 2] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 0]) * 3 + (cast(s32) s[2 * x + 2]) * 9 +
                    (cast(s32) t[2 * x + 0]) * 1 + (cast(s32) t[2 * x + 2]) * 3 + 8) >> 4);
            d[4 * x + 3] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 1]) * 3 + (cast(s32) s[2 * x + 3]) * 9 +
                    (cast(s32) t[2 * x + 1]) * 1 + (cast(s32) t[2 * x + 3]) * 3 + 8) >> 4);
            e[4 * x + 0] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 0]) * 3 + (cast(s32) s[2 * x + 2]) * 1 +
                    (cast(s32) t[2 * x + 0]) * 9 + (cast(s32) t[2 * x + 2]) * 3 + 8) >> 4);
            e[4 * x + 1] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 1]) * 3 + (cast(s32) s[2 * x + 3]) * 1 +
                    (cast(s32) t[2 * x + 1]) * 9 + (cast(s32) t[2 * x + 3]) * 3 + 8) >> 4);
            e[4 * x + 2] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 0]) * 1 + (cast(s32) s[2 * x + 2]) * 3 +
                    (cast(s32) t[2 * x + 0]) * 3 + (cast(s32) t[2 * x + 2]) * 9 + 8) >> 4);
            e[4 * x + 3] =
                cast,no_check(u16) (((cast(s32) s[2 * x + 1]) * 1 + (cast(s32) s[2 * x + 3]) * 3 +
                    (cast(s32) t[2 * x + 1]) * 3 + (cast(s32) t[2 * x + 3]) * 9 + 8) >> 4);
        }
    }
}

ScaleUVCols_C :: (dst_uv: *u8, src_uv: *u8, dst_width: s32, x: s32, dx: s32) {
    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            src := cast,no_check(*u8) ((src_uv + x >> 16 * 2));
            dst_uv[0] = src[0];
            dst_uv[1] = src[1];
            dst_uv += 2;
            x += dx;
        }
    }
}

ScaleUVCols64_C :: (dst_uv: *u8, src_uv: *u8, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            src := cast,no_check(*u8) ((src_uv + x >> 16 * 2));
            dst_uv[0] = src[0];
            dst_uv[1] = src[1];
            dst_uv += 2;
            x += cast,no_check(s64) dx;
        }
    }
}

ScaleUVColsUp2_C :: (dst_uv: *u8, src_uv: *u8, dst_width: s32, x: s32, dx: s32) {
    j: s32 = 0;
    while j < dst_width - 1 {
        dst_uv[2] = src_uv[0];
        dst_uv[0] = dst_uv[2];
        dst_uv[3] = src_uv[1];
        dst_uv[1] = dst_uv[3];
        src_uv += 2;
        dst_uv += 4;
        j += 2;
    }
    if dst_width & 1 != 0 {
        dst_uv[0] = src_uv[0];
        dst_uv[1] = src_uv[1];
    }
}

ScaleUVFilterCols_C :: (dst_uv: *u8, src_uv: *u8, dst_width: s32, x: s32, dx: s32) {
    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            xi := x >> 16 * 2;
            xf := x >> 9 & 0x7f;
            a := cast,no_check(*u8) ((src_uv + xi));
            b := cast,no_check(*u8) ((a + 2));
            dst_uv[0] = cast,no_check(u8) ((cast(s32) a[0]) + ((xf * ((cast(s32) b[0]) - cast(s32) a[0])) + 64) >> 7);
            dst_uv[1] = cast,no_check(u8) ((cast(s32) a[1]) + ((xf * ((cast(s32) b[1]) - cast(s32) a[1])) + 64) >> 7);
            dst_uv += 2;
            x += dx;
        }
    }
}

ScaleUVFilterCols64_C :: (dst_uv: *u8, src_uv: *u8, dst_width: s32, x32: s32, dx: s32) {
    x := cast,no_check(s64) x32;

    if 0 < dst_width {
        for j: 0..dst_width - 1 {
            xi := x >> 16 * 2;
            xf := cast,no_check(s32) (x >> 9 & 0x7f);
            a := cast,no_check(*u8) ((src_uv + xi));
            b := cast,no_check(*u8) ((a + 2));
            dst_uv[0] = cast,no_check(u8) ((cast(s32) a[0]) + ((xf * ((cast(s32) b[0]) - cast(s32) a[0])) + 64) >> 7);
            dst_uv[1] = cast,no_check(u8) ((cast(s32) a[1]) + ((xf * ((cast(s32) b[1]) - cast(s32) a[1])) + 64) >> 7);
            dst_uv += 2;
            x += cast,no_check(s64) dx;
        }
    }
}

globals_initialization_state_for_scale_common: u32;
initialize_globals_for_scale_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_scale_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_scale_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_scale_common) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_scale_common = 0x1;
    K_CPU_HAS_ARM_in_scale_common = 0x2;
    K_CPU_HAS_NEON_in_scale_common = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_scale_common = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_scale_common = 0x400;
    K_CPU_HAS_SVE_in_scale_common = 0x800;
    K_CPU_HAS_SVE2_in_scale_common = 0x1000;
    K_CPU_HAS_SME_in_scale_common = 0x2000;
    K_CPU_HAS_SME2_in_scale_common = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_scale_common = 0x8000;
    K_CPU_HAS_RISCV_in_scale_common = 0x4;
    K_CPU_HAS_RVV_in_scale_common = 0x100;
    K_CPU_HAS_RVVZVFH_in_scale_common = 0x200;
    K_CPU_HAS_X86_in_scale_common = 0x8;
    K_CPU_HAS_SSE2_in_scale_common = 0x100;
    K_CPU_HAS_SSSE3_in_scale_common = 0x200;
    K_CPU_HAS_SSE41_in_scale_common = 0x400;
    K_CPU_HAS_SSE42_in_scale_common = 0x800;
    K_CPU_HAS_AVX_in_scale_common = 0x1000;
    K_CPU_HAS_AVX2_in_scale_common = 0x2000;
    K_CPU_HAS_ERMS_in_scale_common = 0x4000;
    K_CPU_HAS_FSMR_in_scale_common = 0x8000;
    K_CPU_HAS_FMA3_in_scale_common = 0x10000;
    K_CPU_HAS_F16_C_in_scale_common = 0x20000;
    K_CPU_HAS_AVX512_BW_in_scale_common = 0x40000;
    K_CPU_HAS_AVX512_VL_in_scale_common = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_scale_common = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_scale_common = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_scale_common = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_scale_common = 0x800000;
    K_CPU_HAS_AVX10_in_scale_common = 0x1000000;
    K_CPU_HAS_AVX10_2_in_scale_common = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_scale_common = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_scale_common = 0x8000000;
    K_CPU_HAS_AMXINT8_in_scale_common = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_scale_common = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_scale_common = 0x20;
    K_CPU_HAS_LSX_in_scale_common = 0x100;
    K_CPU_HAS_LASX_in_scale_common = 0x200;
    atomic_store(*globals_initialization_state_for_scale_common, 2);
}

