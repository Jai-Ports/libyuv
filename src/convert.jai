K_CPU_INITIALIZED_storage: s32;

K_CPU_HAS_ARM_storage: s32;

K_CPU_HAS_NEON_storage: s32;

K_CPU_HAS_NEON_DOT_PROD_storage: s32;

K_CPU_HAS_NEON_I8_MM_storage: s32;

K_CPU_HAS_SVE_storage: s32;

K_CPU_HAS_SVE2_storage: s32;

K_CPU_HAS_SME_storage: s32;

K_CPU_HAS_SME2_storage: s32;

K_CPU_HAS_SVEF32_MM_storage: s32;

K_CPU_HAS_RISCV_storage: s32;

K_CPU_HAS_RVV_storage: s32;

K_CPU_HAS_RVVZVFH_storage: s32;

K_CPU_HAS_X86_storage: s32;

K_CPU_HAS_SSE2_storage: s32;

K_CPU_HAS_SSSE3_storage: s32;

K_CPU_HAS_SSE41_storage: s32;

K_CPU_HAS_SSE42_storage: s32;

K_CPU_HAS_AVX_storage: s32;

K_CPU_HAS_AVX2_storage: s32;

K_CPU_HAS_ERMS_storage: s32;

K_CPU_HAS_FSMR_storage: s32;

K_CPU_HAS_FMA3_storage: s32;

K_CPU_HAS_F16_C_storage: s32;

K_CPU_HAS_AVX512_BW_storage: s32;

K_CPU_HAS_AVX512_VL_storage: s32;

K_CPU_HAS_AVX512_VNNI_storage: s32;

K_CPU_HAS_AVX512_VBMI_storage: s32;

K_CPU_HAS_AVX512_VBMI2_storage: s32;

K_CPU_HAS_AVX512_VBITALG_storage: s32;

K_CPU_HAS_AVX10_storage: s32;

K_CPU_HAS_AVX10_2_storage: s32;

K_CPU_HAS_AVXVNNI_storage: s32;

K_CPU_HAS_AVXVNNIINT8_storage: s32;

K_CPU_HAS_AMXINT8_storage: s32;

K_CPU_HAS_AVX512_BMM_storage: s32;

K_CPU_HAS_LOONGARCH_storage: s32;

K_CPU_HAS_LSX_storage: s32;

K_CPU_HAS_LASX_storage: s32;

i444_to_i420 :: (
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
    return i4xx_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        width,
        height
    );
}

i4xx_to_i420 :: (
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
    src_y_width: s32,
    src_y_height: s32,
    src_uv_width: s32,
    src_uv_height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        src_y_width <= 0 ||
        src_y_height == 0 ||
        src_y_height == -2147483647 - 1 ||
        src_uv_width <= 0 ||
        src_uv_height == 0 {
        return -1;
    }
    DST_Y_WIDTH := src_y_width;
    DST_Y_HEIGHT := abs(src_y_height);
    DST_UV_WIDTH := (ifx DST_Y_WIDTH < 0 then -((-DST_Y_WIDTH + 1) >> 1) else (DST_Y_WIDTH + 1) >> 1);
    DST_UV_HEIGHT := (ifx DST_Y_HEIGHT < 0 then -((-DST_Y_HEIGHT + 1) >> 1) else (DST_Y_HEIGHT + 1) >> 1);
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, src_y_width, src_y_height);
    }
    r :=
        ScalePlane(
            src_u,
            src_stride_u,
            src_uv_width,
            src_uv_height,
            dst_u,
            dst_stride_u,
            DST_UV_WIDTH,
            DST_UV_HEIGHT,
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_v,
            src_stride_v,
            src_uv_width,
            src_uv_height,
            dst_v,
            dst_stride_v,
            DST_UV_WIDTH,
            DST_UV_HEIGHT,
            K_FILTER_BILINEAR
        );
    return r;
}

abs :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

i444_to_nv12 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_uv == null ||
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
    HalfMergeUVPlane(src_u, src_stride_u, src_v, src_stride_v, dst_uv, dst_stride_uv, width, height);
    return 0;
}

i444_to_nv21 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    return i444_to_nv12(
        src_y,
        src_stride_y,
        src_v,
        src_stride_v,
        src_u,
        src_stride_u,
        dst_y,
        dst_stride_y,
        dst_vu,
        dst_stride_vu,
        width,
        height
    );
}

i422_to_i420 :: (
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
    SRC_UV_WIDTH := (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1);
    return i4xx_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        SRC_UV_WIDTH,
        height
    );
}

i422_to_i210 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
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
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    Convert8To16Plane(src_y, src_stride_y, dst_y, dst_stride_y, 1024, width, height);

    Convert8To16Plane(src_u, src_stride_u, dst_u, dst_stride_u, 1024, halfwidth, height);
    Convert8To16Plane(src_v, src_stride_v, dst_v, dst_stride_v, 1024, halfwidth, height);
    return 0;
}

mm21_to_nv12 :: (
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
    if src_uv == null || dst_uv == null || width <= 0 {
        return -1;
    }

    sign := (ifx height < 0 then cast(s32) -1 else 1);

    if dst_y != null {
        DetilePlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height, 32);
    }
    DetilePlane(src_uv, src_stride_uv, dst_uv, dst_stride_uv, (width + 1) & ~(cast(s32) 1), (height + sign) / 2, 16);

    return 0;
}

mm21_to_i420 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    sign := (ifx height < 0 then cast(s32) -1 else 1);

    if src_uv == null || dst_u == null || dst_v == null || width <= 0 {
        return -1;
    }

    if dst_y != null {
        DetilePlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height, 32);
    }
    DetileSplitUVPlane(
        src_uv,
        src_stride_uv,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        (width + 1) & ~(cast(s32) 1),
        (height + sign) / 2,
        16
    );

    return 0;
}

