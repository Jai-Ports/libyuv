// Generated directly from C++ by cpp_transpiler.
K_CPU_INITIALIZED_in_convert_from: s32;

K_CPU_HAS_ARM_in_convert_from: s32;

K_CPU_HAS_NEON_in_convert_from: s32;

K_CPU_HAS_NEON_DOT_PROD_in_convert_from: s32;

K_CPU_HAS_NEON_I8_MM_in_convert_from: s32;

K_CPU_HAS_SVE_in_convert_from: s32;

K_CPU_HAS_SVE2_in_convert_from: s32;

K_CPU_HAS_SME_in_convert_from: s32;

K_CPU_HAS_SME2_in_convert_from: s32;

K_CPU_HAS_SVEF32_MM_in_convert_from: s32;

K_CPU_HAS_RISCV_in_convert_from: s32;

K_CPU_HAS_RVV_in_convert_from: s32;

K_CPU_HAS_RVVZVFH_in_convert_from: s32;

K_CPU_HAS_X86_in_convert_from: s32;

K_CPU_HAS_SSE2_in_convert_from: s32;

K_CPU_HAS_SSSE3_in_convert_from: s32;

K_CPU_HAS_SSE41_in_convert_from: s32;

K_CPU_HAS_SSE42_in_convert_from: s32;

K_CPU_HAS_AVX_in_convert_from: s32;

K_CPU_HAS_AVX2_in_convert_from: s32;

K_CPU_HAS_ERMS_in_convert_from: s32;

K_CPU_HAS_FSMR_in_convert_from: s32;

K_CPU_HAS_FMA3_in_convert_from: s32;

K_CPU_HAS_F16_C_in_convert_from: s32;

K_CPU_HAS_AVX512_BW_in_convert_from: s32;

K_CPU_HAS_AVX512_VL_in_convert_from: s32;

K_CPU_HAS_AVX512_VNNI_in_convert_from: s32;

K_CPU_HAS_AVX512_VBMI_in_convert_from: s32;

K_CPU_HAS_AVX512_VBMI2_in_convert_from: s32;

K_CPU_HAS_AVX512_VBITALG_in_convert_from: s32;

K_CPU_HAS_AVX10_in_convert_from: s32;

K_CPU_HAS_AVX10_2_in_convert_from: s32;

K_CPU_HAS_AVXVNNI_in_convert_from: s32;

K_CPU_HAS_AVXVNNIINT8_in_convert_from: s32;

K_CPU_HAS_AMXINT8_in_convert_from: s32;

K_CPU_HAS_AVX512_BMM_in_convert_from: s32;

K_CPU_HAS_LOONGARCH_in_convert_from: s32;

K_CPU_HAS_LSX_in_convert_from: s32;

K_CPU_HAS_LASX_in_convert_from: s32;

I420ToI010 :: (
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
        if src_y != null {
            src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
            src_stride_y = -src_stride_y;
        }
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_v));
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        Convert8To16Plane(src_y, src_stride_y, dst_y, dst_stride_y, 1024, width, height);
    }

    Convert8To16Plane(src_u, src_stride_u, dst_u, dst_stride_u, 1024, halfwidth, halfheight);
    Convert8To16Plane(src_v, src_stride_v, dst_v, dst_stride_v, 1024, halfwidth, halfheight);
    return 0;
}

I420ToI012 :: (
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
        if src_y != null {
            src_y = cast,no_check(*u8) ((src_y + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_y));
            src_stride_y = -src_stride_y;
        }
        src_u = cast,no_check(*u8) ((src_u + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_u));
        src_v = cast,no_check(*u8) ((src_v + (cast,no_check(s64) (halfheight - 1)) * cast(s64) src_stride_v));
        src_stride_u = -src_stride_u;
        src_stride_v = -src_stride_v;
    }

    if dst_y != null {
        Convert8To16Plane(src_y, src_stride_y, dst_y, dst_stride_y, 4096, width, height);
    }

    Convert8To16Plane(src_u, src_stride_u, dst_u, dst_stride_u, 4096, halfwidth, halfheight);
    Convert8To16Plane(src_v, src_stride_v, dst_v, dst_stride_v, 4096, halfwidth, halfheight);
    return 0;
}

