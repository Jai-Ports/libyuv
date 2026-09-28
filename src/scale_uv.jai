// Generated directly from C++ by cpp_transpiler.
K_CPU_INITIALIZED_in_scale_uv: s32;

K_CPU_HAS_ARM_in_scale_uv: s32;

K_CPU_HAS_NEON_in_scale_uv: s32;

K_CPU_HAS_NEON_DOT_PROD_in_scale_uv: s32;

K_CPU_HAS_NEON_I8_MM_in_scale_uv: s32;

K_CPU_HAS_SVE_in_scale_uv: s32;

K_CPU_HAS_SVE2_in_scale_uv: s32;

K_CPU_HAS_SME_in_scale_uv: s32;

K_CPU_HAS_SME2_in_scale_uv: s32;

K_CPU_HAS_SVEF32_MM_in_scale_uv: s32;

K_CPU_HAS_RISCV_in_scale_uv: s32;

K_CPU_HAS_RVV_in_scale_uv: s32;

K_CPU_HAS_RVVZVFH_in_scale_uv: s32;

K_CPU_HAS_X86_in_scale_uv: s32;

K_CPU_HAS_SSE2_in_scale_uv: s32;

K_CPU_HAS_SSSE3_in_scale_uv: s32;

K_CPU_HAS_SSE41_in_scale_uv: s32;

K_CPU_HAS_SSE42_in_scale_uv: s32;

K_CPU_HAS_AVX_in_scale_uv: s32;

K_CPU_HAS_AVX2_in_scale_uv: s32;

K_CPU_HAS_ERMS_in_scale_uv: s32;

K_CPU_HAS_FSMR_in_scale_uv: s32;

K_CPU_HAS_FMA3_in_scale_uv: s32;

K_CPU_HAS_F16_C_in_scale_uv: s32;

K_CPU_HAS_AVX512_BW_in_scale_uv: s32;

K_CPU_HAS_AVX512_VL_in_scale_uv: s32;

K_CPU_HAS_AVX512_VNNI_in_scale_uv: s32;

K_CPU_HAS_AVX512_VBMI_in_scale_uv: s32;

K_CPU_HAS_AVX512_VBMI2_in_scale_uv: s32;

K_CPU_HAS_AVX512_VBITALG_in_scale_uv: s32;

K_CPU_HAS_AVX10_in_scale_uv: s32;

K_CPU_HAS_AVX10_2_in_scale_uv: s32;

K_CPU_HAS_AVXVNNI_in_scale_uv: s32;

K_CPU_HAS_AVXVNNIINT8_in_scale_uv: s32;

K_CPU_HAS_AMXINT8_in_scale_uv: s32;

K_CPU_HAS_AVX512_BMM_in_scale_uv: s32;

K_CPU_HAS_LOONGARCH_in_scale_uv: s32;

K_CPU_HAS_LSX_in_scale_uv: s32;

K_CPU_HAS_LASX_in_scale_uv: s32;

UVScale :: (
    src_uv: *u8,
    src_stride_uv: s32,
    src_width: s32,
    src_height: s32,
    dst_uv: *u8,
    dst_stride_uv: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_uv == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_width > 32768 ||
        src_height < -32768 ||
        src_height > 32768 ||
        dst_uv == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }
    return scale_uv(
        src_uv,
        src_stride_uv,
        src_width,
        src_height,
        dst_uv,
        dst_stride_uv,
        dst_width,
        dst_height,
        0,
        0,
        dst_width,
        dst_height,
        filtering
    );
}