mm21_to_yuy2 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null || src_uv == null || dst_yuy2 == null || width <= 0 {
        return -1;
    }

    DetileToYUY2(src_y, src_stride_y, src_uv, src_stride_uv, dst_yuy2, dst_stride_yuy2, width, height, 32);

    return 0;
}

mt2_t_to_p010 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    if width <= 0 || height == 0 || height == -2147483647 - 1 || src_uv == null || dst_uv == null {
        return -1;
    }

    {
        uv_width := (width + 1) & ~(cast(s32) 1);
        uv_height := (height + 1) / 2;
        y: s32 = 0;
        TILE_WIDTH: s32 = 16;
        Y_TILE_HEIGHT: s32 = 32;
        UV_TILE_HEIGHT: s32 = 16;
        padded_width := (width + TILE_WIDTH - 1) & ~(TILE_WIDTH - 1);
        y_tile_row_size := padded_width * Y_TILE_HEIGHT * 10 / 8;
        uv_tile_row_size := padded_width * UV_TILE_HEIGHT * 10 / 8;
        row_buf_size: u64 = (cast,no_check(u64) (padded_width * Y_TILE_HEIGHT)) * 2;
        unpack_mt2_t: #type (_: *u8, _: *u16, _: u64) = cast,no_check(#type (_: *u8, _: *u16, _: u64)) UnpackMT2T_C;
        row_buf_mem_size := row_buf_size;

        row_buf_mem: *void =
            cast,no_check(*void) ((ifx row_buf_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_buf_mem_size + 63))));

        row_buf :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_buf_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row_buf == null {
            return 1;
        }

        if height < 0 {
            height = -height;
            uv_height = (height + 1) / 2;
            if dst_y != null {
                dst_y = cast,no_check(*u16) ((dst_y + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_y));
                dst_stride_y = -dst_stride_y;
            }
            dst_uv = cast,no_check(*u16) ((dst_uv + (cast,no_check(s64) (uv_height - 1)) * cast(s64) dst_stride_uv));
            dst_stride_uv = -dst_stride_uv;
        }

        if src_y != null && dst_y != null {
            y = 0;
            while y < height & ~(Y_TILE_HEIGHT - 1) {
                unpack_mt2_t(src_y, cast(*u16) row_buf, cast,no_check(u64) y_tile_row_size);
                DetilePlane_16(
                    cast(*u16) row_buf,
                    padded_width,
                    dst_y,
                    dst_stride_y,
                    width,
                    Y_TILE_HEIGHT,
                    Y_TILE_HEIGHT
                );
                src_y += src_stride_y * Y_TILE_HEIGHT;
                dst_y += dst_stride_y * Y_TILE_HEIGHT;
                y += Y_TILE_HEIGHT;
            }
            if height & (Y_TILE_HEIGHT - 1) != 0 {
                unpack_mt2_t(src_y, cast(*u16) row_buf, cast,no_check(u64) y_tile_row_size);
                DetilePlane_16(
                    cast(*u16) row_buf,
                    padded_width,
                    dst_y,
                    dst_stride_y,
                    width,
                    height & (Y_TILE_HEIGHT - 1),
                    Y_TILE_HEIGHT
                );
            }
        }

        y = 0;
        while y < uv_height & ~(UV_TILE_HEIGHT - 1) {
            unpack_mt2_t(src_uv, cast(*u16) row_buf, cast,no_check(u64) uv_tile_row_size);
            DetilePlane_16(
                cast(*u16) row_buf,
                padded_width,
                dst_uv,
                dst_stride_uv,
                uv_width,
                UV_TILE_HEIGHT,
                UV_TILE_HEIGHT
            );
            src_uv += src_stride_uv * UV_TILE_HEIGHT;
            dst_uv += dst_stride_uv * UV_TILE_HEIGHT;
            y += UV_TILE_HEIGHT;
        }
        if uv_height & (UV_TILE_HEIGHT - 1) != 0 {
            unpack_mt2_t(src_uv, cast(*u16) row_buf, cast,no_check(u64) uv_tile_row_size);
            DetilePlane_16(
                cast(*u16) row_buf,
                padded_width,
                dst_uv,
                dst_stride_uv,
                uv_width,
                uv_height & (UV_TILE_HEIGHT - 1),
                UV_TILE_HEIGHT
            );
        }
        c_transpiler_deallocate_memory(row_buf_mem);

        row_buf = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

i422_to_nv21 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    PLANE_SIZE := (cast,no_check(u64) halfwidth) * cast,no_check(u64) halfheight;
    if PLANE_SIZE > (cast(u64) 18446744073709551615) / 2 {
        return 1;
    }
    plane_u_mem_size := PLANE_SIZE * 2;

    plane_u_mem: *void =
        cast,no_check(*void) ((ifx plane_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(plane_u_mem_size + 63))));

    plane_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) plane_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if plane_u == null {
        return 1;
    }
    plane_v := cast,no_check(*u8) ((plane_u + PLANE_SIZE));

    r :=
        i422_to_i420(
            src_y,
            src_stride_y,
            src_u,
            src_stride_u,
            src_v,
            src_stride_v,
            dst_y,
            dst_stride_y,
            plane_u,
            halfwidth,
            plane_v,
            halfwidth,
            width,
            height
        );
    if r != 0 {
        return r;
    }
    MergeUVPlane(plane_v, halfwidth, plane_u, halfwidth, dst_vu, dst_stride_vu, halfwidth, halfheight);
    c_transpiler_deallocate_memory(plane_u_mem);

    plane_u = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

