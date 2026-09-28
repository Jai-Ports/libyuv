K_CPU_INITIALIZED_in_planar_functions: s32;

K_CPU_HAS_ARM_in_planar_functions: s32;

K_CPU_HAS_NEON_in_planar_functions: s32;

K_CPU_HAS_NEON_DOT_PROD_in_planar_functions: s32;

K_CPU_HAS_NEON_I8_MM_in_planar_functions: s32;

K_CPU_HAS_SVE_in_planar_functions: s32;

K_CPU_HAS_SVE2_in_planar_functions: s32;

K_CPU_HAS_SME_in_planar_functions: s32;

K_CPU_HAS_SME2_in_planar_functions: s32;

K_CPU_HAS_SVEF32_MM_in_planar_functions: s32;

K_CPU_HAS_RISCV_in_planar_functions: s32;

K_CPU_HAS_RVV_in_planar_functions: s32;

K_CPU_HAS_RVVZVFH_in_planar_functions: s32;

K_CPU_HAS_X86_in_planar_functions: s32;

K_CPU_HAS_SSE2_in_planar_functions: s32;

K_CPU_HAS_SSSE3_in_planar_functions: s32;

K_CPU_HAS_SSE41_in_planar_functions: s32;

K_CPU_HAS_SSE42_in_planar_functions: s32;

K_CPU_HAS_AVX_in_planar_functions: s32;

K_CPU_HAS_AVX2_in_planar_functions: s32;

K_CPU_HAS_ERMS_in_planar_functions: s32;

K_CPU_HAS_FSMR_in_planar_functions: s32;

K_CPU_HAS_FMA3_in_planar_functions: s32;

K_CPU_HAS_F16_C_in_planar_functions: s32;

K_CPU_HAS_AVX512_BW_in_planar_functions: s32;

K_CPU_HAS_AVX512_VL_in_planar_functions: s32;

K_CPU_HAS_AVX512_VNNI_in_planar_functions: s32;

K_CPU_HAS_AVX512_VBMI_in_planar_functions: s32;

K_CPU_HAS_AVX512_VBMI2_in_planar_functions: s32;

K_CPU_HAS_AVX512_VBITALG_in_planar_functions: s32;

K_CPU_HAS_AVX10_in_planar_functions: s32;

K_CPU_HAS_AVX10_2_in_planar_functions: s32;

K_CPU_HAS_AVXVNNI_in_planar_functions: s32;

K_CPU_HAS_AVXVNNIINT8_in_planar_functions: s32;

K_CPU_HAS_AMXINT8_in_planar_functions: s32;

K_CPU_HAS_AVX512_BMM_in_planar_functions: s32;

K_CPU_HAS_LOONGARCH_in_planar_functions: s32;

K_CPU_HAS_LSX_in_planar_functions: s32;

K_CPU_HAS_LASX_in_planar_functions: s32;

CopyPlane :: (src_y: *u8, src_stride_y: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) {
    copy_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) CopyRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if src_y == dst_y && src_stride_y == dst_stride_y {
        return;
    }

    if 0 < height {
        for y: 0..height - 1 {
            copy_row(src_y, dst_y, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

CopyPlane_16 :: (src_y: *u16, src_stride_y: s32, dst_y: *u16, dst_stride_y: s32, width: s32, height: s32) {
    CopyPlane(cast(*u8) src_y, src_stride_y * 2, cast(*u8) dst_y, dst_stride_y * 2, width * 2, height);
}

Convert16To8Plane :: (
    src_y: *u16,
    src_stride_y: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    scale: s32,
    width: s32,
    height: s32
) {
    convert16_to8_row: #type (_: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u8, _: s32, _: s32)) Convert16To8Row_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            convert16_to8_row(src_y, dst_y, scale, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

Convert8To16Plane :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    bits: s32,
    width: s32,
    height: s32
) {
    convert8_to16_row: #type (_: *u8, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u16, _: s32, _: s32)) Convert8To16Row_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if bits > 16 {
        b: s32 = 0;
        while bits > 1 {
            c_transpiler_compound_shr(*(bits), (cast(s32) 1), s32, s32);
            b += 1;
        }
        bits = b;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u16) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            convert8_to16_row(src_y, dst_y, bits, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

Convert8To8Plane :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    scale: s32,
    bias: s32,
    width: s32,
    height: s32
) {
    convert8_to8_row: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) Convert8To8Row_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            convert8_to8_row(src_y, dst_y, scale, bias, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

SetPlane :: (dst_y: *u8, dst_stride_y: s32, width: s32, height: s32, value: u32) {
    set_row: #type (_: *u8, _: u8, _: s32) = cast,no_check(#type (_: *u8, _: u8, _: s32)) SetRow_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }
    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            set_row(dst_y, cast,no_check(u8) value, width);
            dst_y += dst_stride_y;
        }
    }
}

DetilePlane :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    width: s32,
    height: s32,
    tile_height: s32
) -> s32 {
    SRC_TILE_STRIDE := cast,no_check(s64) (16 * tile_height);

    detile_row: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) DetileRow_C;
    if src_y == null ||
        dst_y == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        tile_height & (tile_height - 1) != 0 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            detile_row(src_y, SRC_TILE_STRIDE, dst_y, width);
            dst_y += dst_stride_y;
            src_y += 16;

            if y & (tile_height - 1) == tile_height - 1 {
                src_y = cast,no_check(*u8) ((src_y - SRC_TILE_STRIDE + src_stride_y * tile_height));
            }
        }
    }
    return 0;
}

DetilePlane_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    width: s32,
    height: s32,
    tile_height: s32
) -> s32 {
    SRC_TILE_STRIDE := cast,no_check(s64) (16 * tile_height);

    detile_row_16: #type (_: *u16, _: s64, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) DetileRow_16_C;
    if src_y == null ||
        dst_y == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        tile_height & (tile_height - 1) != 0 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u16) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            detile_row_16(src_y, SRC_TILE_STRIDE, dst_y, width);
            dst_y += dst_stride_y;
            src_y += 16;

            if y & (tile_height - 1) == tile_height - 1 {
                src_y = cast,no_check(*u16) ((src_y - SRC_TILE_STRIDE + src_stride_y * tile_height));
            }
        }
    }
    return 0;
}

DetileSplitUVPlane :: (
    src_uv: *u8,
    src_stride_uv: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    tile_height: s32
) {
    SRC_TILE_STRIDE := cast,no_check(s64) (16 * tile_height);

    detile_split_uv_row: #type (_: *u8, _: s64, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: *u8, _: s32)) DetileSplitUVRow_C;
    assert(src_stride_uv >= 0);
    assert(tile_height > 0);
    assert(src_stride_uv > 0);

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_u = cast,no_check(*u8) ((dst_u + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_u));
        dst_stride_u = -dst_stride_u;
        dst_v = cast,no_check(*u8) ((dst_v + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_v));
        dst_stride_v = -dst_stride_v;
    }

    if 0 < height {
        for y: 0..height - 1 {
            detile_split_uv_row(src_uv, SRC_TILE_STRIDE, dst_u, dst_v, width);
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
            src_uv += 16;

            if y & (tile_height - 1) == tile_height - 1 {
                src_uv = cast,no_check(*u8) ((src_uv - SRC_TILE_STRIDE + src_stride_uv * tile_height));
            }
        }
    }
}

DetileToYUY2 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    width: s32,
    height: s32,
    tile_height: s32
) {
    SRC_Y_TILE_STRIDE := cast,no_check(s64) (16 * tile_height);
    SRC_UV_TILE_STRIDE := SRC_Y_TILE_STRIDE / 2;

    detile_to_yuy2: #type (_: *u8, _: s64, _: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: *u8, _: s32)) DetileToYUY2_C;
    assert(src_stride_y >= 0);
    assert(src_stride_y > 0);
    assert(src_stride_uv >= 0);
    assert(src_stride_uv > 0);
    assert(tile_height > 0);

    if width <= 0 || height == 0 || height == -2147483647 - 1 || tile_height <= 0 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_yuy2 = cast,no_check(*u8) ((dst_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_yuy2));
        dst_stride_yuy2 = -dst_stride_yuy2;
    }

    if 0 < height {
        for y: 0..height - 1 {
            detile_to_yuy2(src_y, SRC_Y_TILE_STRIDE, src_uv, SRC_UV_TILE_STRIDE, dst_yuy2, width);
            dst_yuy2 += dst_stride_yuy2;
            src_y += 16;

            if y & 0x1 != 0 {
                src_uv += 16;
            }

            if y & (tile_height - 1) == tile_height - 1 {
                src_y = cast,no_check(*u8) ((src_y - SRC_Y_TILE_STRIDE + src_stride_y * tile_height));
                src_uv = cast,no_check(*u8) ((src_uv - SRC_UV_TILE_STRIDE + src_stride_uv * (tile_height / 2)));
            }
        }
    }
}

