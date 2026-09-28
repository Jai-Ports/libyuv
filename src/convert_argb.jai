K_SHUFFLE_MASK_BGRA_TO_ARGB: Uvec8;

K_SHUFFLE_MASK_ABGR_TO_ARGB: Uvec8;

K_SHUFFLE_MASK_RGBA_TO_ARGB: Uvec8;

K_SHUFFLE_MASK_AR64_TO_AB64: Uvec8;

K_DITHER565_4X4: [16] u8;

K_CPU_INITIALIZED_in_convert_argb: s32;

K_CPU_HAS_ARM_in_convert_argb: s32;

K_CPU_HAS_NEON_in_convert_argb: s32;

K_CPU_HAS_NEON_DOT_PROD_in_convert_argb: s32;

K_CPU_HAS_NEON_I8_MM_in_convert_argb: s32;

K_CPU_HAS_SVE_in_convert_argb: s32;

K_CPU_HAS_SVE2_in_convert_argb: s32;

K_CPU_HAS_SME_in_convert_argb: s32;

K_CPU_HAS_SME2_in_convert_argb: s32;

K_CPU_HAS_SVEF32_MM_in_convert_argb: s32;

K_CPU_HAS_RISCV_in_convert_argb: s32;

K_CPU_HAS_RVV_in_convert_argb: s32;

K_CPU_HAS_RVVZVFH_in_convert_argb: s32;

K_CPU_HAS_X86_in_convert_argb: s32;

K_CPU_HAS_SSE2_in_convert_argb: s32;

K_CPU_HAS_SSSE3_in_convert_argb: s32;

K_CPU_HAS_SSE41_in_convert_argb: s32;

K_CPU_HAS_SSE42_in_convert_argb: s32;

K_CPU_HAS_AVX_in_convert_argb: s32;

K_CPU_HAS_AVX2_in_convert_argb: s32;

K_CPU_HAS_ERMS_in_convert_argb: s32;

K_CPU_HAS_FSMR_in_convert_argb: s32;

K_CPU_HAS_FMA3_in_convert_argb: s32;

K_CPU_HAS_F16_C_in_convert_argb: s32;

K_CPU_HAS_AVX512_BW_in_convert_argb: s32;

K_CPU_HAS_AVX512_VL_in_convert_argb: s32;

K_CPU_HAS_AVX512_VNNI_in_convert_argb: s32;

K_CPU_HAS_AVX512_VBMI_in_convert_argb: s32;

K_CPU_HAS_AVX512_VBMI2_in_convert_argb: s32;

K_CPU_HAS_AVX512_VBITALG_in_convert_argb: s32;

K_CPU_HAS_AVX10_in_convert_argb: s32;

K_CPU_HAS_AVX10_2_in_convert_argb: s32;

K_CPU_HAS_AVXVNNI_in_convert_argb: s32;

K_CPU_HAS_AVXVNNIINT8_in_convert_argb: s32;

K_CPU_HAS_AMXINT8_in_convert_argb: s32;

K_CPU_HAS_AVX512_BMM_in_convert_argb: s32;

K_CPU_HAS_LOONGARCH_in_convert_argb: s32;

K_CPU_HAS_LSX_in_convert_argb: s32;

K_CPU_HAS_LASX_in_convert_argb: s32;

ARGBCopy :: (src_argb: *u8, src_stride_argb: s32, dst_argb: *u8, dst_stride_argb: s32, width: s32, height: s32) -> s32 {
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    CopyPlane(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width * 4, height);
    return 0;
}

I420ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

J420ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_JPEG_CONSTANTS,
        width,
        height
    );
}

J420ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_JPEG_CONSTANTS,
        width,
        height
    );
}

H420ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H420ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U420ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U420ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU2020_CONSTANTS,
        width,
        height
    );
}

I422ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I422ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_y == width &&
        src_stride_u * 2 == width &&
        src_stride_v * 2 == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_v = dst_stride_argb;
        src_stride_u = src_stride_v;
        src_stride_y = src_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I422ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

J422ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_JPEG_CONSTANTS,
        width,
        height
    );
}

J422ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_JPEG_CONSTANTS,
        width,
        height
    );
}

H422ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H422ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U422ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U422ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU2020_CONSTANTS,
        width,
        height
    );
}

I444ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I444ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_y == width &&
        src_stride_u == width &&
        src_stride_v == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_v = dst_stride_argb;
        src_stride_u = src_stride_v;
        src_stride_y = src_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i444_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I444ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

J444ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_JPEG_CONSTANTS,
        width,
        height
    );
}

J444ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_JPEG_CONSTANTS,
        width,
        height
    );
}

H444ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H444ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U444ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U444ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU2020_CONSTANTS,
        width,
        height
    );
}

I444ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I444ToRGB24Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToRGB24Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb24 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    if src_stride_y == width &&
        src_stride_u == width &&
        src_stride_v == width &&
        dst_stride_rgb24 == width * 3 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgb24 = 0;
        src_stride_v = dst_stride_rgb24;
        src_stride_u = src_stride_v;
        src_stride_y = src_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i444_to_rgb24_row(src_y, src_u, src_v, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I444ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return I444ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_raw,
        dst_stride_raw,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

I010ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I010ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i210_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I010ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H010ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H010ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U010ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U010ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU2020_CONSTANTS,
        width,
        height
    );
}

I210ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I210ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i210_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I210ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H210ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H210ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U210ToARGB :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_argb,
        dst_stride_argb,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U210ToABGR :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU2020_CONSTANTS,
        width,
        height
    );
}

I420AlphaToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I420AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_a,
        src_stride_a,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I420AlphaToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i422_alpha_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420AlphaToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I420AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        src_a,
        src_stride_a,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I422AlphaToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I422AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_a,
        src_stride_a,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I422AlphaToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i422_alpha_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I422AlphaToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I422AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        src_a,
        src_stride_a,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I444AlphaToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I444AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_a,
        src_stride_a,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I444AlphaToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i444_alpha_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i444_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I444AlphaToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    return I444AlphaToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        src_a,
        src_stride_a,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height,
        attenuate
    );
}

I400ToARGB :: (src_y: *u8, src_stride_y: s32, dst_argb: *u8, dst_stride_argb: s32, width: s32, height: s32) -> s32 {
    return I400ToARGBMatrix(src_y, src_stride_y, dst_argb, dst_stride_argb, *K_YUV_I601_CONSTANTS, width, height);
}