scale_uv :: (
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
    src_width = abs_in_scale_uv(src_width);
    if clip_x != 0 {
        clipf := (cast,no_check(s64) clip_x) * cast(s64) dx;
        x = cast,no_check(s32) ((cast,no_check(s64) x) + (clipf & 0xffff));
        src += clipf >> 16 * 2;
        dst += clip_x * 2;
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
                    scale_uv_down2(
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
                    return scale_uv_down4_box(
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

                scale_uv_down_even(
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
                    return uv_copy(
                        (src + (cast(s64) (y >> 16)) * cast,no_check(s64) src_stride) + x >> 16 * 2,
                        src_stride,
                        dst,
                        dst_stride,
                        clip_width,
                        clip_height
                    );
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
            2,
            filtering
        );
        return 0;
    }
    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR && (dst_width + 1) / 2 == src_width {
        scale_uv_linear_up2(
            src_width,
            src_height,
            clip_width,
            clip_height,
            cast,no_check(s64) src_stride,
            cast,no_check(s64) dst_stride,
            src,
            dst
        );
        return 0;
    }
    if (clip_height + 1) / 2 == src_height &&
        (clip_width + 1) / 2 == src_width &&
        (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR ||
            cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX) {
        scale_uv_bilinear_up2(src_width, src_height, clip_width, clip_height, src_stride, dst_stride, src, dst);
        return 0;
    }

    if filtering != 0 && dy < 65536 {
        return scale_uv_bilinear_up(
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
        return scale_uv_bilinear_down(
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

    scale_uv_simple(
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

scale_uv_simple :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32
) {
    scale_uv_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleUVCols64_C else ScaleUVCols_C);

    if src_width * 2 == dst_width && x < 0x8000 {
        scale_uv_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleUVColsUp2_C;
    }

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_uv_cols(dst_uv, src_uv + (cast(s64) (y >> 16)) * src_stride, dst_width, x, dx);
            dst_uv += dst_stride;
            y += dy;
        }
    }
}

scale_uv_bilinear_down :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) -> s32 {
    j: s32 = ---;
    interpolate_row: #type (_: *u8, _: *u8, _: s64, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s64, _: s32, _: s32)) InterpolateRow_C;
    scale_uv_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx src_width >= 32768 then ScaleUVFilterCols64_C else ScaleUVFilterCols_C);
    xlast := (cast(s64) x) + (cast,no_check(s64) (dst_width - 1)) * cast(s64) dx;
    xl := (ifx dx >= 0 then cast,no_check(s64) x else xlast);
    xr := (ifx dx >= 0 then xlast else cast,no_check(s64) x);

    xl = xl >> 16 & cast,no_check(s64) (~(cast(s32) 3));
    xr = xr >> 16 + 1;
    xr = ((xr + 1) + 3) & cast,no_check(s64) (~(cast(s32) 3));
    if xr > cast,no_check(s64) src_width {
        xr = cast,no_check(s64) src_width;
    }
    clip_src_width := (cast,no_check(s32) (xr - xl)) * 2;
    src_uv += xl * 2;
    x -= cast,no_check(s32) (xl << 16);

    {
        MAX_Y := (src_height - 1) << 16;
        row_mem_size := cast,no_check(u64) (clip_src_width * 2);

        row_mem: *void =
            cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
                63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

        row :=
            cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
                63) & cast,no_check(s64) (~(cast(s32) 63)))));
        if row == null {
            return 1;
        }
        if y > MAX_Y {
            y = MAX_Y;
        }
        j = 0;
        while j < dst_height {
            yi := y >> 16;
            src := cast,no_check(*u8) ((src_uv + (cast(s64) yi) * src_stride));
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                scale_uv_filter_cols(dst_uv, src, dst_width, x, dx);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(row, src, src_stride, clip_src_width, yf);
                scale_uv_filter_cols(dst_uv, row, dst_width, x, dx);
            }
            dst_uv += dst_stride;
            y += dy;
            if y > MAX_Y {
                y = MAX_Y;
            }
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_uv_bilinear_up :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
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
    scale_uv_filter_cols: #type (_: *u8, _: *u8, _: s32, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleUVFilterCols_C else ScaleUVCols_C);
    MAX_Y := (src_height - 1) << 16;

    if src_width >= 32768 {
        scale_uv_filter_cols =
            cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) (ifx filtering != 0 then ScaleUVFilterCols64_C else ScaleUVCols64_C);
    }

    if !(filtering != 0) && src_width * 2 == dst_width && x < 0x8000 {
        scale_uv_filter_cols = cast,no_check(#type (_: *u8, _: *u8, _: s32, _: s32, _: s32)) ScaleUVColsUp2_C;
    }

    if y > MAX_Y {
        y = MAX_Y;
    }

    {
        yi := y >> 16;
        src := cast,no_check(*u8) ((src_uv + (cast(s64) yi) * src_stride));

        ROW_SIZE := (dst_width * 2 + 15) & ~(cast(s32) 15);
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

        scale_uv_filter_cols(rowptr, src, dst_width, x, dx);
        if src_height > 1 {
            src += src_stride;
        }
        scale_uv_filter_cols(rowptr + rowstride, src, dst_width, x, dx);
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
                scale_uv_filter_cols(rowptr, src, dst_width, x, dx);
                rowptr += rowstride;
                rowstride = -rowstride;
                lasty = yi;
                if y + 65536 < MAX_Y {
                    src += src_stride;
                }
            }
            if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
                interpolate_row(dst_uv, rowptr, 0, dst_width * 2, 0);
            } else {
                yf := y >> 8 & 255;
                interpolate_row(dst_uv, rowptr, rowstride, dst_width * 2, yf);
            }
            dst_uv += dst_stride;
            y += dy;
            j += 1;
        }
        c_transpiler_deallocate_memory(row_mem);

        row = cast,no_check(*u8) (cast(*u8) null);
    }
    return 0;
}