SplitUVPlane :: (
    src_uv: *u8,
    src_stride_uv: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) {
    split_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) SplitUVRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_u = cast,no_check(*u8) ((dst_u + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_u));
        dst_v = cast,no_check(*u8) ((dst_v + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_v));
        dst_stride_u = -dst_stride_u;
        dst_stride_v = -dst_stride_v;
    }

    if src_stride_uv == width * 2 &&
        dst_stride_u == width &&
        dst_stride_v == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_v = 0;
        dst_stride_u = dst_stride_v;
        src_stride_uv = dst_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            split_uv_row(src_uv, dst_u, dst_v, width);
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
            src_uv += src_stride_uv;
        }
    }
}

MergeUVPlane :: (
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) {
    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_uv = cast,no_check(*u8) ((dst_uv + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_uv));
        dst_stride_uv = -dst_stride_uv;
    }

    if src_stride_u == width &&
        src_stride_v == width &&
        dst_stride_uv == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_uv = 0;
        src_stride_v = dst_stride_uv;
        src_stride_u = src_stride_v;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_uv_row(src_u, src_v, dst_uv, width);
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_uv += dst_stride_uv;
        }
    }
}

SplitUVPlane_16 :: (
    src_uv: *u16,
    src_stride_uv: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    split_uv_row_16: #type (_: *u16, _: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: s32, _: s32)) SplitUVRow_16_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_u = cast,no_check(*u16) ((dst_u + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_u));
        dst_v = cast,no_check(*u16) ((dst_v + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_v));
        dst_stride_u = -dst_stride_u;
        dst_stride_v = -dst_stride_v;
    }

    if src_stride_uv == width * 2 &&
        dst_stride_u == width &&
        dst_stride_v == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_v = 0;
        dst_stride_u = dst_stride_v;
        src_stride_uv = dst_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            split_uv_row_16(src_uv, dst_u, dst_v, depth, width);
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
            src_uv += src_stride_uv;
        }
    }
}

MergeUVPlane_16 :: (
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_uv_row_16: #type (_: *u16, _: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: s32, _: s32)) MergeUVRow_16_C;
    assert(depth >= 8);
    assert(depth <= 16);
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_uv = cast,no_check(*u16) ((dst_uv + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_uv));
        dst_stride_uv = -dst_stride_uv;
    }

    if src_stride_u == width &&
        src_stride_v == width &&
        dst_stride_uv == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_uv = 0;
        src_stride_v = dst_stride_uv;
        src_stride_u = src_stride_v;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_uv_row_16(src_u, src_v, dst_uv, depth, width);
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_uv += dst_stride_uv;
        }
    }
}

ConvertToMSBPlane_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    scale := (cast(s32) 1) << (((16 - depth)) & 31);
    multiply_row_16: #type (_: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32)) MultiplyRow_16_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u16) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            multiply_row_16(src_y, dst_y, scale, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

ConvertToLSBPlane_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    scale := (cast(s32) 1) << ((depth) & 31);
    divide_row: #type (_: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32)) DivideRow_16_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u16) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            divide_row(src_y, dst_y, scale, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

HalfMergeUVPlane :: (
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) {
    half_merge_uv_row: #type (_: *u8, _: s32, _: *u8, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32, _: *u8, _: s32)) HalfMergeUVRow_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    y: s32 = 0;
    while y < height - 1 {
        half_merge_uv_row(src_u, src_stride_u, src_v, src_stride_v, dst_uv, width);
        src_u += src_stride_u * 2;
        src_v += src_stride_v * 2;
        dst_uv += dst_stride_uv;
        y += 2;
    }
    if height & 1 != 0 {
        half_merge_uv_row(src_u, 0, src_v, 0, dst_uv, width);
    }
}

SwapUVPlane :: (src_uv: *u8, src_stride_uv: s32, dst_vu: *u8, dst_stride_vu: s32, width: s32, height: s32) {
    swap_uv_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) SwapUVRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    if src_stride_uv == width * 2 &&
        dst_stride_vu == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_vu = 0;
        src_stride_uv = dst_stride_vu;
    }

    if 0 < height {
        for y: 0..height - 1 {
            swap_uv_row(src_uv, dst_vu, width);
            src_uv += src_stride_uv;
            dst_vu += dst_stride_vu;
        }
    }
}

SplitRGBPlane :: (
    src_rgb: *u8,
    src_stride_rgb: s32,
    dst_r: *u8,
    dst_stride_r: s32,
    dst_g: *u8,
    dst_stride_g: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    split_rgb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) SplitRGBRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_r = cast,no_check(*u8) ((dst_r + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_r));
        dst_g = cast,no_check(*u8) ((dst_g + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_g));
        dst_b = cast,no_check(*u8) ((dst_b + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_b));
        dst_stride_r = -dst_stride_r;
        dst_stride_g = -dst_stride_g;
        dst_stride_b = -dst_stride_b;
    }

    if src_stride_rgb == width * 3 &&
        dst_stride_r == width &&
        dst_stride_g == width &&
        dst_stride_b == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_b = 0;
        dst_stride_g = dst_stride_b;
        dst_stride_r = dst_stride_g;
        src_stride_rgb = dst_stride_r;
    }

    if 0 < height {
        for y: 0..height - 1 {
            split_rgb_row(src_rgb, dst_r, dst_g, dst_b, width);
            dst_r += dst_stride_r;
            dst_g += dst_stride_g;
            dst_b += dst_stride_b;
            src_rgb += src_stride_rgb;
        }
    }
}

MergeRGBPlane :: (
    src_r: *u8,
    src_stride_r: s32,
    src_g: *u8,
    src_stride_g: s32,
    src_b: *u8,
    src_stride_b: s32,
    dst_rgb: *u8,
    dst_stride_rgb: s32,
    width: s32,
    height: s32
) {
    merge_rgb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) MergeRGBRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_rgb = cast,no_check(*u8) ((dst_rgb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_rgb));
        dst_stride_rgb = -dst_stride_rgb;
    }

    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        dst_stride_rgb == width * 3 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgb = 0;
        src_stride_b = dst_stride_rgb;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_rgb_row(src_r, src_g, src_b, dst_rgb, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            dst_rgb += dst_stride_rgb;
        }
    }
}

SplitARGBPlane :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_r: *u8,
    dst_stride_r: s32,
    dst_g: *u8,
    dst_stride_g: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    width: s32,
    height: s32
) {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_r = cast,no_check(*u8) ((dst_r + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_r));
        dst_g = cast,no_check(*u8) ((dst_g + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_g));
        dst_b = cast,no_check(*u8) ((dst_b + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_b));
        dst_a = cast,no_check(*u8) ((dst_a + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_a));
        dst_stride_r = -dst_stride_r;
        dst_stride_g = -dst_stride_g;
        dst_stride_b = -dst_stride_b;
        dst_stride_a = -dst_stride_a;
    }

    if dst_a == null {
        split_argb_plane_opaque(
            src_argb,
            src_stride_argb,
            dst_r,
            dst_stride_r,
            dst_g,
            dst_stride_g,
            dst_b,
            dst_stride_b,
            width,
            height
        );
    } else {
        split_argb_plane_alpha(
            src_argb,
            src_stride_argb,
            dst_r,
            dst_stride_r,
            dst_g,
            dst_stride_g,
            dst_b,
            dst_stride_b,
            dst_a,
            dst_stride_a,
            width,
            height
        );
    }
}