I400ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i400_to_argb_row: #type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I400ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_y == width && dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_y = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i400_to_argb_row(src_y, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
        }
    }
    return 0;
}

J400ToARGB :: (src_y: *u8, src_stride_y: s32, dst_argb: *u8, dst_stride_argb: s32, width: s32, height: s32) -> s32 {
    j400_to_argb_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) J400ToARGBRow_C;
    if src_y == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }

    if src_stride_y == width && dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_y = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            j400_to_argb_row(src_y, dst_argb, width);
            src_y += src_stride_y;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

NV12ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12ToARGBMatrix(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

NV12ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    nv12_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV12ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv12_to_argb_row(src_y, src_uv, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_uv += src_stride_uv;
            }
        }
    }
    return 0;
}

NV21ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV21ToARGBMatrix(
        src_y,
        src_stride_y,
        src_vu,
        src_stride_vu,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

NV21ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    nv21_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV21ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null || src_vu == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv21_to_argb_row(src_y, src_vu, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_vu += src_stride_vu;
            }
        }
    }
    return 0;
}

NV12ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV21ToARGBMatrix(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

NV21ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12ToARGBMatrix(
        src_y,
        src_stride_y,
        src_vu,
        src_stride_vu,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

NV12ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

NV12ToRGB24Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    nv12_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV12ToRGB24Row_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_rgb24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv12_to_rgb24_row(src_y, src_uv, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_uv += src_stride_uv;
            }
        }
    }
    return 0;
}

NV21ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV21ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_vu,
        src_stride_vu,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

NV21ToRGB24Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    nv21_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV21ToRGB24Row_C;
    assert(yuvconstants != null);
    if src_y == null || src_vu == null || dst_rgb24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv21_to_rgb24_row(src_y, src_vu, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_vu += src_stride_vu;
            }
        }
    }
    return 0;
}

NV21ToYUV24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_yuv24: *u8,
    dst_stride_yuv24: s32,
    width: s32,
    height: s32
) -> s32 {
    nv21_to_yuv24_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) NV21ToYUV24Row_C;
    if src_y == null || src_vu == null || dst_yuv24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_yuv24 = cast,no_check(*u8) ((dst_yuv24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_yuv24));
        dst_stride_yuv24 = -dst_stride_yuv24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv21_to_yuv24_row(src_y, src_vu, dst_yuv24, width);
            dst_yuv24 += dst_stride_yuv24;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_vu += src_stride_vu;
            }
        }
    }
    return 0;
}

NV12ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV21ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_raw,
        dst_stride_raw,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

NV21ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_vu,
        src_stride_vu,
        dst_raw,
        dst_stride_raw,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

YUY2ToARGB :: (
    src_yuy2: *u8,
    src_stride_yuy2: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return YUY2ToARGBMatrix(src_yuy2, src_stride_yuy2, dst_argb, dst_stride_argb, *K_YUV_I601_CONSTANTS, width, height);
}

YUY2ToARGBMatrix :: (
    src_yuy2: *u8,
    src_stride_yuy2: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    yuy2_to_argb_row: #type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32)) YUY2ToARGBRow_C;
    if src_yuy2 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_yuy2 = cast,no_check(*u8) ((src_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_yuy2));
        src_stride_yuy2 = -src_stride_yuy2;
    }

    if src_stride_yuy2 == width * 2 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_yuy2 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            yuy2_to_argb_row(src_yuy2, dst_argb, yuvconstants, width);
            src_yuy2 += src_stride_yuy2;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

UYVYToARGB :: (
    src_uyvy: *u8,
    src_stride_uyvy: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return UYVYToARGBMatrix(src_uyvy, src_stride_uyvy, dst_argb, dst_stride_argb, *K_YUV_I601_CONSTANTS, width, height);
}

UYVYToARGBMatrix :: (
    src_uyvy: *u8,
    src_stride_uyvy: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    uyvy_to_argb_row: #type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *Yuv_Constants, _: s32)) UYVYToARGBRow_C;
    if src_uyvy == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uyvy = cast,no_check(*u8) ((src_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uyvy));
        src_stride_uyvy = -src_stride_uyvy;
    }

    if src_stride_uyvy == width * 2 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_uyvy = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            uyvy_to_argb_row(src_uyvy, dst_argb, yuvconstants, width);
            src_uyvy += src_stride_uyvy;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

I010ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I010ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i210_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_to_ar30_row(src_y, src_u, src_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

H010ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

I010ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H010ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U010ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U010ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I010ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

I210ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I210ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i210_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_to_ar30_row(src_y, src_u, src_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I210ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H210ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H210ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

U210ToAR30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

U210ToAB30 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I210ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YUV2020_CONSTANTS,
        width,
        height
    );
}

BGRAToARGB :: (
    src_bgra: *u8,
    src_stride_bgra: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_bgra,
        src_stride_bgra,
        dst_argb,
        dst_stride_argb,
        cast(*u8) *K_SHUFFLE_MASK_BGRA_TO_ARGB,
        width,
        height
    );
}

ABGRToARGB :: (
    src_abgr: *u8,
    src_stride_abgr: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_abgr,
        src_stride_abgr,
        dst_argb,
        dst_stride_argb,
        cast(*u8) *K_SHUFFLE_MASK_ABGR_TO_ARGB,
        width,
        height
    );
}

RGBAToARGB :: (
    src_rgba: *u8,
    src_stride_rgba: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_rgba,
        src_stride_rgba,
        dst_argb,
        dst_stride_argb,
        cast(*u8) *K_SHUFFLE_MASK_RGBA_TO_ARGB,
        width,
        height
    );
}

RGB24ToARGB :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb24_to_argb_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) RGB24ToARGBRow_C;
    if src_rgb24 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_rgb24 = cast,no_check(*u8) ((src_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb24));
        src_stride_rgb24 = -src_stride_rgb24;
    }

    if src_stride_rgb24 == width * 3 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_rgb24 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb24_to_argb_row(src_rgb24, dst_argb, width);
            src_rgb24 += src_stride_rgb24;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

RAWToARGB :: (src_raw: *u8, src_stride_raw: s32, dst_argb: *u8, dst_stride_argb: s32, width: s32, height: s32) -> s32 {
    raw_to_argb_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) RAWToARGBRow_C;
    if src_raw == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    if src_stride_raw == width * 3 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_raw = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            raw_to_argb_row(src_raw, dst_argb, width);
            src_raw += src_stride_raw;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