i420_copy :: (
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
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    CopyPlane(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
    CopyPlane(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
    return 0;
}

i010_copy :: (
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
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    CopyPlane_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
    CopyPlane_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
    return 0;
}

i010_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        1,
        10
    );
}

planar16bit_to8bit :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    subsample_x: s32,
    subsample_y: s32,
    depth: s32
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
    uv_width :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    uv_height :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));
    scale := (cast(s32) 1) << (((24 - depth)) & 31);

    if height < 0 {
        height = -height;
        uv_height = -uv_height;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (uv_height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (uv_height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        Convert16To8Plane(src_y, src_stride_y, dst_y, dst_stride_y, scale, width, height);
    }

    Convert16To8Plane(src_u, src_stride_u, dst_u, dst_stride_u, scale, uv_width, uv_height);
    Convert16To8Plane(src_v, src_stride_v, dst_v, dst_stride_v, scale, uv_width, uv_height);
    return 0;
}

i210_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return i21x_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        10
    );
}

i21x_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    depth: s32
) -> s32 {
    SCALE := (cast(s32) 1) << (((24 - depth)) & 31);
    UV_WIDTH := (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1);
    convert16_to8_row: #type (_: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u8, _: s32, _: s32)) Convert16To8Row_C;
    half_row_16_to8: #type (_: *u16, _: s64, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u8, _: s32, _: s32)) HalfRow_16To8_C;

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
        if src_y != null {
            src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
            src_stride_y = -src_stride_y;
        }
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    y: s32 = 0;
    while y < height - 1 {
        half_row_16_to8(src_u, cast,no_check(s64) src_stride_u, dst_u, SCALE, UV_WIDTH);
        half_row_16_to8(src_v, cast,no_check(s64) src_stride_v, dst_v, SCALE, UV_WIDTH);
        if dst_y != null {
            convert16_to8_row(src_y, dst_y, SCALE, width);
            convert16_to8_row(src_y + src_stride_y, dst_y + dst_stride_y, SCALE, width);
            src_y += src_stride_y * 2;
            dst_y += dst_stride_y * 2;
        }
        src_u += src_stride_u * 2;
        src_v += src_stride_v * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        half_row_16_to8(src_u, 0, dst_u, SCALE, UV_WIDTH);
        half_row_16_to8(src_v, 0, dst_v, SCALE, UV_WIDTH);
        if dst_y != null {
            convert16_to8_row(src_y, dst_y, SCALE, width);
        }
    }
    return 0;
}

i210_to_i422 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        0,
        10
    );
}

i410_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return i41x_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        10
    );
}

i41x_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    depth: s32
) -> s32 {
    SCALE := (cast(s32) 1) << (((24 - depth)) & 31);
    UV_WIDTH := (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1);
    convert16_to8_row: #type (_: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u8, _: s32, _: s32)) Convert16To8Row_C;
    half_width_row_16_to8: #type (_: *u16, _: s64, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u8, _: s32, _: s32)) (ifx width & 1 != 0 then HalfWidthRow_16To8_Odd_C else HalfWidthRow_16To8_C);

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
        if src_y != null {
            src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
            src_stride_y = -src_stride_y;
        }
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_v));
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if (cast,no_check(u64) width) & cast,no_check(u64) (2 - 1) == 0 {
    }

    y: s32 = 0;
    while y < height - 1 {
        half_width_row_16_to8(src_u, cast,no_check(s64) src_stride_u, dst_u, SCALE, UV_WIDTH);
        half_width_row_16_to8(src_v, cast,no_check(s64) src_stride_v, dst_v, SCALE, UV_WIDTH);
        if dst_y != null {
            convert16_to8_row(src_y, dst_y, SCALE, width);
            convert16_to8_row(src_y + src_stride_y, dst_y + dst_stride_y, SCALE, width);
            src_y += src_stride_y * 2;
            dst_y += dst_stride_y * 2;
        }
        src_u += src_stride_u * 2;
        src_v += src_stride_v * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        half_width_row_16_to8(src_u, 0, dst_u, SCALE, UV_WIDTH);
        half_width_row_16_to8(src_v, 0, dst_v, SCALE, UV_WIDTH);
        if dst_y != null {
            convert16_to8_row(src_y, dst_y, SCALE, width);
        }
    }
    return 0;
}

i410_to_i444 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        0,
        0,
        10
    );
}

i012_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        1,
        12
    );
}

i212_to_i422 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        0,
        12
    );
}

i212_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return i21x_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        12
    );
}

i412_to_i444 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return planar16bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        0,
        0,
        12
    );
}

i412_to_i420 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
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
    return i41x_to_i420(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        12
    );
}

p010_to_nv12 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return biplanar16bit_to8bit(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        width,
        height,
        1,
        1,
        16
    );
}