split_argb_plane_alpha :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_r: *u8,
    dst_stride_r: s32,
    dst_g: *u8,
    dst_stride_g: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    width: s32,
    height: s32
) {
    split_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: s32)) SplitARGBRow_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_argb == width * 4 &&
        dst_stride_r == width &&
        dst_stride_g == width &&
        dst_stride_b == width &&
        dst_stride_a == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_a = 0;
        dst_stride_b = dst_stride_a;
        dst_stride_g = dst_stride_b;
        dst_stride_r = dst_stride_g;
        src_stride_argb = dst_stride_r;
    }

    if 0 < height {
        for y: 0..height - 1 {
            split_argb_row(src_argb, dst_r, dst_g, dst_b, dst_a, width);
            dst_r += dst_stride_r;
            dst_g += dst_stride_g;
            dst_b += dst_stride_b;
            dst_a += dst_stride_a;
            src_argb += src_stride_argb;
        }
    }
}

split_argb_plane_opaque :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_r: *u8,
    dst_stride_r: s32,
    dst_g: *u8,
    dst_stride_g: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    split_xrgb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) SplitXRGBRow_C;
    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_argb == width * 4 &&
        dst_stride_r == width &&
        dst_stride_g == width &&
        dst_stride_b == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_b = 0;
        dst_stride_g = dst_stride_b;
        dst_stride_r = dst_stride_g;
        src_stride_argb = dst_stride_r;
    }

    if 0 < height {
        for y: 0..height - 1 {
            split_xrgb_row(src_argb, dst_r, dst_g, dst_b, width);
            dst_r += dst_stride_r;
            dst_g += dst_stride_g;
            dst_b += dst_stride_b;
            src_argb += src_stride_argb;
        }
    }
}

MergeARGBPlane :: (
    src_r: *u8,
    src_stride_r: s32,
    src_g: *u8,
    src_stride_g: s32,
    src_b: *u8,
    src_stride_b: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_a == null {
        merge_argb_plane_opaque(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            dst_argb,
            dst_stride_argb,
            width,
            height
        );
    } else {
        merge_argb_plane_alpha(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            src_a,
            src_stride_a,
            dst_argb,
            dst_stride_argb,
            width,
            height
        );
    }
}

merge_argb_plane_alpha :: (
    src_r: *u8,
    src_stride_r: s32,
    src_g: *u8,
    src_stride_g: s32,
    src_b: *u8,
    src_stride_b: s32,
    src_a: *u8,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) {
    merge_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *u8, _: s32)) MergeARGBRow_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        src_stride_a == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_a = dst_stride_argb;
        src_stride_b = src_stride_a;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_argb_row(src_r, src_g, src_b, src_a, dst_argb, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            src_a += src_stride_a;
            dst_argb += dst_stride_argb;
        }
    }
}

merge_argb_plane_opaque :: (
    src_r: *u8,
    src_stride_r: s32,
    src_g: *u8,
    src_stride_g: s32,
    src_b: *u8,
    src_stride_b: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) {
    merge_xrgb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) MergeXRGBRow_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_b = dst_stride_argb;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_xrgb_row(src_r, src_g, src_b, dst_argb, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            dst_argb += dst_stride_argb;
        }
    }
}

MergeXR30Plane :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    dst_ar30: *u8,
    dst_stride_ar30: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_xr30_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32)) MergeXR30Row_C;

    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_ar30 = cast,no_check(*u8) ((dst_ar30 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar30));
        dst_stride_ar30 = -dst_stride_ar30;
    }

    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        dst_stride_ar30 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar30 = 0;
        src_stride_b = dst_stride_ar30;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_xr30_row(src_r, src_g, src_b, dst_ar30, depth, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            dst_ar30 += dst_stride_ar30;
        }
    }
}

MergeAR64Plane :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_ar64: *u16,
    dst_stride_ar64: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_ar64 = cast,no_check(*u16) ((dst_ar64 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_ar64));
        dst_stride_ar64 = -dst_stride_ar64;
    }

    if src_a == null {
        merge_ar64_plane_opaque(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            dst_ar64,
            dst_stride_ar64,
            width,
            height,
            depth
        );
    } else {
        merge_ar64_plane_alpha(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            src_a,
            src_stride_a,
            dst_ar64,
            dst_stride_ar64,
            width,
            height,
            depth
        );
    }
}

merge_ar64_plane_alpha :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_ar64: *u16,
    dst_stride_ar64: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_ar64_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u16, _: s32, _: s32)) MergeAR64Row_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        src_stride_a == width &&
        dst_stride_ar64 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar64 = 0;
        src_stride_a = dst_stride_ar64;
        src_stride_b = src_stride_a;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_ar64_row(src_r, src_g, src_b, src_a, dst_ar64, depth, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            src_a += src_stride_a;
            dst_ar64 += dst_stride_ar64;
        }
    }
}

merge_ar64_plane_opaque :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    dst_ar64: *u16,
    dst_stride_ar64: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_xr64_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: s32, _: s32)) MergeXR64Row_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }

    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        dst_stride_ar64 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar64 = 0;
        src_stride_b = dst_stride_ar64;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_xr64_row(src_r, src_g, src_b, dst_ar64, depth, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            dst_ar64 += dst_stride_ar64;
        }
    }
}

MergeARGB16To8Plane :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_a == null {
        merge_argb16_to8_plane_opaque(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            dst_argb,
            dst_stride_argb,
            width,
            height,
            depth
        );
    } else {
        merge_argb16_to8_plane_alpha(
            src_r,
            src_stride_r,
            src_g,
            src_stride_g,
            src_b,
            src_stride_b,
            src_a,
            src_stride_a,
            dst_argb,
            dst_stride_argb,
            width,
            height,
            depth
        );
    }
}

merge_argb16_to8_plane_alpha :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    src_a: *u16,
    src_stride_a: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_argb16_to8_row: #type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32)) MergeARGB16To8Row_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }
    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        src_stride_a == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_a = dst_stride_argb;
        src_stride_b = src_stride_a;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_argb16_to8_row(src_r, src_g, src_b, src_a, dst_argb, depth, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            src_a += src_stride_a;
            dst_argb += dst_stride_argb;
        }
    }
}

merge_argb16_to8_plane_opaque :: (
    src_r: *u16,
    src_stride_r: s32,
    src_g: *u16,
    src_stride_g: s32,
    src_b: *u16,
    src_stride_b: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    depth: s32
) {
    merge_xrgb16_to8_row: #type (_: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: *u16, _: *u8, _: s32, _: s32)) MergeXRGB16To8Row_C;

    assert(height >= 0);

    if width <= 0 || height == 0 {
        return;
    }

    if src_stride_r == width &&
        src_stride_g == width &&
        src_stride_b == width &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_b = dst_stride_argb;
        src_stride_g = src_stride_b;
        src_stride_r = src_stride_g;
    }

    if 0 < height {
        for y: 0..height - 1 {
            merge_xrgb16_to8_row(src_r, src_g, src_b, dst_argb, depth, width);
            src_r += src_stride_r;
            src_g += src_stride_g;
            src_b += src_stride_b;
            dst_argb += dst_stride_argb;
        }
    }
}

I400ToI400 :: (src_y: *u8, src_stride_y: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    if src_y == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }
    CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    return 0;
}

I422Copy :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;

    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    CopyPlane(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
    CopyPlane(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
    return 0;
}

I444Copy :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    CopyPlane(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
    CopyPlane(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
    return 0;
}

I210Copy :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;

    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    CopyPlane_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
    CopyPlane_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
    return 0;
}

I410Copy :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    CopyPlane_16(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
    CopyPlane_16(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
    return 0;
}

NV12Copy :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if src_y == null ||
        dst_y == null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }
    CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    CopyPlane(src_uv, src_stride_uv, dst_uv, dst_stride_uv, halfwidth * 2, halfheight);
    return 0;
}

NV21Copy :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return NV12Copy(src_y, src_stride_y, src_vu, src_stride_vu, dst_y, dst_stride_y, dst_vu, dst_stride_vu, width, height);
}