RAWToRGBA :: (src_raw: *u8, src_stride_raw: s32, dst_rgba: *u8, dst_stride_rgba: s32, width: s32, height: s32) -> s32 {
    raw_to_rgba_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) RAWToRGBARow_C;
    if src_raw == null || dst_rgba == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    if src_stride_raw == width * 3 &&
        dst_stride_rgba == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgba = 0;
        src_stride_raw = dst_stride_rgba;
    }

    if 0 < height {
        for y: 0..height - 1 {
            raw_to_rgba_row(src_raw, dst_rgba, width);
            src_raw += src_stride_raw;
            dst_rgba += dst_stride_rgba;
        }
    }
    return 0;
}

RGB565ToARGB :: (
    src_rgb565: *u8,
    src_stride_rgb565: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb565_to_argb_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) RGB565ToARGBRow_C;
    if src_rgb565 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_rgb565 =
            cast,no_check(*u8) ((src_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb565));
        src_stride_rgb565 = -src_stride_rgb565;
    }

    if src_stride_rgb565 == width * 2 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_rgb565 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb565_to_argb_row(src_rgb565, dst_argb, width);
            src_rgb565 += src_stride_rgb565;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGB1555ToARGB :: (
    src_argb1555: *u8,
    src_stride_argb1555: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb1555_to_argb_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGB1555ToARGBRow_C;
    if src_argb1555 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb1555 =
            cast,no_check(*u8) ((src_argb1555 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb1555));
        src_stride_argb1555 = -src_stride_argb1555;
    }

    if src_stride_argb1555 == width * 2 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb1555 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb1555_to_argb_row(src_argb1555, dst_argb, width);
            src_argb1555 += src_stride_argb1555;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGB4444ToARGB :: (
    src_argb4444: *u8,
    src_stride_argb4444: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb4444_to_argb_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGB4444ToARGBRow_C;
    if src_argb4444 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb4444 =
            cast,no_check(*u8) ((src_argb4444 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb4444));
        src_stride_argb4444 = -src_stride_argb4444;
    }

    if src_stride_argb4444 == width * 2 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb4444 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb4444_to_argb_row(src_argb4444, dst_argb, width);
            src_argb4444 += src_stride_argb4444;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

AR30ToARGB :: (
    src_ar30: *u8,
    src_stride_ar30: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_ar30 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ar30 = cast,no_check(*u8) ((src_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ar30));
        src_stride_ar30 = -src_stride_ar30;
    }

    if src_stride_ar30 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_ar30 = dst_stride_argb;
    }
    if 0 < height {
        for y: 0..height - 1 {
            AR30ToARGBRow_C(src_ar30, dst_argb, width);
            src_ar30 += src_stride_ar30;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

AR30ToABGR :: (
    src_ar30: *u8,
    src_stride_ar30: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_ar30 == null || dst_abgr == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ar30 = cast,no_check(*u8) ((src_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ar30));
        src_stride_ar30 = -src_stride_ar30;
    }

    if src_stride_ar30 == width * 4 &&
        dst_stride_abgr == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_abgr = 0;
        src_stride_ar30 = dst_stride_abgr;
    }
    if 0 < height {
        for y: 0..height - 1 {
            AR30ToABGRRow_C(src_ar30, dst_abgr, width);
            src_ar30 += src_stride_ar30;
            dst_abgr += dst_stride_abgr;
        }
    }
    return 0;
}

AR30ToAB30 :: (
    src_ar30: *u8,
    src_stride_ar30: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_ar30 == null || dst_ab30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ar30 = cast,no_check(*u8) ((src_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ar30));
        src_stride_ar30 = -src_stride_ar30;
    }

    if src_stride_ar30 == width * 4 &&
        dst_stride_ab30 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ab30 = 0;
        src_stride_ar30 = dst_stride_ab30;
    }
    if 0 < height {
        for y: 0..height - 1 {
            AR30ToAB30Row_C(src_ar30, dst_ab30, width);
            src_ar30 += src_stride_ar30;
            dst_ab30 += dst_stride_ab30;
        }
    }
    return 0;
}

AR64ToARGB :: (
    src_ar64: *u16,
    src_stride_ar64: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    ar64_to_argb_row: #type (_: *u16, _: *u8, _: s32) = cast,no_check(#type (_: *u16, _: *u8, _: s32)) AR64ToARGBRow_C;
    if src_ar64 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ar64 = cast,no_check(*u16) ((src_ar64 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ar64));
        src_stride_ar64 = -src_stride_ar64;
    }

    if src_stride_ar64 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_ar64 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            ar64_to_argb_row(src_ar64, dst_argb, width);
            src_ar64 += src_stride_ar64;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

AB64ToARGB :: (
    src_ab64: *u16,
    src_stride_ab64: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    ab64_to_argb_row: #type (_: *u16, _: *u8, _: s32) = cast,no_check(#type (_: *u16, _: *u8, _: s32)) AB64ToARGBRow_C;
    if src_ab64 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ab64 = cast,no_check(*u16) ((src_ab64 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ab64));
        src_stride_ab64 = -src_stride_ab64;
    }

    if src_stride_ab64 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_ab64 = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            ab64_to_argb_row(src_ab64, dst_argb, width);
            src_ab64 += src_stride_ab64;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

AR64ToAB64 :: (
    src_ar64: *u16,
    src_stride_ar64: s32,
    dst_ab64: *u16,
    dst_stride_ab64: s32,
    width: s32,
    height: s32
) -> s32 {
    return AR64Shuffle(
        src_ar64,
        src_stride_ar64,
        dst_ab64,
        dst_stride_ab64,
        cast(*u8) *K_SHUFFLE_MASK_AR64_TO_AB64,
        width,
        height
    );
}

Android420ToARGB :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_pixel_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    return Android420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_pixel_stride_uv,
        dst_argb,
        dst_stride_argb,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

