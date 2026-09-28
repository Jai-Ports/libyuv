// Generated directly from C++ by cpp_transpiler.
K_CPU_INITIALIZED_in_scale_argb: s32;

K_CPU_HAS_ARM_in_scale_argb: s32;

K_CPU_HAS_NEON_in_scale_argb: s32;

K_CPU_HAS_NEON_DOT_PROD_in_scale_argb: s32;

K_CPU_HAS_NEON_I8_MM_in_scale_argb: s32;

K_CPU_HAS_SVE_in_scale_argb: s32;

K_CPU_HAS_SVE2_in_scale_argb: s32;

K_CPU_HAS_SME_in_scale_argb: s32;

K_CPU_HAS_SME2_in_scale_argb: s32;

K_CPU_HAS_SVEF32_MM_in_scale_argb: s32;

K_CPU_HAS_RISCV_in_scale_argb: s32;

K_CPU_HAS_RVV_in_scale_argb: s32;

K_CPU_HAS_RVVZVFH_in_scale_argb: s32;

K_CPU_HAS_X86_in_scale_argb: s32;

K_CPU_HAS_SSE2_in_scale_argb: s32;

K_CPU_HAS_SSSE3_in_scale_argb: s32;

K_CPU_HAS_SSE41_in_scale_argb: s32;

K_CPU_HAS_SSE42_in_scale_argb: s32;

K_CPU_HAS_AVX_in_scale_argb: s32;

K_CPU_HAS_AVX2_in_scale_argb: s32;

K_CPU_HAS_ERMS_in_scale_argb: s32;

K_CPU_HAS_FSMR_in_scale_argb: s32;

K_CPU_HAS_FMA3_in_scale_argb: s32;

K_CPU_HAS_F16_C_in_scale_argb: s32;

K_CPU_HAS_AVX512_BW_in_scale_argb: s32;

K_CPU_HAS_AVX512_VL_in_scale_argb: s32;

K_CPU_HAS_AVX512_VNNI_in_scale_argb: s32;

K_CPU_HAS_AVX512_VBMI_in_scale_argb: s32;

K_CPU_HAS_AVX512_VBMI2_in_scale_argb: s32;

K_CPU_HAS_AVX512_VBITALG_in_scale_argb: s32;

K_CPU_HAS_AVX10_in_scale_argb: s32;

K_CPU_HAS_AVX10_2_in_scale_argb: s32;

K_CPU_HAS_AVXVNNI_in_scale_argb: s32;

K_CPU_HAS_AVXVNNIINT8_in_scale_argb: s32;

K_CPU_HAS_AMXINT8_in_scale_argb: s32;

K_CPU_HAS_AVX512_BMM_in_scale_argb: s32;

K_CPU_HAS_LOONGARCH_in_scale_argb: s32;

K_CPU_HAS_LSX_in_scale_argb: s32;

K_CPU_HAS_LASX_in_scale_argb: s32;

test_cpu_flag_in_scale_argb :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_scale_argb :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

argb_scale :: (
    src_argb: *u8,
    src_stride_argb: s32,
    src_width: s32,
    src_height: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_argb == null ||
        src_width == 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        src_width > 32768 ||
        src_height > 32768 ||
        dst_argb == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    return scale_argb(
        src_argb,
        src_stride_argb,
        src_width,
        src_height,
        dst_argb,
        dst_stride_argb,
        dst_width,
        dst_height,
        0,
        0,
        dst_width,
        dst_height,
        filtering
    );
}

