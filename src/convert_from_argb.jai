// Generated directly from C++ by cpp_transpiler.
K_SHUFFLE_MASK_ARGB_TO_RGBA: Uvec8;

K_DITHER565_4X4_storage: [16] u8;

K_CPU_INITIALIZED_in_convert_from_argb: s32;

K_CPU_HAS_ARM_in_convert_from_argb: s32;

K_CPU_HAS_NEON_in_convert_from_argb: s32;

K_CPU_HAS_NEON_DOT_PROD_in_convert_from_argb: s32;

K_CPU_HAS_NEON_I8_MM_in_convert_from_argb: s32;

K_CPU_HAS_SVE_in_convert_from_argb: s32;

K_CPU_HAS_SVE2_in_convert_from_argb: s32;

K_CPU_HAS_SME_in_convert_from_argb: s32;

K_CPU_HAS_SME2_in_convert_from_argb: s32;

K_CPU_HAS_SVEF32_MM_in_convert_from_argb: s32;

K_CPU_HAS_RISCV_in_convert_from_argb: s32;

K_CPU_HAS_RVV_in_convert_from_argb: s32;

K_CPU_HAS_RVVZVFH_in_convert_from_argb: s32;

K_CPU_HAS_X86_in_convert_from_argb: s32;

K_CPU_HAS_SSE2_in_convert_from_argb: s32;

K_CPU_HAS_SSSE3_in_convert_from_argb: s32;

K_CPU_HAS_SSE41_in_convert_from_argb: s32;

K_CPU_HAS_SSE42_in_convert_from_argb: s32;

K_CPU_HAS_AVX_in_convert_from_argb: s32;

K_CPU_HAS_AVX2_in_convert_from_argb: s32;

K_CPU_HAS_ERMS_in_convert_from_argb: s32;

K_CPU_HAS_FSMR_in_convert_from_argb: s32;

K_CPU_HAS_FMA3_in_convert_from_argb: s32;

K_CPU_HAS_F16_C_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_BW_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_VL_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_VNNI_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_VBMI_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_VBMI2_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_VBITALG_in_convert_from_argb: s32;

K_CPU_HAS_AVX10_in_convert_from_argb: s32;

K_CPU_HAS_AVX10_2_in_convert_from_argb: s32;

K_CPU_HAS_AVXVNNI_in_convert_from_argb: s32;

K_CPU_HAS_AVXVNNIINT8_in_convert_from_argb: s32;

K_CPU_HAS_AMXINT8_in_convert_from_argb: s32;

K_CPU_HAS_AVX512_BMM_in_convert_from_argb: s32;

K_CPU_HAS_LOONGARCH_in_convert_from_argb: s32;

K_CPU_HAS_LSX_in_convert_from_argb: s32;

K_CPU_HAS_LASX_in_convert_from_argb: s32;

ARGBToRGBA :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_rgba: *u8,
    dst_stride_rgba: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_argb,
        src_stride_argb,
        dst_rgba,
        dst_stride_rgba,
        cast(*u8) *K_SHUFFLE_MASK_ARGB_TO_RGBA,
        width,
        height
    );
}

ABGRToAR30 :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    abgr_to_ar30_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ABGRToAR30Row_C;
    if src_abgr == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_abgr = cast,no_check(*u8) ((src_abgr + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_abgr));
        src_stride_abgr = -src_stride_abgr;
    }

    if src_stride_abgr == width * 4 &&
        dst_stride_ar30 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar30 = 0;
        src_stride_abgr = dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            abgr_to_ar30_row(src_abgr, dst_ar30, width);
            src_abgr += src_stride_abgr;
            dst_ar30 += dst_stride_ar30;
        }
    }
    return 0;
}

ARGBToAR30 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_ar30_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToAR30Row_C;
    if src_argb == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_ar30 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar30 = 0;
        src_stride_argb = dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_ar30_row(src_argb, dst_ar30, width);
            src_argb += src_stride_argb;
            dst_ar30 += dst_stride_ar30;
        }
    }
    return 0;
}

ARGBToRGB24 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_rgb24_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToRGB24Row_C;
    if src_argb == null || dst_rgb24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_rgb24 == width * 3 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgb24 = 0;
        src_stride_argb = dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_rgb24_row(src_argb, dst_rgb24, width);
            src_argb += src_stride_argb;
            dst_rgb24 += dst_stride_rgb24;
        }
    }
    return 0;
}