YUY2ToI422 :: (
    src_yuy2: *u8,
    src_stride_yuy2: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    yuy2_to_uv422_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) YUY2ToUV422Row_C;
    yuy2_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) YUY2ToYRow_C;
    if src_yuy2 == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_yuy2 = cast,no_check(*u8) ((src_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_yuy2));
        src_stride_yuy2 = -src_stride_yuy2;
    }

    if src_stride_yuy2 == width * 2 &&
        dst_stride_y == width &&
        dst_stride_u * 2 == width &&
        dst_stride_v * 2 == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 32768 {
        width *= height;
        height = 1;
        dst_stride_v = 0;
        dst_stride_u = dst_stride_v;
        dst_stride_y = dst_stride_u;
        src_stride_yuy2 = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            yuy2_to_uv422_row(src_yuy2, dst_u, dst_v, width);
            yuy2_to_y_row(src_yuy2, dst_y, width);
            src_yuy2 += src_stride_yuy2;
            dst_y += dst_stride_y;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    return 0;
}

UYVYToI422 :: (
    src_uyvy: *u8,
    src_stride_uyvy: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    uyvy_to_uv422_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) UYVYToUV422Row_C;
    uyvy_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) UYVYToYRow_C;
    if src_uyvy == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uyvy = cast,no_check(*u8) ((src_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uyvy));
        src_stride_uyvy = -src_stride_uyvy;
    }

    if src_stride_uyvy == width * 2 &&
        dst_stride_y == width &&
        dst_stride_u * 2 == width &&
        dst_stride_v * 2 == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 32768 {
        width *= height;
        height = 1;
        dst_stride_v = 0;
        dst_stride_u = dst_stride_v;
        dst_stride_y = dst_stride_u;
        src_stride_uyvy = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            uyvy_to_uv422_row(src_uyvy, dst_u, dst_v, width);
            uyvy_to_y_row(src_uyvy, dst_y, width);
            src_uyvy += src_stride_uyvy;
            dst_y += dst_stride_y;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    return 0;
}

YUY2ToNV12 :: (
    src_yuy2: *u8,
    src_stride_yuy2: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    yuy2_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) YUY2ToYRow_C;
    yuy2_to_nvuv_row: #type (_: *u8, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32)) YUY2ToNVUVRow_C;
    if src_yuy2 == null || dst_y == null || dst_uv == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_yuy2 = cast,no_check(*u8) ((src_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_yuy2));
        src_stride_yuy2 = -src_stride_yuy2;
    }

    y: s32 = 0;
    while y < height - 1 {
        yuy2_to_y_row(src_yuy2, dst_y, width);
        yuy2_to_y_row(src_yuy2 + src_stride_yuy2, dst_y + dst_stride_y, width);
        yuy2_to_nvuv_row(src_yuy2, src_stride_yuy2, dst_uv, width);
        src_yuy2 += src_stride_yuy2 * 2;
        dst_y += dst_stride_y * 2;
        dst_uv += dst_stride_uv;
        y += 2;
    }
    if height & 1 != 0 {
        yuy2_to_y_row(src_yuy2, dst_y, width);
        yuy2_to_nvuv_row(src_yuy2, 0, dst_uv, width);
    }
    return 0;
}

UYVYToNV12 :: (
    src_uyvy: *u8,
    src_stride_uyvy: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    y: s32 = ---;
    halfwidth := (width + 1) >> 1;
    split_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) SplitUVRow_C;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;

    if src_uyvy == null || dst_y == null || dst_uv == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uyvy = cast,no_check(*u8) ((src_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uyvy));
        src_stride_uyvy = -src_stride_uyvy;
    }

    {
        awidth := halfwidth * 2;

        rows_mem_size := cast,no_check(u64) (awidth * 3);

        rows_mem: *void =
            cast,no_check(*void) ((ifx rows_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(rows_mem_size + 63))));

        rows :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) rows_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if rows == null {
            return 1;
        }

        y = 0;
        while y < height - 1 {
            split_uv_row(src_uyvy, rows + awidth, rows, awidth);
            copy_memory(dst_y, rows, cast,no_check(u64) width);
            split_uv_row(src_uyvy + src_stride_uyvy, rows + awidth * 2, rows, awidth);
            copy_memory(dst_y + dst_stride_y, rows, cast,no_check(u64) width);
            interpolate_row(dst_uv, rows + awidth, cast,no_check(s64) awidth, awidth, 128);
            src_uyvy += src_stride_uyvy * 2;
            dst_y += dst_stride_y * 2;
            dst_uv += dst_stride_uv;
            y += 2;
        }
        if height & 1 != 0 {
            split_uv_row(src_uyvy, dst_uv, rows, awidth);
            copy_memory(dst_y, rows, cast,no_check(u64) width);
        }
        c_transpiler_deallocate_memory(rows_mem);

        rows = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

NV12ToNV21 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if src_uv == null || dst_vu == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    SwapUVPlane(src_uv, src_stride_uv, dst_vu, dst_stride_vu, halfwidth, halfheight);
    return 0;
}

YUY2ToY :: (src_yuy2: *u8, src_stride_yuy2: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    yuy2_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) YUY2ToYRow_C;
    if src_yuy2 == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_yuy2 = cast,no_check(*u8) ((src_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_yuy2));
        src_stride_yuy2 = -src_stride_yuy2;
    }

    if src_stride_yuy2 == width * 2 && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_yuy2 = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            yuy2_to_y_row(src_yuy2, dst_y, width);
            src_yuy2 += src_stride_yuy2;
            dst_y += dst_stride_y;
        }
    }
    return 0;
}

UYVYToY :: (src_uyvy: *u8, src_stride_uyvy: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    uyvy_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) UYVYToYRow_C;
    if src_uyvy == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uyvy = cast,no_check(*u8) ((src_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uyvy));
        src_stride_uyvy = -src_stride_uyvy;
    }

    if src_stride_uyvy == width * 2 && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_uyvy = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            uyvy_to_y_row(src_uyvy, dst_y, width);
            src_uyvy += src_stride_uyvy;
            dst_y += dst_stride_y;
        }
    }
    return 0;
}

I420ToI400 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }

    CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    return 0;
}

I420Mirror :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        MirrorPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    MirrorPlane(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
    MirrorPlane(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
    return 0;
}

MirrorPlane :: (src_y: *u8, src_stride_y: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) {
    mirror_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) MirrorRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            mirror_row(src_y, dst_y, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
}

I400Mirror :: (src_y: *u8, src_stride_y: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    if src_y == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }

    MirrorPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    return 0;
}

NV12Mirror :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }

    if dst_y != null {
        MirrorPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    MirrorUVPlane(src_uv, src_stride_uv, dst_uv, dst_stride_uv, halfwidth, halfheight);
    return 0;
}

MirrorUVPlane :: (src_uv: *u8, src_stride_uv: s32, dst_uv: *u8, dst_stride_uv: s32, width: s32, height: s32) {
    mirror_uv_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) MirrorUVRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return;
    }

    if height < 0 {
        height = -height;
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    if 0 < height {
        for y: 0..height - 1 {
            mirror_uv_row(src_uv, dst_uv, width);
            src_uv += src_stride_uv;
            dst_uv += dst_stride_uv;
        }
    }
}

ARGBMirror :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_mirror_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBMirrorRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_mirror_row(src_argb, dst_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

RGB24Mirror :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb24_mirror_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) RGB24MirrorRow_C;
    if src_rgb24 == null || dst_rgb24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_rgb24 = cast,no_check(*u8) ((src_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb24));
        src_stride_rgb24 = -src_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb24_mirror_row(src_rgb24, dst_rgb24, width);
            src_rgb24 += src_stride_rgb24;
            dst_rgb24 += dst_stride_rgb24;
        }
    }
    return 0;
}

RAWToRGB24 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_rgb24: *u8,
    dst_stride_rgb24: s32,
    width: s32,
    height: s32
) -> s32 {
    raw_to_rgb24_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) RAWToRGB24Row_C;
    if src_raw == null || dst_rgb24 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    if src_stride_raw == width * 3 &&
        dst_stride_rgb24 == width * 3 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_rgb24 = 0;
        src_stride_raw = dst_stride_rgb24;
    }

    if 0 < height {
        for y: 0..height - 1 {
            raw_to_rgb24_row(src_raw, dst_rgb24, width);
            src_raw += src_stride_raw;
            dst_rgb24 += dst_stride_rgb24;
        }
    }
    return 0;
}