scale_argb :: (
    src: *u8,
    src_stride: s32,
    src_width: s32,
    src_height: s32,
    dst: *u8,
    dst_stride: s32,
    dst_width: s32,
    dst_height: s32,
    clip_x: s32,
    clip_y: s32,
    clip_width: s32,
    clip_height: s32,
    filtering: Filter_Mode
) -> s32 {
    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;

    filtering = ScaleFilterReduce(src_width, src_height, dst_width, dst_height, filtering);

    if src_height < 0 {
        src_height = -src_height;
        src = cast,no_check(*u8) ((src + (cast(s64) (src_height - 1)) * cast,no_check(s64) src_stride));
        src_stride = -src_stride;
    }
    ScaleSlope(src_width, src_height, dst_width, dst_height, filtering, *x, *y, *dx, *dy);
    src_width = abs_in_scale_argb(src_width);
    if clip_x != 0 {
        clipf := (cast,no_check(s64) clip_x) * cast(s64) dx;
        x = cast,no_check(s32) ((cast,no_check(s64) x) + (clipf & 0xffff));
        src += clipf >> 16 * 4;
        dst += clip_x * 4;
    }
    if clip_y != 0 {
        clipf := (cast,no_check(s64) clip_y) * cast(s64) dy;
        y = cast,no_check(s32) ((cast,no_check(s64) y) + (clipf & 0xffff));
        src += clipf >> 16 * cast,no_check(s64) src_stride;
        dst += (cast(s64) clip_y) * cast,no_check(s64) dst_stride;
    }

    if dx | dy & 0xffff == 0 {
        if dx == 0 || dy == 0 {
            filtering = K_FILTER_NONE;
        } else {
            if dx & 0x10000 == 0 && dy & 0x10000 == 0 {
                if dx == 0x20000 && dy == 0x20000 {
                    scale_argb_down2(
                        src_width,
                        src_height,
                        clip_width,
                        clip_height,
                        cast,no_check(s64) src_stride,
                        cast,no_check(s64) dst_stride,
                        src,
                        dst,
                        x,
                        dx,
                        y,
                        dy,
                        filtering
                    );
                    return 0;
                }
                if dx == 0x40000 && dy == 0x40000 && cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX {
                    return scale_argb_down4_box(
                        src_width,
                        src_height,
                        clip_width,
                        clip_height,
                        cast,no_check(s64) src_stride,
                        cast,no_check(s64) dst_stride,
                        src,
                        dst,
                        x,
                        dx,
                        y,
                        dy
                    );
                }
                scale_argb_down_even(
                    src_width,
                    src_height,
                    clip_width,
                    clip_height,
                    cast,no_check(s64) src_stride,
                    cast,no_check(s64) dst_stride,
                    src,
                    dst,
                    x,
                    dx,
                    y,
                    dy,
                    filtering
                );
                return 0;
            }

            if dx & 0x10000 != 0 && dy & 0x10000 != 0 {
                filtering = K_FILTER_NONE;
                if dx == 0x10000 && dy == 0x10000 {
                    ARGBCopy(
                        (src + (cast(s64) (y >> 16)) * cast,no_check(s64) src_stride) + x >> 16 * 4,
                        src_stride,
                        dst,
                        dst_stride,
                        clip_width,
                        clip_height
                    );
                    return 0;
                }
            }
        }
    }
    if dx == 0x10000 && x & 0xffff == 0 {
        ScalePlaneVertical(
            src_height,
            clip_width,
            clip_height,
            src_stride,
            dst_stride,
            src,
            dst,
            x,
            y,
            dy,
            4,
            filtering
        );
        return 0;
    }
    if filtering != 0 && dy < 65536 {
        return scale_argb_bilinear_up(
            src_width,
            src_height,
            clip_width,
            clip_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            x,
            dx,
            y,
            dy,
            filtering
        );
    }
    if filtering != 0 {
        return scale_argb_bilinear_down(
            src_width,
            src_height,
            clip_width,
            clip_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            x,
            dx,
            y,
            dy,
            filtering
        );
    }
    scale_argb_simple(
        src_width,
        src_height,
        clip_width,
        clip_height,
        cast,no_check(s64) src_stride,
        cast,no_check(s64) dst_stride,
        src,
        dst,
        x,
        dx,
        y,
        dy
    );
    return 0;
}