biplanar16bit_to8bit :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32,
    subsample_x: s32,
    subsample_y: s32,
    depth: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }
    uv_width :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    uv_height :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));
    scale := (cast(s32) 1) << (((24 - depth)) & 31);

    if height < 0 {
        height = -height;
        uv_height = -uv_height;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_uv = cast,no_check(*u16) ((src_uv + (cast,no_check(s64) (uv_height - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }

    if dst_y != null {
        Convert16To8Plane(src_y, src_stride_y, dst_y, dst_stride_y, scale, width, height);
    }

    Convert16To8Plane(src_uv, src_stride_uv, dst_uv, dst_stride_uv, scale, uv_width * 2, uv_height);
    return 0;
}

i410_to_i010 :: (
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
    return ix10_to_i010(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        0,
        0
    );
}

ix10_to_i010 :: (
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
    height: s32,
    subsample_x: s32,
    subsample_y: s32
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
    DST_Y_WIDTH := width;
    DST_Y_HEIGHT := abs(height);
    SRC_UV_WIDTH :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    SRC_UV_HEIGHT :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));
    DST_UV_WIDTH := (ifx DST_Y_WIDTH < 0 then -((-DST_Y_WIDTH + 1) >> 1) else (DST_Y_WIDTH + 1) >> 1);
    DST_UV_HEIGHT := (ifx DST_Y_HEIGHT < 0 then -((-DST_Y_HEIGHT + 1) >> 1) else (DST_Y_HEIGHT + 1) >> 1);
    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        ScalePlane_12(
            src_u,
            src_stride_u,
            SRC_UV_WIDTH,
            SRC_UV_HEIGHT,
            dst_u,
            dst_stride_u,
            DST_UV_WIDTH,
            DST_UV_HEIGHT,
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_v,
            src_stride_v,
            SRC_UV_WIDTH,
            SRC_UV_HEIGHT,
            dst_v,
            dst_stride_v,
            DST_UV_WIDTH,
            DST_UV_HEIGHT,
            K_FILTER_BILINEAR
        );
    return r;
}

i210_to_i010 :: (
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
    return ix10_to_i010(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        0
    );
}

i010_to_p010 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ixxx_to_pxxx(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        width,
        height,
        1,
        1,
        10
    );
}

ixxx_to_pxxx :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32,
    subsample_x: s32,
    subsample_y: s32,
    depth: s32
) -> s32 {
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    UV_WIDTH :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    UV_HEIGHT :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));

    ConvertToMSBPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height, depth);
    MergeUVPlane_16(src_u, src_stride_u, src_v, src_stride_v, dst_uv, dst_stride_uv, UV_WIDTH, UV_HEIGHT, depth);
    return 0;
}

i010_to_nv12 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    y: s32 = ---;
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    SCALE: s32 = 16385;
    convert16_to8_row: #type (_: *u16, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u8, _: s32, _: s32)) Convert16To8Row_C;
    merge_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MergeUVRow_C;
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u16) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u16) ((src_u + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u16) ((src_v + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        Convert16To8Plane(src_y, src_stride_y, dst_y, dst_stride_y, SCALE, width, height);
    }

    {
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

        y = 0;
        while y < halfheight {
            convert16_to8_row(src_u, row_u, SCALE, halfwidth);
            convert16_to8_row(src_v, row_v, SCALE, halfwidth);
            merge_uv_row(row_u, row_v, dst_uv, halfwidth);
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_uv += dst_stride_uv;
            y += 1;
        }
        c_transpiler_deallocate_memory(row_u_mem);

        row_u = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

i210_to_p210 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ixxx_to_pxxx(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        width,
        height,
        1,
        0,
        10
    );
}

i012_to_p012 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ixxx_to_pxxx(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        width,
        height,
        1,
        1,
        12
    );
}

i212_to_p212 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    return ixxx_to_pxxx(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_uv,
        dst_stride_uv,
        width,
        height,
        1,
        0,
        12
    );
}

i400_to_i420 :: (
    src_y: *u8,
    src_stride_y: s32,
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
        src_stride_y = -src_stride_y;
    }
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    SetPlane(dst_u, dst_stride_u, halfwidth, halfheight, 128);
    SetPlane(dst_v, dst_stride_v, halfwidth, halfheight, 128);
    return 0;
}

j420_to_i420 :: (
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
    return planar8bit_to8bit(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        1,
        220,
        16,
        225,
        16
    );
}

planar8bit_to8bit :: (
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
    height: s32,
    subsample_x: s32,
    subsample_y: s32,
    scale_y: s32,
    bias_y: s32,
    scale_uv: s32,
    bias_uv: s32
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
    uv_width :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    uv_height :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));

    if height < 0 {
        height = -height;
        uv_height = -uv_height;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (uv_height - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (uv_height - 1)) * cast(s64) src_stride_v));
        src_stride_y = -src_stride_y;
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        Convert8To8Plane(src_y, src_stride_y, dst_y, dst_stride_y, scale_y, bias_y, width, height);
    }

    Convert8To8Plane(src_u, src_stride_u, dst_u, dst_stride_u, scale_uv, bias_uv, uv_width, uv_height);
    Convert8To8Plane(src_v, src_stride_v, dst_v, dst_stride_v, scale_uv, bias_uv, uv_width, uv_height);
    return 0;
}

i400_to_nv21 :: (
    src_y: *u8,
    src_stride_y: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    if src_y == null && dst_y != null || dst_vu == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        halfheight = (height + 1) >> 1;
        src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
        src_stride_y = -src_stride_y;
    }
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    SetPlane(dst_vu, dst_stride_vu, halfwidth * 2, halfheight, 128);
    return 0;
}

nv12_to_i420 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
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
        src_uv == null ||
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
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }

    if src_stride_y == width && dst_stride_y == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_y = 0;
        src_stride_y = dst_stride_y;
    }

    if src_stride_uv == halfwidth * 2 &&
        dst_stride_u == halfwidth &&
        dst_stride_v == halfwidth &&
        ((cast,no_check(s64) halfwidth) * cast(s64) halfheight) <= 2147483647 {
        halfwidth *= halfheight;
        halfheight = 1;
        dst_stride_v = 0;
        dst_stride_u = dst_stride_v;
        src_stride_uv = dst_stride_u;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    SplitUVPlane(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, halfwidth, halfheight);

    return 0;
}

nv21_to_i420 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_vu: *u8,
    src_stride_vu: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return nv12_to_i420(
        src_y,
        src_stride_y,
        src_vu,
        src_stride_vu,
        dst_y,
        dst_stride_y,
        dst_v,
        dst_stride_v,
        dst_u,
        dst_stride_u,
        width,
        height
    );
}

