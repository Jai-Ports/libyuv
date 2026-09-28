K_CPU_INITIALIZED_in_convert_to_argb: s32;

K_CPU_HAS_ARM_in_convert_to_argb: s32;

K_CPU_HAS_NEON_in_convert_to_argb: s32;

K_CPU_HAS_NEON_DOT_PROD_in_convert_to_argb: s32;

K_CPU_HAS_NEON_I8_MM_in_convert_to_argb: s32;

K_CPU_HAS_SVE_in_convert_to_argb: s32;

K_CPU_HAS_SVE2_in_convert_to_argb: s32;

K_CPU_HAS_SME_in_convert_to_argb: s32;

K_CPU_HAS_SME2_in_convert_to_argb: s32;

K_CPU_HAS_SVEF32_MM_in_convert_to_argb: s32;

K_CPU_HAS_RISCV_in_convert_to_argb: s32;

K_CPU_HAS_RVV_in_convert_to_argb: s32;

K_CPU_HAS_RVVZVFH_in_convert_to_argb: s32;

K_CPU_HAS_X86_in_convert_to_argb: s32;

K_CPU_HAS_SSE2_in_convert_to_argb: s32;

K_CPU_HAS_SSSE3_in_convert_to_argb: s32;

K_CPU_HAS_SSE41_in_convert_to_argb: s32;

K_CPU_HAS_SSE42_in_convert_to_argb: s32;

K_CPU_HAS_AVX_in_convert_to_argb: s32;

K_CPU_HAS_AVX2_in_convert_to_argb: s32;

K_CPU_HAS_ERMS_in_convert_to_argb: s32;

K_CPU_HAS_FSMR_in_convert_to_argb: s32;

K_CPU_HAS_FMA3_in_convert_to_argb: s32;

K_CPU_HAS_F16_C_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_BW_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_VL_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_VNNI_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_VBMI_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_VBMI2_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_VBITALG_in_convert_to_argb: s32;

K_CPU_HAS_AVX10_in_convert_to_argb: s32;

K_CPU_HAS_AVX10_2_in_convert_to_argb: s32;

K_CPU_HAS_AVXVNNI_in_convert_to_argb: s32;

K_CPU_HAS_AVXVNNIINT8_in_convert_to_argb: s32;

K_CPU_HAS_AMXINT8_in_convert_to_argb: s32;

K_CPU_HAS_AVX512_BMM_in_convert_to_argb: s32;

K_CPU_HAS_LOONGARCH_in_convert_to_argb: s32;

K_CPU_HAS_LSX_in_convert_to_argb: s32;

K_CPU_HAS_LASX_in_convert_to_argb: s32;