ARGBToRAW :: (src_argb: *u8, src_stride_argb: s32, dst_raw: *u8, dst_stride_raw: s32, width: s32, height: s32) -> s32 {
    argb_to_raw_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToRAWRow_C;
    if src_argb == null || dst_raw == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_raw == width * 3 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_raw = 0;
        src_stride_argb = dst_stride_raw;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_raw_row(src_argb, dst_raw, width);
            src_argb += src_stride_argb;
            dst_raw += dst_stride_raw;
        }
    }
    return 0;
}

ARGBToRGB565 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_rgb565_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToRGB565Row_C;
    if src_argb == null || dst_rgb565 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_rgb565 == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgb565 = 0;
        src_stride_argb = dst_stride_rgb565;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_rgb565_row(src_argb, dst_rgb565, width);
            src_argb += src_stride_argb;
            dst_rgb565 += dst_stride_rgb565;
        }
    }
    return 0;
}

ARGBToRGB565Dither :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    dither4x4: *u8,
    width: s32,
    height: s32
) -> s32 {
    dither4: [4] u32 = ---;
    argb_to_rgb565_dither_row: #type (_: *u8, _: *u8, _: u32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: u32, _: s32)) ARGBToRGB565DitherRow_C;
    if src_argb == null || dst_rgb565 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }
    if dither4x4 == null {
        dither4x4 = cast,no_check(*u8) (K_DITHER565_4X4_storage.data);
    }
    copy_memory(dither4.data, dither4x4, 16);

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_rgb565_dither_row(src_argb, dst_rgb565, dither4[y & 3], width);
            src_argb += src_stride_argb;
            dst_rgb565 += dst_stride_rgb565;
        }
    }
    return 0;
}

ARGBToARGB1555 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb1555: *u8,
    dst_stride_argb1555: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_argb1555_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToARGB1555Row_C;
    if src_argb == null || dst_argb1555 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb1555 == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb1555 = 0;
        src_stride_argb = dst_stride_argb1555;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_argb1555_row(src_argb, dst_argb1555, width);
            src_argb += src_stride_argb;
            dst_argb1555 += dst_stride_argb1555;
        }
    }
    return 0;
}

ARGBToARGB4444 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb4444: *u8,
    dst_stride_argb4444: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_argb4444_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBToARGB4444Row_C;
    if src_argb == null || dst_argb4444 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb4444 == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb4444 = 0;
        src_stride_argb = dst_stride_argb4444;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_argb4444_row(src_argb, dst_argb4444, width);
            src_argb += src_stride_argb;
            dst_argb4444 += dst_stride_argb4444;
        }
    }
    return 0;
}

ARGBToI444 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToI444Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToI444Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv444_matrix_row: #type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUV444MatrixRow_C;

    if src_argb == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
            argb_to_uv444_matrix_row(src_argb, dst_u, dst_v, width, argbconstants);
            src_argb += src_stride_argb;
            dst_y += dst_stride_y;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    return 0;
}

ARGBToAR64 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_ar64: *u16,
    dst_stride_ar64: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_ar64_row: #type (_: *u8, _: *u16, _: s32) = cast,no_check(#type (_: *u8, _: *u16, _: s32)) ARGBToAR64Row_C;
    if src_argb == null || dst_ar64 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_ar64 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar64 = 0;
        src_stride_argb = dst_stride_ar64;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_ar64_row(src_argb, dst_ar64, width);
            src_argb += src_stride_argb;
            dst_ar64 += dst_stride_ar64;
        }
    }
    return 0;
}

ARGBToAB64 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_ab64: *u16,
    dst_stride_ab64: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_ab64_row: #type (_: *u8, _: *u16, _: s32) = cast,no_check(#type (_: *u8, _: *u16, _: s32)) ARGBToAB64Row_C;
    if src_argb == null || dst_ab64 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_ab64 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ab64 = 0;
        src_stride_argb = dst_stride_ab64;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_ab64_row(src_argb, dst_ab64, width);
            src_argb += src_stride_argb;
            dst_ab64 += dst_stride_ab64;
        }
    }
    return 0;
}