nv12_to_nv24 :: (
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
    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        UVScale(
            src_uv,
            src_stride_uv,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            (ifx height < 0 then -((-height + 1) >> 1) else (height + 1) >> 1),
            dst_uv,
            dst_stride_uv,
            abs(width),
            abs(height),
            K_FILTER_BILINEAR
        );
    return r;
}

nv16_to_nv24 :: (
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
    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        UVScale(
            src_uv,
            src_stride_uv,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_uv,
            dst_stride_uv,
            abs(width),
            abs(height),
            K_FILTER_BILINEAR
        );
    return r;
}

p010_to_i010 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return pxxx_to_ixxx(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        1,
        10
    );
}

pxxx_to_ixxx :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    subsample_x: s32,
    subsample_y: s32,
    depth: s32
) -> s32 {
    UV_WIDTH :=
        (ifx width < 0 then -((-width + subsample_x) >> ((subsample_x) & 31)) else (width +
            subsample_x) >> ((subsample_x) & 31));
    UV_HEIGHT :=
        (ifx height < 0 then -((-height + subsample_y) >> ((subsample_y) & 31)) else (height +
            subsample_y) >> ((subsample_y) & 31));
    if src_y == null ||
        dst_y == null ||
        src_uv == null ||
        dst_u == null ||
        dst_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }
    ConvertToLSBPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height, depth);
    SplitUVPlane_16(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, UV_WIDTH, UV_HEIGHT, depth);
    return 0;
}

p012_to_i012 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return pxxx_to_ixxx(
        src_y,
        src_stride_y,
        src_uv,
        src_stride_uv,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        1,
        1,
        12
    );
}

p010_to_p410 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        UVScale_16(
            src_uv,
            src_stride_uv,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            (ifx height < 0 then -((-height + 1) >> 1) else (height + 1) >> 1),
            dst_uv,
            dst_stride_uv,
            abs(width),
            abs(height),
            K_FILTER_BILINEAR
        );
    return r;
}

p210_to_p410 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_uv: *u16,
    src_stride_uv: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    if src_y == null && dst_y != null ||
        src_uv == null ||
        dst_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        UVScale_16(
            src_uv,
            src_stride_uv,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_uv,
            dst_stride_uv,
            abs(width),
            abs(height),
            K_FILTER_BILINEAR
        );
    return r;
}

yuy2_to_i420 :: (
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
    yuy2_to_uv_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32)) YUY2ToUVRow_C;
    yuy2_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) YUY2ToYRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_yuy2 = cast,no_check(*u8) ((src_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_yuy2));
        src_stride_yuy2 = -src_stride_yuy2;
    }

    y: s32 = 0;
    while y < height - 1 {
        yuy2_to_uv_row(src_yuy2, src_stride_yuy2, dst_u, dst_v, width);
        yuy2_to_y_row(src_yuy2, dst_y, width);
        yuy2_to_y_row(src_yuy2 + src_stride_yuy2, dst_y + dst_stride_y, width);
        src_yuy2 += src_stride_yuy2 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        yuy2_to_uv_row(src_yuy2, 0, dst_u, dst_v, width);
        yuy2_to_y_row(src_yuy2, dst_y, width);
    }
    return 0;
}

uyvy_to_i420 :: (
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
    uyvy_to_uv_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32)) UYVYToUVRow_C;
    uyvy_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) UYVYToYRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uyvy = cast,no_check(*u8) ((src_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uyvy));
        src_stride_uyvy = -src_stride_uyvy;
    }

    y: s32 = 0;
    while y < height - 1 {
        uyvy_to_uv_row(src_uyvy, src_stride_uyvy, dst_u, dst_v, width);
        uyvy_to_y_row(src_uyvy, dst_y, width);
        uyvy_to_y_row(src_uyvy + src_stride_uyvy, dst_y + dst_stride_y, width);
        src_uyvy += src_stride_uyvy * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        uyvy_to_uv_row(src_uyvy, 0, dst_u, dst_v, width);
        uyvy_to_y_row(src_uyvy, dst_y, width);
    }
    return 0;
}

ayuv_to_nv12 :: (
    src_ayuv: *u8,
    src_stride_ayuv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    width: s32,
    height: s32
) -> s32 {
    ayuv_to_uv_row: #type (_: *u8, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32)) AYUVToUVRow_C;
    ayuv_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) AYUVToYRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ayuv = cast,no_check(*u8) ((src_ayuv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ayuv));
        src_stride_ayuv = -src_stride_ayuv;
    }

    y: s32 = 0;
    while y < height - 1 {
        ayuv_to_uv_row(src_ayuv, src_stride_ayuv, dst_uv, width);
        ayuv_to_y_row(src_ayuv, dst_y, width);
        ayuv_to_y_row(src_ayuv + src_stride_ayuv, dst_y + dst_stride_y, width);
        src_ayuv += src_stride_ayuv * 2;
        dst_y += dst_stride_y * 2;
        dst_uv += dst_stride_uv;
        y += 2;
    }
    if height & 1 != 0 {
        ayuv_to_uv_row(src_ayuv, 0, dst_uv, width);
        ayuv_to_y_row(src_ayuv, dst_y, width);
    }
    return 0;
}

ayuv_to_nv21 :: (
    src_ayuv: *u8,
    src_stride_ayuv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_vu: *u8,
    dst_stride_vu: s32,
    width: s32,
    height: s32
) -> s32 {
    ayuv_to_vu_row: #type (_: *u8, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32)) AYUVToVURow_C;
    ayuv_to_y_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) AYUVToYRow_C;
    if width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_ayuv = cast,no_check(*u8) ((src_ayuv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_ayuv));
        src_stride_ayuv = -src_stride_ayuv;
    }

    y: s32 = 0;
    while y < height - 1 {
        ayuv_to_vu_row(src_ayuv, src_stride_ayuv, dst_vu, width);
        ayuv_to_y_row(src_ayuv, dst_y, width);
        ayuv_to_y_row(src_ayuv + src_stride_ayuv, dst_y + dst_stride_y, width);
        src_ayuv += src_stride_ayuv * 2;
        dst_y += dst_stride_y * 2;
        dst_vu += dst_stride_vu;
        y += 2;
    }
    if height & 1 != 0 {
        ayuv_to_vu_row(src_ayuv, 0, dst_vu, width);
        ayuv_to_y_row(src_ayuv, dst_y, width);
    }
    return 0;
}