ConvertToARGB :: (
    sample: *u8,
    sample_size: u64,
    dst_argb: *u8,
    dst_stride_argb: s32,
    crop_x: s32,
    crop_y: s32,
    src_width: s32,
    src_height: s32,
    crop_width: s32,
    crop_height: s32,
    rotation: Rotation_Mode,
    fourcc: u32
) -> s32 {
    abs_src_height: s32 = ---;
    abs_crop_height: s32 = ---;
    format: u32 = ---;
    aligned_src_width: s32 = ---;
    src: *u8 = ---;
    src_uv: *u8 = ---;
    r: s32 = ---;
    need_buf: s32 = ---;
    dest_argb: *u8 = ---;
    dest_dst_stride_argb: s32 = ---;
    rotate_buffer: *u8 = ---;
    inv_crop_height: s32 = ---;
    ROTATE_BUFFER_SIZE: u64 = ---;
    src_y: *u8 = ---;
    src_u: *u8 = ---;
    src_v: *u8 = ---;
    halfwidth: s32 = ---;
    halfheight: s32 = ---;
    halfwidth_2: s32 = ---;
    halfheight_2: s32 = ---;
    src_y_2: *u8 = ---;
    src_u_2: *u8 = ---;
    src_v_2: *u8 = ---;
    halfwidth_3: s32 = ---;
    halfheight_3: s32 = ---;
    src_y_3: *u8 = ---;
    src_u_3: *u8 = ---;
    src_v_3: *u8 = ---;
    halfwidth_4: s32 = ---;
    halfheight_4: s32 = ---;
    src_y_4: *u8 = ---;
    src_u_4: *u8 = ---;
    src_v_4: *u8 = ---;
    halfwidth_5: s32 = ---;
    src_y_5: *u8 = ---;
    src_u_5: *u8 = ---;
    src_v_5: *u8 = ---;
    halfwidth_6: s32 = ---;
    src_y_6: *u8 = ---;
    src_u_6: *u8 = ---;
    src_v_6: *u8 = ---;
    halfwidth_7: s32 = ---;
    src_y_7: *u8 = ---;
    src_u_7: *u8 = ---;
    src_v_7: *u8 = ---;
    halfwidth_8: s32 = ---;
    src_y_8: *u8 = ---;
    src_u_8: *u8 = ---;
    src_v_8: *u8 = ---;
    src_y_9: *u8 = ---;
    src_u_9: *u8 = ---;
    src_v_9: *u8 = ---;
    src_y_10: *u8 = ---;
    src_u_10: *u8 = ---;
    src_v_10: *u8 = ---;
    src_y_11: *u8 = ---;
    src_u_11: *u8 = ---;
    src_v_11: *u8 = ---;
    src_y_12: *u8 = ---;
    src_u_12: *u8 = ---;
    src_v_12: *u8 = ---;
    code_block_to_execute: s64 = 218;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 42; {
                if need_buf != 0 {
                    if r == 0 {
                        r =
                            ARGBRotate(
                                dst_argb,
                                dst_stride_argb,
                                dest_argb,
                                dest_dst_stride_argb,
                                crop_width,
                                abs_crop_height,
                                rotation
                            );
                        c_transpiler_deallocate_memory(rotate_buffer);
                        return r;
                    } else {
                        c_transpiler_deallocate_memory(rotate_buffer);
                        return r;
                    }
                } else {
                    if rotation != 0 {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r =
                            ARGBRotate(
                                src,
                                src_width * 4,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height,
                                rotation
                            );
                        return r;
                    } else {
                        return r;
                    }
                }
            }
            case 43; {
                r = -1;
                code_block_to_execute = 42;
                continue c_transpiler_dispatch;
            }
            case 60; {
                r =
                    I444ToARGB(
                        src_y_9,
                        src_width,
                        src_u_9,
                        src_width,
                        src_v_9,
                        src_width,
                        dst_argb,
                        dst_stride_argb,
                        crop_width,
                        inv_crop_height
                    );
                code_block_to_execute = 42;
                continue c_transpiler_dispatch;
            }
            case 68; {
                src_y_9 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                if format == cast,no_check(u32) FOURCC_YV24 {
                    src_v_9 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) +
                            crop_x));
                    src_u_9 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) abs_src_height) * 2) + cast(s64) crop_y)) +
                            crop_x));
                    code_block_to_execute = 60;
                    continue c_transpiler_dispatch;
                } else {
                    src_u_9 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) +
                            crop_x));
                    src_v_9 =
                        cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) abs_src_height) * 2) + cast(s64) crop_y)) +
                            crop_x));
                    code_block_to_execute = 60;
                    continue c_transpiler_dispatch;
                }
            }
            case 88; {
                r =
                    I422ToARGB(
                        src_y_5,
                        src_width,
                        src_u_5,
                        halfwidth_5,
                        src_v_5,
                        halfwidth_5,
                        dst_argb,
                        dst_stride_argb,
                        crop_width,
                        inv_crop_height
                    );
                code_block_to_execute = 42;
                continue c_transpiler_dispatch;
            }
            case 97; {
                halfwidth_5 = (src_width + 1) / 2;
                src_y_5 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                if format == cast,no_check(u32) FOURCC_YV16 {
                    src_v_5 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast,no_check(s64) halfwidth_5) * cast(s64) crop_y) +
                            crop_x / 2));
                    src_u_5 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_5) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) +
                            crop_x / 2));
                    code_block_to_execute = 88;
                    continue c_transpiler_dispatch;
                } else {
                    src_u_5 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast,no_check(s64) halfwidth_5) * cast(s64) crop_y) +
                            crop_x / 2));
                    src_v_5 =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_5) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) +
                            crop_x / 2));
                    code_block_to_execute = 88;
                    continue c_transpiler_dispatch;
                }
            }
            case 120; {
                r =
                    I420ToARGB(
                        src_y,
                        src_width,
                        src_u,
                        halfwidth,
                        src_v,
                        halfwidth,
                        dst_argb,
                        dst_stride_argb,
                        crop_width,
                        inv_crop_height
                    );
                code_block_to_execute = 42;
                continue c_transpiler_dispatch;
            }
            case 130; {
                src_y = cast,no_check(*u8) ((sample + (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                halfwidth = (src_width + 1) / 2;
                halfheight = (abs_src_height + 1) / 2;
                if format == cast,no_check(u32) FOURCC_YV12 {
                    src_v =
                        cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) +
                            (((cast,no_check(s64) halfwidth) * cast(s64) crop_y) + cast(s64) crop_x) / 2));
                    src_u =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth) * ((cast,no_check(s64) halfheight) + cast(s64) (crop_y / 2))) +
                            crop_x / 2));
                    code_block_to_execute = 120;
                    continue c_transpiler_dispatch;
                } else {
                    src_u =
                        cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) +
                            (((cast,no_check(s64) halfwidth) * cast(s64) crop_y) + cast(s64) crop_x) / 2));
                    src_v =
                        cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth) * ((cast,no_check(s64) halfheight) + cast(s64) (crop_y / 2))) +
                            crop_x / 2));
                    code_block_to_execute = 120;
                    continue c_transpiler_dispatch;
                }
            }
            case 193; {
                c_transpiler_switch_value_193 := format;
                if c_transpiler_switch_value_193 == {
                    case cast,no_check(u32) FOURCC_YUY2; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) aligned_src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            YUY2ToARGB(
                                src,
                                aligned_src_width * 2,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_UYVY; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) aligned_src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r =
                            UYVYToARGB(
                                src,
                                aligned_src_width * 2,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_24BG; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 3));
                        r = RGB24ToARGB(src, src_width * 3, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RAW; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 3));
                        r = RAWToARGB(src, src_width * 3, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_ARGB; {
                        if need_buf == 0 && !(rotation != 0) {
                            src =
                                cast,no_check(*u8) ((sample +
                                    (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                            r = ARGBCopy(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                            code_block_to_execute = 42;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 42;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case cast,no_check(u32) FOURCC_BGRA; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r = BGRAToARGB(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_ABGR; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r = ABGRToARGB(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBA; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r = RGBAToARGB(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_AR30; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r = AR30ToARGB(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_AB30; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 4));
                        r = AR30ToABGR(src, src_width * 4, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBP; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r = RGB565ToARGB(src, src_width * 2, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_RGBO; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r = ARGB1555ToARGB(src, src_width * 2, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_R444; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x) * 2));
                        r = ARGB4444ToARGB(src, src_width * 2, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I400; {
                        src =
                            cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) +
                                crop_x));
                        r = I400ToARGB(src, src_width, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_J400; {
                        src =
                            cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) +
                                crop_x));
                        r = J400ToARGB(src, src_width, dst_argb, dst_stride_argb, crop_width, inv_crop_height);
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV12; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) (((sample + (cast(s64) aligned_src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) (crop_y / 2))) +
                                crop_x));
                        r =
                            NV12ToARGB(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV21; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) (((sample + (cast(s64) aligned_src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) (crop_y / 2))) +
                                crop_x));
                        r =
                            NV21ToARGB(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV16; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) (((sample + (cast(s64) aligned_src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) +
                                crop_x & ~(cast(s32) 1)));
                        r =
                            nv16_to_argb(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_NV24; {
                        src =
                            cast,no_check(*u8) ((sample +
                                (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_uv =
                            cast,no_check(*u8) ((((sample + (cast,no_check(s64) aligned_src_width) * cast(s64) abs_src_height) + ((cast,no_check(s64) aligned_src_width) * 2) * cast(s64) crop_y) +
                                (cast,no_check(s64) crop_x) * 2));
                        r =
                            nv24_to_argb(
                                src,
                                src_width,
                                src_uv,
                                aligned_src_width * 2,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I420; {
                        code_block_to_execute = 130;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV12; {
                        code_block_to_execute = 130;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_J420; {
                        halfwidth_2 = (src_width + 1) / 2;
                        halfheight_2 = (abs_src_height + 1) / 2;
                        src_y_2 = cast,no_check(*u8) ((sample + (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_u_2 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (((cast,no_check(s64) halfwidth_2) * cast(s64) crop_y) + cast(s64) crop_x) / 2));
                        src_v_2 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_2) * ((cast,no_check(s64) halfheight_2) + cast(s64) (crop_y / 2))) + crop_x / 2));
                        r =
                            J420ToARGB(
                                src_y_2,
                                src_width,
                                src_u_2,
                                halfwidth_2,
                                src_v_2,
                                halfwidth_2,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_H420; {
                        halfwidth_3 = (src_width + 1) / 2;
                        halfheight_3 = (abs_src_height + 1) / 2;
                        src_y_3 = cast,no_check(*u8) ((sample + (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_u_3 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (((cast,no_check(s64) halfwidth_3) * cast(s64) crop_y) + cast(s64) crop_x) / 2));
                        src_v_3 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_3) * ((cast,no_check(s64) halfheight_3) + cast(s64) (crop_y / 2))) + crop_x / 2));
                        r =
                            H420ToARGB(
                                src_y_3,
                                src_width,
                                src_u_3,
                                halfwidth_3,
                                src_v_3,
                                halfwidth_3,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_U420; {
                        halfwidth_4 = (src_width + 1) / 2;
                        halfheight_4 = (abs_src_height + 1) / 2;
                        src_y_4 = cast,no_check(*u8) ((sample + (((cast,no_check(s64) src_width) * cast(s64) crop_y) + cast(s64) crop_x)));
                        src_u_4 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (((cast,no_check(s64) halfwidth_4) * cast(s64) crop_y) + cast(s64) crop_x) / 2));
                        src_v_4 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_4) * ((cast,no_check(s64) halfheight_4) + cast(s64) (crop_y / 2))) + crop_x / 2));
                        r =
                            U420ToARGB(
                                src_y_4,
                                src_width,
                                src_u_4,
                                halfwidth_4,
                                src_v_4,
                                halfwidth_4,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I422; {
                        code_block_to_execute = 97;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV16; {
                        code_block_to_execute = 97;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_J422; {
                        halfwidth_6 = (src_width + 1) / 2;
                        src_y_6 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_6 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast,no_check(s64) halfwidth_6) * cast(s64) crop_y) + crop_x / 2));
                        src_v_6 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_6) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x / 2));
                        r =
                            J422ToARGB(
                                src_y_6,
                                src_width,
                                src_u_6,
                                halfwidth_6,
                                src_v_6,
                                halfwidth_6,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_H422; {
                        halfwidth_7 = (src_width + 1) / 2;
                        src_y_7 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_7 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast,no_check(s64) halfwidth_7) * cast(s64) crop_y) + crop_x / 2));
                        src_v_7 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_7) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x / 2));
                        r =
                            H422ToARGB(
                                src_y_7,
                                src_width,
                                src_u_7,
                                halfwidth_7,
                                src_v_7,
                                halfwidth_7,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_U422; {
                        halfwidth_8 = (src_width + 1) / 2;
                        src_y_8 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_8 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast,no_check(s64) halfwidth_8) * cast(s64) crop_y) + crop_x / 2));
                        src_v_8 = cast,no_check(*u8) ((((sample + (cast,no_check(s64) src_width) * cast(s64) abs_src_height) + (cast(s64) halfwidth_8) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x / 2));
                        r =
                            H422ToARGB(
                                src_y_8,
                                src_width,
                                src_u_8,
                                halfwidth_8,
                                src_v_8,
                                halfwidth_8,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_I444; {
                        code_block_to_execute = 68;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_YV24; {
                        code_block_to_execute = 68;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_J444; {
                        src_y_10 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_10 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x));
                        src_v_10 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) abs_src_height) * 2) + cast(s64) crop_y)) + crop_x));
                        r =
                            J444ToARGB(
                                src_y_10,
                                src_width,
                                src_u_10,
                                src_width,
                                src_v_10,
                                src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_H444; {
                        src_y_11 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_11 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x));
                        src_v_11 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) abs_src_height) * 2) + cast(s64) crop_y)) + crop_x));
                        r =
                            H444ToARGB(
                                src_y_11,
                                src_width,
                                src_u_11,
                                src_width,
                                src_v_11,
                                src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) FOURCC_U444; {
                        src_y_12 = cast,no_check(*u8) (((sample + (cast,no_check(s64) src_width) * cast(s64) crop_y) + crop_x));
                        src_u_12 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * ((cast,no_check(s64) abs_src_height) + cast(s64) crop_y)) + crop_x));
                        src_v_12 = cast,no_check(*u8) (((sample + (cast(s64) src_width) * (((cast,no_check(s64) abs_src_height) * 2) + cast(s64) crop_y)) + crop_x));
                        r =
                            U444ToARGB(
                                src_y_12,
                                src_width,
                                src_u_12,
                                src_width,
                                src_v_12,
                                src_width,
                                dst_argb,
                                dst_stride_argb,
                                crop_width,
                                inv_crop_height
                            );
                        code_block_to_execute = 42;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 43;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 200; {
                if need_buf != 0 {
                    ROTATE_BUFFER_SIZE = ((cast,no_check(u64) crop_width) * 4) * cast,no_check(u64) abs_crop_height;
                    rotate_buffer = cast,no_check(*u8) (cast(*u8) c_transpiler_allocate_memory(ROTATE_BUFFER_SIZE));
                    if rotate_buffer == null {
                        return 1;
                    } else {
                        dst_argb = cast,no_check(*u8) (rotate_buffer);
                        dst_stride_argb = crop_width * 4;
                        code_block_to_execute = 193;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 193;
                    continue c_transpiler_dispatch;
                }
            }
            case 218; {
                if src_height == -2147483647 - 1 || crop_height == -2147483647 - 1 {
                    return -1;
                } else {
                    abs_src_height = (ifx src_height < 0 then -src_height else src_height);
                    abs_crop_height = (ifx crop_height < 0 then -crop_height else crop_height);
                    if dst_argb == null || sample == null || src_width <= 0 || src_width > 2147483647 / 4 || crop_width <= 0 || crop_width > 2147483647 / 4 || src_height == 0 || crop_height == 0 || crop_x < 0 || crop_y < 0 || crop_width > src_width || crop_x > src_width - crop_width || abs_crop_height > abs_src_height || crop_y > abs_src_height - abs_crop_height {
                        return -1;
                    } else {
                        format = CanonicalFourCC(fourcc);
                        aligned_src_width = (src_width + 1) & ~(cast(s32) 1);
                        r = 0;
                        need_buf = cast(s32) (rotation != 0 && format != cast,no_check(u32) FOURCC_ARGB || dst_argb == sample);
                        dest_argb = cast,no_check(*u8) (dst_argb);
                        dest_dst_stride_argb = dst_stride_argb;
                        rotate_buffer = cast,no_check(*u8) (cast(*u8) null);
                        inv_crop_height = (ifx crop_height < 0 then -crop_height else crop_height);
                        if src_height < 0 {
                            inv_crop_height = -inv_crop_height;
                            code_block_to_execute = 200;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 200;
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

nv24_to_argb :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    i444_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) I444ToARGBRow_C;
    split_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) SplitUVRow_C;
    if src_y == null || src_uv == null || dst_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }
    if height < 0 {
        height = -height;
        dst_argb = cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) (height - 1)) * cast(s64) dst_stride_argb));
        dst_stride_argb = -dst_stride_argb;
    }

    row_u_mem_size := cast,no_check(u64) width;

    row_u_mem: *void =
        cast,no_check(*void) ((ifx row_u_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_u_mem_size + 63))));

    row_u :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_u_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    row_v_mem_size := cast,no_check(u64) width;

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
    if 0 < height {
        for y: 0..height - 1 {
            split_uv_row(src_uv, row_u, row_v, width);
            i444_to_argb_row(src_y, row_u, row_v, dst_argb, *K_YUV_I601_CONSTANTS, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }
    c_transpiler_deallocate_memory(row_u_mem);

    row_u = cast,no_check(*u8) (cast(*u8) null);
    c_transpiler_deallocate_memory(row_v_mem);

    row_v = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

nv16_to_argb :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    nv12_to_argb_row: #type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: *Yuv_Constants, _: s32)) NV12ToARGBRow_C;
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
            nv12_to_argb_row(src_y, src_uv, dst_argb, *K_YUV_I601_CONSTANTS, width);
            dst_argb += dst_stride_argb;
            src_y += src_stride_y;
            src_uv += src_stride_uv;
        }
    }
    return 0;
}