ARGBToI422 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToI422Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToI422Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;

    if src_argb == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_uv_matrix_row(src_argb, 0, dst_u, dst_v, width, argbconstants);
            argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
            src_argb += src_stride_argb;
            dst_y += dst_stride_y;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    return 0;
}

ARGBToJ420 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return argb_to_i420_matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ARGB_JPEG_CONSTANTS,
        width,
        height
    );
}

ARGBToJ422 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToI422Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ARGB_JPEG_CONSTANTS,
        width,
        height
    );
}

ARGBToJ444 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToI444Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ARGB_JPEG_CONSTANTS,
        width,
        height
    );
}

ARGBToJ400 :: (src_argb: *u8, src_stride_argb: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    return argb_to_i400_matrix(src_argb, src_stride_argb, dst_y, dst_stride_y, *K_ARGB_JPEG_CONSTANTS, width, height);
}

argb_to_i400_matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    constants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    if src_argb == null || dst_y == null || constants == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_y_matrix_row(src_argb, dst_y, width, constants);
            src_argb += src_stride_argb;
            dst_y += dst_stride_y;
        }
    }
    return 0;
}

ABGRToJ420 :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return argb_to_i420_matrix(
        src_abgr,
        src_stride_abgr,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ABGR_JPEG_CONSTANTS,
        width,
        height
    );
}

ABGRToJ422 :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToI422Matrix(
        src_abgr,
        src_stride_abgr,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ABGR_JPEG_CONSTANTS,
        width,
        height
    );
}

ABGRToJ400 :: (src_abgr: *u8, src_stride_abgr: s32, dst_yj: *u8, dst_stride_yj: s32, width: s32, height: s32) -> s32 {
    return argb_to_i400_matrix(src_abgr, src_stride_abgr, dst_yj, dst_stride_yj, *K_ABGR_JPEG_CONSTANTS, width, height);
}

RGBAToJ400 :: (src_rgba: *u8, src_stride_rgba: s32, dst_yj: *u8, dst_stride_yj: s32, width: s32, height: s32) -> s32 {
    return argb_to_i400_matrix(src_rgba, src_stride_rgba, dst_yj, dst_stride_yj, *K_RGBA_JPEG_CONSTANTS, width, height);
}

ARGBToI400 :: (src_argb: *u8, src_stride_argb: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    return argb_to_i400_matrix(src_argb, src_stride_argb, dst_y, dst_stride_y, *K_ARGB_I601_CONSTANTS, width, height);
}