android420_to_i420 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_pixel_stride_uv: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return Android420ToI420Rotate(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_pixel_stride_uv,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        width,
        height,
        K_ROTATE0
    );
}

argb_to_i420 :: (
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
        *K_ARGB_I601_CONSTANTS,
        width,
        height
    );
}

argb_to_i420_matrix :: (
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

    y: s32 = 0;
    while y < height - 1 {
        argb_to_uv_matrix_row(src_argb, src_stride_argb, dst_u, dst_v, width, argbconstants);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
        argb_to_y_matrix_row(src_argb + src_stride_argb, dst_y + dst_stride_y, width, argbconstants);
        src_argb += src_stride_argb * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        argb_to_uv_matrix_row(src_argb, 0, dst_u, dst_v, width, argbconstants);
        argb_to_y_matrix_row(src_argb, dst_y, width, argbconstants);
    }
    return 0;
}

argb_to_i420_alpha :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    width: s32,
    height: s32
) -> s32 {
    argb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToYMatrixRow_C;
    argb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGBToUVMatrixRow_C;
    argb_extract_alpha_row: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBExtractAlphaRow_C;
    if src_argb == null ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_a == null ||
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

    y: s32 = 0;
    while y < height - 1 {
        argb_to_uv_matrix_row(src_argb, src_stride_argb, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        argb_to_y_matrix_row(src_argb, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb_to_y_matrix_row(src_argb + src_stride_argb, dst_y + dst_stride_y, width, *K_ARGB_I601_CONSTANTS);
        argb_extract_alpha_row(src_argb, dst_a, width);
        argb_extract_alpha_row(src_argb + src_stride_argb, dst_a + dst_stride_a, width);
        src_argb += src_stride_argb * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        dst_a += dst_stride_a * 2;
        y += 2;
    }
    if height & 1 != 0 {
        argb_to_uv_matrix_row(src_argb, 0, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        argb_to_y_matrix_row(src_argb, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb_extract_alpha_row(src_argb, dst_a, width);
    }
    return 0;
}

bgra_to_i420 :: (
    src_bgra: *u8,
    src_stride_bgra: s32,
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
        src_bgra,
        src_stride_bgra,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_BGRA_I601_CONSTANTS,
        width,
        height
    );
}

abgr_to_i420 :: (
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
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

bgra_to_i422 :: (
    src_bgra: *u8,
    src_stride_bgra: s32,
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
        src_bgra,
        src_stride_bgra,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_BGRA_I601_CONSTANTS,
        width,
        height
    );
}

abgr_to_i422 :: (
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
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

rgba_to_i422 :: (
    src_rgba: *u8,
    src_stride_rgba: s32,
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
        src_rgba,
        src_stride_rgba,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_RGBA_I601_CONSTANTS,
        width,
        height
    );
}

rgba_to_i420 :: (
    src_rgba: *u8,
    src_stride_rgba: s32,
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
        src_rgba,
        src_stride_rgba,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_RGBA_I601_CONSTANTS,
        width,
        height
    );
}

rgb24_to_i420 :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUVMatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;

    if src_rgb24 == null ||
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
        src_rgb24 = cast,no_check(*u8) ((src_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb24));
        src_stride_rgb24 = -src_stride_rgb24;
    }

    y: s32 = 0;
    while y < height - 1 {
        rgb_to_uv_matrix_row(src_rgb24, src_stride_rgb24, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        rgb_to_y_matrix_row(src_rgb24, dst_y, width, *K_ARGB_I601_CONSTANTS);
        rgb_to_y_matrix_row(src_rgb24 + src_stride_rgb24, dst_y + dst_stride_y, width, *K_ARGB_I601_CONSTANTS);
        src_rgb24 += src_stride_rgb24 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        rgb_to_y_matrix_row(src_rgb24, dst_y, width, *K_ARGB_I601_CONSTANTS);
        rgb_to_uv_matrix_row(src_rgb24, 0, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
    }
    return 0;
}

rgb24_to_j420 :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUVMatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;

    if src_rgb24 == null ||
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
        src_rgb24 = cast,no_check(*u8) ((src_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb24));
        src_stride_rgb24 = -src_stride_rgb24;
    }

    y: s32 = 0;
    while y < height - 1 {
        rgb_to_uv_matrix_row(src_rgb24, src_stride_rgb24, dst_u, dst_v, width, *K_ARGB_JPEG_CONSTANTS);
        rgb_to_y_matrix_row(src_rgb24, dst_y, width, *K_ARGB_JPEG_CONSTANTS);
        rgb_to_y_matrix_row(src_rgb24 + src_stride_rgb24, dst_y + dst_stride_y, width, *K_ARGB_JPEG_CONSTANTS);
        src_rgb24 += src_stride_rgb24 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        rgb_to_y_matrix_row(src_rgb24, dst_y, width, *K_ARGB_JPEG_CONSTANTS);
        rgb_to_uv_matrix_row(src_rgb24, 0, dst_u, dst_v, width, *K_ARGB_JPEG_CONSTANTS);
    }
    return 0;
}