Android420ToARGBMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_pixel_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    VU_OFF := src_v - src_u;
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_pixel_stride_uv == 1 {
        return I420ToARGBMatrix(
            src_y,
            src_stride_y,
            src_u,
            src_stride_u,
            src_v,
            src_stride_v,
            dst_argb,
            dst_stride_argb,
            yuvconstants,
            width,
            height
        );
    }
    if src_pixel_stride_uv == 2 && VU_OFF == -1 && src_stride_u == src_stride_v {
        return NV21ToARGBMatrix(
            src_y,
            src_stride_y,
            src_v,
            src_stride_v,
            dst_argb,
            dst_stride_argb,
            yuvconstants,
            width,
            height
        );
    }
    if src_pixel_stride_uv == 2 && VU_OFF == 1 && src_stride_u == src_stride_v {
        return NV12ToARGBMatrix(
            src_y,
            src_stride_y,
            src_u,
            src_stride_u,
            dst_argb,
            dst_stride_argb,
            yuvconstants,
            width,
            height
        );
    }

    UV_SIZE := ((cast,no_check(u64) halfwidth) * 2) * cast,no_check(u64) halfheight;
    if UV_SIZE > cast(u64) 18446744073709551615 {
        return 1;
    }
    plane_uv_mem_size := UV_SIZE;

    plane_uv_mem: *void =
        cast,no_check(*void) ((ifx plane_uv_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(plane_uv_mem_size + 63))));

    plane_uv :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) plane_uv_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if plane_uv == null {
        return 1;
    }
    dst_uv := cast,no_check(*u8) (plane_uv);
    if 0 < halfheight {
        for y: 0..halfheight - 1 {
            weave_pixels(src_u, src_v, src_pixel_stride_uv, dst_uv, halfwidth);
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_uv += halfwidth * 2;
        }
    }
    NV12ToARGBMatrix(
        src_y,
        src_stride_y,
        plane_uv,
        halfwidth * 2,
        dst_argb,
        dst_stride_argb,
        yuvconstants,
        width,
        height
    );
    c_transpiler_deallocate_memory(plane_uv_mem);

    plane_uv = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

weave_pixels :: (src_u: *u8, src_v: *u8, src_pixel_stride_uv: s32, dst_uv: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst_uv[0] = src_u.*;
            dst_uv[1] = src_v.*;
            dst_uv += 2;
            src_u += src_pixel_stride_uv;
            src_v += src_pixel_stride_uv;
        }
    }
}

Android420ToABGR :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_pixel_stride_uv: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return Android420ToARGBMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        src_pixel_stride_uv,
        dst_abgr,
        dst_stride_abgr,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

NV12ToRGB565 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12ToRGB565Matrix(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_rgb565,
        dst_stride_rgb565,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

NV12ToRGB565Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    nv12_to_rgb565_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV12ToRGB565Row_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_rgb565 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb565 =
            cast,no_check(*u8) ((dst_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb565));
        dst_stride_rgb565 = -dst_stride_rgb565;
    }

    if 0 < height {
        for y: 0..height - 1 {
            nv12_to_rgb565_row(src_y, src_uv, dst_rgb565, yuvconstants, width);
            dst_rgb565 += dst_stride_rgb565;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_uv += src_stride_uv;
            }
        }
    }
    return 0;
}

I422ToBGRA :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_bgra: *u8,
    dst_stride_bgra: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToRGBAMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_bgra,
        dst_stride_bgra,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

I422ToRGBAMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgba: *u8,
    dst_stride_rgba: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgba_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGBARow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgba == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgba = cast,no_check(*u8) ((dst_rgba + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgba));
        dst_stride_rgba = -dst_stride_rgba;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgba_row(src_y, src_u, src_v, dst_rgba, yuvconstants, width);
            dst_rgba += dst_stride_rgba;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I422ToRGBA :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgba: *u8,
    dst_stride_rgba: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToRGBAMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgba,
        dst_stride_rgba,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToBGRA :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_bgra: *u8,
    dst_stride_bgra: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGBAMatrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_bgra,
        dst_stride_bgra,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

I420ToRGBAMatrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgba: *u8,
    dst_stride_rgba: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgba_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGBARow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgba == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgba = cast,no_check(*u8) ((dst_rgba + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgba));
        dst_stride_rgba = -dst_stride_rgba;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgba_row(src_y, src_u, src_v, dst_rgba, yuvconstants, width);
            dst_rgba += dst_stride_rgba;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToRGBA :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgba: *u8,
    dst_stride_rgba: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGBAMatrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgba,
        dst_stride_rgba,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToRGB24Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGB24Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb24 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgb24_row(src_y, src_u, src_v, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_raw,
        dst_stride_raw,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H420ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

H420ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_raw,
        dst_stride_raw,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

J420ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_JPEG_CONSTANTS,
        width,
        height
    );
}

J420ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_raw,
        dst_stride_raw,
        *K_YVU_JPEG_CONSTANTS,
        width,
        height
    );
}

I422ToRGB24 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb24,
        dst_stride_rgb24,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I422ToRGB24Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGB24Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb24 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgb24_row(src_y, src_u, src_v, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I422ToRAW :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_raw: *u8,
    dst_stride_raw: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToRGB24Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_raw,
        dst_stride_raw,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

I420ToRGB565 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB565Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb565,
        dst_stride_rgb565,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToRGB565Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgb565_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGB565Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb565 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb565 =
            cast,no_check(*u8) ((dst_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb565));
        dst_stride_rgb565 = -dst_stride_rgb565;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgb565_row(src_y, src_u, src_v, dst_rgb565, yuvconstants, width);
            dst_rgb565 += dst_stride_rgb565;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

J420ToRGB565 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB565Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb565,
        dst_stride_rgb565,
        *K_YUV_JPEG_CONSTANTS,
        width,
        height
    );
}

H420ToRGB565 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToRGB565Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb565,
        dst_stride_rgb565,
        *K_YUV_H709_CONSTANTS,
        width,
        height
    );
}