I420ToI422 :: (
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
    DST_UV_WIDTH := (abs_in_convert_from(width) + 1) >> 1;
    DST_UV_HEIGHT := abs_in_convert_from(height);
    return i420_to_i4xx(
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
        DST_UV_WIDTH,
        DST_UV_HEIGHT
    );
}

abs_in_convert_from :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

i420_to_i4xx :: (
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
    dst_uv_width: s32,
    dst_uv_height: s32
) -> s32 {
    SRC_UV_WIDTH := (ifx src_y_width < 0 then -((-src_y_width + 1) >> 1) else (src_y_width + 1) >> 1);
    SRC_UV_HEIGHT := (ifx src_y_height < 0 then -((-src_y_height + 1) >> 1) else (src_y_height + 1) >> 1);

    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        dst_u == null ||
        dst_v == null ||
        src_y_width <= 0 ||
        src_y_height == 0 ||
        dst_uv_width <= 0 ||
        dst_uv_height <= 0 {
        return -1;
    }
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, src_y_width, src_y_height);
    }
    r :=
        ScalePlane(
            src_u,
            src_stride_u,
            SRC_UV_WIDTH,
            SRC_UV_HEIGHT,
            dst_u,
            dst_stride_u,
            dst_uv_width,
            dst_uv_height,
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_v,
            src_stride_v,
            SRC_UV_WIDTH,
            SRC_UV_HEIGHT,
            dst_v,
            dst_stride_v,
            dst_uv_width,
            dst_uv_height,
            K_FILTER_BILINEAR
        );
    return r;
}

I420ToI444 :: (
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
    DST_UV_WIDTH := abs_in_convert_from(width);
    DST_UV_HEIGHT := abs_in_convert_from(height);
    return i420_to_i4xx(
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
        DST_UV_WIDTH,
        DST_UV_HEIGHT
    );
}

I400Copy :: (src_y: *u8, src_stride_y: s32, dst_y: *u8, dst_stride_y: s32, width: s32, height: s32) -> s32 {
    if src_y == null || dst_y == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    return 0;
}

I420ToNV12 :: (
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
    halfwidth := (width + 1) / 2;
    halfheight := (height + 1) / 2;
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
    MergeUVPlane(src_u, src_stride_u, src_v, src_stride_v, dst_uv, dst_stride_uv, halfwidth, halfheight);
    return 0;
}

I420ToNV21 :: (
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
    return I420ToNV12(
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

I420ToYUY2 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_yuy2_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToYUY2Row_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_yuy2 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_yuy2 = cast,no_check(*u8) ((dst_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_yuy2));
        dst_stride_yuy2 = -dst_stride_yuy2;
    }

    y: s32 = 0;
    while y < height - 1 {
        i422_to_yuy2_row(src_y, src_u, src_v, dst_yuy2, width);
        i422_to_yuy2_row(src_y + src_stride_y, src_u, src_v, dst_yuy2 + dst_stride_yuy2, width);
        src_y += src_stride_y * 2;
        src_u += src_stride_u;
        src_v += src_stride_v;
        dst_yuy2 += dst_stride_yuy2 * 2;
        y += 2;
    }
    if height & 1 != 0 {
        i422_to_yuy2_row(src_y, src_u, src_v, dst_yuy2, width);
    }
    return 0;
}

I420ToUYVY :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_uyvy: *u8,
    dst_stride_uyvy: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_uyvy_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToUYVYRow_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_uyvy == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_uyvy = cast,no_check(*u8) ((dst_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_uyvy));
        dst_stride_uyvy = -dst_stride_uyvy;
    }

    y: s32 = 0;
    while y < height - 1 {
        i422_to_uyvy_row(src_y, src_u, src_v, dst_uyvy, width);
        i422_to_uyvy_row(src_y + src_stride_y, src_u, src_v, dst_uyvy + dst_stride_uyvy, width);
        src_y += src_stride_y * 2;
        src_u += src_stride_u;
        src_v += src_stride_v;
        dst_uyvy += dst_stride_uyvy * 2;
        y += 2;
    }
    if height & 1 != 0 {
        i422_to_uyvy_row(src_y, src_u, src_v, dst_uyvy, width);
    }
    return 0;
}