raw_to_i420 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUVMatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;

    if src_raw == null ||
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
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    y: s32 = 0;
    while y < height - 1 {
        rgb_to_uv_matrix_row(src_raw, src_stride_raw, dst_u, dst_v, width, *K_ABGR_I601_CONSTANTS);
        rgb_to_y_matrix_row(src_raw, dst_y, width, *K_ABGR_I601_CONSTANTS);
        rgb_to_y_matrix_row(src_raw + src_stride_raw, dst_y + dst_stride_y, width, *K_ABGR_I601_CONSTANTS);
        src_raw += src_stride_raw * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        rgb_to_y_matrix_row(src_raw, dst_y, width, *K_ABGR_I601_CONSTANTS);
        rgb_to_uv_matrix_row(src_raw, 0, dst_u, dst_v, width, *K_ABGR_I601_CONSTANTS);
    }
    return 0;
}

raw_to_i444 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_i444_matrix(
        src_raw,
        src_stride_raw,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        *K_ABGR_I601_CONSTANTS,
        width,
        height
    );
}

raw_to_i444_matrix :: (
    src_raw: *u8,
    src_stride_raw: s32,
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
    rgb_to_uv444_matrix_row: #type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUV444MatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;

    if src_raw == null ||
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
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb_to_y_matrix_row(src_raw, dst_y, width, argbconstants);
            rgb_to_uv444_matrix_row(src_raw, dst_u, dst_v, width, argbconstants);
            src_raw += src_stride_raw;
            dst_y += dst_stride_y;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    return 0;
}

raw_to_j420 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToUVMatrixRow_C;
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;

    if src_raw == null ||
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
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    y: s32 = 0;
    while y < height - 1 {
        rgb_to_uv_matrix_row(src_raw, src_stride_raw, dst_u, dst_v, width, *K_ABGR_JPEG_CONSTANTS);
        rgb_to_y_matrix_row(src_raw, dst_y, width, *K_ABGR_JPEG_CONSTANTS);
        rgb_to_y_matrix_row(src_raw + src_stride_raw, dst_y + dst_stride_y, width, *K_ABGR_JPEG_CONSTANTS);
        src_raw += src_stride_raw * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        rgb_to_y_matrix_row(src_raw, dst_y, width, *K_ABGR_JPEG_CONSTANTS);
        rgb_to_uv_matrix_row(src_raw, 0, dst_u, dst_v, width, *K_ABGR_JPEG_CONSTANTS);
    }
    return 0;
}