scale_argb_simple :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32
) {
    scale_argb_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleARGBCols64_C else ScaleARGBCols_C);
    MAX_Y := (cast,no_check(s64) (src_height - 1)) << 16;

    if src_width * 2 == dst_width && x < 0x8000 {
        scale_argb_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleARGBColsUp2_C;
    }

    y64 := cast,no_check(s64) y;
    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            if y64 > MAX_Y {
                y64 = MAX_Y;
            }
            scale_argb_cols(dst_argb, src_argb + y64 >> 16 * src_stride, dst_width, x, dx);
            dst_argb += dst_stride;
            y64 += cast,no_check(s64) dy;
        }
    }
}

scale_argb_bilinear_down :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) -> s32 {
    j: s32 = ---;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    scale_argb_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleARGBFilterCols64_C else ScaleARGBFilterCols_C);
    xlast := (cast(s64) x) + (cast,no_check(s64) (dst_width - 1)) * cast(s64) dx;
    xl := (ifx dx >= 0 then cast,no_check(s64) x else xlast);
    xr := (ifx dx >= 0 then xlast else cast,no_check(s64) x);

    xl = xl >> 16 & cast,no_check(s64) (~(cast(s32) 3));
    xr = xr >> 16 + 1;
    xr = ((xr + 1) + 3) & cast,no_check(s64) (~(cast(s32) 3));
    if xr > cast,no_check(s64) src_width {
        xr = cast,no_check(s64) src_width;
    }
    clip_src_width := (cast,no_check(s32) (xr - xl)) * 4;
    src_argb += xl * 4;
    x -= cast,no_check(s32) (xl << 16);

    {
        row_mem_size := cast,no_check(u64) (clip_src_width * 4);

        row_mem: *void =
            cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

        row :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row == null {
            return 1;
        }

        MAX_Y := (cast,no_check(s64) (src_height - 1)) << 16;
        y64 := cast,no_check(s64) y;
        j = 0;
        while j < dst_height {
            if y64 > MAX_Y {
                y64 = MAX_Y;
            }
            yi := cast,no_check(s32) (y64 >> 16);
            src := cast,no_check(*u8) ((src_argb + (cast(s64) yi) * src_stride));
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                scale_argb_filter_cols(dst_argb, src, dst_width, x, dx);
            } else {
                yf := cast,no_check(s32) (y64 >> 8 & 255);
                interpolate_row(row, src, src_stride, clip_src_width, yf);
                scale_argb_filter_cols(dst_argb, row, dst_width, x, dx);
            }
            dst_argb += dst_stride;
            y64 += cast,no_check(s64) dy;
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_argb_bilinear_up :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) -> s32 {
    assert(src_width > 0);
    assert(src_height > 0);
    assert(dst_width > 0);
    assert(dst_height > 0);
    assert(dy <= 65536);

    j: s32 = ---;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    scale_argb_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleARGBFilterCols_C else ScaleARGBCols_C);
    MAX_Y := (cast,no_check(s64) (src_height - 1)) << 16;

    if src_width >= 32768 {
        scale_argb_filter_cols =
            cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleARGBFilterCols64_C else ScaleARGBCols64_C);
    }

    if !(filtering != 0) && src_width * 2 == dst_width && x < 0x8000 {
        scale_argb_filter_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleARGBColsUp2_C;
    }

    y64 := cast,no_check(s64) y;
    if y64 > MAX_Y {
        y64 = MAX_Y;
    }

    {
        yi := cast,no_check(s32) (y64 >> 16);
        src := cast,no_check(*u8) ((src_argb + (cast(s64) yi) * src_stride));

        ROW_SIZE := (dst_width * 4 + 31) & ~(cast(s32) 31);
        row_mem_size := cast,no_check(u64) (ROW_SIZE * 2);

        row_mem: *void =
            cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

        row :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row == null {
            return 1;
        }

        rowptr := cast,no_check(*u8) (row);
        rowstride := cast,no_check(s64) ROW_SIZE;
        lasty := yi;

        scale_argb_filter_cols(rowptr, src, dst_width, x, dx);
        if src_height > 1 {
            src += src_stride;
        }
        scale_argb_filter_cols(rowptr + rowstride, src, dst_width, x, dx);
        if src_height > 2 {
            src += src_stride;
        }

        j = 0;
        while j < dst_height {
            if y64 > MAX_Y {
                y64 = MAX_Y;
            }
            yi = cast,no_check(s32) (y64 >> 16);
            if yi != lasty {
                scale_argb_filter_cols(rowptr, src, dst_width, x, dx);
                rowptr += rowstride;
                rowstride = -rowstride;
                lasty = yi;
                if (y64 + 65536) < MAX_Y {
                    src += src_stride;
                }
            }
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                interpolate_row(dst_argb, rowptr, 0, dst_width * 4, 0);
            } else {
                yf := cast,no_check(s32) (y64 >> 8 & 255);
                interpolate_row(dst_argb, rowptr, rowstride, dst_width * 4, yf);
            }
            dst_argb += dst_stride;
            y64 += cast,no_check(s64) dy;
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_argb_down_even :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) {
    col_step := dx >> 16;
    row_stride := (cast(s64) (dy >> 16)) * src_stride;
    scale_argb_row_down_even: #type (_: *u8, _: s64, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: s32, _: *u8, _: s32)) (ifx filtering != 0 then ScaleARGBRowDownEvenBox_C else ScaleARGBRowDownEven_C);

    assert((cast,no_check(u64) src_width) & cast,no_check(u64) (2 - 1) == 0);
    assert((cast,no_check(u64) src_height) & cast,no_check(u64) (2 - 1) == 0);
    src_argb += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 4);

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_argb_row_down_even(src_argb, src_stride, col_step, dst_argb, dst_width);
            src_argb += row_stride;
            dst_argb += dst_stride;
        }
    }
}