ConvertFromI420 :: (
    y: *u8,
    y_stride: s32,
    u: *u8,
    u_stride: s32,
    v: *u8,
    v_stride: s32,
    dst_sample: *u8,
    dst_sample_stride: s32,
    width: s32,
    height: s32,
    fourcc: u32
) -> s32 {
    format: u32 = ---;
    r: s32 = ---;
    dst_y_stride: s32 = ---;
    dst_uv: *u8 = ---;
    dst_y_stride_2: s32 = ---;
    dst_vu: *u8 = ---;
    dst_y_stride_3: s32 = ---;
    dst_uv_stride: s32 = ---;
    dst_uv_2: *u8 = ---;
    halfwidth: s32 = ---;
    halfheight: s32 = ---;
    dst_y_stride_4: s32 = ---;
    dst_uv_stride_2: s32 = ---;
    dst_uv_3: *u8 = ---;
    temp_u_mem_size: u64 = ---;
    temp_u_mem: *void = ---;
    temp_u: *u8 = ---;
    temp_v_mem_size: u64 = ---;
    temp_v_mem: *void = ---;
    temp_v: *u8 = ---;
    halfstride: s32 = ---;
    halfheight_2: s32 = ---;
    dst_u: *u8 = ---;
    dst_v: *u8 = ---;
    halfstride_2: s32 = ---;
    dst_u_2: *u8 = ---;
    dst_v_2: *u8 = ---;
    dst_u_3: *u8 = ---;
    dst_v_3: *u8 = ---;
    code_block_to_execute: s64 = 131;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 24; {
                return r;
            }
            case 35; {
                dst_sample_stride = ifx dst_sample_stride != 0 then dst_sample_stride else width;
                if format == cast,no_check(u32) FOURCC_YV24 {
                    dst_v_3 =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_u_3 =
                        cast,no_check(*u8) ((dst_v_3 +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    r =
                        I420ToI444(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u_3,
                            dst_sample_stride,
                            dst_v_3,
                            dst_sample_stride,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                } else {
                    dst_u_3 =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_v_3 =
                        cast,no_check(*u8) ((dst_u_3 +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    r =
                        I420ToI444(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u_3,
                            dst_sample_stride,
                            dst_v_3,
                            dst_sample_stride,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 46; {
                dst_sample_stride = ifx dst_sample_stride != 0 then dst_sample_stride else width;
                halfstride_2 = (dst_sample_stride + 1) / 2;
                if format == cast,no_check(u32) FOURCC_YV16 {
                    dst_v_2 =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_u_2 = cast,no_check(*u8) ((dst_v_2 + (cast,no_check(s64) halfstride_2) * cast(s64) height));
                    r =
                        I420ToI422(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u_2,
                            halfstride_2,
                            dst_v_2,
                            halfstride_2,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                } else {
                    dst_u_2 =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_v_2 = cast,no_check(*u8) ((dst_u_2 + (cast,no_check(s64) halfstride_2) * cast(s64) height));
                    r =
                        I420ToI422(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u_2,
                            halfstride_2,
                            dst_v_2,
                            halfstride_2,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 58; {
                dst_sample_stride = ifx dst_sample_stride != 0 then dst_sample_stride else width;
                halfstride = (dst_sample_stride + 1) / 2;
                halfheight_2 = (height + 1) / 2;
                if format == cast,no_check(u32) FOURCC_YV12 {
                    dst_v =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_u = cast,no_check(*u8) ((dst_v + (cast,no_check(s64) halfstride) * cast(s64) halfheight_2));
                    r =
                        i420_copy(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u,
                            halfstride,
                            dst_v,
                            halfstride,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                } else {
                    dst_u =
                        cast,no_check(*u8) ((dst_sample +
                            (cast,no_check(s64) dst_sample_stride) * cast(s64) height));
                    dst_v = cast,no_check(*u8) ((dst_u + (cast,no_check(s64) halfstride) * cast(s64) halfheight_2));
                    r =
                        i420_copy(
                            y,
                            y_stride,
                            u,
                            u_stride,
                            v,
                            v_stride,
                            dst_sample,
                            dst_sample_stride,
                            dst_u,
                            halfstride,
                            dst_v,
                            halfstride,
                            width,
                            height
                        );
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 63; {
                c_transpiler_deallocate_memory(temp_u_mem);
                temp_u = cast,no_check(*u8) (cast(*u8) null);
                c_transpiler_deallocate_memory(temp_v_mem);
                temp_v = cast,no_check(*u8) (cast(*u8) null);
                code_block_to_execute = 24;
                continue c_transpiler_dispatch;
            }
            case 131; {
                format = CanonicalFourCC(fourcc);
                r = 0;
                if y == null || u == null || v == null || dst_sample == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
                    return -1;
                } else {
                    c_transpiler_switch_value_127 := format;
                    if c_transpiler_switch_value_127 == {
                        case cast,no_check(u32) FOURCC_YUY2; {
                            r =
                                I420ToYUY2(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 2),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_UYVY; {
                            r =
                                I420ToUYVY(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 2),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_RGBP; {
                            r =
                                I420ToRGB565(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 2),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_RGBO; {
                            r =
                                I420ToARGB1555(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 2),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_R444; {
                            r =
                                I420ToARGB4444(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 2),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_24BG; {
                            r =
                                I420ToRGB24(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 3),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_RAW; {
                            r =
                                I420ToRAW(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 3),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_ARGB; {
                            r =
                                I420ToARGB(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 4),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_BGRA; {
                            r =
                                I420ToBGRA(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 4),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_ABGR; {
                            r =
                                I420ToABGR(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 4),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_RGBA; {
                            r =
                                I420ToRGBA(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 4),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_AR30; {
                            r =
                                I420ToAR30(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width * 4),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_I400; {
                            r =
                                I400Copy(
                                    y,
                                    y_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_NV12; {
                            dst_y_stride = (ifx dst_sample_stride != 0 then dst_sample_stride else width);
                            dst_uv = cast,no_check(*u8) ((dst_sample + (cast,no_check(s64) dst_y_stride) * cast(s64) height));
                            r =
                                I420ToNV12(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width),
                                    dst_uv,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_NV21; {
                            dst_y_stride_2 = (ifx dst_sample_stride != 0 then dst_sample_stride else width);
                            dst_vu = cast,no_check(*u8) ((dst_sample + (cast,no_check(s64) dst_y_stride_2) * cast(s64) height));
                            r =
                                I420ToNV21(
                                    y,
                                    y_stride,
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_sample,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width),
                                    dst_vu,
                                    (ifx dst_sample_stride != 0 then dst_sample_stride else width),
                                    width,
                                    height
                                );
                            code_block_to_execute = 24;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_NV16; {
                            dst_y_stride_3 = (ifx dst_sample_stride != 0 then dst_sample_stride else width);
                            dst_uv_stride = (ifx dst_sample_stride != 0 then dst_sample_stride else width);
                            dst_uv_2 = cast,no_check(*u8) ((dst_sample + (cast,no_check(s64) dst_y_stride_3) * cast(s64) height));
                            halfwidth = (width + 1) / 2;
                            halfheight = (height + 1) / 2;
                            CopyPlane(y, y_stride, dst_sample, dst_y_stride_3, width, height);
                            MergeUVPlane(u, u_stride, v, v_stride, dst_uv_2, dst_uv_stride * 2, halfwidth, halfheight);
                            if height > 1 {
                                MergeUVPlane(
                                    u,
                                    u_stride,
                                    v,
                                    v_stride,
                                    dst_uv_2 + dst_uv_stride,
                                    dst_uv_stride * 2,
                                    halfwidth,
                                    height / 2
                                );
                                r = 0;
                                code_block_to_execute = 24;
                                continue c_transpiler_dispatch;
                            } else {
                                r = 0;
                                code_block_to_execute = 24;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case cast,no_check(u32) FOURCC_NV24; {
                            dst_y_stride_4 = (ifx dst_sample_stride != 0 then dst_sample_stride else width);
                            dst_uv_stride_2 = (ifx dst_sample_stride != 0 then dst_sample_stride * 2 else width * 2);
                            dst_uv_3 = cast,no_check(*u8) ((dst_sample + (cast,no_check(s64) dst_y_stride_4) * cast(s64) height));
                            temp_u_mem_size = (cast,no_check(u64) width) * cast,no_check(u64) height;
                            temp_u_mem = cast,no_check(*void) ((ifx temp_u_mem_size > (cast(u64) 18446744073709551615) - 63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(temp_u_mem_size + 63))));
                            temp_u = cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) temp_u_mem) + 63) & cast,no_check(s64) (~(cast(s32) 63)))));
                            temp_v_mem_size = (cast,no_check(u64) width) * cast,no_check(u64) height;
                            temp_v_mem = cast,no_check(*void) ((ifx temp_v_mem_size > (cast(u64) 18446744073709551615) - 63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(temp_v_mem_size + 63))));
                            temp_v = cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) temp_v_mem) + 63) & cast,no_check(s64) (~(cast(s32) 63)))));
                            if temp_u == null || temp_v == null {
                                c_transpiler_deallocate_memory(temp_u_mem);
                                temp_u = cast,no_check(*u8) (cast(*u8) null);
                                c_transpiler_deallocate_memory(temp_v_mem);
                                temp_v = cast,no_check(*u8) (cast(*u8) null);
                                return 1;
                            } else {
                                r =
                                    I420ToI444(
                                        y,
                                        y_stride,
                                        u,
                                        u_stride,
                                        v,
                                        v_stride,
                                        dst_sample,
                                        dst_y_stride_4,
                                        temp_u,
                                        width,
                                        temp_v,
                                        width,
                                        width,
                                        height
                                    );
                                if r == 0 {
                                    MergeUVPlane(temp_u, width, temp_v, width, dst_uv_3, dst_uv_stride_2, width, height);
                                    code_block_to_execute = 63;
                                    continue c_transpiler_dispatch;
                                } else {
                                    code_block_to_execute = 63;
                                    continue c_transpiler_dispatch;
                                }
                            }
                        }
                        case cast,no_check(u32) FOURCC_I420; {
                            code_block_to_execute = 58;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_YV12; {
                            code_block_to_execute = 58;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_I422; {
                            code_block_to_execute = 46;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_YV16; {
                            code_block_to_execute = 46;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_I444; {
                            code_block_to_execute = 35;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) FOURCC_YV24; {
                            code_block_to_execute = 35;
                            continue c_transpiler_dispatch;
                        }
                        case; {
                            return -1;
                        }
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
    return unreachable_value(s32);
}

I422ToYUY2 :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_yuy2: *u8,
    dst_stride_yuy2: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_yuy2_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToYUY2Row_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_yuy2 == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_yuy2 = cast,no_check(*u8) ((dst_yuy2 + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_yuy2));
        dst_stride_yuy2 = -dst_stride_yuy2;
    }

    if src_stride_y == width &&
        src_stride_u * 2 == width &&
        src_stride_v * 2 == width &&
        dst_stride_yuy2 == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_yuy2 = 0;
        src_stride_v = dst_stride_yuy2;
        src_stride_u = src_stride_v;
        src_stride_y = src_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_yuy2_row(src_y, src_u, src_v, dst_yuy2, width);
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_yuy2 += dst_stride_yuy2;
        }
    }
    return 0;
}

I422ToUYVY :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    dst_uyvy: *u8,
    dst_stride_uyvy: s32,
    width: s32,
    height: s32
) -> s32 {
    i422_to_uyvy_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: s32)) I422ToUYVYRow_C;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_uyvy == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        dst_uyvy = cast,no_check(*u8) ((dst_uyvy + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_uyvy));
        dst_stride_uyvy = -dst_stride_uyvy;
    }

    if src_stride_y == width &&
        src_stride_u * 2 == width &&
        src_stride_v * 2 == width &&
        dst_stride_uyvy == width * 2 &&
        ((cast,no_check(s64) width) * cast(s64) height) <= 2147483647 {
        width *= height;
        height = 1;
        dst_stride_uyvy = 0;
        src_stride_v = dst_stride_uyvy;
        src_stride_u = src_stride_v;
        src_stride_y = src_stride_u;
    }

    if 0 < height {
        for y: 0..height - 1 {
            i422_to_uyvy_row(src_y, src_u, src_v, dst_uyvy, width);
            src_y += src_stride_y;
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_uyvy += dst_stride_uyvy;
        }
    }
    return 0;
}

I422ToI444 :: (
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

    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        ScalePlane(
            src_u,
            src_stride_u,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_u,
            dst_stride_u,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_v,
            src_stride_v,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_v,
            dst_stride_v,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    return r;
}

I010ToI410 :: (
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

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        ScalePlane_12(
            src_u,
            src_stride_u,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            (ifx height < 0 then -((-height + 1) >> 1) else (height + 1) >> 1),
            dst_u,
            dst_stride_u,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_v,
            src_stride_v,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            (ifx height < 0 then -((-height + 1) >> 1) else (height + 1) >> 1),
            dst_v,
            dst_stride_v,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    return r;
}

I210ToI410 :: (
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

    if dst_y != null {
        CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }
    r :=
        ScalePlane_12(
            src_u,
            src_stride_u,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_u,
            dst_stride_u,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_v,
            src_stride_v,
            (ifx width < 0 then -((-width + 1) >> 1) else (width + 1) >> 1),
            height,
            dst_v,
            dst_stride_v,
            width,
            abs_in_convert_from(height),
            K_FILTER_BILINEAR
        );
    return r;
}

test_cpu_flag_in_convert_from :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert_from :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert_from: u32;
initialize_globals_for_convert_from :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert_from);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert_from, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert_from) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_convert_from = 0x1;
    K_CPU_HAS_ARM_in_convert_from = 0x2;
    K_CPU_HAS_NEON_in_convert_from = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_convert_from = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_convert_from = 0x400;
    K_CPU_HAS_SVE_in_convert_from = 0x800;
    K_CPU_HAS_SVE2_in_convert_from = 0x1000;
    K_CPU_HAS_SME_in_convert_from = 0x2000;
    K_CPU_HAS_SME2_in_convert_from = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_convert_from = 0x8000;
    K_CPU_HAS_RISCV_in_convert_from = 0x4;
    K_CPU_HAS_RVV_in_convert_from = 0x100;
    K_CPU_HAS_RVVZVFH_in_convert_from = 0x200;
    K_CPU_HAS_X86_in_convert_from = 0x8;
    K_CPU_HAS_SSE2_in_convert_from = 0x100;
    K_CPU_HAS_SSSE3_in_convert_from = 0x200;
    K_CPU_HAS_SSE41_in_convert_from = 0x400;
    K_CPU_HAS_SSE42_in_convert_from = 0x800;
    K_CPU_HAS_AVX_in_convert_from = 0x1000;
    K_CPU_HAS_AVX2_in_convert_from = 0x2000;
    K_CPU_HAS_ERMS_in_convert_from = 0x4000;
    K_CPU_HAS_FSMR_in_convert_from = 0x8000;
    K_CPU_HAS_FMA3_in_convert_from = 0x10000;
    K_CPU_HAS_F16_C_in_convert_from = 0x20000;
    K_CPU_HAS_AVX512_BW_in_convert_from = 0x40000;
    K_CPU_HAS_AVX512_VL_in_convert_from = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_convert_from = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_convert_from = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_convert_from = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_convert_from = 0x800000;
    K_CPU_HAS_AVX10_in_convert_from = 0x1000000;
    K_CPU_HAS_AVX10_2_in_convert_from = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_convert_from = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_convert_from = 0x8000000;
    K_CPU_HAS_AMXINT8_in_convert_from = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_convert_from = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_convert_from = 0x20;
    K_CPU_HAS_LSX_in_convert_from = 0x100;
    K_CPU_HAS_LASX_in_convert_from = 0x200;
    atomic_store(*globals_initialization_state_for_convert_from, 2);
}