raw_to_j444 :: (
    src_raw: *u8,
    src_stride_raw: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    return raw_to_i444_matrix(
        src_raw,
        src_stride_raw,
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

rgb565_to_i420 :: (
    src_rgb565: *u8,
    src_stride_rgb565: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb565_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGB565ToUVMatrixRow_C;
    rgb565_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGB565ToYMatrixRow_C;

    if src_rgb565 == null ||
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
        src_rgb565 =
            cast,no_check(*u8) ((src_rgb565 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb565));
        src_stride_rgb565 = -src_stride_rgb565;
    }

    y: s32 = 0;
    while y < height - 1 {
        rgb565_to_uv_matrix_row(src_rgb565, src_stride_rgb565, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        rgb565_to_y_matrix_row(src_rgb565, dst_y, width, *K_ARGB_I601_CONSTANTS);
        rgb565_to_y_matrix_row(src_rgb565 + src_stride_rgb565, dst_y + dst_stride_y, width, *K_ARGB_I601_CONSTANTS);
        src_rgb565 += src_stride_rgb565 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        rgb565_to_y_matrix_row(src_rgb565, dst_y, width, *K_ARGB_I601_CONSTANTS);
        rgb565_to_uv_matrix_row(src_rgb565, 0, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
    }
    return 0;
}

argb1555_to_i420 :: (
    src_argb1555: *u8,
    src_stride_argb1555: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    argb1555_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGB1555ToUVMatrixRow_C;
    argb1555_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGB1555ToYMatrixRow_C;

    if src_argb1555 == null ||
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
        src_argb1555 =
            cast,no_check(*u8) ((src_argb1555 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb1555));
        src_stride_argb1555 = -src_stride_argb1555;
    }

    y: s32 = 0;
    while y < height - 1 {
        argb1555_to_uv_matrix_row(src_argb1555, src_stride_argb1555, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        argb1555_to_y_matrix_row(src_argb1555, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb1555_to_y_matrix_row(
            src_argb1555 + src_stride_argb1555,
            dst_y + dst_stride_y,
            width,
            *K_ARGB_I601_CONSTANTS
        );
        src_argb1555 += src_stride_argb1555 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        argb1555_to_y_matrix_row(src_argb1555, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb1555_to_uv_matrix_row(src_argb1555, 0, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
    }
    return 0;
}

argb4444_to_i420 :: (
    src_argb4444: *u8,
    src_stride_argb4444: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32
) -> s32 {
    argb4444_to_uv_matrix_row: #type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGB4444ToUVMatrixRow_C;
    argb4444_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) ARGB4444ToYMatrixRow_C;

    if src_argb4444 == null ||
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
        src_argb4444 =
            cast,no_check(*u8) ((src_argb4444 +
                (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb4444));
        src_stride_argb4444 = -src_stride_argb4444;
    }

    y: s32 = 0;
    while y < height - 1 {
        argb4444_to_uv_matrix_row(src_argb4444, src_stride_argb4444, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
        argb4444_to_y_matrix_row(src_argb4444, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb4444_to_y_matrix_row(
            src_argb4444 + src_stride_argb4444,
            dst_y + dst_stride_y,
            width,
            *K_ARGB_I601_CONSTANTS
        );
        src_argb4444 += src_stride_argb4444 * 2;
        dst_y += dst_stride_y * 2;
        dst_u += dst_stride_u;
        dst_v += dst_stride_v;
        y += 2;
    }
    if height & 1 != 0 {
        argb4444_to_y_matrix_row(src_argb4444, dst_y, width, *K_ARGB_I601_CONSTANTS);
        argb4444_to_uv_matrix_row(src_argb4444, 0, dst_u, dst_v, width, *K_ARGB_I601_CONSTANTS);
    }
    return 0;
}

rgb24_to_j400 :: (
    src_rgb24: *u8,
    src_stride_rgb24: s32,
    dst_yj: *u8,
    dst_stride_yj: s32,
    width: s32,
    height: s32
) -> s32 {
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;
    if src_rgb24 == null || dst_yj == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_rgb24 = cast,no_check(*u8) ((src_rgb24 + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_rgb24));
        src_stride_rgb24 = -src_stride_rgb24;
    }

    if src_stride_rgb24 == width * 3 && dst_stride_yj == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_yj = 0;
        src_stride_rgb24 = dst_stride_yj;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb_to_y_matrix_row(src_rgb24, dst_yj, width, *K_ARGB_JPEG_CONSTANTS);
            src_rgb24 += src_stride_rgb24;
            dst_yj += dst_stride_yj;
        }
    }
    return 0;
}

raw_to_j400 :: (src_raw: *u8, src_stride_raw: s32, dst_yj: *u8, dst_stride_yj: s32, width: s32, height: s32) -> s32 {
    rgb_to_y_matrix_row: #type (_: *u8, _: *u8, _: s32, _: *Argb_Constants) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: *Argb_Constants)) RGBToYMatrixRow_C;
    if src_raw == null || dst_yj == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        src_raw = cast,no_check(*u8) ((src_raw + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_raw));
        src_stride_raw = -src_stride_raw;
    }

    if src_stride_raw == width * 3 && dst_stride_yj == width && ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_yj = 0;
        src_stride_raw = dst_stride_yj;
    }

    if 0 < height {
        for y: 0..height - 1 {
            rgb_to_y_matrix_row(src_raw, dst_yj, width, *K_ABGR_JPEG_CONSTANTS);
            src_raw += src_stride_raw;
            dst_yj += dst_stride_yj;
        }
    }
    return 0;
}

test_cpu_flag_in_convert :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert: u32;
initialize_globals_for_convert :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_storage = 0x1;
    K_CPU_HAS_ARM_storage = 0x2;
    K_CPU_HAS_NEON_storage = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_storage = 0x200;
    K_CPU_HAS_NEON_I8_MM_storage = 0x400;
    K_CPU_HAS_SVE_storage = 0x800;
    K_CPU_HAS_SVE2_storage = 0x1000;
    K_CPU_HAS_SME_storage = 0x2000;
    K_CPU_HAS_SME2_storage = 0x4000;
    K_CPU_HAS_SVEF32_MM_storage = 0x8000;
    K_CPU_HAS_RISCV_storage = 0x4;
    K_CPU_HAS_RVV_storage = 0x100;
    K_CPU_HAS_RVVZVFH_storage = 0x200;
    K_CPU_HAS_X86_storage = 0x8;
    K_CPU_HAS_SSE2_storage = 0x100;
    K_CPU_HAS_SSSE3_storage = 0x200;
    K_CPU_HAS_SSE41_storage = 0x400;
    K_CPU_HAS_SSE42_storage = 0x800;
    K_CPU_HAS_AVX_storage = 0x1000;
    K_CPU_HAS_AVX2_storage = 0x2000;
    K_CPU_HAS_ERMS_storage = 0x4000;
    K_CPU_HAS_FSMR_storage = 0x8000;
    K_CPU_HAS_FMA3_storage = 0x10000;
    K_CPU_HAS_F16_C_storage = 0x20000;
    K_CPU_HAS_AVX512_BW_storage = 0x40000;
    K_CPU_HAS_AVX512_VL_storage = 0x80000;
    K_CPU_HAS_AVX512_VNNI_storage = 0x100000;
    K_CPU_HAS_AVX512_VBMI_storage = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_storage = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_storage = 0x800000;
    K_CPU_HAS_AVX10_storage = 0x1000000;
    K_CPU_HAS_AVX10_2_storage = 0x2000000;
    K_CPU_HAS_AVXVNNI_storage = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_storage = 0x8000000;
    K_CPU_HAS_AMXINT8_storage = 0x10000000;
    K_CPU_HAS_AVX512_BMM_storage = 0x20000000;
    K_CPU_HAS_LOONGARCH_storage = 0x20;
    K_CPU_HAS_LSX_storage = 0x100;
    K_CPU_HAS_LASX_storage = 0x200;
    atomic_store(*globals_initialization_state_for_convert, 2);
}

Filter_Mode :: u32;
K_FILTER_NONE : Filter_Mode : 0;
K_FILTER_LINEAR : Filter_Mode : 1;
K_FILTER_BILINEAR : Filter_Mode : 2;
K_FILTER_BOX : Filter_Mode : 3;

Rotation_Mode :: u32;
K_ROTATE0 : Rotation_Mode : 0;
K_ROTATE90 : Rotation_Mode : 90;
K_ROTATE180 : Rotation_Mode : 180;
K_ROTATE270 : Rotation_Mode : 270;
K_ROTATE_NONE : Rotation_Mode : 0;
K_ROTATE_CLOCKWISE : Rotation_Mode : 90;
K_ROTATE_COUNTER_CLOCKWISE : Rotation_Mode : 270;

Argb_Constants :: struct {
    k_rgb_to_y: [32] u8;
    k_rgb_to_u: [32] s8;
    k_rgb_to_v: [32] s8;
    k_add_y: [16] u16;
    k_add_uv: [16] u16;
}