test_cpu_flag_in_convert_to_argb :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_convert_to_argb :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_convert_to_argb: u32;
initialize_globals_for_convert_to_argb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_convert_to_argb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_convert_to_argb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_convert_to_argb) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_convert_to_argb = 0x1;
    K_CPU_HAS_ARM_in_convert_to_argb = 0x2;
    K_CPU_HAS_NEON_in_convert_to_argb = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_convert_to_argb = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_convert_to_argb = 0x400;
    K_CPU_HAS_SVE_in_convert_to_argb = 0x800;
    K_CPU_HAS_SVE2_in_convert_to_argb = 0x1000;
    K_CPU_HAS_SME_in_convert_to_argb = 0x2000;
    K_CPU_HAS_SME2_in_convert_to_argb = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_convert_to_argb = 0x8000;
    K_CPU_HAS_RISCV_in_convert_to_argb = 0x4;
    K_CPU_HAS_RVV_in_convert_to_argb = 0x100;
    K_CPU_HAS_RVVZVFH_in_convert_to_argb = 0x200;
    K_CPU_HAS_X86_in_convert_to_argb = 0x8;
    K_CPU_HAS_SSE2_in_convert_to_argb = 0x100;
    K_CPU_HAS_SSSE3_in_convert_to_argb = 0x200;
    K_CPU_HAS_SSE41_in_convert_to_argb = 0x400;
    K_CPU_HAS_SSE42_in_convert_to_argb = 0x800;
    K_CPU_HAS_AVX_in_convert_to_argb = 0x1000;
    K_CPU_HAS_AVX2_in_convert_to_argb = 0x2000;
    K_CPU_HAS_ERMS_in_convert_to_argb = 0x4000;
    K_CPU_HAS_FSMR_in_convert_to_argb = 0x8000;
    K_CPU_HAS_FMA3_in_convert_to_argb = 0x10000;
    K_CPU_HAS_F16_C_in_convert_to_argb = 0x20000;
    K_CPU_HAS_AVX512_BW_in_convert_to_argb = 0x40000;
    K_CPU_HAS_AVX512_VL_in_convert_to_argb = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_convert_to_argb = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_convert_to_argb = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_convert_to_argb = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_convert_to_argb = 0x800000;
    K_CPU_HAS_AVX10_in_convert_to_argb = 0x1000000;
    K_CPU_HAS_AVX10_2_in_convert_to_argb = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_convert_to_argb = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_convert_to_argb = 0x8000000;
    K_CPU_HAS_AMXINT8_in_convert_to_argb = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_convert_to_argb = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_convert_to_argb = 0x20;
    K_CPU_HAS_LSX_in_convert_to_argb = 0x100;
    K_CPU_HAS_LASX_in_convert_to_argb = 0x200;
    atomic_store(*globals_initialization_state_for_convert_to_argb, 2);
}