scale_uv_bilinear_up2 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s32,
    dst_stride: s32,
    src_ptr: *u8,
    dst_ptr: *u8
) {
    scale2_row_up: #type (_: *u8, _: s64, _: *u8, _: s64, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: s32)) ScaleUVRowUp2_Bilinear_Any_C;

    assert(src_width == (dst_width + 1) / 2);
    assert(src_height == (dst_height + 1) / 2);

    scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    dst_ptr += dst_stride;
    x: s32 = 0;
    while x < src_height - 1 {
        scale2_row_up(src_ptr, cast,no_check(s64) src_stride, dst_ptr, cast,no_check(s64) dst_stride, dst_width);
        src_ptr += src_stride;

        dst_ptr += 2 * dst_stride;
        x += 1;
    }
    if dst_height & 1 == 0 {
        scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    }
}

scale_uv_linear_up2 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8
) {
    scale_row_up: #type (_: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: s32)) ScaleUVRowUp2_Linear_Any_C;
    i: s32 = ---;
    y: s32 = ---;
    dy: s32 = ---;

    assert(src_width == (dst_width + 1) / 2);

    if dst_height == 1 {
        scale_row_up(src_uv + (cast(s64) ((src_height - 1) / 2)) * src_stride, dst_uv, dst_width);
    } else {
        dy = FixedDiv_C(src_height - 1, dst_height - 1);
        y = (cast(s32) 1) << 15 - 1;
        i = 0;
        while i < dst_height {
            scale_row_up(src_uv + (cast(s64) (y >> 16)) * src_stride, dst_uv, dst_width);
            dst_uv += dst_stride;
            y += dy;
            i += 1;
        }
    }
}

uv_copy :: (src_uv: *u8, src_stride_uv: s32, dst_uv: *u8, dst_stride_uv: s32, width: s32, height: s32) -> s32 {
    if src_uv == null || dst_uv == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uv = cast,no_check(*u8) ((src_uv + (cast(s64) (height - 1)) * cast,no_check(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    CopyPlane(src_uv, src_stride_uv, dst_uv, dst_stride_uv, width * 2, height);
    return 0;
}

scale_uv_down_even :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) {
    col_step := dx >> 16;
    row_stride := (cast(s64) (dy >> 16)) * src_stride;
    scale_uv_row_down_even: #type (_: *u8, _: s64, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: s32, _: *u8, _: s32)) (ifx filtering != 0 then ScaleUVRowDownEvenBox_C else ScaleUVRowDownEven_C);

    assert((cast,no_check(u64) src_width) & cast,no_check(u64) (2 - 1) == 0);
    assert((cast,no_check(u64) src_height) & cast,no_check(u64) (2 - 1) == 0);
    src_uv += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 2);

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_uv_row_down_even(src_uv, src_stride, col_step, dst_uv, dst_width);
            src_uv += row_stride;
            dst_uv += dst_stride;
        }
    }
}

scale_uv_down4_box :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32
) -> s32 {
    ROW_SIZE := (dst_width * 2 * 2 + 15) & ~(cast(s32) 15);
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
    scale_uv_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) ScaleUVRowDown2Box_C;

    src_uv += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 2);

    assert(dx == 65536 * 4);
    assert(dy & 0x3ffff == 0);

    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_uv_row_down2(src_uv, src_stride, row, dst_width * 2);
            scale_uv_row_down2(src_uv + src_stride * 2, src_stride, row + ROW_SIZE, dst_width * 2);
            scale_uv_row_down2(row, cast,no_check(s64) ROW_SIZE, dst_uv, dst_width);
            src_uv += row_stride;
            dst_uv += dst_stride;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