ARGBToNV12 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV12Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToNV12Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;

    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if src_argb == null ||
        dst_y == null ||
        dst_uv == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    row_u_mem_size := cast,no_check(u64) ((halfwidth + 31) & ~(cast(s32) 31) * 2);

    row_u_mem: *void =
        cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

    row_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    row_v := cast,no_check(*u8) ((row_u + (halfwidth + 31) & ~(cast(s32) 31)));
    if row_u == null {
        return 1;
    }

    y: s32 = 0;
    while y < height - 1 {
        argb_to_uv_matrix_row(src_argb, src_stride_argb, row_u, row_v, width, argbconstants);
        merge_uv_row(row_u, row_v, dst_uv, halfwidth);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
        argb_to_y_matrix_row(src_argb + src_stride_argb, dst_y + dst_stride_y, width, argbconstants);
        src_argb += src_stride_argb * 2;
        dst_y += dst_stride_y * 2;
        dst_uv += dst_stride_uv;
        y += 2;
    }
    if height & 1 != 0 {
        argb_to_uv_matrix_row(src_argb, 0, row_u, row_v, width, argbconstants);
        merge_uv_row(row_u, row_v, dst_uv, halfwidth);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
    }
    c_transpiler_deallocate_memory(row_u_mem);

    row_u = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBToNV16 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV16Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToNV16Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := width >> 1 + width & 1;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;

    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if src_argb == null ||
        dst_y == null ||
        dst_uv == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    row_size := ((cast,no_check(u64) halfwidth) + 31) & ~(cast(u64) 31);
    if row_size > (cast(u64) 18446744073709551615) / 2 {
        return -1;
    }
    row_u_mem_size := row_size * 2;

    row_u_mem: *void =
        cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

    row_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row_u == null {
        return 1;
    }
    row_v := cast,no_check(*u8) ((row_u + row_size));

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_uv_matrix_row(src_argb, 0, row_u, row_v, width, argbconstants);
            argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
            merge_uv_row(row_u, row_v, dst_uv, halfwidth);
            src_argb += src_stride_argb;
            dst_y += dst_stride_y;
            dst_uv += dst_stride_uv;
        }
    }
    c_transpiler_deallocate_memory(row_u_mem);

    row_u = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBToNV24 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV24Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToNV24Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv444_matrix_row: #type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUV444MatrixRow_C;

    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if src_argb == null ||
        dst_y == null ||
        dst_uv == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    row_size := ((cast,no_check(u64) width) + 31) & ~(cast(u64) 31);
    if row_size > (cast(u64) 18446744073709551615) / 2 {
        return -1;
    }
    row_u_mem_size := row_size * 2;

    row_u_mem: *void =
        cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

    row_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row_u == null {
        return 1;
    }
    row_v := cast,no_check(*u8) ((row_u + row_size));

    if 0 < height {
        for y: 0..height - 1 {
            argb_to_uv444_matrix_row(src_argb, row_u, row_v, width, argbconstants);
            argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
            merge_uv_row(row_u, row_v, dst_uv, width);
            src_argb += src_stride_argb;
            dst_y += dst_stride_y;
            dst_uv += dst_stride_uv;
        }
    }
    c_transpiler_deallocate_memory(row_u_mem);

    row_u = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBToNV21Matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;

    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if src_argb == null ||
        dst_y == null ||
        dst_vu == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    row_u_mem_size := cast,no_check(u64) ((halfwidth + 31) & ~(cast(s32) 31) * 2);

    row_u_mem: *void =
        cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

    row_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    row_v := cast,no_check(*u8) ((row_u + (halfwidth + 31) & ~(cast(s32) 31)));
    if row_u == null {
        return 1;
    }

    y: s32 = 0;
    while y < height - 1 {
        argb_to_uv_matrix_row(src_argb, src_stride_argb, row_u, row_v, width, argbconstants);
        merge_uv_row(row_v, row_u, dst_vu, halfwidth);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
        argb_to_y_matrix_row(src_argb + src_stride_argb, dst_y + dst_stride_y, width, argbconstants);
        src_argb += src_stride_argb * 2;
        dst_y += dst_stride_y * 2;
        dst_vu += dst_stride_vu;
        y += 2;
    }
    if height & 1 != 0 {
        argb_to_uv_matrix_row(src_argb, 0, row_u, row_v, width, argbconstants);
        merge_uv_row(row_v, row_u, dst_vu, halfwidth);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
    }
    c_transpiler_deallocate_memory(row_u_mem);

    row_u = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBToNV21 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV21Matrix(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

ABGRToNV12 :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV12Matrix(
        src_abgr,
        src_stride_abgr,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

ABGRToNV21 :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBToNV21Matrix(
        src_abgr,
        src_stride_abgr,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

ARGBToYUY2 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    width: s32,
    height: s32
) -> s32 {
    return argb_to_yuy2_matrix(src_argb, src_stride_argb, dst_yuy2, dst_stride_yuy2, *K_ARGB_I601_CONSTANTS, width, height);
}

argb_to_yuy2_matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    constants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    y: s32 = ---;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    i422_to_yuy2_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToYUY2Row_C;

    if src_argb == null || dst_yuy2 == null || constants == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        dst_yuy2 = cast,no_check(*u8) ((dst_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_yuy2));
        dst_stride_yuy2 = -dst_stride_yuy2;
    }

    {
        row_y_mem_size := cast,no_check(u64) ((width + 63) & ~(cast(s32) 63) * 2);

        row_y_mem: *void =
            cast,no_check(*void) ((ifx row_y_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_y_mem_size + 63))));

        row_y :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_y_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        row_u := cast,no_check(*u8) ((row_y + (width + 63) & ~(cast(s32) 63)));
        row_v := cast,no_check(*u8) ((row_u + (width + 63) & ~(cast(s32) 63) / 2));
        if row_y == null {
            return 1;
        }

        y = 0;
        while y < height {
            argb_to_uv_matrix_row(src_argb, 0, row_u, row_v, width, constants);
            argb_to_y_matrix_row(src_argb, row_y, width, constants);
            i422_to_yuy2_row(row_y, row_u, row_v, dst_yuy2, width);
            src_argb += src_stride_argb;
            dst_yuy2 += dst_stride_yuy2;
            y += 1;
        }

        c_transpiler_deallocate_memory(row_y_mem);

        row_y = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

