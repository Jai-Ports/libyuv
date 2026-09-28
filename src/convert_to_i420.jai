K_CPU_INITIALIZED_in_convert_to_i420: s32;

K_CPU_HAS_ARM_in_convert_to_i420: s32;

K_CPU_HAS_NEON_in_convert_to_i420: s32;

K_CPU_HAS_NEON_DOT_PROD_in_convert_to_i420: s32;

K_CPU_HAS_NEON_I8_MM_in_convert_to_i420: s32;

K_CPU_HAS_SVE_in_convert_to_i420: s32;

K_CPU_HAS_SVE2_in_convert_to_i420: s32;

K_CPU_HAS_SME_in_convert_to_i420: s32;

K_CPU_HAS_SME2_in_convert_to_i420: s32;

K_CPU_HAS_SVEF32_MM_in_convert_to_i420: s32;

K_CPU_HAS_RISCV_in_convert_to_i420: s32;

K_CPU_HAS_RVV_in_convert_to_i420: s32;

K_CPU_HAS_RVVZVFH_in_convert_to_i420: s32;

K_CPU_HAS_X86_in_convert_to_i420: s32;

K_CPU_HAS_SSE2_in_convert_to_i420: s32;

K_CPU_HAS_SSSE3_in_convert_to_i420: s32;

K_CPU_HAS_SSE41_in_convert_to_i420: s32;

K_CPU_HAS_SSE42_in_convert_to_i420: s32;

K_CPU_HAS_AVX_in_convert_to_i420: s32;

K_CPU_HAS_AVX2_in_convert_to_i420: s32;

K_CPU_HAS_ERMS_in_convert_to_i420: s32;

K_CPU_HAS_FSMR_in_convert_to_i420: s32;

K_CPU_HAS_FMA3_in_convert_to_i420: s32;

K_CPU_HAS_F16_C_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_BW_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_VL_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_VNNI_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_VBMI_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_VBMI2_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_VBITALG_in_convert_to_i420: s32;

K_CPU_HAS_AVX10_in_convert_to_i420: s32;

K_CPU_HAS_AVX10_2_in_convert_to_i420: s32;

K_CPU_HAS_AVXVNNI_in_convert_to_i420: s32;

K_CPU_HAS_AVXVNNIINT8_in_convert_to_i420: s32;

K_CPU_HAS_AMXINT8_in_convert_to_i420: s32;

K_CPU_HAS_AVX512_BMM_in_convert_to_i420: s32;

K_CPU_HAS_LOONGARCH_in_convert_to_i420: s32;

K_CPU_HAS_LSX_in_convert_to_i420: s32;

K_CPU_HAS_LASX_in_convert_to_i420: s32;

