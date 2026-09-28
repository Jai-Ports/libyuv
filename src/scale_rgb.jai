// Generated directly from C++ by cpp_transpiler.
rgb_scale :: (
    src_rgb: *u8,
    src_stride_rgb: s32,
    src_width: s32,
    src_height: s32,
    dst_rgb: *u8,
    dst_stride_rgb: s32,
    dst_width: s32,
    dst_height: s32,
    filtering: Filter_Mode
) -> s32 {
    if src_rgb == null ||
        dst_rgb == null ||
        src_width <= 0 ||
        src_width > 2147483647 / 4 ||
        src_height == 0 ||
        src_height == -2147483647 - 1 ||
        dst_width <= 0 ||
        dst_width > 2147483647 / 4 ||
        dst_height <= 0 {
        return -1;
    }
    ABS_SRC_HEIGHT := (ifx src_height < 0 then -src_height else src_height);
    SRC_ARGB_SIZE := ((cast,no_check(u64) src_width) * cast,no_check(u64) ABS_SRC_HEIGHT) * 4;
    DST_ARGB_SIZE := ((cast,no_check(u64) dst_width) * cast,no_check(u64) dst_height) * 4;
    if SRC_ARGB_SIZE > (cast(u64) 18446744073709551615) - DST_ARGB_SIZE {
        return -1;
    }
    ARGB_SIZE := SRC_ARGB_SIZE + DST_ARGB_SIZE;

    src_argb := cast,no_check(*u8) (cast(*u8) c_transpiler_allocate_memory(ARGB_SIZE));
    if src_argb == null {
        return 1;
    }
    dst_argb := cast,no_check(*u8) ((src_argb + SRC_ARGB_SIZE));

    r := RGB24ToARGB(src_rgb, src_stride_rgb, src_argb, src_width * 4, src_width, src_height);
    if r == 0 {
        r =
            argb_scale(
                src_argb,
                src_width * 4,
                src_width,
                ABS_SRC_HEIGHT,
                dst_argb,
                dst_width * 4,
                dst_width,
                dst_height,
                filtering
            );
        if r == 0 {
            r = ARGBToRGB24(dst_argb, dst_width * 4, dst_rgb, dst_stride_rgb, dst_width, dst_height);
        }
    }
    c_transpiler_deallocate_memory(src_argb);
    return r;
}