I420Rect :: (
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    x: s32,
    y: s32,
    width: s32,
    height: s32,
    value_y: s32,
    value_u: s32,
    value_v: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    start_y := cast,no_check(*u8) ((dst_y + y * dst_stride_y + x));
    start_u := cast,no_check(*u8) ((dst_u + y / 2 * dst_stride_u + x / 2));
    start_v := cast,no_check(*u8) ((dst_v + y / 2 * dst_stride_v + x / 2));

    if dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        x < 0 ||
        y < 0 ||
        value_y < 0 ||
        value_y > 255 ||
        value_u < 0 ||
        value_u > 255 ||
        value_v < 0 ||
        value_v > 255 {
        return -1;
    }

    SetPlane(start_y, dst_stride_y, width, height, cast,no_check(u32) value_y);
    SetPlane(start_u, dst_stride_u, halfwidth, halfheight, cast,no_check(u32) value_u);
    SetPlane(start_v, dst_stride_v, halfwidth, halfheight, cast,no_check(u32) value_v);
    return 0;
}

ARGBRect :: (dst_argb: *u8, dst_stride_argb: s32, dst_x: s32, dst_y: s32, width: s32, height: s32, value: u32) -> s32 {
    argb_set_row: #type (_: *u8, _: u32, _: s32) = cast,no_check(#type (_: *u8, _: u32, _: s32)) ARGBSetRow_C;
    if dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 || dst_x < 0 || dst_y < 0 {
        return -1;
    }
    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }
    dst_argb += dst_y * dst_stride_argb + dst_x * 4;

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_set_row(dst_argb, value, width);
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBGrayTo :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_gray_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBGrayRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_gray_row(src_argb, dst_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBGray :: (dst_argb: *u8, dst_stride_argb: s32, dst_x: s32, dst_y: s32, width: s32, height: s32) -> s32 {
    argb_gray_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBGrayRow_C;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 {
        return -1;
    }

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_gray_row(dst, dst, width);
            dst += dst_stride_argb;
        }
    }
    return 0;
}

ARGBSepia :: (dst_argb: *u8, dst_stride_argb: s32, dst_x: s32, dst_y: s32, width: s32, height: s32) -> s32 {
    argb_sepia_row: #type (_: *u8, _: s32) = cast,no_check(#type (_: *u8, _: s32)) ARGBSepiaRow_C;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 {
        return -1;
    }

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_sepia_row(dst, width);
            dst += dst_stride_argb;
        }
    }
    return 0;
}

ARGBColorMatrix :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    matrix_argb: *s8,
    width: s32,
    height: s32
) -> s32 {
    argb_color_matrix_row: #type (_: *u8, _: *u8, _: *s8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *s8, _: s32)) ARGBColorMatrixRow_C;
    if src_argb == null || dst_argb == null || matrix_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_color_matrix_row(src_argb, dst_argb, matrix_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

RGBColorMatrix :: (
    dst_argb: *u8,
    dst_stride_argb: s32,
    matrix_rgb: *s8,
    dst_x: s32,
    dst_y: s32,
    width: s32,
    height: s32
) -> s32 {
    matrix_argb: [16] s8 = ---;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || matrix_rgb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 {
        return -1;
    }

    matrix_argb[0] = cast,no_check(s8) ((cast(s32) matrix_rgb[0]) / 2);
    matrix_argb[1] = cast,no_check(s8) ((cast(s32) matrix_rgb[1]) / 2);
    matrix_argb[2] = cast,no_check(s8) ((cast(s32) matrix_rgb[2]) / 2);
    matrix_argb[3] = cast,no_check(s8) ((cast(s32) matrix_rgb[3]) / 2);
    matrix_argb[4] = cast,no_check(s8) ((cast(s32) matrix_rgb[4]) / 2);
    matrix_argb[5] = cast,no_check(s8) ((cast(s32) matrix_rgb[5]) / 2);
    matrix_argb[6] = cast,no_check(s8) ((cast(s32) matrix_rgb[6]) / 2);
    matrix_argb[7] = cast,no_check(s8) ((cast(s32) matrix_rgb[7]) / 2);
    matrix_argb[8] = cast,no_check(s8) ((cast(s32) matrix_rgb[8]) / 2);
    matrix_argb[9] = cast,no_check(s8) ((cast(s32) matrix_rgb[9]) / 2);
    matrix_argb[10] = cast,no_check(s8) ((cast(s32) matrix_rgb[10]) / 2);
    matrix_argb[11] = cast,no_check(s8) ((cast(s32) matrix_rgb[11]) / 2);
    matrix_argb[12] = 0;
    matrix_argb[13] = matrix_argb[12];
    matrix_argb[14] = matrix_argb[13];
    matrix_argb[15] = 64;

    return ARGBColorMatrix(dst, dst_stride_argb, dst, dst_stride_argb, matrix_argb.data + 0, width, height);
}

ARGBColorTable :: (
    dst_argb: *u8,
    dst_stride_argb: s32,
    table_argb: *u8,
    dst_x: s32,
    dst_y: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_color_table_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBColorTableRow_C;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || table_argb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 {
        return -1;
    }

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_color_table_row(dst, table_argb, width);
            dst += dst_stride_argb;
        }
    }
    return 0;
}

RGBColorTable :: (
    dst_argb: *u8,
    dst_stride_argb: s32,
    table_argb: *u8,
    dst_x: s32,
    dst_y: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_color_table_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) RGBColorTableRow_C;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || table_argb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 {
        return -1;
    }

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb_color_table_row(dst, table_argb, width);
            dst += dst_stride_argb;
        }
    }
    return 0;
}

ARGBLumaColorTable :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    luma: *u8,
    width: s32,
    height: s32
) -> s32 {
    argb_luma_color_table_row: #type (_: *u8, _: *u8, _: s32, _: *u8, _: u32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *u8, _: u32)) ARGBLumaColorTableRow_C;
    if src_argb == null || dst_argb == null || luma == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_luma_color_table_row(src_argb, dst_argb, width, luma, 0x264b0f);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBPolynomial :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    poly: *float32,
    width: s32,
    height: s32
) -> s32 {
    argb_polynomial_row: #type (_: *u8, _: *u8, _: *float32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *float32, _: s32)) ARGBPolynomialRow_C;
    if src_argb == null || dst_argb == null || poly == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_polynomial_row(src_argb, dst_argb, poly, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

HalfFloatPlane :: (
    src_y: *u16,
    src_stride_y: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    scale: float32,
    width: s32,
    height: s32
) -> s32 {
    half_float_row: #type (_: *u16, _: *u16, _: float32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: float32, _: s32)) HalfFloatRow_C;
    if src_y == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    c_transpiler_compound_shr(*(src_stride_y), (cast(s32) 1), s32, s32);
    c_transpiler_compound_shr(*(dst_stride_y), (cast(s32) 1), s32, s32);

    if height < 0 {
        height = -height;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if 0 < height {
        for y: 0..height - 1 {
            half_float_row(src_y, dst_y, scale, width);
            src_y += src_stride_y;
            dst_y += dst_stride_y;
        }
    }
    return 0;
}

ByteToFloat :: (src_y: *u8, dst_y: *float32, scale: float32, width: s32) -> s32 {
    byte_to_float_row: #type (_: *u8, _: *float32, _: float32, _: s32) =
        cast,no_check(#type (_: *u8, _: *float32, _: float32, _: s32)) ByteToFloatRow_C;
    if src_y == null || dst_y == null || width <= 0 {
        return -1;
    }

    byte_to_float_row(src_y, dst_y, scale, width);
    return 0;
}

ARGBQuantize :: (
    dst_argb: *u8,
    dst_stride_argb: s32,
    scale: s32,
    interval_size: s32,
    interval_offset: s32,
    dst_x: s32,
    dst_y: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_quantize_row: #type (_: *u8, _: s32, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: s32, _: s32, _: s32)) ARGBQuantizeRow_C;
    dst := cast,no_check(*u8) ((dst_argb + dst_y * dst_stride_argb + dst_x * 4));
    if dst_argb == null || width <= 0 || height <= 0 || dst_x < 0 || dst_y < 0 || interval_size < 1 || interval_size > 255 {
        return -1;
    }

    if dst_stride_argb == width * 4 && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_quantize_row(dst, scale, interval_size, interval_offset, width);
            dst += dst_stride_argb;
        }
    }
    return 0;
}

ARGBCopyAlpha :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_copy_alpha_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBCopyAlphaRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_copy_alpha_row(src_argb, dst_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBExtractAlpha :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_argb == null || dst_a == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb += (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb;
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 && dst_stride_a == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_a = 0;
        src_stride_argb = dst_stride_a;
    }
    argb_extract_alpha_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBExtractAlphaRow_C;

    if 0 < height {
        for y: 0..height - 1 {
            argb_extract_alpha_row(src_argb, dst_a, width);
            src_argb += src_stride_argb;
            dst_a += dst_stride_a;
        }
    }
    return 0;
}

ARGBCopyYToAlpha :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_copy_y_to_alpha_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBCopyYToAlphaRow_C;
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
            argb_copy_y_to_alpha_row(src_y, dst_argb, width);
            src_y += src_stride_y;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBBlend :: (
    src_argb0: *u8,
    src_stride_argb0: s32,
    src_argb1: *u8,
    src_stride_argb1: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_blend_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) ARGBBlendRow_C;
    if src_argb0 == null || src_argb1 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_argb0 == width * 4 &&
        src_stride_argb1 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb1 = dst_stride_argb;
        src_stride_argb0 = src_stride_argb1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_blend_row(src_argb0, src_argb1, dst_argb, width);
            src_argb0 += src_stride_argb0;
            src_argb1 += src_stride_argb1;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

BlendPlane :: (
    src_y0: *u8,
    src_stride_y0: s32,
    src_y1: *u8,
    src_stride_y1: s32,
    alpha: *u8,
    alpha_stride: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    width: s32,
    height: s32
) -> s32 {
    blend_plane_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) BlendPlaneRow_C;
    if src_y0 == null ||
        src_y1 == null ||
        alpha == null ||
        dst_y == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    if src_stride_y0 == width &&
        src_stride_y1 == width &&
        alpha_stride == width &&
        dst_stride_y == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        alpha_stride = dst_stride_y;
        src_stride_y1 = alpha_stride;
        src_stride_y0 = src_stride_y1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            blend_plane_row(src_y0, src_y1, alpha, dst_y, width);
            src_y0 += src_stride_y0;
            src_y1 += src_stride_y1;
            alpha += alpha_stride;
            dst_y += dst_stride_y;
        }
    }
    return 0;
}