I422ToRGB565 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    width: s32,
    height: s32
) -> s32 {
    return I422ToRGB565Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_rgb565,
        dst_stride_rgb565,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I422ToRGB565Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_rgb565_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToRGB565Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb565 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb565 =
            cast,no_check(*u8) ((dst_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb565));
        dst_stride_rgb565 = -dst_stride_rgb565;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_rgb565_row(src_y, src_u, src_v, dst_rgb565, yuvconstants, width);
            dst_rgb565 += dst_stride_rgb565;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I420ToRGB565Dither :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb565: *u8,
    dst_stride_rgb565: s32,
    dither4x4: *u8,
    width: s32,
    height: s32
) -> s32 {
    y: s32 = ---;
    dither4: [4] u32 = ---;
    i422_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToARGBRow_C;
    argb_to_rgb565_dither_row: #type (_: *u8, _: *u8, _: u32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: u32, _: s32)) ARGBToRGB565DitherRow_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb565 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb565 =
            cast,no_check(*u8) ((dst_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb565));
        dst_stride_rgb565 = -dst_stride_rgb565;
    }
    if dither4x4 == null {
        dither4x4 = cast,no_check(*u8) (K_DITHER565_4X4.data);
    }
    copy_memory(dither4.data, dither4x4, 16);

    {
        row_argb_mem_size := cast,no_check(u64) (width * 4);

        row_argb_mem: *void =
            cast,no_check(*void) ((ifx row_argb_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_argb_mem_size + 63))));

        row_argb :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_argb_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row_argb == null {
            return 1;
        }
        y = 0;
        while y < height {
            i422_to_argb_row(src_y, src_u, src_v, row_argb, *K_YUV_I601_CONSTANTS, width);
            argb_to_rgb565_dither_row(row_argb, dst_rgb565, dither4[y & 3], width);
            dst_rgb565 += dst_stride_rgb565;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
            y += 1;
        }
        c_transpiler_deallocate_memory(row_argb_mem);

        row_argb = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

I420ToARGB1555 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb1555: *u8,
    dst_stride_argb1555: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_argb1555_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToARGB1555Row_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb1555 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb1555 =
            cast,no_check(*u8) ((dst_argb1555 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb1555));
        dst_stride_argb1555 = -dst_stride_argb1555;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_argb1555_row(src_y, src_u, src_v, dst_argb1555, *K_YUV_I601_CONSTANTS, width);
            dst_argb1555 += dst_stride_argb1555;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToARGB4444 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb4444: *u8,
    dst_stride_argb4444: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_argb4444_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToARGB4444Row_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb4444 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb4444 =
            cast,no_check(*u8) ((dst_argb4444 +
                (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb4444));
        dst_stride_argb4444 = -dst_stride_argb4444;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_argb4444_row(src_y, src_u, src_v, dst_argb4444, *K_YUV_I601_CONSTANTS, width);
            dst_argb4444 += dst_stride_argb4444;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToAR30 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YUV_I601_CONSTANTS,
        width,
        height
    );
}

I420ToAR30Matrix :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i422_to_ar30_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I422ToAR30Row_C;

    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_ar30_row(src_y, src_u, src_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I420ToAB30 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_I601_CONSTANTS,
        width,
        height
    );
}

H420ToAR30 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToAR30Matrix(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_ar30,
        dst_stride_ar30,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

H420ToAB30 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_ab30: *u8,
    dst_stride_ab30: s32,
    width: s32,
    height: s32
) -> s32 {
    return I420ToAR30Matrix(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_ab30,
        dst_stride_ab30,
        *K_YVU_H709_CONSTANTS,
        width,
        height
    );
}

I410ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i410_to_ar30_row(src_y, src_u, src_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I012ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i212_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I212ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i212_to_ar30_row(src_y, src_u, src_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I012ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i212_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I212ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i212_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I410ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i410_to_argb_row(src_y, src_u, src_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

P010ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p210_to_argb_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P210ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            p210_to_argb_row(src_y, src_uv, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_uv += src_stride_uv;
            }
        }
    }
    return 0;
}

P210ToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p210_to_argb_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P210ToARGBRow_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            p210_to_argb_row(src_y, src_uv, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }
    return 0;
}

P010ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p210_to_ar30_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P210ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            p210_to_ar30_row(src_y, src_uv, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_uv += src_stride_uv;
            }
        }
    }
    return 0;
}

P210ToAR30Matrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p210_to_ar30_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P210ToAR30Row_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if 0 < height {
        for y: 0..height - 1 {
            p210_to_ar30_row(src_y, src_uv, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }
    return 0;
}

I010AlphaToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i210_alpha_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            if y & 1 != 0 {
                src_u += src_stride_u;
                src_v += src_stride_v;
            }
        }
    }
    return 0;
}

I210AlphaToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i210_alpha_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I210AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i210_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I410AlphaToARGBMatrix :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i410_alpha_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i410_alpha_to_argb_row(src_y, src_u, src_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    return 0;
}

I420ToARGBMatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I420ToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i420_to_argb_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR;
            return -1;
    }

    return -1;
}

