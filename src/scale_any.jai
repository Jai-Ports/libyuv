// Generated directly from C++ by cpp_transpiler.
ScaleRowUp2_Linear_Any_C :: (src_ptr: *u8, dst_ptr: *u8, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    dst_ptr[0] = src_ptr[0];

    if work_width > 0 {
        if n != 0 {
            ScaleRowUp2_Linear_C(src_ptr, dst_ptr + 1, n);
        }

        ScaleRowUp2_Linear_C(src_ptr + n / 2, dst_ptr + n + 1, r);
    }

    dst_ptr[dst_width - 1] = src_ptr[(dst_width - 1) / 2];
}

ScaleRowUp2_Bilinear_Any_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_stride: s64, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    sa := cast,no_check(*u8) (src_ptr);

    sb := cast,no_check(*u8) ((src_ptr + src_stride));

    da := cast,no_check(*u8) (dst_ptr);

    db := cast,no_check(*u8) ((dst_ptr + dst_stride));

    da[0] = cast,no_check(u8) ((((3 * cast(s32) sa[0]) + cast(s32) sb[0]) + 2) >> 2);

    db[0] = cast,no_check(u8) ((((cast(s32) sa[0]) + 3 * cast(s32) sb[0]) + 2) >> 2);

    if work_width > 0 {
        if n != 0 {
            ScaleRowUp2_Bilinear_C(sa, sb - sa, da + 1, db - da, n);
        }

        ScaleRowUp2_Bilinear_C(sa + n / 2, sb - sa, da + n + 1, db - da, r);
    }

    da[dst_width - 1] =
        cast,no_check(u8) ((((3 * cast(s32) sa[(dst_width - 1) / 2]) + cast(s32) sb[(dst_width - 1) / 2]) +
            2) >> 2);

    db[dst_width - 1] =
        cast,no_check(u8) ((((cast(s32) sa[(dst_width - 1) / 2]) + 3 * cast(s32) sb[(dst_width - 1) / 2]) +
            2) >> 2);
}

ScaleRowUp2_Linear_16_Any_C :: (src_ptr: *u16, dst_ptr: *u16, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    dst_ptr[0] = src_ptr[0];

    if work_width > 0 {
        if n != 0 {
            ScaleRowUp2_Linear_16_C(src_ptr, dst_ptr + 1, n);
        }

        ScaleRowUp2_Linear_16_C(src_ptr + n / 2, dst_ptr + n + 1, r);
    }

    dst_ptr[dst_width - 1] = src_ptr[(dst_width - 1) / 2];
}

ScaleRowUp2_Bilinear_16_Any_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_stride: s64, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    sa := cast,no_check(*u16) (src_ptr);

    sb := cast,no_check(*u16) ((src_ptr + src_stride));

    da := cast,no_check(*u16) (dst_ptr);

    db := cast,no_check(*u16) ((dst_ptr + dst_stride));

    da[0] = cast,no_check(u16) ((((3 * cast(s32) sa[0]) + cast(s32) sb[0]) + 2) >> 2);

    db[0] = cast,no_check(u16) ((((cast(s32) sa[0]) + 3 * cast(s32) sb[0]) + 2) >> 2);

    if work_width > 0 {
        if n != 0 {
            ScaleRowUp2_Bilinear_16_C(sa, sb - sa, da + 1, db - da, n);
        }

        ScaleRowUp2_Bilinear_16_C(sa + n / 2, sb - sa, da + n + 1, db - da, r);
    }

    da[dst_width - 1] =
        cast,no_check(u16) ((((3 * cast(s32) sa[(dst_width - 1) / 2]) + cast(s32) sb[(dst_width - 1) / 2]) +
            2) >> 2);

    db[dst_width - 1] =
        cast,no_check(u16) ((((cast(s32) sa[(dst_width - 1) / 2]) + 3 * cast(s32) sb[(dst_width - 1) / 2]) +
            2) >> 2);
}

ScaleUVRowUp2_Linear_Any_C :: (src_ptr: *u8, dst_ptr: *u8, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    dst_ptr[0] = src_ptr[0];

    dst_ptr[1] = src_ptr[1];

    if work_width > 0 {
        if n != 0 {
            ScaleUVRowUp2_Linear_C(src_ptr, dst_ptr + 2, n);
        }

        np := cast,no_check(s64) n;

        ScaleUVRowUp2_Linear_C(src_ptr + np, dst_ptr + 2 * np + 2, r);
    }

    dst_ptr[2 * dst_width - 2] = src_ptr[(dst_width + 1) & ~(cast(s32) 1) - 2];

    dst_ptr[2 * dst_width - 1] = src_ptr[(dst_width + 1) & ~(cast(s32) 1) - 1];
}