I420Blend :: (
    src_y0: *u8,
    src_stride_y0: s32,
    src_u0: *u8,
    src_stride_u0: s32,
    src_v0: *u8,
    src_stride_v0: s32,
    src_y1: *u8,
    src_stride_y1: s32,
    src_u1: *u8,
    src_stride_u1: s32,
    src_v1: *u8,
    src_stride_v1: s32,
    alpha: *u8,
    alpha_stride: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    blend_plane_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) BlendPlaneRow_C;
    scale_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown2Box_C;

    if src_y0 == null ||
        src_u0 == null ||
        src_v0 == null ||
        src_y1 == null ||
        src_u1 == null ||
        src_v1 == null ||
        alpha == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_y = cast,no_check(*u8) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
        dst_stride_y = -dst_stride_y;
    }

    BlendPlane(src_y0, src_stride_y0, src_y1, src_stride_y1, alpha, alpha_stride, dst_y, dst_stride_y, width, height);

    if (cast,no_check(u64) width) & cast,no_check(u64) (2 - 1) != 0 {
        scale_row_down2 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown2Box_Odd_C;
    }

    halfalpha_mem_size := cast,no_check(u64) halfwidth;

    halfalpha_mem: *void =
        cast,no_check(*void) ((ifx halfalpha_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(halfalpha_mem_size + 63))));

    halfalpha :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) halfalpha_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if halfalpha == null {
        return 1;
    }
    y: s32 = 0;
    while y < height {
        if y == height - 1 {
            alpha_stride = 0;
        }

        scale_row_down2(alpha, cast,no_check(s64) alpha_stride, halfalpha, halfwidth);
        alpha += (cast,no_check(s64) alpha_stride) * 2;
        blend_plane_row(src_u0, src_u1, halfalpha, dst_u, halfwidth);
        blend_plane_row(src_v0, src_v1, halfalpha, dst_v, halfwidth);
        src_u0 += src_stride_u0;
        src_u1 += src_stride_u1;
        dst_u += dst_stride_u;
        src_v0 += src_stride_v0;
        src_v1 += src_stride_v1;
        dst_v += dst_stride_v;
        y += 2;
    }
    c_transpiler_deallocate_memory(halfalpha_mem);

    halfalpha = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