scale_uv_down2 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u8,
    dst_uv: *u8,
    x: s32,
    dx: s32,
    y: s32,
    dy: s32,
    filtering: Filter_Mode
) {
    row_stride := src_stride * cast(s64) (dy >> 16);
    scale_uv_row_down2: #type (_: *u8, _: s64, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s32)) (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_NONE then ScaleUVRowDown2_C else (ifx cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR then ScaleUVRowDown2Linear_C else ScaleUVRowDown2Box_C));

    assert(dx == 65536 * 2);
    assert(dy & 0x1ffff == 0);

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR {
        src_uv += (cast(s64) (y >> 16)) * src_stride + cast(s64) (x >> 16 * 2);
    } else {
        src_uv += (cast(s64) (y >> 16)) * src_stride + cast(s64) ((x >> 16 - 1) * 2);
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR {
        src_stride = 0;
    }
    if 0 < dst_height {
        for j: 0..dst_height - 1 {
            scale_uv_row_down2(src_uv, src_stride, dst_uv, dst_width);
            src_uv += row_stride;
            dst_uv += dst_stride;
        }
    }
}

abs_in_scale_uv :: (v: s32) -> s32 {
    return ifx v >= 0 then v else -v;
}

UVScale_16 :: (
    src_uv: *u16,
    src_stride_uv: s32,
    src_width: s32,
    src_height: s32,
    dst_uv: *u16,
    dst_stride_uv: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    dy: s32 = 0;

    if src_uv == null ||
        src_width <= 0 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        src_width > 32768 ||
        src_height > 32768 ||
        dst_uv == null ||
        dst_width <= 0 ||
        dst_height <= 0 {
        return -1;
    }

    filtering = ScaleFilterReduce(src_width, src_height, dst_width, dst_height, filtering);

    if src_height < 0 {
        src_height = -src_height;
        src_uv = cast,no_check(*u16) ((src_uv + (cast(s64) (src_height - 1)) * cast,no_check(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }
    src_width = abs_in_scale_uv(src_width);

    if !(filtering != 0) && src_width == dst_width && src_height % dst_height == 0 {
        if dst_height == 1 {
            return uv_copy_16(
                src_uv + (cast(s64) ((src_height - 1) / 2)) * cast,no_check(s64) src_stride_uv,
                src_stride_uv,
                dst_uv,
                dst_stride_uv,
                dst_width,
                dst_height
            );
        }
        dy = src_height / dst_height;
        if src_stride_uv > 2147483647 / dy {
            return -1;
        }
        return uv_copy_16(
            src_uv + (cast(s64) ((dy - 1) / 2)) * cast,no_check(s64) src_stride_uv,
            dy * src_stride_uv,
            dst_uv,
            dst_stride_uv,
            dst_width,
            dst_height
        );
    }

    if cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_LINEAR && (dst_width + 1) / 2 == src_width {
        scale_uv_linear_up2_16(
            src_width,
            src_height,
            dst_width,
            dst_height,
            cast,no_check(s64) src_stride_uv,
            cast,no_check(s64) dst_stride_uv,
            src_uv,
            dst_uv
        );
        return 0;
    }

    if (dst_height + 1) / 2 == src_height &&
        (dst_width + 1) / 2 == src_width &&
        (cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BILINEAR ||
            cast,no_check(s32) filtering == cast,no_check(s32) K_FILTER_BOX) {
        scale_uv_bilinear_up2_16(
            src_width,
            src_height,
            dst_width,
            dst_height,
            src_stride_uv,
            dst_stride_uv,
            src_uv,
            dst_uv
        );
        return 0;
    }

    return -1;
}

scale_uv_bilinear_up2_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s32,
    dst_stride: s32,
    src_ptr: *u16,
    dst_ptr: *u16
) {
    scale2_row_up: #type (_: *u16, _: s64, _: *u16, _: s64, _: s32) =
        cast,no_check(#type (_: *u16, _: s64, _: *u16, _: s64, _: s32)) ScaleUVRowUp2_Bilinear_16_Any_C;

    assert(src_width == (dst_width + 1) / 2);
    assert(src_height == (dst_height + 1) / 2);

    scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    dst_ptr += dst_stride;
    x: s32 = 0;
    while x < src_height - 1 {
        scale2_row_up(src_ptr, cast,no_check(s64) src_stride, dst_ptr, cast,no_check(s64) dst_stride, dst_width);
        src_ptr += src_stride;

        dst_ptr += 2 * dst_stride;
        x += 1;
    }
    if dst_height & 1 == 0 {
        scale2_row_up(src_ptr, 0, dst_ptr, 0, dst_width);
    }
}

scale_uv_linear_up2_16 :: (
    src_width: s32,
    src_height: s32,
    dst_width: s32,
    dst_height: s32,
    src_stride: s64,
    dst_stride: s64,
    src_uv: *u16,
    dst_uv: *u16
) {
    scale_row_up: #type (_: *u16, _: *u16, _: s32) =
        cast,no_check(#type (_: *u16, _: *u16, _: s32)) ScaleUVRowUp2_Linear_16_Any_C;
    i: s32 = ---;
    y: s32 = ---;
    dy: s32 = ---;

    assert(src_width == (dst_width + 1) / 2);

    if dst_height == 1 {
        scale_row_up(src_uv + (cast(s64) ((src_height - 1) / 2)) * src_stride, dst_uv, dst_width);
    } else {
        dy = FixedDiv_C(src_height - 1, dst_height - 1);
        y = (cast(s32) 1) << 15 - 1;
        i = 0;
        while i < dst_height {
            scale_row_up(src_uv + (cast(s64) (y >> 16)) * src_stride, dst_uv, dst_width);
            dst_uv += dst_stride;
            y += dy;
            i += 1;
        }
    }
}

uv_copy_16 :: (src_uv: *u16, src_stride_uv: s32, dst_uv: *u16, dst_stride_uv: s32, width: s32, height: s32) -> s32 {
    if src_uv == null || dst_uv == null || width <= 0 || height == 0 || height == -2147483647 - 1 {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uv = cast,no_check(*u16) ((src_uv + (cast(s64) (height - 1)) * cast,no_check(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    CopyPlane_16(src_uv, src_stride_uv, dst_uv, dst_stride_uv, width * 2, height);
    return 0;
}

test_cpu_flag_in_scale_uv :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_scale_uv :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_scale_uv: u32;
initialize_globals_for_scale_uv :: () {
    {
        state := atomic_load(*globals_initialization_state_for_scale_uv);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_scale_uv, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_scale_uv) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_scale_uv = 0x1;
    K_CPU_HAS_ARM_in_scale_uv = 0x2;
    K_CPU_HAS_NEON_in_scale_uv = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_scale_uv = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_scale_uv = 0x400;
    K_CPU_HAS_SVE_in_scale_uv = 0x800;
    K_CPU_HAS_SVE2_in_scale_uv = 0x1000;
    K_CPU_HAS_SME_in_scale_uv = 0x2000;
    K_CPU_HAS_SME2_in_scale_uv = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_scale_uv = 0x8000;
    K_CPU_HAS_RISCV_in_scale_uv = 0x4;
    K_CPU_HAS_RVV_in_scale_uv = 0x100;
    K_CPU_HAS_RVVZVFH_in_scale_uv = 0x200;
    K_CPU_HAS_X86_in_scale_uv = 0x8;
    K_CPU_HAS_SSE2_in_scale_uv = 0x100;
    K_CPU_HAS_SSSE3_in_scale_uv = 0x200;
    K_CPU_HAS_SSE41_in_scale_uv = 0x400;
    K_CPU_HAS_SSE42_in_scale_uv = 0x800;
    K_CPU_HAS_AVX_in_scale_uv = 0x1000;
    K_CPU_HAS_AVX2_in_scale_uv = 0x2000;
    K_CPU_HAS_ERMS_in_scale_uv = 0x4000;
    K_CPU_HAS_FSMR_in_scale_uv = 0x8000;
    K_CPU_HAS_FMA3_in_scale_uv = 0x10000;
    K_CPU_HAS_F16_C_in_scale_uv = 0x20000;
    K_CPU_HAS_AVX512_BW_in_scale_uv = 0x40000;
    K_CPU_HAS_AVX512_VL_in_scale_uv = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_scale_uv = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_scale_uv = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_scale_uv = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_scale_uv = 0x800000;
    K_CPU_HAS_AVX10_in_scale_uv = 0x1000000;
    K_CPU_HAS_AVX10_2_in_scale_uv = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_scale_uv = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_scale_uv = 0x8000000;
    K_CPU_HAS_AMXINT8_in_scale_uv = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_scale_uv = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_scale_uv = 0x20;
    K_CPU_HAS_LSX_in_scale_uv = 0x100;
    K_CPU_HAS_LASX_in_scale_uv = 0x200;
    atomic_store(*globals_initialization_state_for_scale_uv, 2);
}

