// Generated directly from C++ by cpp_transpiler.
K_CPU_INITIALIZED_in_scale: s32;

K_CPU_HAS_ARM_in_scale: s32;

K_CPU_HAS_NEON_in_scale: s32;

K_CPU_HAS_NEON_DOT_PROD_in_scale: s32;

K_CPU_HAS_NEON_I8_MM_in_scale: s32;

K_CPU_HAS_SVE_in_scale: s32;

K_CPU_HAS_SVE2_in_scale: s32;

K_CPU_HAS_SME_in_scale: s32;

K_CPU_HAS_SME2_in_scale: s32;

K_CPU_HAS_SVEF32_MM_in_scale: s32;

K_CPU_HAS_RISCV_in_scale: s32;

K_CPU_HAS_RVV_in_scale: s32;

K_CPU_HAS_RVVZVFH_in_scale: s32;

K_CPU_HAS_X86_in_scale: s32;

K_CPU_HAS_SSE2_in_scale: s32;

K_CPU_HAS_SSSE3_in_scale: s32;

K_CPU_HAS_SSE41_in_scale: s32;

K_CPU_HAS_SSE42_in_scale: s32;

K_CPU_HAS_AVX_in_scale: s32;

K_CPU_HAS_AVX2_in_scale: s32;

K_CPU_HAS_ERMS_in_scale: s32;

K_CPU_HAS_FSMR_in_scale: s32;

K_CPU_HAS_FMA3_in_scale: s32;

K_CPU_HAS_F16_C_in_scale: s32;

K_CPU_HAS_AVX512_BW_in_scale: s32;

K_CPU_HAS_AVX512_VL_in_scale: s32;

K_CPU_HAS_AVX512_VNNI_in_scale: s32;

K_CPU_HAS_AVX512_VBMI_in_scale: s32;

K_CPU_HAS_AVX512_VBMI2_in_scale: s32;

K_CPU_HAS_AVX512_VBITALG_in_scale: s32;

K_CPU_HAS_AVX10_in_scale: s32;

K_CPU_HAS_AVX10_2_in_scale: s32;

K_CPU_HAS_AVXVNNI_in_scale: s32;

K_CPU_HAS_AVXVNNIINT8_in_scale: s32;

K_CPU_HAS_AMXINT8_in_scale: s32;

K_CPU_HAS_AVX512_BMM_in_scale: s32;

K_CPU_HAS_LOONGARCH_in_scale: s32;

K_CPU_HAS_LSX_in_scale: s32;

K_CPU_HAS_LASX_in_scale: s32;