ARGBMultiply :: (
    src_argb0: *u8,
    src_stride_argb0: s32,
    src_argb1: *u8,
    src_stride_argb1: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_multiply_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) ARGBMultiplyRow_C;
    if src_argb0 == null || src_argb1 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_argb0 == width * 4 &&
        src_stride_argb1 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb1 = dst_stride_argb;
        src_stride_argb0 = src_stride_argb1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_multiply_row(src_argb0, src_argb1, dst_argb, width);
            src_argb0 += src_stride_argb0;
            src_argb1 += src_stride_argb1;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBAdd :: (
    src_argb0: *u8,
    src_stride_argb0: s32,
    src_argb1: *u8,
    src_stride_argb1: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_add_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) ARGBAddRow_C;
    if src_argb0 == null || src_argb1 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_argb0 == width * 4 &&
        src_stride_argb1 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb1 = dst_stride_argb;
        src_stride_argb0 = src_stride_argb1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_add_row(src_argb0, src_argb1, dst_argb, width);
            src_argb0 += src_stride_argb0;
            src_argb1 += src_stride_argb1;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBSubtract :: (
    src_argb0: *u8,
    src_stride_argb0: s32,
    src_argb1: *u8,
    src_stride_argb1: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_subtract_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) ARGBSubtractRow_C;
    if src_argb0 == null || src_argb1 == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    if src_stride_argb0 == width * 4 &&
        src_stride_argb1 == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb1 = dst_stride_argb;
        src_stride_argb0 = src_stride_argb1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_subtract_row(src_argb0, src_argb1, dst_argb, width);
            src_argb0 += src_stride_argb0;
            src_argb1 += src_stride_argb1;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBAttenuate :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_attenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBAttenuateRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_attenuate_row(src_argb, dst_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBUnattenuate :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_unattenuate_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBUnattenuateRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_unattenuate_row(src_argb, dst_argb, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

ARGBComputeCumulativeSum :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_cumsum: *s32,
    dst_stride32_cumsum: s32,
    width: s32,
    height: s32
) -> s32 {
    compute_cumulative_sum_row: #type (_: *u8, _: *s32, _: *s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *s32, _: *s32, _: s32)) ComputeCumulativeSumRow_C;
    previous_cumsum := cast,no_check(*s32) (dst_cumsum);
    if dst_cumsum == null || src_argb == null || width <= 0 || height <= 0 {
        return -1;
    }

    fill_memory(dst_cumsum, 0, (cast,no_check(u64) width) * 4 * 4);
    if 0 < height {
        for y: 0..height - 1 {
            compute_cumulative_sum_row(src_argb, dst_cumsum, previous_cumsum, width);
            previous_cumsum = cast,no_check(*s32) (dst_cumsum);
            dst_cumsum += dst_stride32_cumsum;
            src_argb += src_stride_argb;
        }
    }
    return 0;
}

ARGBBlur :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    dst_cumsum: *s32,
    dst_stride32_cumsum: s32,
    width: s32,
    height: s32,
    radius: s32
) -> s32 {
    compute_cumulative_sum_row: #type (_: *u8, _: *s32, _: *s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *s32, _: *s32, _: s32)) ComputeCumulativeSumRow_C;
    cumulative_sum_to_average_row: #type (_: *s32, _: *s32, _: s32, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *s32, _: *s32, _: s32, _: s32, _: *u8, _: s32)) CumulativeSumToAverageRow_C;

    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }
    if radius > height {
        radius = height;
    }
    if radius > width / 2 - 1 {
        radius = width / 2 - 1;
    }
    if radius <= 0 || height <= 1 {
        return -1;
    }

    ARGBComputeCumulativeSum(src_argb, src_stride_argb, dst_cumsum, dst_stride32_cumsum, width, radius);

    src_argb = cast,no_check(*u8) ((src_argb + radius * src_stride_argb));
    cumsum_bot_row := cast,no_check(*s32) (*dst_cumsum[(radius - 1) * dst_stride32_cumsum]);

    max_cumsum_bot_row := cast,no_check(*s32) (*dst_cumsum[(radius * 2 + 2) * dst_stride32_cumsum]);
    cumsum_top_row := cast,no_check(*s32) (*dst_cumsum[0]);

    if 0 < height {
        for y: 0..height - 1 {
            top_y := (ifx y - radius - 1 >= 0 then y - radius - 1 else 0);
            bot_y := (ifx y + radius < height then y + radius else height - 1);
            area := radius * (bot_y - top_y);
            boxwidth := radius * 4;

            if top_y != 0 {
                cumsum_top_row += dst_stride32_cumsum;
                if cumsum_top_row >= max_cumsum_bot_row {
                    cumsum_top_row = cast,no_check(*s32) (dst_cumsum);
                }
            }

            if y + radius < height {
                prev_cumsum_bot_row := cast,no_check(*s32) (cumsum_bot_row);
                cumsum_bot_row += dst_stride32_cumsum;
                if cumsum_bot_row >= max_cumsum_bot_row {
                    cumsum_bot_row = cast,no_check(*s32) (dst_cumsum);
                }
                compute_cumulative_sum_row(src_argb, cumsum_bot_row, prev_cumsum_bot_row, width);
                src_argb += src_stride_argb;
            }

            x: s32 = 0;
            while x < radius + 1 {
                cumulative_sum_to_average_row(cumsum_top_row, cumsum_bot_row, boxwidth, area, *dst_argb[x * 4], 1);
                area += bot_y - top_y;
                boxwidth += 4;
                x += 1;
            }

            n := width - 1 - radius - x + 1;
            cumulative_sum_to_average_row(cumsum_top_row, cumsum_bot_row, boxwidth, area, *dst_argb[x * 4], n);

            x += n;
            while x <= width - 1 {
                area -= bot_y - top_y;
                boxwidth -= 4;
                cumulative_sum_to_average_row(
                    cumsum_top_row + (x - radius - 1) * 4,
                    cumsum_bot_row + (x - radius - 1) * 4,
                    boxwidth,
                    area,
                    *dst_argb[x * 4],
                    1
                );
                x += 1;
            }
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

GaussPlane_F32 :: (src: *float32, src_stride: s32, dst: *float32, dst_stride: s32, width: s32, height: s32) -> s32 {
    y: s32 = ---;
    gauss_col_f32: #type (_: *float32, _: *float32, _: *float32, _: *float32, _: *float32, _: *float32, _: s32) =
        cast,no_check(#type (_: *float32, _: *float32, _: *float32, _: *float32, _: *float32, _: *float32, _: s32)) GaussCol_F32_C;
    gauss_row_f32: #type (_: *float32, _: *float32, _: s32) =
        cast,no_check(#type (_: *float32, _: *float32, _: s32)) GaussRow_F32_C;
    if src == null || dst == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src = cast,no_check(*float32) ((src + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride));
        src_stride = -src_stride;
    }

    {
        rowbuf_mem_size := cast,no_check(u64) ((4 + width + 4) * 4);

        rowbuf_mem: *void =
            cast,no_check(*void) ((ifx rowbuf_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(rowbuf_mem_size + 63))));

        rowbuf :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) rowbuf_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if rowbuf == null {
            return 1;
        }
        fill_memory(rowbuf, 0, 16);
        fill_memory(rowbuf + (4 + width) * 4, 0, 16);
        row := cast,no_check(*float32) (cast(*float32) (rowbuf + 16));
        src0 := cast,no_check(*float32) (src);
        src1 := cast,no_check(*float32) (src);
        src2 := cast,no_check(*float32) (src);
        src3 := cast,no_check(*float32) ((src2 + (ifx height > 1 then src_stride else 0)));
        src4 := cast,no_check(*float32) ((src3 + (ifx height > 2 then src_stride else 0)));

        y = 0;
        while y < height {
            gauss_col_f32(src0, src1, src2, src3, src4, row, width);

            row[-1] = row[0];
            row[-2] = row[-1];
            row[width] = row[width - 1];
            row[width + 1] = row[width];

            gauss_row_f32(row - 2, dst, width);

            src0 = cast,no_check(*float32) (src1);
            src1 = cast,no_check(*float32) (src2);
            src2 = cast,no_check(*float32) (src3);
            src3 = cast,no_check(*float32) (src4);
            if y + 2 < height - 1 {
                src4 += src_stride;
            }
            dst += dst_stride;
            y += 1;
        }
        c_transpiler_deallocate_memory(rowbuf_mem);

        rowbuf = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

ARGBShade :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    value: u32
) -> s32 {
    argb_shade_row: #type (_: *u8, _: *u8, _: s32, _: u32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: u32)) ARGBShadeRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 || value == 0 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_shade_row(src_argb, dst_argb, width, value);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

InterpolatePlane :: (
    src0: *u8,
    src_stride0: s32,
    src1: *u8,
    src_stride1: s32,
    dst: *u8,
    dst_stride: s32,
    width: s32,
    height: s32,
    interpolation: s32
) -> s32 {
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    if src0 == null || src1 == null || dst == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst = cast,no_check(*u8) ((dst + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride));
        dst_stride = -dst_stride;
    }

    if src_stride0 == width &&
        src_stride1 == width &&
        dst_stride == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride = 0;
        src_stride1 = dst_stride;
        src_stride0 = src_stride1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            interpolate_row(dst, src0, src1 - src0, width, interpolation);
            src0 += src_stride0;
            src1 += src_stride1;
            dst += dst_stride;
        }
    }
    return 0;
}

InterpolatePlane_16 :: (
    src0: *u16,
    src_stride0: s32,
    src1: *u16,
    src_stride1: s32,
    dst: *u16,
    dst_stride: s32,
    width: s32,
    height: s32,
    interpolation: s32
) -> s32 {
    interpolate_row_16: #type (_: *u16, _: *u16, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s64, _: s32, _: s32)) InterpolateRow_16_C;
    if src0 == null || src1 == null || dst == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst = cast,no_check(*u16) ((dst + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride));
        dst_stride = -dst_stride;
    }

    if src_stride0 == width &&
        src_stride1 == width &&
        dst_stride == width &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride = 0;
        src_stride1 = dst_stride;
        src_stride0 = src_stride1;
    }

    if 0 < height {
        for y: 0..height - 1 {
            interpolate_row_16(dst, src0, src1 - src0, width, interpolation);
            src0 += src_stride0;
            src1 += src_stride1;
            dst += dst_stride;
        }
    }
    return 0;
}

ARGBInterpolate :: (
    src_argb0: *u8,
    src_stride_argb0: s32,
    src_argb1: *u8,
    src_stride_argb1: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    interpolation: s32
) -> s32 {
    return InterpolatePlane(
        src_argb0,
        src_stride_argb0,
        src_argb1,
        src_stride_argb1,
        dst_argb,
        dst_stride_argb,
        width * 4,
        height,
        interpolation
    );
}

I420Interpolate :: (
    src0_y: *u8,
    src0_stride_y: s32,
    src0_u: *u8,
    src0_stride_u: s32,
    src0_v: *u8,
    src0_stride_v: s32,
    src1_y: *u8,
    src1_stride_y: s32,
    src1_u: *u8,
    src1_stride_u: s32,
    src1_v: *u8,
    src1_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    interpolation: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if src0_y == null ||
        src0_u == null ||
        src0_v == null ||
        src1_y == null ||
        src1_u == null ||
        src1_v == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    InterpolatePlane(src0_y, src0_stride_y, src1_y, src1_stride_y, dst_y, dst_stride_y, width, height, interpolation);
    InterpolatePlane(
        src0_u,
        src0_stride_u,
        src1_u,
        src1_stride_u,
        dst_u,
        dst_stride_u,
        halfwidth,
        halfheight,
        interpolation
    );
    InterpolatePlane(
        src0_v,
        src0_stride_v,
        src1_v,
        src1_stride_v,
        dst_v,
        dst_stride_v,
        halfwidth,
        halfheight,
        interpolation
    );
    return 0;
}