i420_to_argb_matrix_bilinear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToARGBRow_C;
    scale2_row_up_bilinear: #type (_: *u8, _: s64, _: *u8, _: s64, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: s32)) ScaleRowUp2_Bilinear_Any_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 4);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u8) (row);
    temp_u_2 := cast,no_check(*u8) ((row + ROW_SIZE));
    temp_v_1 := cast,no_check(*u8) ((row + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u8) ((row + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear(src_u, temp_u_1, width);
    scale_row_up2_linear(src_v, temp_v_1, width);
    i444_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
    dst_argb += dst_stride_argb;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i444_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        i444_to_argb_row(src_y, temp_u_2, temp_v_2, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_u += src_stride_u;
        src_v += src_stride_v;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear(src_u, temp_u_1, width);
        scale_row_up2_linear(src_v, temp_v_1, width);
        i444_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I422ToARGBMatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I422ToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i422_to_argb_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i422_to_argb_matrix_linear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToARGBRow_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u8) (row);
    temp_v := cast,no_check(*u8) ((row + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_u, temp_u, width);
            scale_row_up2_linear(src_v, temp_v, width);
            i444_to_argb_row(src_y, temp_u, temp_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I422ToRGB24MatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I422ToRGB24Matrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_rgb24,
                dst_stride_rgb24,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i422_to_rgb24_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_rgb24,
                dst_stride_rgb24,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i422_to_rgb24_matrix_linear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToRGB24Row_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb24 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u8) (row);
    temp_v := cast,no_check(*u8) ((row + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_u, temp_u, width);
            scale_row_up2_linear(src_v, temp_v, width);
            i444_to_rgb24_row(src_y, temp_u, temp_v, dst_rgb24, yuvconstants, width);
            dst_rgb24 += dst_stride_rgb24;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I420ToRGB24MatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I420ToRGB24Matrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_rgb24,
                dst_stride_rgb24,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i420_to_rgb24_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_rgb24,
                dst_stride_rgb24,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i420_to_rgb24_matrix_bilinear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i444_to_rgb24_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToRGB24Row_C;
    scale2_row_up_bilinear: #type (_: *u8, _: s64, _: *u8, _: s64, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: s32)) ScaleRowUp2_Bilinear_Any_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_rgb24 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_rgb24 = cast,no_check(*u8) ((dst_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb24));
        dst_stride_rgb24 = -dst_stride_rgb24;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 4);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u8) (row);
    temp_u_2 := cast,no_check(*u8) ((row + ROW_SIZE));
    temp_v_1 := cast,no_check(*u8) ((row + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u8) ((row + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear(src_u, temp_u_1, width);
    scale_row_up2_linear(src_v, temp_v_1, width);
    i444_to_rgb24_row(src_y, temp_u_1, temp_v_1, dst_rgb24, yuvconstants, width);
    dst_rgb24 += dst_stride_rgb24;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i444_to_rgb24_row(src_y, temp_u_1, temp_v_1, dst_rgb24, yuvconstants, width);
        dst_rgb24 += dst_stride_rgb24;
        src_y += src_stride_y;
        i444_to_rgb24_row(src_y, temp_u_2, temp_v_2, dst_rgb24, yuvconstants, width);
        dst_rgb24 += dst_stride_rgb24;
        src_y += src_stride_y;
        src_u += src_stride_u;
        src_v += src_stride_v;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear(src_u, temp_u_1, width);
        scale_row_up2_linear(src_v, temp_v_1, width);
        i444_to_rgb24_row(src_y, temp_u_1, temp_v_1, dst_rgb24, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I010ToAR30MatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I010ToAR30Matrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i010_to_ar30_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i010_to_ar30_matrix_bilinear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToAR30Row_C;
    scale2_row_up_bilinear_12: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleRowUp2_Bilinear_16_Any_C;
    scale_row_up2_linear_12: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 4)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u16) (cast(*u16) row);
    temp_u_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    temp_v_1 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear_12(src_u, temp_u_1, width);
    scale_row_up2_linear_12(src_v, temp_v_1, width);
    i410_to_ar30_row(src_y, temp_u_1, temp_v_1, dst_ar30, yuvconstants, width);
    dst_ar30 += dst_stride_ar30;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear_12(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear_12(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i410_to_ar30_row(src_y, temp_u_1, temp_v_1, dst_ar30, yuvconstants, width);
        dst_ar30 += dst_stride_ar30;
        src_y += src_stride_y;
        i410_to_ar30_row(src_y, temp_u_2, temp_v_2, dst_ar30, yuvconstants, width);
        dst_ar30 += dst_stride_ar30;
        src_y += src_stride_y;
        src_u += src_stride_u;
        src_v += src_stride_v;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear_12(src_u, temp_u_1, width);
        scale_row_up2_linear_12(src_v, temp_v_1, width);
        i410_to_ar30_row(src_y, temp_u_1, temp_v_1, dst_ar30, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);

    return 0;
}

I210ToAR30MatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I210ToAR30Matrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i210_to_ar30_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i210_to_ar30_matrix_linear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_ar30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToAR30Row_C;
    scale_row_up2_linear_12: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_ar30 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 2)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u16) (cast(*u16) row);
    temp_v := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear_12(src_u, temp_u, width);
            scale_row_up2_linear_12(src_v, temp_v, width);
            i410_to_ar30_row(src_y, temp_u, temp_v, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I010ToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I010ToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i010_to_argb_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i010_to_argb_matrix_bilinear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToARGBRow_C;
    scale2_row_up_bilinear_12: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleRowUp2_Bilinear_16_Any_C;
    scale_row_up2_linear_12: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 4)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u16) (cast(*u16) row);
    temp_u_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    temp_v_1 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear_12(src_u, temp_u_1, width);
    scale_row_up2_linear_12(src_v, temp_v_1, width);
    i410_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
    dst_argb += dst_stride_argb;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear_12(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear_12(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i410_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        i410_to_argb_row(src_y, temp_u_2, temp_v_2, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_u += src_stride_u;
        src_v += src_stride_v;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear_12(src_u, temp_u_1, width);
        scale_row_up2_linear_12(src_v, temp_v_1, width);
        i410_to_argb_row(src_y, temp_u_1, temp_v_1, dst_argb, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I210ToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I210ToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i210_to_argb_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

i210_to_argb_matrix_linear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    i410_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410ToARGBRow_C;
    scale_row_up2_linear_12: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 2)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u16) (cast(*u16) row);
    temp_v := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear_12(src_u, temp_u, width);
            scale_row_up2_linear_12(src_v, temp_v, width);
            i410_to_argb_row(src_y, temp_u, temp_v, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I420AlphaToARGBMatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I420AlphaToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i420_alpha_to_argb_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
    }

    return -1;
}

i420_alpha_to_argb_matrix_bilinear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i444_alpha_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    scale2_row_up_bilinear: #type (_: *u8, _: s64, _: *u8, _: s64, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: s32)) ScaleRowUp2_Bilinear_Any_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 4);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u8) (row);
    temp_u_2 := cast,no_check(*u8) ((row + ROW_SIZE));
    temp_v_1 := cast,no_check(*u8) ((row + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u8) ((row + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear(src_u, temp_u_1, width);
    scale_row_up2_linear(src_v, temp_v_1, width);
    i444_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
    if attenuate != 0 {
        argb_attenuate_row(dst_argb, dst_argb, width);
    }
    dst_argb += dst_stride_argb;
    src_y += src_stride_y;
    src_a += src_stride_a;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i444_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_a += src_stride_a;
        i444_alpha_to_argb_row(src_y, temp_u_2, temp_v_2, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_u += src_stride_u;
        src_v += src_stride_v;
        src_a += src_stride_a;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear(src_u, temp_u_1, width);
        scale_row_up2_linear(src_v, temp_v_1, width);
        i444_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I422AlphaToARGBMatrixFilter :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I422AlphaToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i422_alpha_to_argb_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
    }

    return -1;
}

i422_alpha_to_argb_matrix_linear :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i444_alpha_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    scale_row_up2_linear: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size := cast,no_check(u64) (ROW_SIZE * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u8) (row);
    temp_v := cast,no_check(*u8) ((row + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_u, temp_u, width);
            scale_row_up2_linear(src_v, temp_v, width);
            i444_alpha_to_argb_row(src_y, temp_u, temp_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I010AlphaToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I010AlphaToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return i010_alpha_to_argb_matrix_bilinear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
    }

    return -1;
}

i010_alpha_to_argb_matrix_bilinear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i410_alpha_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    scale2_row_up_bilinear_12: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleRowUp2_Bilinear_16_Any_C;
    scale_row_up2_linear_12: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 4)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u_1 := cast,no_check(*u16) (cast(*u16) row);
    temp_u_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    temp_v_1 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 2));
    temp_v_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE * 3));
    if row == null {
        return 1;
    }

    scale_row_up2_linear_12(src_u, temp_u_1, width);
    scale_row_up2_linear_12(src_v, temp_v_1, width);
    i410_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
    if attenuate != 0 {
        argb_attenuate_row(dst_argb, dst_argb, width);
    }
    dst_argb += dst_stride_argb;
    src_y += src_stride_y;
    src_a += src_stride_a;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear_12(src_u, cast,no_check(s64) src_stride_u, temp_u_1, cast,no_check(s64) ROW_SIZE, width);
        scale2_row_up_bilinear_12(src_v, cast,no_check(s64) src_stride_v, temp_v_1, cast,no_check(s64) ROW_SIZE, width);
        i410_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_a += src_stride_a;
        i410_alpha_to_argb_row(src_y, temp_u_2, temp_v_2, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_a += src_stride_a;
        src_u += src_stride_u;
        src_v += src_stride_v;
        y += 2;
    }

    if height & 1 == 0 {
        scale_row_up2_linear_12(src_u, temp_u_1, width);
        scale_row_up2_linear_12(src_v, temp_v_1, width);
        i410_alpha_to_argb_row(src_y, temp_u_1, temp_v_1, src_a, dst_argb, yuvconstants, width);
        if attenuate != 0 {
            argb_attenuate_row(dst_argb, dst_argb, width);
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

I210AlphaToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return I210AlphaToARGBMatrix(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return i210_alpha_to_argb_matrix_linear(
                src_y,
                src_stride_y,
                src_u,
                src_stride_u,
                src_v,
                src_stride_v,
                src_a,
                src_stride_a,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height,
                attenuate
            );
    }

    return -1;
}

i210_alpha_to_argb_matrix_linear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    attenuate: s32
) -> s32 {
    i410_alpha_to_argb_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) I410AlphaToARGBRow_C;
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    scale_row_up2_linear: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_a == null ||
        dst_argb == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 2)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_u := cast,no_check(*u16) (cast(*u16) row);
    temp_v := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_u, temp_u, width);
            scale_row_up2_linear(src_v, temp_v, width);
            i410_alpha_to_argb_row(src_y, temp_u, temp_v, src_a, dst_argb, yuvconstants, width);
            if attenuate != 0 {
                argb_attenuate_row(dst_argb, dst_argb, width);
            }
            dst_argb += dst_stride_argb;
            src_a += src_stride_a;
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