ScalePlane :: (
    src: *u8,
    src_stride: s32,
    src_width: s32,
    src_height: s32,
    dst: *u8,
    dst_stride: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_width > 32768 ||
        src_height < -32768 ||
        src_height > 32768 ||
        dst == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    filtering = ScaleFilterReduce(src_width, src_height, dst_width, dst_height, filtering);

    if src_height < 0 {
        src_height = -src_height;
        src = cast,no_check(*u8) ((src + (cast(s64) (src_height - 1)) * cast,no_check(s64) src_stride));
        src_stride = -src_stride;
    }

    if dst_width == src_width && dst_height == src_height {
        CopyPlane(src, src_stride, dst, dst_stride, dst_width, dst_height);
        return 0;
    }
    if dst_width == src_width && cast,no_check(s32) filtering != cast,no_check(s32) K_FILTER_BOX {
        dy: s32 = 0;
        y: s32 = 0;

        if dst_height <= src_height {
            dy = FixedDiv_C(src_height, dst_height);
            y = ifx dy < 0 then -(-dy >> 1 + -32768) else dy >> 1 + -32768;
        } else if src_height > 1 && dst_height > 1 {
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE {
                dy = FixedDiv_C(src_height, dst_height);
                y = ifx dy < 0 then -(-dy >> 1 + 0) else dy >> 1 + 0;
            } else {
                dy = FixedDiv1_C(src_height, dst_height);
            }
        }

        ScalePlaneVertical(src_height, dst_width, dst_height, src_stride, dst_stride, src, dst, 0, y, dy, 1, filtering);
        return 0;
    }
    if dst_width <= abs_in_scale(src_width) && dst_height <= src_height {
        if 4 * dst_width == 3 * src_width && 4 * dst_height == 3 * src_height {
            scale_plane_down34(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
        if 2 * dst_width == src_width && 2 * dst_height == src_height {
            scale_plane_down2(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }

        if 8 * dst_width == 3 * src_width && 8 * dst_height == 3 * src_height {
            scale_plane_down38(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
        if 4 * dst_width == src_width &&
            4 * dst_height == src_height &&
            (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX ||
                cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE) {
            scale_plane_down4(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX && dst_height * 2 < src_height {
        return scale_plane_box(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
    }
    if (dst_width + 1) / 2 == src_width && cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        scale_plane_up2_linear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if (dst_height + 1) / 2 == src_height &&
        (dst_width + 1) / 2 == src_width &&
        (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR ||
            cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX) {
        scale_plane_up2_bilinear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if filtering != 0 && dst_height > src_height {
        return scale_plane_bilinear_up(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            filtering
        );
    }
    if filtering != 0 {
        return scale_plane_bilinear_down(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            filtering
        );
    }
    scale_plane_simple(
        src_width,
        src_height,
        dst_width,
        dst_height,
        cast,no_check(s64) src_stride,
        cast,no_check(s64) dst_stride,
        src,
        dst
    );
    return 0;
}

scale_plane_simple :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8
) {
    scale_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleCols_C;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    ScaleSlope(src_width, src_height, dst_width, dst_height, K_FILTER_NONE, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);

    if src_width * 2 == dst_width && x < 0x8000 {
        scale_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleColsUp2_C;
    }

    if 0 < dst_height {
        for i: 0..dst_height - 1 {
            scale_cols(dst_ptr, src_ptr + (cast(s64) (y >> 16)) * src_stride, dst_width, x, dx);
            dst_ptr += dst_stride;
            y += dy;
        }
    }
}

abs_in_scale :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

scale_plane_bilinear_down :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) -> s32 {
    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;

    row_mem_size := cast,no_check(u64) src_width;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row == null {
        return 1;
    }

    MAX_Y := (src_height - 1) << 16;

    scale_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleFilterCols64_C else ScaleFilterCols_C);
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    ScaleSlope(src_width, src_height, dst_width, dst_height, filtering, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);

    if y > MAX_Y {
        y = MAX_Y;
    }

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            yi := y >> 16;
            src := cast,no_check(*u8) ((src_ptr + (cast(s64) yi) * src_stride));
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                scale_filter_cols(dst_ptr, src, dst_width, x, dx);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(row, src, src_stride, src_width, yf);
                scale_filter_cols(dst_ptr, row, dst_width, x, dx);
            }
            dst_ptr += dst_stride;
            y += dy;
            if y > MAX_Y {
                y = MAX_Y;
            }
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

scale_plane_bilinear_up :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) -> s32 {
    assert(src_width > 0);
    assert(src_height > 0);
    assert(dst_width > 0);
    assert(dst_height > 0);

    j: s32 = ---;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    MAX_Y := (src_height - 1) << 16;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    scale_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleFilterCols_C else ScaleCols_C);
    ScaleSlope(src_width, src_height, dst_width, dst_height, filtering, *x, *y, *dx, *dy);
    assert(dy <= 65536);
    src_width = abs_in_scale(src_width);

    if filtering != 0 && src_width >= 32768 {
        scale_filter_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleFilterCols64_C;
    }

    if !(filtering != 0) && src_width * 2 == dst_width && x < 0x8000 {
        scale_filter_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleColsUp2_C;
    }

    if y > MAX_Y {
        y = MAX_Y;
    }
    {
        yi := y >> 16;
        src := cast,no_check(*u8) ((src_ptr + (cast(s64) yi) * src_stride));

        ROW_SIZE := (dst_width + 31) & ~(cast(s32) 31);
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

        scale_filter_cols(rowptr, src, dst_width, x, dx);
        if src_height > 1 {
            src += src_stride;
        }
        scale_filter_cols(rowptr + rowstride, src, dst_width, x, dx);
        if src_height > 2 {
            src += src_stride;
        }

        j = 0;
        while j < dst_height {
            if y > MAX_Y {
                y = MAX_Y;
            }
            yi = y >> 16;
            if yi != lasty {
                scale_filter_cols(rowptr, src, dst_width, x, dx);
                rowptr += rowstride;
                rowstride = -rowstride;
                lasty = yi;
                if y + 65536 < MAX_Y {
                    src += src_stride;
                }
            }
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                interpolate_row(dst_ptr, rowptr, 0, dst_width, 0);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(dst_ptr, rowptr, rowstride, dst_width, yf);
            }
            dst_ptr += dst_stride;
            y += dy;
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_plane_up2_bilinear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8
) {
    scale2_row_up: #type (_: *u8, _: s64, _: *u8, _: s64, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: s32)) ScaleRowUp2_Bilinear_Any_C;

    assert(src_width == (dst_width + 1) / 2);
    assert(src_height == (dst_height + 1) / 2);

    scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    dst_ptr += dst_stride;
    x: s32 = 0;
    while x < src_height - 1 {
        scale2_row_up(src_ptr, src_stride, dst_ptr, dst_stride, dst_width);
        src_ptr += src_stride;

        dst_ptr += 2 * dst_stride;
        x += 1;
    }
    if dst_height & 1 == 0 {
        scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    }
}

scale_plane_up2_linear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8
) {
    scale_row_up: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleRowUp2_Linear_Any_C;
    i: s32 = ---;
    y: s32 = ---;
    dy: s32 = ---;

    assert(src_width == (dst_width + 1) / 2);

    if dst_height == 1 {
        scale_row_up(src_ptr + (cast(s64) ((src_height - 1) / 2)) * src_stride, dst_ptr, dst_width);
    } else {
        dy = FixedDiv_C(src_height - 1, dst_height - 1);
        y = (cast(s32) 1) << 15 - 1;
        i = 0;
        while i < dst_height {
            scale_row_up(src_ptr + (cast(s64) (y >> 16)) * src_stride, dst_ptr, dst_width);
            dst_ptr += dst_stride;
            y += dy;
            i += 1;
        }
    }
}

scale_plane_box :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8
) -> s32 {
    j, k: s32 = ---;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    MAX_Y := src_height << 16;
    ScaleSlope(src_width, src_height, dst_width, dst_height, K_FILTER_BOX, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);
    {
        row16_mem_size := cast,no_check(u64) (src_width * 2);

        row16_mem: *void =
            cast,no_check(*void) ((ifx row16_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row16_mem_size + 63))));

        row16 :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row16_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row16 == null {
            return 1;
        }
        scale_add_cols: #type (_: s32, _: s32, _: s32, _: s32, _: *u16, _: *u8) =
            cast,no_check(#type (_: s32, _: s32, _: s32, _: s32, _: *u16, _: *u8)) (ifx dx & 0xffff != 0 then scale_add_cols2_c else (ifx dx != 0x10000 then scale_add_cols1_c else scale_add_cols0_c));
        scale_add_row: #type (_: *u8, _: *u16, _: s32) = cast,no_check(#type (_: *u8, _: *u16, _: s32)) ScaleAddRow_C;

        j = 0;
        while j < dst_height {
            iy := y >> 16;
            src := cast,no_check(*u8) ((src_ptr + (cast(s64) iy) * src_stride));
            y += dy;
            if y > MAX_Y {
                y = MAX_Y;
            }
            boxheight := (ifx y >> 16 - iy < 1 then 1 else y >> 16 - iy);
            fill_memory(row16, 0, cast,no_check(u64) (src_width * 2));
            k = 0;
            while k < boxheight {
                scale_add_row(src, cast(*u16) row16, src_width);
                src += src_stride;
                k += 1;
            }
            scale_add_cols(dst_width, boxheight, x, dx, cast(*u16) row16, dst_ptr);
            dst_ptr += dst_stride;
            j += 1;
        }
        c_transpiler_deallocate_memory(row16_mem);

        row16 = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_add_cols0_c :: (dst_width: s32, boxheight: s32, x: s32, dx: s32, src_ptr: *u16, dst_ptr: *u8) {
    scaleval := 65536 / boxheight;

    src_ptr += x >> 16;
    if 0 < dst_width {
        for i: 0..dst_width - 1 {
            dst_ptr.* = cast,no_check(u8) (((cast(s32) src_ptr[i]) * scaleval) >> 16);
            dst_ptr += 1;
        }
    }
}

scale_add_cols1_c :: (dst_width: s32, boxheight: s32, x: s32, dx: s32, src_ptr: *u16, dst_ptr: *u8) {
    boxwidth := (ifx dx >> 16 < 1 then 1 else dx >> 16);
    scaleval := 65536 / (boxwidth * boxheight);

    c_transpiler_compound_shr(*(x), (cast(s32) 16), s32, s32);
    if 0 < dst_width {
        for i: 0..dst_width - 1 {
            assignment_0: u8 =
                cast,no_check(u8) ((sum_pixels(boxwidth, src_ptr + x) *
                    cast,no_check(u32) scaleval) >> 16);
            ((cast,no_check(*u8) *((c_transpiler_post_increment(*(dst_ptr))).*)).*) = assignment_0;
            x += boxwidth;
        }
    }
}

sum_pixels :: (iboxwidth: s32, src_ptr: *u16) -> u32 {
    sum: u32 = 0;

    assert(iboxwidth > 0);
    if 0 < iboxwidth {
        for x: 0..iboxwidth - 1 {
            sum += cast,no_check(u32) src_ptr[x];
        }
    }
    return sum;
}

scale_add_cols2_c :: (dst_width: s32, boxheight: s32, x: s32, dx: s32, src_ptr: *u16, dst_ptr: *u8) {
    scaletbl: [2] s32 = ---;
    minboxwidth := dx >> 16;
    boxwidth: s32 = ---;
    scaletbl[0] = 65536 / ((ifx minboxwidth < 1 then 1 else minboxwidth) * boxheight);
    scaletbl[1] = 65536 / ((ifx minboxwidth + 1 < 1 then 1 else minboxwidth + 1) * boxheight);
    if 0 < dst_width {
        for i: 0..dst_width - 1 {
            ix := x >> 16;
            x += dx;
            boxwidth = ifx x >> 16 - ix < 1 then 1 else x >> 16 - ix;
            scaletbl_index := boxwidth - minboxwidth;
            assert(scaletbl_index == 0 || scaletbl_index == 1);
            assignment_1: u8 =
                cast,no_check(u8) ((sum_pixels(boxwidth, src_ptr + ix) *
                    cast,no_check(u32) scaletbl[scaletbl_index]) >> 16);
            ((cast,no_check(*u8) *((c_transpiler_post_increment(*(dst_ptr))).*)).*) = assignment_1;
        }
    }
}

scale_plane_down4 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) {
    scale_row_down4: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) (ifx filtering != 0 then ScaleRowDown4Box_C else ScaleRowDown4_C);
    row_stride := src_stride * 4;

    if !(filtering != 0) {
        src_ptr += src_stride * 2;
        src_stride = 0;
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for y: 0..dst_height - 1 {
            scale_row_down4(src_ptr, src_stride, dst_ptr, dst_width);
            src_ptr += row_stride;
            dst_ptr += dst_stride;
        }
    }
}

scale_plane_down38 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) {
    scale_row_down38_3: #type (_: *u8, _: s64, _: *u8, _: s32) = ---;
    scale_row_down38_2: #type (_: *u8, _: s64, _: *u8, _: s32) = ---;
    FILTER_STRIDE := (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then 0 else src_stride);
    assert(dst_width % 3 == 0);

    if !(filtering != 0) {
        scale_row_down38_3 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown38_C;
        scale_row_down38_2 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown38_C;
    } else {
        scale_row_down38_3 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown38_3_Box_C;
        scale_row_down38_2 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown38_2_Box_C;
    }

    y: s32 = 0;
    while y < dst_height - 2 {
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_2(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 2;
        dst_ptr += dst_stride;
        y += 3;
    }

    if dst_height % 3 == 2 {
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_3(src_ptr, 0, dst_ptr, dst_width);
    } else if dst_height % 3 == 1 {
        scale_row_down38_3(src_ptr, 0, dst_ptr, dst_width);
    }
}

scale_plane_down2 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) {
    scale_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE then ScaleRowDown2_C else (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then ScaleRowDown2Linear_C else ScaleRowDown2Box_C));
    row_stride := src_stride * 2;

    if !(filtering != 0) {
        src_ptr += src_stride;
        src_stride = 0;
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }

    if 0 < dst_height {
        for y: 0..dst_height - 1 {
            scale_row_down2(src_ptr, src_stride, dst_ptr, dst_width);
            src_ptr += row_stride;
            dst_ptr += dst_stride;
        }
    }
}

scale_plane_down34 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u8,
    dst_ptr: *u8,
    filtering: Filter_Mode
) {
    scale_row_down34_0: #type (_: *u8, _: s64, _: *u8, _: s32) = ---;
    scale_row_down34_1: #type (_: *u8, _: s64, _: *u8, _: s32) = ---;
    FILTER_STRIDE := (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then 0 else src_stride);

    assert(dst_width % 3 == 0);
    if !(filtering != 0) {
        scale_row_down34_0 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown34_C;
        scale_row_down34_1 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown34_C;
    } else {
        scale_row_down34_0 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown34_0_Box_C;
        scale_row_down34_1 = cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleRowDown34_1_Box_C;
    }

    y: s32 = 0;
    while y < dst_height - 2 {
        scale_row_down34_0(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_1(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_0(src_ptr + src_stride, -FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 2;
        dst_ptr += dst_stride;
        y += 3;
    }

    if dst_height % 3 == 2 {
        scale_row_down34_0(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_1(src_ptr, 0, dst_ptr, dst_width);
    } else if dst_height % 3 == 1 {
        scale_row_down34_0(src_ptr, 0, dst_ptr, dst_width);
    }
}

ScalePlane_16 :: (
    src: *u16,
    src_stride: s32,
    src_width: s32,
    src_height: s32,
    dst: *u16,
    dst_stride: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_width > 32768 ||
        src_height < -32768 ||
        src_height > 32768 ||
        dst == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    filtering = ScaleFilterReduce(src_width, src_height, dst_width, dst_height, filtering);

    if src_height < 0 {
        src_height = -src_height;
        src = cast,no_check(*u16) ((src + (cast(s64) (src_height - 1)) * cast,no_check(s64) src_stride));
        src_stride = -src_stride;
    }

    if dst_width == src_width && dst_height == src_height {
        CopyPlane_16(src, src_stride, dst, dst_stride, dst_width, dst_height);
        return 0;
    }
    if dst_width == src_width && cast,no_check(s32) filtering != cast,no_check(s32) K_FILTER_BOX {
        dy: s32 = 0;
        y: s32 = 0;

        if dst_height <= src_height {
            dy = FixedDiv_C(src_height, dst_height);
            y = ifx dy < 0 then -(-dy >> 1 + -32768) else dy >> 1 + -32768;
        } else if src_height > 1 && dst_height > 1 {
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE {
                dy = FixedDiv_C(src_height, dst_height);
                y = ifx dy < 0 then -(-dy >> 1 + 0) else dy >> 1 + 0;
            } else {
                dy = FixedDiv1_C(src_height, dst_height);
            }
        }

        ScalePlaneVertical_16(
            src_height,
            dst_width,
            dst_height,
            src_stride,
            dst_stride,
            src,
            dst,
            0,
            y,
            dy,
            1,
            filtering
        );
        return 0;
    }
    if dst_width <= abs_in_scale(src_width) && dst_height <= src_height {
        if 4 * dst_width == 3 * src_width && 4 * dst_height == 3 * src_height {
            scale_plane_down34_16(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
        if 2 * dst_width == src_width && 2 * dst_height == src_height {
            scale_plane_down2_16(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }

        if 8 * dst_width == 3 * src_width && 8 * dst_height == 3 * src_height {
            scale_plane_down38_16(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
        if 4 * dst_width == src_width &&
            4 * dst_height == src_height &&
            (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX ||
                cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE) {
            scale_plane_down4_16(
                src_width,
                src_height,
                dst_width,
                dst_height,
                cast,no_check(s64) src_stride,
                cast,no_check(s64) dst_stride,
                src,
                dst,
                filtering
            );
            return 0;
        }
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX && dst_height * 2 < src_height {
        return scale_plane_box_16(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
    }
    if (dst_width + 1) / 2 == src_width && cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        scale_plane_up2_16_linear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if (dst_height + 1) / 2 == src_height &&
        (dst_width + 1) / 2 == src_width &&
        (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR ||
            cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX) {
        scale_plane_up2_16_bilinear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if filtering != 0 && dst_height > src_height {
        return scale_plane_bilinear_up_16(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            filtering
        );
    }
    if filtering != 0 {
        return scale_plane_bilinear_down_16(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst,
            filtering
        );
    }
    scale_plane_simple_16(
        src_width,
        src_height,
        dst_width,
        dst_height,
        cast,no_check(s64) src_stride,
        cast,no_check(s64) dst_stride,
        src,
        dst
    );
    return 0;
}

scale_plane_simple_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale_cols: #type (_: *u16, _: *u16, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) ScaleCols_16_C;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    ScaleSlope(src_width, src_height, dst_width, dst_height, K_FILTER_NONE, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);

    if src_width * 2 == dst_width && x < 0x8000 {
        scale_cols = cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) ScaleColsUp2_16_C;
    }

    if 0 < dst_height {
        for i: 0..dst_height - 1 {
            scale_cols(dst_ptr, src_ptr + (cast(s64) (y >> 16)) * src_stride, dst_width, x, dx);
            dst_ptr += dst_stride;
            y += dy;
        }
    }
}

scale_plane_bilinear_down_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) -> s32 {
    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;

    row_mem_size := cast,no_check(u64) (src_width * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row == null {
        return 1;
    }

    MAX_Y := (src_height - 1) << 16;

    scale_filter_cols: #type (_: *u16, _: *u16, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleFilterCols64_16_C else ScaleFilterCols_16_C);
    interpolate_row: #type (_: *u16, _: *u16, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s64, _: s32, _: s32)) InterpolateRow_16_C;
    ScaleSlope(src_width, src_height, dst_width, dst_height, filtering, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);

    if y > MAX_Y {
        y = MAX_Y;
    }

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            yi := y >> 16;
            src := cast,no_check(*u16) ((src_ptr + (cast(s64) yi) * src_stride));
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                scale_filter_cols(dst_ptr, src, dst_width, x, dx);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(cast(*u16) row, src, src_stride, src_width, yf);
                scale_filter_cols(dst_ptr, cast(*u16) row, dst_width, x, dx);
            }
            dst_ptr += dst_stride;
            y += dy;
            if y > MAX_Y {
                y = MAX_Y;
            }
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

scale_plane_bilinear_up_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) -> s32 {
    assert(src_width > 0);
    assert(src_height > 0);
    assert(dst_width > 0);
    assert(dst_height > 0);

    j: s32 = ---;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    MAX_Y := (src_height - 1) << 16;
    interpolate_row: #type (_: *u16, _: *u16, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s64, _: s32, _: s32)) InterpolateRow_16_C;
    scale_filter_cols: #type (_: *u16, _: *u16, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleFilterCols_16_C else ScaleCols_16_C);
    ScaleSlope(src_width, src_height, dst_width, dst_height, filtering, *x, *y, *dx, *dy);
    assert(dy <= 65536);
    src_width = abs_in_scale(src_width);

    if filtering != 0 && src_width >= 32768 {
        scale_filter_cols = cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) ScaleFilterCols64_16_C;
    }

    if !(filtering != 0) && src_width * 2 == dst_width && x < 0x8000 {
        scale_filter_cols = cast,no_check(#type (_: *u16, _: *u16, _: s32, _: s32, _: s32)) ScaleColsUp2_16_C;
    }

    if y > MAX_Y {
        y = MAX_Y;
    }
    {
        yi := y >> 16;
        src := cast,no_check(*u16) ((src_ptr + (cast(s64) yi) * src_stride));

        ROW_SIZE := (dst_width + 31) & ~(cast(s32) 31);
        row_mem_size := cast,no_check(u64) (ROW_SIZE * 4);

        row_mem: *void =
            cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

        row :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        rowstride := cast,no_check(s64) ROW_SIZE;
        lasty := yi;
        rowptr := cast,no_check(*u16) (cast(*u16) row);
        if row == null {
            return 1;
        }

        scale_filter_cols(rowptr, src, dst_width, x, dx);
        if src_height > 1 {
            src += src_stride;
        }
        scale_filter_cols(rowptr + rowstride, src, dst_width, x, dx);
        if src_height > 2 {
            src += src_stride;
        }

        j = 0;
        while j < dst_height {
            if y > MAX_Y {
                y = MAX_Y;
            }
            yi = y >> 16;
            if yi != lasty {
                scale_filter_cols(rowptr, src, dst_width, x, dx);
                rowptr += rowstride;
                rowstride = -rowstride;
                lasty = yi;
                if y + 65536 < MAX_Y {
                    src += src_stride;
                }
            }
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                interpolate_row(dst_ptr, rowptr, 0, dst_width, 0);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(dst_ptr, rowptr, rowstride, dst_width, yf);
            }
            dst_ptr += dst_stride;
            y += dy;
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_plane_up2_16_bilinear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale2_row_up: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleRowUp2_Bilinear_16_Any_C;

    assert(src_width == (dst_width + 1) / 2);
    assert(src_height == (dst_height + 1) / 2);

    scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    dst_ptr += dst_stride;
    x: s32 = 0;
    while x < src_height - 1 {
        scale2_row_up(src_ptr, src_stride, dst_ptr, dst_stride, dst_width);
        src_ptr += src_stride;
        dst_ptr += 2 * dst_stride;
        x += 1;
    }
    if dst_height & 1 == 0 {
        scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    }
}

scale_plane_up2_16_linear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale_row_up: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    i: s32 = ---;
    y: s32 = ---;
    dy: s32 = ---;

    assert(src_width == (dst_width + 1) / 2);

    if dst_height == 1 {
        scale_row_up(src_ptr + (cast(s64) ((src_height - 1) / 2)) * src_stride, dst_ptr, dst_width);
    } else {
        dy = FixedDiv_C(src_height - 1, dst_height - 1);
        y = (cast(s32) 1) << 15 - 1;
        i = 0;
        while i < dst_height {
            scale_row_up(src_ptr + (cast(s64) (y >> 16)) * src_stride, dst_ptr, dst_width);
            dst_ptr += dst_stride;
            y += dy;
            i += 1;
        }
    }
}

scale_plane_box_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) -> s32 {
    j, k: s32 = ---;

    x: s32 = 0;
    y: s32 = 0;
    dx: s32 = 0;
    dy: s32 = 0;
    MAX_Y := src_height << 16;
    ScaleSlope(src_width, src_height, dst_width, dst_height, K_FILTER_BOX, *x, *y, *dx, *dy);
    src_width = abs_in_scale(src_width);
    {
        row32_mem_size := cast,no_check(u64) (src_width * 4);

        row32_mem: *void =
            cast,no_check(*void) ((ifx row32_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row32_mem_size + 63))));

        row32 :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row32_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row32 == null {
            return 1;
        }
        scale_add_cols: #type (_: s32, _: s32, _: s32, _: s32, _: *u32, _: *u16) =
            cast,no_check(#type (_: s32, _: s32, _: s32, _: s32, _: *u32, _: *u16)) (ifx dx & 0xffff != 0 then scale_add_cols2_16_c else scale_add_cols1_16_c);
        scale_add_row: #type (_: *u16, _: *u32, _: s32) =
            cast,no_check(#type (_: *u16, _: *u32, _: s32)) ScaleAddRow_16_C;

        j = 0;
        while j < dst_height {
            iy := y >> 16;
            src := cast,no_check(*u16) ((src_ptr + (cast(s64) iy) * src_stride));
            y += dy;
            if y > MAX_Y {
                y = MAX_Y;
            }
            boxheight := (ifx y >> 16 - iy < 1 then 1 else y >> 16 - iy);
            fill_memory(row32, 0, cast,no_check(u64) (src_width * 4));
            k = 0;
            while k < boxheight {
                scale_add_row(src, cast(*u32) row32, src_width);
                src += src_stride;
                k += 1;
            }
            scale_add_cols(dst_width, boxheight, x, dx, cast(*u32) row32, dst_ptr);
            dst_ptr += dst_stride;
            j += 1;
        }
        c_transpiler_deallocate_memory(row32_mem);

        row32 = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_add_cols1_16_c :: (dst_width: s32, boxheight: s32, x: s32, dx: s32, src_ptr: *u32, dst_ptr: *u16) {
    boxwidth := (ifx dx >> 16 < 1 then 1 else dx >> 16);
    scaleval := 65536 / (boxwidth * boxheight);

    if 0 < dst_width {
        for i: 0..dst_width - 1 {
            assignment_2: u16 =
                cast,no_check(u16) ((sum_pixels_16(boxwidth, src_ptr + x) *
                    cast,no_check(u32) scaleval) >> 16);
            ((cast,no_check(*u16) *((c_transpiler_post_increment(*(dst_ptr))).*)).*) = assignment_2;
            x += boxwidth;
        }
    }
}

sum_pixels_16 :: (iboxwidth: s32, src_ptr: *u32) -> u32 {
    sum: u32 = 0;

    assert(iboxwidth > 0);
    if 0 < iboxwidth {
        for x: 0..iboxwidth - 1 {
            sum += src_ptr[x];
        }
    }
    return sum;
}

scale_add_cols2_16_c :: (dst_width: s32, boxheight: s32, x: s32, dx: s32, src_ptr: *u32, dst_ptr: *u16) {
    scaletbl: [2] s32 = ---;
    minboxwidth := dx >> 16;
    boxwidth: s32 = ---;
    scaletbl[0] = 65536 / ((ifx minboxwidth < 1 then 1 else minboxwidth) * boxheight);
    scaletbl[1] = 65536 / ((ifx minboxwidth + 1 < 1 then 1 else minboxwidth + 1) * boxheight);
    if 0 < dst_width {
        for i: 0..dst_width - 1 {
            ix := x >> 16;
            x += dx;
            boxwidth = ifx x >> 16 - ix < 1 then 1 else x >> 16 - ix;
            scaletbl_index := boxwidth - minboxwidth;
            assert(scaletbl_index == 0 || scaletbl_index == 1);
            assignment_3: u16 =
                cast,no_check(u16) ((sum_pixels_16(boxwidth, src_ptr + ix) *
                    cast,no_check(u32) scaletbl[scaletbl_index]) >> 16);
            ((cast,no_check(*u16) *((c_transpiler_post_increment(*(dst_ptr))).*)).*) = assignment_3;
        }
    }
}

scale_plane_down4_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) {
    scale_row_down4: #type (_: *u16, _: s64, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) (ifx filtering != 0 then ScaleRowDown4Box_16_C else ScaleRowDown4_16_C);
    row_stride := src_stride * 4;

    if !(filtering != 0) {
        src_ptr += src_stride * 2;
        src_stride = 0;
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for y: 0..dst_height - 1 {
            scale_row_down4(src_ptr, src_stride, dst_ptr, dst_width);
            src_ptr += row_stride;
            dst_ptr += dst_stride;
        }
    }
}

scale_plane_down38_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) {
    scale_row_down38_3: #type (_: *u16, _: s64, _: *u16, _: s32) = ---;
    scale_row_down38_2: #type (_: *u16, _: s64, _: *u16, _: s32) = ---;
    FILTER_STRIDE := (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then 0 else src_stride);

    assert(dst_width % 3 == 0);
    if !(filtering != 0) {
        scale_row_down38_3 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown38_16_C;
        scale_row_down38_2 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown38_16_C;
    } else {
        scale_row_down38_3 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown38_3_Box_16_C;
        scale_row_down38_2 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown38_2_Box_16_C;
    }

    y: s32 = 0;
    while y < dst_height - 2 {
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_2(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 2;
        dst_ptr += dst_stride;
        y += 3;
    }

    if dst_height % 3 == 2 {
        scale_row_down38_3(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 3;
        dst_ptr += dst_stride;
        scale_row_down38_3(src_ptr, 0, dst_ptr, dst_width);
    } else if dst_height % 3 == 1 {
        scale_row_down38_3(src_ptr, 0, dst_ptr, dst_width);
    }
}

scale_plane_down2_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) {
    scale_row_down2: #type (_: *u16, _: s64, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE then ScaleRowDown2_16_C else (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then ScaleRowDown2Linear_16_C else ScaleRowDown2Box_16_C));
    row_stride := src_stride * 2;

    if !(filtering != 0) {
        src_ptr += src_stride;
        src_stride = 0;
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }

    if 0 < dst_height {
        for y: 0..dst_height - 1 {
            scale_row_down2(src_ptr, src_stride, dst_ptr, dst_width);
            src_ptr += row_stride;
            dst_ptr += dst_stride;
        }
    }
}

scale_plane_down34_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16,
    filtering: Filter_Mode
) {
    scale_row_down34_0: #type (_: *u16, _: s64, _: *u16, _: s32) = ---;
    scale_row_down34_1: #type (_: *u16, _: s64, _: *u16, _: s32) = ---;
    FILTER_STRIDE := (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then 0 else src_stride);

    assert(dst_width % 3 == 0);
    if !(filtering != 0) {
        scale_row_down34_0 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown34_16_C;
        scale_row_down34_1 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown34_16_C;
    } else {
        scale_row_down34_0 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown34_0_Box_16_C;
        scale_row_down34_1 = cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s32)) ScaleRowDown34_1_Box_16_C;
    }

    y: s32 = 0;
    while y < dst_height - 2 {
        scale_row_down34_0(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_1(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_0(src_ptr + src_stride, -FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride * 2;
        dst_ptr += dst_stride;
        y += 3;
    }

    if dst_height % 3 == 2 {
        scale_row_down34_0(src_ptr, FILTER_STRIDE, dst_ptr, dst_width);
        src_ptr += src_stride;
        dst_ptr += dst_stride;
        scale_row_down34_1(src_ptr, 0, dst_ptr, dst_width);
    } else if dst_height % 3 == 1 {
        scale_row_down34_0(src_ptr, 0, dst_ptr, dst_width);
    }
}

ScalePlane_12 :: (
    src: *u16,
    src_stride: s32,
    src_width: s32,
    src_height: s32,
    dst: *u16,
    dst_stride: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_width > 32768 ||
        src_height < -32768 ||
        src_height > 32768 ||
        dst == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    filtering = ScaleFilterReduce(src_width, src_height, dst_width, dst_height, filtering);

    if src_height < 0 {
        src_height = -src_height;
        src = cast,no_check(*u16) ((src + (cast(s64) (src_height - 1)) * cast,no_check(s64) src_stride));
        src_stride = -src_stride;
    }

    if (dst_width + 1) / 2 == src_width && cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        scale_plane_up2_12_linear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if (dst_height + 1) / 2 == src_height &&
        (dst_width + 1) / 2 == src_width &&
        (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR ||
            cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX) {
        scale_plane_up2_12_bilinear(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }

    return ScalePlane_16(src, src_stride, src_width, src_height, dst, dst_stride, dst_width, dst_height, filtering);
}

scale_plane_up2_12_bilinear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale2_row_up: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleRowUp2_Bilinear_16_Any_C;

    assert(src_width == (dst_width + 1) / 2);
    assert(src_height == (dst_height + 1) / 2);

    scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    dst_ptr += dst_stride;
    x: s32 = 0;
    while x < src_height - 1 {
        scale2_row_up(src_ptr, src_stride, dst_ptr, dst_stride, dst_width);
        src_ptr += src_stride;
        dst_ptr += 2 * dst_stride;
        x += 1;
    }
    if dst_height & 1 == 0 {
        scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    }
}

scale_plane_up2_12_linear :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale_row_up: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleRowUp2_Linear_16_Any_C;
    i: s32 = ---;
    y: s32 = ---;
    dy: s32 = ---;

    assert(src_width == (dst_width + 1) / 2);

    if dst_height == 1 {
        scale_row_up(src_ptr + (cast(s64) ((src_height - 1) / 2)) * src_stride, dst_ptr, dst_width);
    } else {
        dy = FixedDiv_C(src_height - 1, dst_height - 1);
        y = (cast(s32) 1) << 15 - 1;
        i = 0;
        while i < dst_height {
            scale_row_up(src_ptr + (cast(s64) (y >> 16)) * src_stride, dst_ptr, dst_width);
            dst_ptr += dst_stride;
            y += dy;
            i += 1;
        }
    }
}

I420Scale :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    src_halfheight := (ifx src_height < 0 then -((-src_height + 1) >> 1) else (src_height + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);
    dst_halfheight := (ifx dst_height < 0 then -((-dst_height + 1) >> 1) else (dst_height + 1) >> 1);

    r := ScalePlane(src_y, src_stride_y, src_width, src_height, dst_y, dst_stride_y, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_halfheight,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_halfheight,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    return r;
}

I420Scale_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    src_halfheight := (ifx src_height < 0 then -((-src_height + 1) >> 1) else (src_height + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);
    dst_halfheight := (ifx dst_height < 0 then -((-dst_height + 1) >> 1) else (dst_height + 1) >> 1);

    r :=
        ScalePlane_16(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_halfheight,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_halfheight,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    return r;
}

I420Scale_12 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    src_halfheight := (ifx src_height < 0 then -((-src_height + 1) >> 1) else (src_height + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);
    dst_halfheight := (ifx dst_height < 0 then -((-dst_height + 1) >> 1) else (dst_height + 1) >> 1);

    r :=
        ScalePlane_12(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_halfheight,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_halfheight,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    return r;
}

I444Scale :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    r := ScalePlane(src_y, src_stride_y, src_width, src_height, dst_y, dst_stride_y, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r = ScalePlane(src_u, src_stride_u, src_width, src_height, dst_u, dst_stride_u, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r = ScalePlane(src_v, src_stride_v, src_width, src_height, dst_v, dst_stride_v, dst_width, dst_height, filtering);
    return r;
}

I444Scale_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    r :=
        ScalePlane_16(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(src_u, src_stride_u, src_width, src_height, dst_u, dst_stride_u, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(src_v, src_stride_v, src_width, src_height, dst_v, dst_stride_v, dst_width, dst_height, filtering);
    return r;
}

I444Scale_12 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    r :=
        ScalePlane_12(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(src_u, src_stride_u, src_width, src_height, dst_u, dst_stride_u, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(src_v, src_stride_v, src_width, src_height, dst_v, dst_stride_v, dst_width, dst_height, filtering);
    return r;
}

I422Scale :: (
    src_y: *u8,
    src_stride_y: s32,
    src_u: *u8,
    src_stride_u: s32,
    src_v: *u8,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);

    r := ScalePlane(src_y, src_stride_y, src_width, src_height, dst_y, dst_stride_y, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_height,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_height,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_height,
            filtering
        );
    return r;
}

I422Scale_16 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);

    r :=
        ScalePlane_16(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_height,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_16(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_height,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_height,
            filtering
        );
    return r;
}

I422Scale_12 :: (
    src_y: *u16,
    src_stride_y: s32,
    src_u: *u16,
    src_stride_u: s32,
    src_v: *u16,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u16,
    dst_stride_y: s32,
    dst_u: *u16,
    dst_stride_u: s32,
    dst_v: *u16,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);

    r :=
        ScalePlane_12(
            src_y,
            src_stride_y,
            src_width,
            src_height,
            dst_y,
            dst_stride_y,
            dst_width,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_u,
            src_stride_u,
            src_halfwidth,
            src_height,
            dst_u,
            dst_stride_u,
            dst_halfwidth,
            dst_height,
            filtering
        );
    if r != 0 {
        return r;
    }
    r =
        ScalePlane_12(
            src_v,
            src_stride_v,
            src_halfwidth,
            src_height,
            dst_v,
            dst_stride_v,
            dst_halfwidth,
            dst_height,
            filtering
        );
    return r;
}

NV12Scale :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_uv == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_uv == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    src_halfwidth := (ifx src_width < 0 then -((-src_width + 1) >> 1) else (src_width + 1) >> 1);
    src_halfheight := (ifx src_height < 0 then -((-src_height + 1) >> 1) else (src_height + 1) >> 1);
    dst_halfwidth := (ifx dst_width < 0 then -((-dst_width + 1) >> 1) else (dst_width + 1) >> 1);
    dst_halfheight := (ifx dst_height < 0 then -((-dst_height + 1) >> 1) else (dst_height + 1) >> 1);

    r := ScalePlane(src_y, src_stride_y, src_width, src_height, dst_y, dst_stride_y, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r =
        UVScale(
            src_uv,
            src_stride_uv,
            src_halfwidth,
            src_halfheight,
            dst_uv,
            dst_stride_uv,
            dst_halfwidth,
            dst_halfheight,
            filtering
        );
    return r;
}

NV24Scale :: (
    src_y: *u8,
    src_stride_y: s32,
    src_uv: *u8,
    src_stride_uv: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_stride_y: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_y == null ||
        src_uv == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_y == null ||
        dst_uv == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    r := ScalePlane(src_y, src_stride_y, src_width, src_height, dst_y, dst_stride_y, dst_width, dst_height, filtering);
    if r != 0 {
        return r;
    }
    r = UVScale(src_uv, src_stride_uv, src_width, src_height, dst_uv, dst_stride_uv, dst_width, dst_height, filtering);
    return r;
}

Scale :: (
    src_y: *u8,
    src_u: *u8,
    src_v: *u8,
    src_stride_y: s32,
    src_stride_u: s32,
    src_stride_v: s32,
    src_width: s32,
    src_height: s32,
    dst_y: *u8,
    dst_u: *u8,
    dst_v: *u8,
    dst_stride_y: s32,
    dst_stride_u: s32,
    dst_stride_v: s32,
    dst_width: s32,
    dst_height: s32,
    interpolate: s32
) -> s32 {
    return I420Scale(
        src_y,
        src_stride_y,
        src_u,
        src_stride_u,
        src_v,
        src_stride_v,
        src_width,
        src_height,
        dst_y,
        dst_stride_y,
        dst_u,
        dst_stride_u,
        dst_v,
        dst_stride_v,
        dst_width,
        dst_height,
        (ifx interpolate != 0 then K_FILTER_BOX else K_FILTER_NONE)
    );
}

test_cpu_flag_in_scale :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_scale :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_scale: u32;
initialize_globals_for_scale :: () {
    {
        state := atomic_load(*globals_initialization_state_for_scale);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_scale, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_scale) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_scale = 0x1;
    K_CPU_HAS_ARM_in_scale = 0x2;
    K_CPU_HAS_NEON_in_scale = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_scale = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_scale = 0x400;
    K_CPU_HAS_SVE_in_scale = 0x800;
    K_CPU_HAS_SVE2_in_scale = 0x1000;
    K_CPU_HAS_SME_in_scale = 0x2000;
    K_CPU_HAS_SME2_in_scale = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_scale = 0x8000;
    K_CPU_HAS_RISCV_in_scale = 0x4;
    K_CPU_HAS_RVV_in_scale = 0x100;
    K_CPU_HAS_RVVZVFH_in_scale = 0x200;
    K_CPU_HAS_X86_in_scale = 0x8;
    K_CPU_HAS_SSE2_in_scale = 0x100;
    K_CPU_HAS_SSSE3_in_scale = 0x200;
    K_CPU_HAS_SSE41_in_scale = 0x400;
    K_CPU_HAS_SSE42_in_scale = 0x800;
    K_CPU_HAS_AVX_in_scale = 0x1000;
    K_CPU_HAS_AVX2_in_scale = 0x2000;
    K_CPU_HAS_ERMS_in_scale = 0x4000;
    K_CPU_HAS_FSMR_in_scale = 0x8000;
    K_CPU_HAS_FMA3_in_scale = 0x10000;
    K_CPU_HAS_F16_C_in_scale = 0x20000;
    K_CPU_HAS_AVX512_BW_in_scale = 0x40000;
    K_CPU_HAS_AVX512_VL_in_scale = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_scale = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_scale = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_scale = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_scale = 0x800000;
    K_CPU_HAS_AVX10_in_scale = 0x1000000;
    K_CPU_HAS_AVX10_2_in_scale = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_scale = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_scale = 0x8000000;
    K_CPU_HAS_AMXINT8_in_scale = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_scale = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_scale = 0x20;
    K_CPU_HAS_LSX_in_scale = 0x100;
    K_CPU_HAS_LASX_in_scale = 0x200;
    atomic_store(*globals_initialization_state_for_scale, 2);
}