scale_argb_down4_box :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32
) -> s32 {
    ROW_SIZE := (dst_width * 2 * 4 + 31) & ~(cast(s32) 31);

    row_mem_size := cast,no_check(u64) (ROW_SIZE * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row == null {
        return 1;
    }
    row_stride := src_stride * cast(s64) (dy >> 16);
    scale_argb_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleARGBRowDown2Box_C;

    src_argb += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 4);

    assert(dx == 65536 * 4);
    assert(dy & 0x3ffff == 0);

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_argb_row_down2(src_argb, src_stride, row, dst_width * 2);
            scale_argb_row_down2(src_argb + src_stride * 2, src_stride, row + ROW_SIZE, dst_width * 2);
            scale_argb_row_down2(row, cast,no_check(s64) ROW_SIZE, dst_argb, dst_width);
            src_argb += row_stride;
            dst_argb += dst_stride;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

scale_argb_down2 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_argb: *u8,
    dst_argb: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) {
    row_stride := src_stride * cast(s64) (dy >> 16);
    scale_argb_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE then ScaleARGBRowDown2_C else (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then ScaleARGBRowDown2Linear_C else ScaleARGBRowDown2Box_C));

    assert(dx == 65536 * 2);
    assert(dy & 0x1ffff == 0);

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR {
        src_argb += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 4);
    } else {
        src_argb += (cast(s64) (y >> 16)) * src_stride + cast(s64) ((x >> 16 - 1) * 4);
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_argb_row_down2(src_argb, src_stride, dst_argb, dst_width);
            src_argb += row_stride;
            dst_argb += dst_stride;
        }
    }
}

abs_in_scale_argb :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

argb_scale_clip :: (
    src_argb: *u8,
    src_stride_argb: s32,
    src_width: s32,
    src_height: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    dst_width: s32,
    dst_height: s32,
    clip_x: s32,
    clip_y: s32,
    clip_width: s32,
    clip_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_argb == null ||
        src_width == 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_argb == null ||
        dst_width <= 0 ||
        dst_height <= 0 ||
        clip_x < 0 ||
        clip_y < 0 ||
        clip_width > 32768 ||
        clip_height > 32768 ||
        clip_x + clip_width > dst_width ||
        clip_y + clip_height > dst_height {
        return -1;
    }
    return scale_argb(
        src_argb,
        src_stride_argb,
        src_width,
        src_height,
        dst_argb,
        dst_stride_argb,
        dst_width,
        dst_height,
        clip_x,
        clip_y,
        clip_width,
        clip_height,
        filtering
    );
}