P010ToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return P010ToARGBMatrix(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return p010_to_argb_matrix_bilinear(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

p010_to_argb_matrix_bilinear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p410_to_argb_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P410ToARGBRow_C;
    scale2_row_up_bilinear_16: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleUVRowUp2_Bilinear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (2 * width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 2)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_uv_1 := cast,no_check(*u16) (cast(*u16) row);
    temp_uv_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    if row == null {
        return 1;
    }

    scale2_row_up_bilinear_16(src_uv, 0, temp_uv_1, cast,no_check(s64) ROW_SIZE, width);
    p410_to_argb_row(src_y, temp_uv_1, dst_argb, yuvconstants, width);
    dst_argb += dst_stride_argb;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear_16(
            src_uv,
            cast,no_check(s64) src_stride_uv,
            temp_uv_1,
            cast,no_check(s64) ROW_SIZE,
            width
        );
        p410_to_argb_row(src_y, temp_uv_1, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        p410_to_argb_row(src_y, temp_uv_2, dst_argb, yuvconstants, width);
        dst_argb += dst_stride_argb;
        src_y += src_stride_y;
        src_uv += src_stride_uv;
        y += 2;
    }

    if height & 1 == 0 {
        scale2_row_up_bilinear_16(src_uv, 0, temp_uv_1, cast,no_check(s64) ROW_SIZE, width);
        p410_to_argb_row(src_y, temp_uv_1, dst_argb, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

P210ToARGBMatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return P210ToARGBMatrix(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return p210_to_argb_matrix_linear(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_argb,
                dst_stride_argb,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

p210_to_argb_matrix_linear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p410_to_argb_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P410ToARGBRow_C;
    scale_row_up2_linear: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleUVRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    ROW_SIZE := (2 * width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) ROW_SIZE) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_uv := cast,no_check(*u16) (cast(*u16) row);
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_uv, temp_uv, width);
            p410_to_argb_row(src_y, temp_uv, dst_argb, yuvconstants, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

P010ToAR30MatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return P010ToAR30Matrix(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_LINEAR; #through;
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX;
            return p010_to_ar30_matrix_bilinear(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

p010_to_ar30_matrix_bilinear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p410_to_ar30_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P410ToAR30Row_C;
    scale2_row_up_bilinear_16: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleUVRowUp2_Bilinear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    ROW_SIZE := (2 * width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) (ROW_SIZE * 2)) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_uv_1 := cast,no_check(*u16) (cast(*u16) row);
    temp_uv_2 := cast,no_check(*u16) (((cast(*u16) row) + ROW_SIZE));
    if row == null {
        return 1;
    }

    scale2_row_up_bilinear_16(src_uv, 0, temp_uv_1, cast,no_check(s64) ROW_SIZE, width);
    p410_to_ar30_row(src_y, temp_uv_1, dst_ar30, yuvconstants, width);
    dst_ar30 += dst_stride_ar30;
    src_y += src_stride_y;

    y: s32 = 0;
    while y < height - 2 {
        scale2_row_up_bilinear_16(
            src_uv,
            cast,no_check(s64) src_stride_uv,
            temp_uv_1,
            cast,no_check(s64) ROW_SIZE,
            width
        );
        p410_to_ar30_row(src_y, temp_uv_1, dst_ar30, yuvconstants, width);
        dst_ar30 += dst_stride_ar30;
        src_y += src_stride_y;
        p410_to_ar30_row(src_y, temp_uv_2, dst_ar30, yuvconstants, width);
        dst_ar30 += dst_stride_ar30;
        src_y += src_stride_y;
        src_uv += src_stride_uv;
        y += 2;
    }

    if height & 1 == 0 {
        scale2_row_up_bilinear_16(src_uv, 0, temp_uv_1, cast,no_check(s64) ROW_SIZE, width);
        p410_to_ar30_row(src_y, temp_uv_1, dst_ar30, yuvconstants, width);
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

P210ToAR30MatrixFilter :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32,
    filter: Filter_Mode
) -> s32 {
    if cast,no_check(s32) filter == {
        case cast,no_check(s32) K_FILTER_NONE;
            return P210ToAR30Matrix(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
        case cast,no_check(s32) K_FILTER_BILINEAR; #through;
        case cast,no_check(s32) K_FILTER_BOX; #through;
        case cast,no_check(s32) K_FILTER_LINEAR;
            return p210_to_ar30_matrix_linear(
                src_y,
                src_stride_y,
                src_uv,
                src_stride_uv,
                dst_ar30,
                dst_stride_ar30,
                yuvconstants,
                width,
                height
            );
    }

    return -1;
}

p210_to_ar30_matrix_linear :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    yuvconstants: *Yuv_Constants,
    width: s32,
    height: s32
) -> s32 {
    p410_to_ar30_row: #type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u8, _: *Yuv_Constants, _: s32)) P410ToAR30Row_C;
    scale_row_up2_linear: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleUVRowUp2_Linear_16_Any_C;
    assert(yuvconstants != null);
    if src_y == null || src_uv == null || dst_ar30 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    ROW_SIZE := (2 * width + 31) & ~(cast(s32) 31);
    row_mem_size: u64 = (cast,no_check(u64) ROW_SIZE) * 2;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    temp_uv := cast,no_check(*u16) (cast(*u16) row);
    if row == null {
        return 1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            scale_row_up2_linear(src_uv, temp_uv, width);
            p410_to_ar30_row(src_y, temp_uv, dst_ar30, yuvconstants, width);
            dst_ar30 += dst_stride_ar30;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }

    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBToBGRA :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_bgra: *u8,
    dst_stride_bgra: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_argb,
        src_stride_argb,
        dst_bgra,
        dst_stride_bgra,
        cast(*u8) *K_SHUFFLE_MASK_BGRA_TO_ARGB,
        width,
        height
    );
}

ARGBToABGR :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_abgr: *u8,
    dst_stride_abgr: s32,
    width: s32,
    height: s32
) -> s32 {
    return ARGBShuffle(
        src_argb,
        src_stride_argb,
        dst_abgr,
        dst_stride_abgr,
        cast(*u8) *K_SHUFFLE_MASK_ABGR_TO_ARGB,
        width,
        height
    );
}

test_cpu_flag_in_convert_argb :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert_argb :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert_argb: u32;
initialize_globals_for_convert_argb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert_argb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert_argb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert_argb) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_convert_argb = 0x1;
    K_CPU_HAS_ARM_in_convert_argb = 0x2;
    K_CPU_HAS_NEON_in_convert_argb = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_convert_argb = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_convert_argb = 0x400;
    K_CPU_HAS_SVE_in_convert_argb = 0x800;
    K_CPU_HAS_SVE2_in_convert_argb = 0x1000;
    K_CPU_HAS_SME_in_convert_argb = 0x2000;
    K_CPU_HAS_SME2_in_convert_argb = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_convert_argb = 0x8000;
    K_CPU_HAS_RISCV_in_convert_argb = 0x4;
    K_CPU_HAS_RVV_in_convert_argb = 0x100;
    K_CPU_HAS_RVVZVFH_in_convert_argb = 0x200;
    K_CPU_HAS_X86_in_convert_argb = 0x8;
    K_CPU_HAS_SSE2_in_convert_argb = 0x100;
    K_CPU_HAS_SSSE3_in_convert_argb = 0x200;
    K_CPU_HAS_SSE41_in_convert_argb = 0x400;
    K_CPU_HAS_SSE42_in_convert_argb = 0x800;
    K_CPU_HAS_AVX_in_convert_argb = 0x1000;
    K_CPU_HAS_AVX2_in_convert_argb = 0x2000;
    K_CPU_HAS_ERMS_in_convert_argb = 0x4000;
    K_CPU_HAS_FSMR_in_convert_argb = 0x8000;
    K_CPU_HAS_FMA3_in_convert_argb = 0x10000;
    K_CPU_HAS_F16_C_in_convert_argb = 0x20000;
    K_CPU_HAS_AVX512_BW_in_convert_argb = 0x40000;
    K_CPU_HAS_AVX512_VL_in_convert_argb = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_convert_argb = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_convert_argb = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_convert_argb = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_convert_argb = 0x800000;
    K_CPU_HAS_AVX10_in_convert_argb = 0x1000000;
    K_CPU_HAS_AVX10_2_in_convert_argb = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_convert_argb = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_convert_argb = 0x8000000;
    K_CPU_HAS_AMXINT8_in_convert_argb = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_convert_argb = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_convert_argb = 0x20;
    K_CPU_HAS_LSX_in_convert_argb = 0x100;
    K_CPU_HAS_LASX_in_convert_argb = 0x200;
    K_SHUFFLE_MASK_BGRA_TO_ARGB =
        u8.[
            3,
            2,
            1,
            0,
            7,
            6,
            5,
            4,
            11,
            10,
            9,
            8,
            15,
            14,
            13,
            12
        ];
    K_SHUFFLE_MASK_ABGR_TO_ARGB =
        u8.[
            2,
            1,
            0,
            3,
            6,
            5,
            4,
            7,
            10,
            9,
            8,
            11,
            14,
            13,
            12,
            15
        ];
    K_SHUFFLE_MASK_RGBA_TO_ARGB =
        u8.[
            1,
            2,
            3,
            0,
            5,
            6,
            7,
            4,
            9,
            10,
            11,
            8,
            13,
            14,
            15,
            12
        ];
    K_SHUFFLE_MASK_AR64_TO_AB64 =
        u8.[
            4,
            5,
            2,
            3,
            0,
            1,
            6,
            7,
            12,
            13,
            10,
            11,
            8,
            9,
            14,
            15
        ];
    K_DITHER565_4X4 =
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
    atomic_store(*globals_initialization_state_for_convert_argb, 2);
}

Uvec8 :: [16] u8;

Yuv_Constants :: struct {
    k_uv_to_b: [32] u8;
    k_uv_to_g: [32] u8;
    k_uv_to_r: [32] u8;
    k_y_to_rgb: [16] s16;
    k_y_bias_to_rgb: [16] s16;
}