ARGBShuffle :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    shuffler: *u8,
    width: s32,
    height: s32
) -> s32 {
    argb_shuffle_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) ARGBShuffleRow_C;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if src_stride_argb == width * 4 &&
        dst_stride_argb == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_argb = 0;
        src_stride_argb = dst_stride_argb;
    }

    if 0 < height {
        for y: 0..height - 1 {
            argb_shuffle_row(src_argb, dst_argb, shuffler, width);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
        }
    }
    return 0;
}

AR64Shuffle :: (
    src_ar64: *u16,
    src_stride_ar64: s32,
    dst_ar64: *u16,
    dst_stride_ar64: s32,
    shuffler: *u8,
    width: s32,
    height: s32
) -> s32 {
    ar64_shuffle_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) AR64ShuffleRow_C;
    if src_ar64 == null || dst_ar64 == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ar64 = cast,no_check(*u16) ((src_ar64 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ar64));
        src_stride_ar64 = -src_stride_ar64;
    }

    if src_stride_ar64 == width * 4 &&
        dst_stride_ar64 == width * 4 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_ar64 = 0;
        src_stride_ar64 = dst_stride_ar64;
    }

    if 0 < height {
        for y: 0..height - 1 {
            ar64_shuffle_row(cast(*u8) src_ar64, cast(*u8) dst_ar64, shuffler, width * 2);
            src_ar64 += src_stride_ar64;
            dst_ar64 += dst_stride_ar64;
        }
    }
    return 0;
}

ARGBSobelToPlane :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    width: s32,
    height: s32
) -> s32 {
    sobel_to_plane_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) SobelToPlaneRow_C;

    return argb_sobelize(
        src_argb,
        src_stride_argb,
        dst_y,
        dst_stride_y,
        width,
        height,
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) (sobel_to_plane_row)
    );
}

argb_sobelize :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    sobel_row: Argb_Sobelize_Parameter_6_Type
) -> s32 {
    y: s32 = ---;
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    sobel_y_row: Argb_Sobelize_Parameter_6_Type = cast,no_check(Argb_Sobelize_Parameter_6_Type) SobelYRow_C;
    sobel_x_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) SobelXRow_C;
    K_EDGE: s32 = 16;
    if src_argb == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    {
        ROW_SIZE := (width + K_EDGE + 31) & ~(cast(s32) 31);
        rows_mem_size := cast,no_check(u64) (ROW_SIZE * 2 + (K_EDGE + ROW_SIZE * 3 + K_EDGE));

        rows_mem: *void =
            cast,no_check(*void) ((ifx rows_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(rows_mem_size + 63))));

        rows :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) rows_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        row_sobelx := cast,no_check(*u8) (rows);
        row_sobely := cast,no_check(*u8) ((rows + ROW_SIZE));
        row_y := cast,no_check(*u8) ((rows + ROW_SIZE * 2));

        row_y0 := cast,no_check(*u8) ((row_y + K_EDGE));
        row_y1 := cast,no_check(*u8) ((row_y0 + ROW_SIZE));
        row_y2 := cast,no_check(*u8) ((row_y1 + ROW_SIZE));
        if rows == null {
            return 1;
        }
        argb_to_y_matrix_row(src_argb, row_y0, width, *K_ARGB_JPEG_CONSTANTS);
        row_y0[-1] = row_y0[0];
        fill_memory(row_y0 + width, cast,no_check(s32) row_y0[width - 1], 16);
        argb_to_y_matrix_row(src_argb, row_y1, width, *K_ARGB_JPEG_CONSTANTS);
        row_y1[-1] = row_y1[0];
        fill_memory(row_y1 + width, cast,no_check(s32) row_y1[width - 1], 16);
        fill_memory(row_y2 + width, 0, 16);

        y = 0;
        while y < height {
            if y < height - 1 {
                src_argb += src_stride_argb;
            }
            argb_to_y_matrix_row(src_argb, row_y2, width, *K_ARGB_JPEG_CONSTANTS);
            row_y2[-1] = row_y2[0];
            row_y2[width] = row_y2[width - 1];

            sobel_x_row(row_y0 - 1, row_y1 - 1, row_y2 - 1, row_sobelx, width);
            sobel_y_row(row_y0 - 1, row_y2 - 1, row_sobely, width);
            sobel_row(row_sobelx, row_sobely, dst_argb, width);

            {
                row_yt := cast,no_check(*u8) (row_y0);
                row_y0 = cast,no_check(*u8) (row_y1);
                row_y1 = cast,no_check(*u8) (row_y2);
                row_y2 = cast,no_check(*u8) (row_yt);
            }

            dst_argb += dst_stride_argb;
            y += 1;
        }
        c_transpiler_deallocate_memory(rows_mem);

        rows = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

ARGBSobel :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    sobel_row: Argb_Sobelize_Parameter_6_Type = cast,no_check(Argb_Sobelize_Parameter_6_Type) SobelRow_C;

    return argb_sobelize(
        src_argb,
        src_stride_argb,
        dst_argb,
        dst_stride_argb,
        width,
        height,
        cast,no_check(Argb_Sobelize_Parameter_6_Type) (sobel_row)
    );
}

ARGBSobelXY :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    sobel_xy_row: Argb_Sobelize_Parameter_6_Type = cast,no_check(Argb_Sobelize_Parameter_6_Type) SobelXYRow_C;

    return argb_sobelize(
        src_argb,
        src_stride_argb,
        dst_argb,
        dst_stride_argb,
        width,
        height,
        cast,no_check(Argb_Sobelize_Parameter_6_Type) (sobel_xy_row)
    );
}

test_cpu_flag_in_planar_functions :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_planar_functions :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_planar_functions: u32;
initialize_globals_for_planar_functions :: () {
    {
        state := atomic_load(*globals_initialization_state_for_planar_functions);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_planar_functions, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_planar_functions) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_planar_functions = 0x1;
    K_CPU_HAS_ARM_in_planar_functions = 0x2;
    K_CPU_HAS_NEON_in_planar_functions = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_planar_functions = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_planar_functions = 0x400;
    K_CPU_HAS_SVE_in_planar_functions = 0x800;
    K_CPU_HAS_SVE2_in_planar_functions = 0x1000;
    K_CPU_HAS_SME_in_planar_functions = 0x2000;
    K_CPU_HAS_SME2_in_planar_functions = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_planar_functions = 0x8000;
    K_CPU_HAS_RISCV_in_planar_functions = 0x4;
    K_CPU_HAS_RVV_in_planar_functions = 0x100;
    K_CPU_HAS_RVVZVFH_in_planar_functions = 0x200;
    K_CPU_HAS_X86_in_planar_functions = 0x8;
    K_CPU_HAS_SSE2_in_planar_functions = 0x100;
    K_CPU_HAS_SSSE3_in_planar_functions = 0x200;
    K_CPU_HAS_SSE41_in_planar_functions = 0x400;
    K_CPU_HAS_SSE42_in_planar_functions = 0x800;
    K_CPU_HAS_AVX_in_planar_functions = 0x1000;
    K_CPU_HAS_AVX2_in_planar_functions = 0x2000;
    K_CPU_HAS_ERMS_in_planar_functions = 0x4000;
    K_CPU_HAS_FSMR_in_planar_functions = 0x8000;
    K_CPU_HAS_FMA3_in_planar_functions = 0x10000;
    K_CPU_HAS_F16_C_in_planar_functions = 0x20000;
    K_CPU_HAS_AVX512_BW_in_planar_functions = 0x40000;
    K_CPU_HAS_AVX512_VL_in_planar_functions = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_planar_functions = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_planar_functions = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_planar_functions = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_planar_functions = 0x800000;
    K_CPU_HAS_AVX10_in_planar_functions = 0x1000000;
    K_CPU_HAS_AVX10_2_in_planar_functions = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_planar_functions = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_planar_functions = 0x8000000;
    K_CPU_HAS_AMXINT8_in_planar_functions = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_planar_functions = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_planar_functions = 0x20;
    K_CPU_HAS_LSX_in_planar_functions = 0x100;
    K_CPU_HAS_LASX_in_planar_functions = 0x200;
    atomic_store(*globals_initialization_state_for_planar_functions, 2);
}


Argb_Sobelize_Parameter_6_Type :: #type (_: *u8, _: *u8, _: *u8, _: s32);
