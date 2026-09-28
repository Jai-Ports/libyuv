K_CPU_INITIALIZED_in_rotate: s32;

K_CPU_HAS_ARM_in_rotate: s32;

K_CPU_HAS_NEON_in_rotate: s32;

K_CPU_HAS_NEON_DOT_PROD_in_rotate: s32;

K_CPU_HAS_NEON_I8_MM_in_rotate: s32;

K_CPU_HAS_SVE_in_rotate: s32;

K_CPU_HAS_SVE2_in_rotate: s32;

K_CPU_HAS_SME_in_rotate: s32;

K_CPU_HAS_SME2_in_rotate: s32;

K_CPU_HAS_SVEF32_MM_in_rotate: s32;

K_CPU_HAS_RISCV_in_rotate: s32;

K_CPU_HAS_RVV_in_rotate: s32;

K_CPU_HAS_RVVZVFH_in_rotate: s32;

K_CPU_HAS_X86_in_rotate: s32;

K_CPU_HAS_SSE2_in_rotate: s32;

K_CPU_HAS_SSSE3_in_rotate: s32;

K_CPU_HAS_SSE41_in_rotate: s32;

K_CPU_HAS_SSE42_in_rotate: s32;

K_CPU_HAS_AVX_in_rotate: s32;

K_CPU_HAS_AVX2_in_rotate: s32;

K_CPU_HAS_ERMS_in_rotate: s32;

K_CPU_HAS_FSMR_in_rotate: s32;

K_CPU_HAS_FMA3_in_rotate: s32;

K_CPU_HAS_F16_C_in_rotate: s32;

K_CPU_HAS_AVX512_BW_in_rotate: s32;

K_CPU_HAS_AVX512_VL_in_rotate: s32;

K_CPU_HAS_AVX512_VNNI_in_rotate: s32;

K_CPU_HAS_AVX512_VBMI_in_rotate: s32;

K_CPU_HAS_AVX512_VBMI2_in_rotate: s32;

K_CPU_HAS_AVX512_VBITALG_in_rotate: s32;

K_CPU_HAS_AVX10_in_rotate: s32;

K_CPU_HAS_AVX10_2_in_rotate: s32;

K_CPU_HAS_AVXVNNI_in_rotate: s32;

K_CPU_HAS_AVXVNNIINT8_in_rotate: s32;

K_CPU_HAS_AMXINT8_in_rotate: s32;

K_CPU_HAS_AVX512_BMM_in_rotate: s32;

K_CPU_HAS_LOONGARCH_in_rotate: s32;

K_CPU_HAS_LSX_in_rotate: s32;

K_CPU_HAS_LASX_in_rotate: s32;