ARGBToUYVY :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_uyvy: *u8,
    dst_stride_uyvy: s32,
    width: s32,
    height: s32
) -> s32 {
    return argb_to_uyvy_matrix(src_argb, src_stride_argb, dst_uyvy, dst_stride_uyvy, *K_ARGB_I601_CONSTANTS, width, height);
}

argb_to_uyvy_matrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_uyvy: *u8,
    dst_stride_uyvy: s32,
    constants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    y: s32 = ---;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    i422_to_uyvy_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToUYVYRow_C;

    if src_argb == null || dst_uyvy == null || constants == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        dst_uyvy = cast,no_check(*u8) ((dst_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_uyvy));
        dst_stride_uyvy = -dst_stride_uyvy;
    }

    {
        row_y_mem_size := cast,no_check(u64) ((width + 63) & ~(cast(s32) 63) * 2);

        row_y_mem: *void =
            cast,no_check(*void) ((ifx row_y_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_y_mem_size + 63))));

        row_y :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_y_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        row_u := cast,no_check(*u8) ((row_y + (width + 63) & ~(cast(s32) 63)));
        row_v := cast,no_check(*u8) ((row_u + (width + 63) & ~(cast(s32) 63) / 2));
        if row_y == null {
            return 1;
        }

        y = 0;
        while y < height {
            argb_to_uv_matrix_row(src_argb, 0, row_u, row_v, width, constants);
            argb_to_y_matrix_row(src_argb, row_y, width, constants);
            i422_to_uyvy_row(row_y, row_u, row_v, dst_uyvy, width);
            src_argb += src_stride_argb;
            dst_uyvy += dst_stride_uyvy;
            y += 1;
        }

        c_transpiler_deallocate_memory(row_y_mem);

        row_y = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

RAWToNV21 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_nv21_matrix(
        src_raw,
        src_stride_raw,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

raw_to_nv21_matrix :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_nv_matrix(
        src_raw,
        src_stride_raw,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        argbconstants,
        width,
        height,
        1
    );
}

raw_to_nv_matrix :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    argbconstants: *Argb_Constants,
    width: s32,
    height: s32,
    is_nv21: s32
) -> s32 {
    y: s32 = ---;
    halfwidth := (width + 1) >> 1;
    rgb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUVMatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;
    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;

    if src_raw == null ||
        dst_y == null ||
        dst_uv == null ||
        argbconstants == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    {
        row_u_mem_size := cast,no_check(u64) halfwidth;

        row_u_mem: *void =
            cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

        row_u :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        row_v_mem_size := cast,no_check(u64) halfwidth;

        row_v_mem: *void =
            cast,no_check(*void) ((ifx row_v_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_v_mem_size + 63))));

        row_v :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_v_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));

        if row_u == null || row_v == null {
            c_transpiler_deallocate_memory(row_u_mem);

            row_u = cast,no_check(*u8) (cast(*u8) null);
            c_transpiler_deallocate_memory(row_v_mem);

            row_v = cast,no_check(*u8) (cast(*u8) null);
            return 1;
        }

        first_chroma :=
            cast,no_check(*u8) ((ifx is_nv21 != 0 then cast,no_check(*u8) (row_v) else cast,no_check(*u8) (row_u)));
        second_chroma :=
            cast,no_check(*u8) ((ifx is_nv21 != 0 then cast,no_check(*u8) (row_u) else cast,no_check(*u8) (row_v)));

        y = 0;
        while y < height - 1 {
            rgb_to_uv_matrix_row(src_raw, src_stride_raw, row_u, row_v, width, argbconstants);
            merge_uv_row(first_chroma, second_chroma, dst_uv, halfwidth);
            rgb_to_y_matrix_row(src_raw, dst_y, width, argbconstants);
            rgb_to_y_matrix_row(src_raw + src_stride_raw, dst_y + dst_stride_y, width, argbconstants);
            src_raw += src_stride_raw * 2;
            dst_y += dst_stride_y * 2;
            dst_uv += dst_stride_uv;
            y += 2;
        }
        if height & 1 != 0 {
            rgb_to_uv_matrix_row(src_raw, 0, row_u, row_v, width, argbconstants);
            merge_uv_row(first_chroma, second_chroma, dst_uv, halfwidth);
            rgb_to_y_matrix_row(src_raw, dst_y, width, argbconstants);
        }
        c_transpiler_deallocate_memory(row_v_mem);

        row_v = cast,no_check(*u8) (cast(*u8) null);
        c_transpiler_deallocate_memory(row_u_mem);

        row_u = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