ScaleUVRowUp2_Bilinear_Any_C :: (src_ptr: *u8, src_stride: s64, dst_ptr: *u8, dst_stride: s64, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    sa := cast,no_check(*u8) (src_ptr);

    sb := cast,no_check(*u8) ((src_ptr + src_stride));

    da := cast,no_check(*u8) (dst_ptr);

    db := cast,no_check(*u8) ((dst_ptr + dst_stride));

    da[0] = cast,no_check(u8) ((((3 * cast(s32) sa[0]) + cast(s32) sb[0]) + 2) >> 2);

    db[0] = cast,no_check(u8) ((((cast(s32) sa[0]) + 3 * cast(s32) sb[0]) + 2) >> 2);

    da[1] = cast,no_check(u8) ((((3 * cast(s32) sa[1]) + cast(s32) sb[1]) + 2) >> 2);

    db[1] = cast,no_check(u8) ((((cast(s32) sa[1]) + 3 * cast(s32) sb[1]) + 2) >> 2);

    if work_width > 0 {
        if n != 0 {
            ScaleUVRowUp2_Bilinear_C(sa, sb - sa, da + 2, db - da, n);
        }

        np := cast,no_check(s64) n;

        ScaleUVRowUp2_Bilinear_C(sa + np, sb - sa, da + 2 * np + 2, db - da, r);
    }

    da[2 * dst_width - 2] =
        cast,no_check(u8) ((((3 * cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 2]) + cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 2]) +
            2) >> 2);

    db[2 * dst_width - 2] =
        cast,no_check(u8) ((((cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 2]) + 3 * cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 2]) +
            2) >> 2);

    da[2 * dst_width - 1] =
        cast,no_check(u8) ((((3 * cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 1]) + cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 1]) +
            2) >> 2);

    db[2 * dst_width - 1] =
        cast,no_check(u8) ((((cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 1]) + 3 * cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 1]) +
            2) >> 2);
}

ScaleUVRowUp2_Linear_16_Any_C :: (src_ptr: *u16, dst_ptr: *u16, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    dst_ptr[0] = src_ptr[0];

    dst_ptr[1] = src_ptr[1];

    if work_width > 0 {
        if n != 0 {
            ScaleUVRowUp2_Linear_16_C(src_ptr, dst_ptr + 2, n);
        }

        np := cast,no_check(s64) n;

        ScaleUVRowUp2_Linear_16_C(src_ptr + np, dst_ptr + 2 * np + 2, r);
    }

    dst_ptr[2 * dst_width - 2] = src_ptr[(dst_width + 1) & ~(cast(s32) 1) - 2];

    dst_ptr[2 * dst_width - 1] = src_ptr[(dst_width + 1) & ~(cast(s32) 1) - 1];
}

ScaleUVRowUp2_Bilinear_16_Any_C :: (src_ptr: *u16, src_stride: s64, dst_ptr: *u16, dst_stride: s64, dst_width: s32) {
    work_width := (dst_width - 1) & ~(cast(s32) 1);

    r := work_width & 0;

    n := work_width & ~(cast(s32) 0);

    sa := cast,no_check(*u16) (src_ptr);

    sb := cast,no_check(*u16) ((src_ptr + src_stride));

    da := cast,no_check(*u16) (dst_ptr);

    db := cast,no_check(*u16) ((dst_ptr + dst_stride));

    da[0] = cast,no_check(u16) ((((3 * cast(s32) sa[0]) + cast(s32) sb[0]) + 2) >> 2);

    db[0] = cast,no_check(u16) ((((cast(s32) sa[0]) + 3 * cast(s32) sb[0]) + 2) >> 2);

    da[1] = cast,no_check(u16) ((((3 * cast(s32) sa[1]) + cast(s32) sb[1]) + 2) >> 2);

    db[1] = cast,no_check(u16) ((((cast(s32) sa[1]) + 3 * cast(s32) sb[1]) + 2) >> 2);

    if work_width > 0 {
        if n != 0 {
            ScaleUVRowUp2_Bilinear_16_C(sa, sb - sa, da + 2, db - da, n);
        }

        np := cast,no_check(s64) n;

        ScaleUVRowUp2_Bilinear_16_C(sa + np, sb - sa, da + 2 * np + 2, db - da, r);
    }

    da[2 * dst_width - 2] =
        cast,no_check(u16) ((((3 * cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 2]) + cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 2]) +
            2) >> 2);

    db[2 * dst_width - 2] =
        cast,no_check(u16) ((((cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 2]) + 3 * cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 2]) +
            2) >> 2);

    da[2 * dst_width - 1] =
        cast,no_check(u16) ((((3 * cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 1]) + cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 1]) +
            2) >> 2);

    db[2 * dst_width - 1] =
        cast,no_check(u16) ((((cast(s32) sa[(dst_width + 1) & ~(cast(s32) 1) - 1]) + 3 * cast(s32) sb[(dst_width + 1) & ~(cast(s32) 1) - 1]) +
            2) >> 2);
}