yuv_to_argb_scale_clip :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_fourcc: u32,
    src_width: s32,
    src_height: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    dst_fourcc: u32,
    dst_width: s32,
    dst_height: s32,
    clip_x: s32,
    clip_y: s32,
    clip_width: s32,
    clip_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        dst_argb == null ||
        src_width <= 0 ||
        src_width > 2147483647 / 4 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_width <= 0 ||
        dst_height <= 0 ||
        clip_width <= 0 ||
        clip_height <= 0 {
        return -1;
    }
    ABS_SRC_HEIGHT := (ifx src_height < 0 then -src_height else src_height);
    ARGB_BUFFER_SIZE := ((cast,no_check(u64) src_width) * cast,no_check(u64) ABS_SRC_HEIGHT) * 4;

    argb_buffer := cast,no_check(*u8) (cast(*u8) c_transpiler_allocate_memory(ARGB_BUFFER_SIZE));
    if argb_buffer == null {
        return 1;
    }
    I420ToARGB(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        argb_buffer,
        src_width * 4,
        src_width,
        src_height
    );

    r :=
        argb_scale_clip(
            argb_buffer,
            src_width * 4,
            src_width,
            ABS_SRC_HEIGHT,
            dst_argb,
            dst_stride_argb,
            dst_width,
            dst_height,
            clip_x,
            clip_y,
            clip_width,
            clip_height,
            filtering
        );
    c_transpiler_deallocate_memory(argb_buffer);
    return r;
}

globals_initialization_state_for_scale_argb: u32;
initialize_globals_for_scale_argb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_scale_argb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_scale_argb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_scale_argb) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_scale_argb = 0x1;
    K_CPU_HAS_ARM_in_scale_argb = 0x2;
    K_CPU_HAS_NEON_in_scale_argb = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_scale_argb = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_scale_argb = 0x400;
    K_CPU_HAS_SVE_in_scale_argb = 0x800;
    K_CPU_HAS_SVE2_in_scale_argb = 0x1000;
    K_CPU_HAS_SME_in_scale_argb = 0x2000;
    K_CPU_HAS_SME2_in_scale_argb = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_scale_argb = 0x8000;
    K_CPU_HAS_RISCV_in_scale_argb = 0x4;
    K_CPU_HAS_RVV_in_scale_argb = 0x100;
    K_CPU_HAS_RVVZVFH_in_scale_argb = 0x200;
    K_CPU_HAS_X86_in_scale_argb = 0x8;
    K_CPU_HAS_SSE2_in_scale_argb = 0x100;
    K_CPU_HAS_SSSE3_in_scale_argb = 0x200;
    K_CPU_HAS_SSE41_in_scale_argb = 0x400;
    K_CPU_HAS_SSE42_in_scale_argb = 0x800;
    K_CPU_HAS_AVX_in_scale_argb = 0x1000;
    K_CPU_HAS_AVX2_in_scale_argb = 0x2000;
    K_CPU_HAS_ERMS_in_scale_argb = 0x4000;
    K_CPU_HAS_FSMR_in_scale_argb = 0x8000;
    K_CPU_HAS_FMA3_in_scale_argb = 0x10000;
    K_CPU_HAS_F16_C_in_scale_argb = 0x20000;
    K_CPU_HAS_AVX512_BW_in_scale_argb = 0x40000;
    K_CPU_HAS_AVX512_VL_in_scale_argb = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_scale_argb = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_scale_argb = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_scale_argb = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_scale_argb = 0x800000;
    K_CPU_HAS_AVX10_in_scale_argb = 0x1000000;
    K_CPU_HAS_AVX10_2_in_scale_argb = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_scale_argb = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_scale_argb = 0x8000000;
    K_CPU_HAS_AMXINT8_in_scale_argb = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_scale_argb = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_scale_argb = 0x20;
    K_CPU_HAS_LSX_in_scale_argb = 0x100;
    K_CPU_HAS_LASX_in_scale_argb = 0x200;
    atomic_store(*globals_initialization_state_for_scale_argb, 2);
}