RGB24ToNV12 :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_nv_matrix(
        src_rgb24,
        src_stride_rgb24,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        *K_ARGB_I601_CONSTANTS,
        width,
        height,
        0
    );
}

RAWToJNV21 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_nv21_matrix(
        src_raw,
        src_stride_raw,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        *K_ABGR_JPEG_CONSTANTS,
        width,
        height
    );
}

test_cpu_flag_in_convert_from_argb :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert_from_argb :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert_from_argb: u32;
initialize_globals_for_convert_from_argb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert_from_argb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert_from_argb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert_from_argb) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_convert_from_argb = 0x1;
    K_CPU_HAS_ARM_in_convert_from_argb = 0x2;
    K_CPU_HAS_NEON_in_convert_from_argb = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_convert_from_argb = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_convert_from_argb = 0x400;
    K_CPU_HAS_SVE_in_convert_from_argb = 0x800;
    K_CPU_HAS_SVE2_in_convert_from_argb = 0x1000;
    K_CPU_HAS_SME_in_convert_from_argb = 0x2000;
    K_CPU_HAS_SME2_in_convert_from_argb = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_convert_from_argb = 0x8000;
    K_CPU_HAS_RISCV_in_convert_from_argb = 0x4;
    K_CPU_HAS_RVV_in_convert_from_argb = 0x100;
    K_CPU_HAS_RVVZVFH_in_convert_from_argb = 0x200;
    K_CPU_HAS_X86_in_convert_from_argb = 0x8;
    K_CPU_HAS_SSE2_in_convert_from_argb = 0x100;
    K_CPU_HAS_SSSE3_in_convert_from_argb = 0x200;
    K_CPU_HAS_SSE41_in_convert_from_argb = 0x400;
    K_CPU_HAS_SSE42_in_convert_from_argb = 0x800;
    K_CPU_HAS_AVX_in_convert_from_argb = 0x1000;
    K_CPU_HAS_AVX2_in_convert_from_argb = 0x2000;
    K_CPU_HAS_ERMS_in_convert_from_argb = 0x4000;
    K_CPU_HAS_FSMR_in_convert_from_argb = 0x8000;
    K_CPU_HAS_FMA3_in_convert_from_argb = 0x10000;
    K_CPU_HAS_F16_C_in_convert_from_argb = 0x20000;
    K_CPU_HAS_AVX512_BW_in_convert_from_argb = 0x40000;
    K_CPU_HAS_AVX512_VL_in_convert_from_argb = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_convert_from_argb = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_convert_from_argb = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_convert_from_argb = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_convert_from_argb = 0x800000;
    K_CPU_HAS_AVX10_in_convert_from_argb = 0x1000000;
    K_CPU_HAS_AVX10_2_in_convert_from_argb = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_convert_from_argb = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_convert_from_argb = 0x8000000;
    K_CPU_HAS_AMXINT8_in_convert_from_argb = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_convert_from_argb = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_convert_from_argb = 0x20;
    K_CPU_HAS_LSX_in_convert_from_argb = 0x100;
    K_CPU_HAS_LASX_in_convert_from_argb = 0x200;
    K_SHUFFLE_MASK_ARGB_TO_RGBA =
        u8.[
            3,
            0,
            1,
            2,
            7,
            4,
            5,
            6,
            11,
            8,
            9,
            10,
            15,
            12,
            13,
            14
        ];
    K_DITHER565_4X4_storage =
        u8.[
            0,
            4,
            1,
            5,
            6,
            2,
            7,
            3,
            1,
            5,
            0,
            4,
            7,
            3,
            6,
            2
        ];
    atomic_store(*globals_initialization_state_for_convert_from_argb, 2);
}