ConvertToI420 :: (
    sample: *u8,
    sample_size: u64,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    crop_x: s32,
    crop_y: s32,
    src_width: s32,
    src_height: s32,
    crop_width: s32,
    crop_height: s32,
    rotation: Rotation_Mode,
    fourcc: u32
) -> s32 {
    ABS_SRC_HEIGHT: s32 = ---;
    ABS_CROP_HEIGHT: s32 = ---;
    format: u32 = ---;
    src: *u8 = ---;
    src_uv: *u8 = ---;
    r: s32 = ---;
    need_buf: s32 = ---;
    tmp_y: *u8 = ---;
    tmp_u: *u8 = ---;
    tmp_v: *u8 = ---;
    tmp_y_stride: s32 = ---;
    tmp_u_stride: s32 = ---;
    tmp_v_stride: s32 = ---;
    rotate_buffer: *u8 = ---;
    INV_CROP_HEIGHT: s32 = ---;
    aligned_src_width: s32 = ---;
    y_size: u64 = ---;
    uv_size: u64 = ---;
    ROTATE_BUFFER_SIZE: u64 = ---;
    u: *u8 = ---;
    v: *u8 = ---;
    stride_u: s32 = ---;
    stride_v: s32 = ---;
    u_2: *u8 = ---;
    v_2: *u8 = ---;
    stride_u_2: s32 = ---;
    stride_v_2: s32 = ---;
    src_y: *u8 = ---;
    src_u: *u8 = ---;
    src_v: *u8 = ---;
    halfwidth: s32 = ---;
    halfheight: s32 = ---;
    src_y_2: *u8 = ---;
    src_u_2: *u8 = ---;
    src_v_2: *u8 = ---;
    halfwidth_2: s32 = ---;
    src_y_3: *u8 = ---;
    src_u_3: *u8 = ---;
    src_v_3: *u8 = ---;
    code_block_to_execute: s64 = 156;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 27; {
                if need_buf != 0 {
                    if r == 0 {
                        r =
                            I420Rotate(
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                tmp_y,
                                tmp_y_stride,
                                tmp_u,
                                tmp_u_stride,
                                tmp_v,
                                tmp_v_stride,
                                crop_width,
                                ABS_CROP_HEIGHT,
                                rotation
                            );
                        c_transpiler_deallocate_memory(rotate_buffer);
                        return r;
                    } else {
                        c_transpiler_deallocate_memory(rotate_buffer);
                        return r;
                    }
                } else {
                    return r;
                }
            }
            case 28; {
                r = -1;
                code_block_to_execute = 27;
                continue c_transpiler_dispatch;
            }
            case 30; {
                r =
                    i444_to_i420(
                        src_y_3,
                        src_width,
                        src_u_3,
                        src_width,
                        src_v_3,
                        src_width,
                        dst_y,
                        dst_stride_y,
                        dst_u,
                        dst_stride_u,
                        dst_v,
                        dst_stride_v,
                        crop_width,
                        INV_CROP_HEIGHT
                    );
                code_block_to_execute = 27;
                continue c_transpiler_dispatch;
            }
            case 38; {
                src_y_3 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                if format == cast,no_check(u32) FOURCC_YV24 {
                    src_v_3 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) ABS_SRC_HEIGHT) + cast(s64) crop_y)) +
                            crop_x));
                    src_u_3 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) ABS_SRC_HEIGHT) * 2) + cast(s64) crop_y)) +
                            crop_x));
                    code_block_to_execute = 30;
                    continue c_transpiler_dispatch;
                } else {
                    src_u_3 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) ABS_SRC_HEIGHT) + cast(s64) crop_y)) +
                            crop_x));
                    src_v_3 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) ABS_SRC_HEIGHT) * 2) + cast(s64) crop_y)) +
                            crop_x));
                    code_block_to_execute = 30;
                    continue c_transpiler_dispatch;
                }
            }
            case 40; {
                r =
                    i422_to_i420(
                        src_y_2,
                        src_width,
                        src_u_2,
                        halfwidth_2,
                        src_v_2,
                        halfwidth_2,
                        dst_y,
                        dst_stride_y,
                        dst_u,
                        dst_stride_u,
                        dst_v,
                        dst_stride_v,
                        crop_width,
                        INV_CROP_HEIGHT
                    );
                code_block_to_execute = 27;
                continue c_transpiler_dispatch;
            }
            case 49; {
                src_y_2 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                halfwidth_2 = (src_width + 1) / 2;
                if format == cast,no_check(u32) FOURCC_YV16 {
                    src_v_2 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) halfwidth_2) * cast(s64) crop_y) +
                            crop_x / 2));
                    src_u_2 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast(s64) halfwidth_2) * ((cast,no_check(s64) ABS_SRC_HEIGHT) + cast(s64) crop_y)) +
                            crop_x / 2));
                    code_block_to_execute = 40;
                    continue c_transpiler_dispatch;
                } else {
                    src_u_2 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) halfwidth_2) * cast(s64) crop_y) +
                            crop_x / 2));
                    src_v_2 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast(s64) halfwidth_2) * ((cast,no_check(s64) ABS_SRC_HEIGHT) + cast(s64) crop_y)) +
                            crop_x / 2));
                    code_block_to_execute = 40;
                    continue c_transpiler_dispatch;
                }
            }
            case 51; {
                r =
                    I420Rotate(
                        src_y,
                        src_width,
                        src_u,
                        halfwidth,
                        src_v,
                        halfwidth,
                        dst_y,
                        dst_stride_y,
                        dst_u,
                        dst_stride_u,
                        dst_v,
                        dst_stride_v,
                        crop_width,
                        INV_CROP_HEIGHT,
                        rotation
                    );
                code_block_to_execute = 27;
                continue c_transpiler_dispatch;
            }
            case 61; {
                src_y = cast,no_check(*u8) ((sample + (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                halfwidth = (src_width + 1) / 2;
                halfheight = (ABS_SRC_HEIGHT + 1) / 2;
                if format == cast,no_check(u32) FOURCC_YV12 {
                    src_v =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) halfwidth) * cast(s64) (crop_y / 2)) +
                            crop_x / 2));
                    src_u =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast(s64) halfwidth) * ((cast,no_check(s64) halfheight) + cast(s64) (crop_y / 2))) +
                            crop_x / 2));
                    code_block_to_execute = 51;
                    continue c_transpiler_dispatch;
                } else {
                    src_u =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) halfwidth) * cast(s64) (crop_y / 2)) +
                            crop_x / 2));
                    src_v =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast(s64) halfwidth) * ((cast,no_check(s64) halfheight) + cast(s64) (crop_y / 2))) +
                            crop_x / 2));
                    code_block_to_execute = 51;
                    continue c_transpiler_dispatch;
                }
            }
            case 122; {
                c_transpiler_switch_value_122 := format;
                if c_transpiler_switch_value_122 == {
                    case cast,no_check(u32) FOURCC_YUY2; {
                        u = cast,no_check(*u8) ((ifx crop_x & 1 != 0 then cast,no_check(*u8) (dst_v) else cast,no_check(*u8) (dst_u)));
                        v = cast,no_check(*u8) ((ifx crop_x & 1 != 0 then cast,no_check(*u8) (dst_u) else cast,no_check(*u8) (dst_v)));
                        stride_u = (ifx crop_x & 1 != 0 then dst_stride_v else dst_stride_u);
                        stride_v = (ifx crop_x & 1 != 0 then dst_stride_u else dst_stride_v);
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) aligned_src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            yuy2_to_i420(
                                src,
                                aligned_src_width * 2,
                                dst_y,
                                dst_stride_y,
                                u,
                                stride_u,
                                v,
                                stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_UYVY; {
                        u_2 = cast,no_check(*u8) ((ifx crop_x & 1 != 0 then cast,no_check(*u8) (dst_v) else cast,no_check(*u8) (dst_u)));
                        v_2 = cast,no_check(*u8) ((ifx crop_x & 1 != 0 then cast,no_check(*u8) (dst_u) else cast,no_check(*u8) (dst_v)));
                        stride_u_2 = (ifx crop_x & 1 != 0 then dst_stride_v else dst_stride_u);
                        stride_v_2 = (ifx crop_x & 1 != 0 then dst_stride_u else dst_stride_v);
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) aligned_src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            uyvy_to_i420(
                                src,
                                aligned_src_width * 2,
                                dst_y,
                                dst_stride_y,
                                u_2,
                                stride_u_2,
                                v_2,
                                stride_v_2,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBP; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            rgb565_to_i420(
                                src,
                                src_width * 2,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBO; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            argb1555_to_i420(
                                src,
                                src_width * 2,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_R444; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            argb4444_to_i420(
                                src,
                                src_width * 2,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_24BG; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 3));
                        r =
                            rgb24_to_i420(
                                src,
                                src_width * 3,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RAW; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 3));
                        r =
                            raw_to_i420(
                                src,
                                src_width * 3,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_ARGB; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r =
                            argb_to_i420(
                                src,
                                src_width * 4,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_BGRA; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r =
                            bgra_to_i420(
                                src,
                                src_width * 4,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_ABGR; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r =
                            abgr_to_i420(
                                src,
                                src_width * 4,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBA; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r =
                            rgba_to_i420(
                                src,
                                src_width * 4,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I400; {
                        src =
                            cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) +
                                crop_x));
                        r =
                            i400_to_i420(
                                src,
                                src_width,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV12; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) (crop_y / 2)) * cast(s64) aligned_src_width) +
                                crop_x / 2 * 2));
                        r =
                            NV12ToI420Rotate(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT,
                                rotation
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV21; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) (crop_y / 2)) * cast(s64) aligned_src_width) +
                                crop_x / 2 * 2));
                        r =
                            NV12ToI420Rotate(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_y,
                                dst_stride_y,
                                dst_v,
                                dst_stride_v,
                                dst_u,
                                dst_stride_u,
                                crop_width,
                                INV_CROP_HEIGHT,
                                rotation
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV16; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) ((((sample + (cast,no_check(s64) aligned_src_width) * cast(s64) ABS_SRC_HEIGHT) + (cast,no_check(s64) crop_y) * cast(s64) aligned_src_width) +
                                crop_x / 2 * 2));
                        r =
                            nv16_to_i420(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV24; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) ((((sample + (cast,no_check(s64) aligned_src_width) * cast(s64) ABS_SRC_HEIGHT) + ((cast,no_check(s64) crop_y) * cast(s64) aligned_src_width) * 2) +
                                crop_x * 2));
                        r =
                            nv24_to_i420(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width * 2,
                                dst_y,
                                dst_stride_y,
                                dst_u,
                                dst_stride_u,
                                dst_v,
                                dst_stride_v,
                                crop_width,
                                INV_CROP_HEIGHT
                            );
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I420; {
                        code_block_to_execute = 61;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV12; {
                        code_block_to_execute = 61;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I422; {
                        code_block_to_execute = 49;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV16; {
                        code_block_to_execute = 49;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I444; {
                        code_block_to_execute = 38;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV24; {
                        code_block_to_execute = 38;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 28;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 156; {
                if src_height == -2147483647 - 1 || crop_height == -2147483647 - 1 {
                    return -1;
                } else {
                    ABS_SRC_HEIGHT = (ifx src_height < 0 then -src_height else src_height);
                    ABS_CROP_HEIGHT = (ifx crop_height < 0 then -crop_height else crop_height);
                    if dst_y == null || dst_u == null || dst_v == null || sample == null || src_width <= 0 || src_width > 2147483647 / 4 || crop_width <= 0 || src_height == 0 || crop_height == 0 || crop_x < 0 || crop_y < 0 || crop_width > src_width || crop_x > src_width - crop_width || ABS_CROP_HEIGHT > ABS_SRC_HEIGHT || crop_y > ABS_SRC_HEIGHT - ABS_CROP_HEIGHT {
                        return -1;
                    } else {
                        format = CanonicalFourCC(fourcc);
                        r = 0;
                        need_buf = cast(s32) (rotation != 0 && format != cast,no_check(u32) FOURCC_I420 && format != cast,no_check(u32) FOURCC_NV12 && format != cast,no_check(u32) FOURCC_NV21 && format != cast,no_check(u32) FOURCC_YV12 || dst_y == sample);
                        tmp_y = cast,no_check(*u8) (dst_y);
                        tmp_u = cast,no_check(*u8) (dst_u);
                        tmp_v = cast,no_check(*u8) (dst_v);
                        tmp_y_stride = dst_stride_y;
                        tmp_u_stride = dst_stride_u;
                        tmp_v_stride = dst_stride_v;
                        rotate_buffer = cast,no_check(*u8) (cast(*u8) null);
                        INV_CROP_HEIGHT = (ifx src_height < 0 then -ABS_CROP_HEIGHT else ABS_CROP_HEIGHT);
                        aligned_src_width = (src_width + 1) & ~(cast(s32) 1);
                        if need_buf != 0 {
                            y_size = (cast,no_check(u64) crop_width) * cast,no_check(u64) ABS_CROP_HEIGHT;
                            uv_size = (cast,no_check(u64) ((crop_width + 1) / 2)) * cast,no_check(u64) ((ABS_CROP_HEIGHT + 1) / 2);
                            if uv_size > (cast(u64) 18446744073709551615) / 2 || y_size > (cast(u64) 18446744073709551615) - uv_size * 2 {
                                return -1;
                            } else {
                                ROTATE_BUFFER_SIZE = y_size + uv_size * 2;
                                rotate_buffer =
                                    cast,no_check(*u8) (cast(*u8) c_transpiler_allocate_memory(ROTATE_BUFFER_SIZE));
                                if rotate_buffer == null {
                                    return 1;
                                } else {
                                    dst_y = cast,no_check(*u8) (rotate_buffer);
                                    dst_u = cast,no_check(*u8) ((dst_y + y_size));
                                    dst_v = cast,no_check(*u8) ((dst_u + uv_size));
                                    dst_stride_y = crop_width;
                                    dst_stride_v = ((crop_width + 1) / 2);
                                    dst_stride_u = dst_stride_v;
                                    code_block_to_execute = 122;
                                    continue c_transpiler_dispatch;
                                }
                            }
                        } else {
                            code_block_to_execute = 122;
                            continue c_transpiler_dispatch;
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

nv24_to_i420 :: (
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
    x: s32 = ---;
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
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    row_uv_mem_size := cast,no_check(u64) (width * 2);

    row_uv_mem: *void =
        cast,no_check(*void) ((ifx row_uv_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_uv_mem_size + 63))));

    row_uv :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_uv_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row_uv == null {
        return 1;
    }
    if 0 < halfheight {
        for y: 0..halfheight - 1 {
            if y * 2 + 1 < height {
                half_row_c(src_uv, cast,no_check(s64) src_stride_uv, row_uv, width * 2);
            } else {
                copy_memory(row_uv, src_uv, (cast,no_check(u64) width) * 2);
            }
            x = 0;
            while x < halfwidth - 1 {
                dst_u[x] = cast,no_check(u8) ((((cast(s32) row_uv[x * 4 + 0]) + cast(s32) row_uv[x * 4 + 2]) + 1) >> 1);
                dst_v[x] = cast,no_check(u8) ((((cast(s32) row_uv[x * 4 + 1]) + cast(s32) row_uv[x * 4 + 3]) + 1) >> 1);
                x += 1;
            }
            if width & 1 != 0 {
                dst_u[halfwidth - 1] = row_uv[(halfwidth - 1) * 4 + 0];
                dst_v[halfwidth - 1] = row_uv[(halfwidth - 1) * 4 + 1];
            } else {
                dst_u[halfwidth - 1] =
                    cast,no_check(u8) ((((cast(s32) row_uv[(halfwidth - 1) * 4 + 0]) + cast(s32) row_uv[(halfwidth - 1) * 4 + 2]) +
                        1) >> 1);
                dst_v[halfwidth - 1] =
                    cast,no_check(u8) ((((cast(s32) row_uv[(halfwidth - 1) * 4 + 1]) + cast(s32) row_uv[(halfwidth - 1) * 4 + 3]) +
                        1) >> 1);
            }
            src_uv += (cast,no_check(s64) src_stride_uv) * 2;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    c_transpiler_deallocate_memory(row_uv_mem);

    row_uv = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

half_row_c :: (src_uv: *u8, src_uv_stride: s64, dst_uv: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[x] =
                cast,no_check(u8) ((((cast(s32) src_uv[x]) + cast(s32) src_uv[src_uv_stride + cast(s64) x]) +
                    1) >> 1);
        }
    }
}

nv16_to_i420 :: (
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
    split_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) SplitUVRow_C;
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
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uv));
        src_stride_y = -src_stride_y;
        src_stride_uv = -src_stride_uv;
    }
    if dst_y != null {
        CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
    }

    row_uv_mem_size := cast,no_check(u64) (halfwidth * 2);

    row_uv_mem: *void =
        cast,no_check(*void) ((ifx row_uv_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_uv_mem_size + 63))));

    row_uv :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_uv_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row_uv == null {
        return 1;
    }
    if 0 < halfheight {
        for y: 0..halfheight - 1 {
            if y * 2 + 1 < height {
                half_row_c(src_uv, cast,no_check(s64) src_stride_uv, row_uv, halfwidth * 2);
            } else {
                copy_memory(row_uv, src_uv, (cast,no_check(u64) halfwidth) * 2);
            }
            split_uv_row(row_uv, dst_u, dst_v, halfwidth);
            src_uv += (cast,no_check(s64) src_stride_uv) * 2;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
        }
    }
    c_transpiler_deallocate_memory(row_uv_mem);

    row_uv = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

test_cpu_flag_in_convert_to_i420 :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert_to_i420 :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert_to_i420: u32;
initialize_globals_for_convert_to_i420 :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert_to_i420);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert_to_i420, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert_to_i420) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_convert_to_i420 = 0x1;
    K_CPU_HAS_ARM_in_convert_to_i420 = 0x2;
    K_CPU_HAS_NEON_in_convert_to_i420 = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_convert_to_i420 = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_convert_to_i420 = 0x400;
    K_CPU_HAS_SVE_in_convert_to_i420 = 0x800;
    K_CPU_HAS_SVE2_in_convert_to_i420 = 0x1000;
    K_CPU_HAS_SME_in_convert_to_i420 = 0x2000;
    K_CPU_HAS_SME2_in_convert_to_i420 = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_convert_to_i420 = 0x8000;
    K_CPU_HAS_RISCV_in_convert_to_i420 = 0x4;
    K_CPU_HAS_RVV_in_convert_to_i420 = 0x100;
    K_CPU_HAS_RVVZVFH_in_convert_to_i420 = 0x200;
    K_CPU_HAS_X86_in_convert_to_i420 = 0x8;
    K_CPU_HAS_SSE2_in_convert_to_i420 = 0x100;
    K_CPU_HAS_SSSE3_in_convert_to_i420 = 0x200;
    K_CPU_HAS_SSE41_in_convert_to_i420 = 0x400;
    K_CPU_HAS_SSE42_in_convert_to_i420 = 0x800;
    K_CPU_HAS_AVX_in_convert_to_i420 = 0x1000;
    K_CPU_HAS_AVX2_in_convert_to_i420 = 0x2000;
    K_CPU_HAS_ERMS_in_convert_to_i420 = 0x4000;
    K_CPU_HAS_FSMR_in_convert_to_i420 = 0x8000;
    K_CPU_HAS_FMA3_in_convert_to_i420 = 0x10000;
    K_CPU_HAS_F16_C_in_convert_to_i420 = 0x20000;
    K_CPU_HAS_AVX512_BW_in_convert_to_i420 = 0x40000;
    K_CPU_HAS_AVX512_VL_in_convert_to_i420 = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_convert_to_i420 = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_convert_to_i420 = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_convert_to_i420 = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_convert_to_i420 = 0x800000;
    K_CPU_HAS_AVX10_in_convert_to_i420 = 0x1000000;
    K_CPU_HAS_AVX10_2_in_convert_to_i420 = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_convert_to_i420 = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_convert_to_i420 = 0x8000000;
    K_CPU_HAS_AMXINT8_in_convert_to_i420 = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_convert_to_i420 = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_convert_to_i420 = 0x20;
    K_CPU_HAS_LSX_in_convert_to_i420 = 0x100;
    K_CPU_HAS_LASX_in_convert_to_i420 = 0x200;
    atomic_store(*globals_initialization_state_for_convert_to_i420, 2);
}