I420Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    if src_y == null && dst_y != null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            return i420_copy(
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
                height
            );
        case cast,no_check(s32) K_ROTATE90;
            RotatePlane90(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane90(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            RotatePlane90(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            RotatePlane270(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane270(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            RotatePlane270(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            RotatePlane180(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane180(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            RotatePlane180(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case;
    }
    return -1;
}

RotatePlane180 :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32, height: s32) {
    row_mem_size := cast,no_check(u64) width;

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    assert(row != null);
    if row == null {
        return;
    }
    src_bot := cast,no_check(*u8) ((src + (cast,no_check(s64) src_stride) * cast(s64) (height - 1)));
    dst_bot := cast,no_check(*u8) ((dst + (cast,no_check(s64) dst_stride) * cast(s64) (height - 1)));
    half_height := (height + 1) >> 1;

    mirror_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) MirrorRow_C;
    copy_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) CopyRow_C;

    if 0 < half_height {
        for y: 0..half_height - 1 {
            copy_row(src, row, width);
            mirror_row(src_bot, dst, width);
            mirror_row(row, dst_bot, width);
            src += src_stride;
            dst += dst_stride;
            src_bot -= src_stride;
            dst_bot -= dst_stride;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
}

RotatePlane270 :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32, height: s32) {
    dst += (cast,no_check(s64) dst_stride) * cast(s64) (width - 1);
    dst_stride = -dst_stride;
    TransposePlane(src, src_stride, dst, dst_stride, width, height);
}

TransposePlane :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32, height: s32) {
    i := height;

    transpose_wx8: #type (_: *u8, _: s32, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32, _: s32)) TransposeWx8_C;

    while i >= 8 {
        transpose_wx8(src, src_stride, dst, dst_stride, width);
        src += 8 * src_stride;
        dst += 8;
        i -= 8;
    }

    if i > 0 {
        TransposeWxH_C(src, src_stride, dst, dst_stride, width, i);
    }
}

RotatePlane90 :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32, height: s32) {
    src += (cast,no_check(s64) src_stride) * cast(s64) (height - 1);
    src_stride = -src_stride;
    TransposePlane(src, src_stride, dst, dst_stride, width, height);
}

I422Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    r: s32 = ---;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            CopyPlane(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
            CopyPlane(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            RotatePlane90(src_u, src_stride_u, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_u,
                    dst_stride_u,
                    halfheight,
                    width,
                    K_FILTER_BILINEAR
                );
            if r != 0 {
                return r;
            }
            RotatePlane90(src_v, src_stride_v, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_v,
                    dst_stride_v,
                    halfheight,
                    width,
                    K_FILTER_LINEAR
                );
            if r != 0 {
                return r;
            }
            RotatePlane90(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            RotatePlane270(src_u, src_stride_u, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_u,
                    dst_stride_u,
                    halfheight,
                    width,
                    K_FILTER_BILINEAR
                );
            if r != 0 {
                return r;
            }
            RotatePlane270(src_v, src_stride_v, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_v,
                    dst_stride_v,
                    halfheight,
                    width,
                    K_FILTER_LINEAR
                );
            if r != 0 {
                return r;
            }
            RotatePlane270(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            RotatePlane180(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane180(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
            RotatePlane180(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
            return 0;
        case;
    }
    return -1;
}

I444Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            CopyPlane(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            CopyPlane(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            RotatePlane90(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane90(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            RotatePlane90(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            RotatePlane270(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane270(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            RotatePlane270(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            RotatePlane180(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            RotatePlane180(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            RotatePlane180(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case;
    }
    return -1;
}

I010Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_stride_y < 0 {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            return i010_copy(
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
                height
            );
        case cast,no_check(s32) K_ROTATE90;
            rotate_plane90_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane90_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            rotate_plane90_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            rotate_plane270_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane270_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            rotate_plane270_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            rotate_plane180_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane180_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight);
            rotate_plane180_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case;
    }
    return -1;
}

rotate_plane180_16 :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32, height: s32) {
    src_bot := cast,no_check(*u16) ((src + (cast,no_check(s64) src_stride) * cast(s64) (height - 1)));
    dst_bot := cast,no_check(*u16) ((dst + (cast,no_check(s64) dst_stride) * cast(s64) (height - 1)));
    half_height := (height + 1) >> 1;

    row_mem_size := cast,no_check(u64) (width * 2);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    row_tmp := cast,no_check(*u16) (cast(*u16) row);
    assert(row != null);
    if row == null {
        return;
    }

    if 0 < half_height {
        for y: 0..half_height - 1 {
            CopyRow_16_C(src, row_tmp, width);
            MirrorRow_16_C(src_bot, dst, width);
            MirrorRow_16_C(row_tmp, dst_bot, width);
            src += src_stride;
            dst += dst_stride;
            src_bot -= src_stride;
            dst_bot -= dst_stride;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
}

rotate_plane270_16 :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32, height: s32) {
    dst += (cast,no_check(s64) dst_stride) * cast(s64) (width - 1);
    dst_stride = -dst_stride;
    transpose_plane_16(src, src_stride, dst, dst_stride, width, height);
}

transpose_plane_16 :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32, height: s32) {
    i := height;

    while i >= 8 {
        TransposeWx8_16_C(src, src_stride, dst, dst_stride, width);
        src += 8 * src_stride;
        dst += 8;
        i -= 8;
    }

    if i > 0 {
        TransposeWxH_16_C(src, src_stride, dst, dst_stride, width, i);
    }
}

rotate_plane90_16 :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32, height: s32) {
    src += (cast,no_check(s64) src_stride) * cast(s64) (height - 1);
    src_stride = -src_stride;
    transpose_plane_16(src, src_stride, dst, dst_stride, width, height);
}

I210Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    r: s32 = ---;
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            CopyPlane_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
            CopyPlane_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            rotate_plane90_16(src_u, src_stride_u, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane_16(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_u,
                    dst_stride_u,
                    halfheight,
                    width,
                    K_FILTER_BILINEAR
                );
            if r != 0 {
                return r;
            }
            rotate_plane90_16(src_v, src_stride_v, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane_16(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_v,
                    dst_stride_v,
                    halfheight,
                    width,
                    K_FILTER_LINEAR
                );
            if r != 0 {
                return r;
            }
            rotate_plane90_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            rotate_plane270_16(src_u, src_stride_u, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane_16(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_u,
                    dst_stride_u,
                    halfheight,
                    width,
                    K_FILTER_BILINEAR
                );
            if r != 0 {
                return r;
            }
            rotate_plane270_16(src_v, src_stride_v, dst_y, dst_stride_y, halfwidth, height);
            r =
                ScalePlane_16(
                    dst_y,
                    dst_stride_y,
                    height,
                    halfwidth,
                    dst_v,
                    dst_stride_v,
                    halfheight,
                    width,
                    K_FILTER_LINEAR
                );
            if r != 0 {
                return r;
            }
            rotate_plane270_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            rotate_plane180_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane180_16(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, height);
            rotate_plane180_16(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, height);
            return 0;
        case;
    }
    return -1;
}

I410Rotate :: (
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
    mode: Rotation_Mode
) -> s32 {
    if src_y == null ||
        src_u == null ||
        src_v == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null ||
        dst_stride_y < 0 {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            CopyPlane_16(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            CopyPlane_16(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            rotate_plane90_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane90_16(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            rotate_plane90_16(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            rotate_plane270_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane270_16(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            rotate_plane270_16(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            rotate_plane180_16(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            rotate_plane180_16(src_u, src_stride_u, dst_u, dst_stride_u, width, height);
            rotate_plane180_16(src_v, src_stride_v, dst_v, dst_stride_v, width, height);
            return 0;
        case;
    }
    return -1;
}

NV12ToI420Rotate :: (
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
    height: s32,
    mode: Rotation_Mode
) -> s32 {
    halfwidth := (width + 1) >> 1;
    halfheight := (height + 1) >> 1;
    if src_y == null ||
        src_uv == null ||
        width <= 0 ||
        height == 0 ||
        height == -2147483647 - 1 ||
        dst_y == null ||
        dst_u == null ||
        dst_v == null {
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

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            return nv12_to_i420(
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
                height
            );
        case cast,no_check(s32) K_ROTATE90;
            RotatePlane90(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            SplitRotateUV90(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            RotatePlane270(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            SplitRotateUV270(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            RotatePlane180(src_y, src_stride_y, dst_y, dst_stride_y, width, height);
            SplitRotateUV180(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, halfwidth, halfheight);
            return 0;
        case;
    }
    return -1;
}

SplitRotateUV180 :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    mirror_split_uv_row: #type (_: *u8, _: *u8, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32)) MirrorSplitUVRow_C;

    dst_a += dst_stride_a * (height - 1);
    dst_b += dst_stride_b * (height - 1);

    if 0 < height {
        for i: 0..height - 1 {
            mirror_split_uv_row(src, dst_a, dst_b, width);
            src += src_stride;
            dst_a -= dst_stride_a;
            dst_b -= dst_stride_b;
        }
    }
}

SplitRotateUV270 :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    dst_a += dst_stride_a * (width - 1);
    dst_b += dst_stride_b * (width - 1);
    dst_stride_a = -dst_stride_a;
    dst_stride_b = -dst_stride_b;

    SplitTransposeUV(src, src_stride, dst_a, dst_stride_a, dst_b, dst_stride_b, width, height);
}

SplitTransposeUV :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    i := height;

    transpose_uv_wx8: #type (_: *u8, _: s32, _: *u8, _: s32, _: *u8, _: s32, _: s32) =
        cast,no_check(#type (_: *u8, _: s32, _: *u8, _: s32, _: *u8, _: s32, _: s32)) TransposeUVWx8_C;

    while i >= 8 {
        transpose_uv_wx8(src, src_stride, dst_a, dst_stride_a, dst_b, dst_stride_b, width);
        src += 8 * src_stride;
        dst_a += 8;
        dst_b += 8;
        i -= 8;
    }

    if i > 0 {
        TransposeUVWxH_C(src, src_stride, dst_a, dst_stride_a, dst_b, dst_stride_b, width, i);
    }
}

SplitRotateUV90 :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    src += (cast,no_check(s64) src_stride) * cast(s64) (height - 1);
    src_stride = -src_stride;

    SplitTransposeUV(src, src_stride, dst_a, dst_stride_a, dst_b, dst_stride_b, width, height);
}

Android420ToI420Rotate :: (
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
    height: s32,
    rotation: Rotation_Mode
) -> s32 {
    y: s32 = ---;
    VU_OFF := src_v - src_u;
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
        RotatePlane(src_y, src_stride_y, dst_y, dst_stride_y, width, height, rotation);
    }

    if src_pixel_stride_uv == 1 {
        RotatePlane(src_u, src_stride_u, dst_u, dst_stride_u, halfwidth, halfheight, rotation);
        RotatePlane(src_v, src_stride_v, dst_v, dst_stride_v, halfwidth, halfheight, rotation);
        return 0;
    }

    if src_pixel_stride_uv == 2 && VU_OFF == -1 && src_stride_u == src_stride_v {
        SplitRotateUV(src_v, src_stride_v, dst_v, dst_stride_v, dst_u, dst_stride_u, halfwidth, halfheight, rotation);
        return 0;
    }

    if src_pixel_stride_uv == 2 && VU_OFF == 1 && src_stride_u == src_stride_v {
        SplitRotateUV(src_u, src_stride_u, dst_u, dst_stride_u, dst_v, dst_stride_v, halfwidth, halfheight, rotation);
        return 0;
    }

    if cast,no_check(s32) rotation == 0 {
        y = 0;
        while y < halfheight {
            split_pixels(src_u, src_pixel_stride_uv, dst_u, halfwidth);
            split_pixels(src_v, src_pixel_stride_uv, dst_v, halfwidth);
            src_u += src_stride_u;
            src_v += src_stride_v;
            dst_u += dst_stride_u;
            dst_v += dst_stride_v;
            y += 1;
        }
        return 0;
    }

    return -1;
}

split_pixels :: (src_u: *u8, src_pixel_stride_uv: s32, dst_u: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst_u.* = src_u.*;
            dst_u += 1;
            src_u += src_pixel_stride_uv;
        }
    }
}

SplitRotateUV :: (
    src_uv: *u8,
    src_stride_uv: s32,
    dst_u: *u8,
    dst_stride_u: s32,
    dst_v: *u8,
    dst_stride_v: s32,
    width: s32,
    height: s32,
    mode: Rotation_Mode
) -> s32 {
    if src_uv == null || width <= 0 || height == 0 || height == -2147483647 - 1 || dst_u == null || dst_v == null {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_uv = cast,no_check(*u8) ((src_uv + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_uv));
        src_stride_uv = -src_stride_uv;
    }

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            SplitUVPlane(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            SplitRotateUV90(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            SplitRotateUV270(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            SplitRotateUV180(src_uv, src_stride_uv, dst_u, dst_stride_u, dst_v, dst_stride_v, width, height);
            return 0;
        case;
    }
    return -1;
}

RotatePlane :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    width: s32,
    height: s32,
    mode: Rotation_Mode
) -> s32 {
    if src == null || width <= 0 || height == 0 || height == -2147483647 - 1 || dst == null {
        return -1;
    }

    if height < 0 {
        height = -height;
        src = cast,no_check(*u8) ((src + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride));
        src_stride = -src_stride;
    }

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            RotatePlane90(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            RotatePlane270(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            RotatePlane180(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case;
    }
    return -1;
}

RotatePlane_16 :: (
    src: *u16,
    src_stride: s32,
    dst: *u16,
    dst_stride: s32,
    width: s32,
    height: s32,
    mode: Rotation_Mode
) -> s32 {
    if src == null || width <= 0 || height == 0 || height == -2147483647 - 1 || dst == null {
        return -1;
    }

    if height < 0 {
        height = -height;
        src = cast,no_check(*u16) ((src + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride));
        src_stride = -src_stride;
    }

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            CopyPlane_16(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE90;
            rotate_plane90_16(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE270;
            rotate_plane270_16(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case cast,no_check(s32) K_ROTATE180;
            rotate_plane180_16(src, src_stride, dst, dst_stride, width, height);
            return 0;
        case;
    }
    return -1;
}

test_cpu_flag_in_rotate :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_rotate :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_rotate: u32;
initialize_globals_for_rotate :: () {
    {
        state := atomic_load(*globals_initialization_state_for_rotate);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_rotate, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_rotate) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_rotate = 0x1;
    K_CPU_HAS_ARM_in_rotate = 0x2;
    K_CPU_HAS_NEON_in_rotate = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_rotate = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_rotate = 0x400;
    K_CPU_HAS_SVE_in_rotate = 0x800;
    K_CPU_HAS_SVE2_in_rotate = 0x1000;
    K_CPU_HAS_SME_in_rotate = 0x2000;
    K_CPU_HAS_SME2_in_rotate = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_rotate = 0x8000;
    K_CPU_HAS_RISCV_in_rotate = 0x4;
    K_CPU_HAS_RVV_in_rotate = 0x100;
    K_CPU_HAS_RVVZVFH_in_rotate = 0x200;
    K_CPU_HAS_X86_in_rotate = 0x8;
    K_CPU_HAS_SSE2_in_rotate = 0x100;
    K_CPU_HAS_SSSE3_in_rotate = 0x200;
    K_CPU_HAS_SSE41_in_rotate = 0x400;
    K_CPU_HAS_SSE42_in_rotate = 0x800;
    K_CPU_HAS_AVX_in_rotate = 0x1000;
    K_CPU_HAS_AVX2_in_rotate = 0x2000;
    K_CPU_HAS_ERMS_in_rotate = 0x4000;
    K_CPU_HAS_FSMR_in_rotate = 0x8000;
    K_CPU_HAS_FMA3_in_rotate = 0x10000;
    K_CPU_HAS_F16_C_in_rotate = 0x20000;
    K_CPU_HAS_AVX512_BW_in_rotate = 0x40000;
    K_CPU_HAS_AVX512_VL_in_rotate = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_rotate = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_rotate = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_rotate = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_rotate = 0x800000;
    K_CPU_HAS_AVX10_in_rotate = 0x1000000;
    K_CPU_HAS_AVX10_2_in_rotate = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_rotate = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_rotate = 0x8000000;
    K_CPU_HAS_AMXINT8_in_rotate = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_rotate = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_rotate = 0x20;
    K_CPU_HAS_LSX_in_rotate = 0x100;
    K_CPU_HAS_LASX_in_rotate = 0x200;
    atomic_store(*globals_initialization_state_for_rotate, 2);
}

