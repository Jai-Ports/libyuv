// Generated directly from C++ by cpp_transpiler.
Uint32_Alias_T :: u32;

FIXED_INVTBL8: [256] u32;

K_YUV_I601_CONSTANTS: Yuv_Constants;

K_YUV_JPEG_CONSTANTS: Yuv_Constants;

K_YUV_H709_CONSTANTS: Yuv_Constants;

K_YUV_F709_CONSTANTS: Yuv_Constants;

K_YUV2020_CONSTANTS: Yuv_Constants;

K_YUV_V2020_CONSTANTS: Yuv_Constants;

K_YVU_I601_CONSTANTS: Yuv_Constants;

K_YVU_JPEG_CONSTANTS: Yuv_Constants;

K_YVU_H709_CONSTANTS: Yuv_Constants;

K_YVU_F709_CONSTANTS: Yuv_Constants;

K_YVU2020_CONSTANTS: Yuv_Constants;

K_YVU_V2020_CONSTANTS: Yuv_Constants;

K_ARGB_I601_CONSTANTS: Argb_Constants;

K_ARGB_JPEG_CONSTANTS: Argb_Constants;

K_ARGB_H709_CONSTANTS: Argb_Constants;

K_ARGB_F709_CONSTANTS: Argb_Constants;

K_ARGB_U2020_CONSTANTS: Argb_Constants;

K_ARGB_V2020_CONSTANTS: Argb_Constants;

K_ABGR_I601_CONSTANTS: Argb_Constants;

K_ABGR_JPEG_CONSTANTS: Argb_Constants;

K_ABGR_H709_CONSTANTS: Argb_Constants;

K_ABGR_F709_CONSTANTS: Argb_Constants;

K_ABGR_U2020_CONSTANTS: Argb_Constants;

K_ABGR_V2020_CONSTANTS: Argb_Constants;

K_RGBA_I601_CONSTANTS: Argb_Constants;

K_RGBA_JPEG_CONSTANTS: Argb_Constants;

K_RGBA_H709_CONSTANTS: Argb_Constants;

K_RGBA_F709_CONSTANTS: Argb_Constants;

K_RGBA_U2020_CONSTANTS: Argb_Constants;

K_RGBA_V2020_CONSTANTS: Argb_Constants;

K_BGRA_I601_CONSTANTS: Argb_Constants;

K_BGRA_JPEG_CONSTANTS: Argb_Constants;

K_BGRA_H709_CONSTANTS: Argb_Constants;

K_BGRA_F709_CONSTANTS: Argb_Constants;

K_BGRA_U2020_CONSTANTS: Argb_Constants;

K_BGRA_V2020_CONSTANTS: Argb_Constants;

ARGBToYMatrixRow_C :: (src_argb: *u8, dst_y: *u8, width: s32, c: *Argb_Constants) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_y_matrix(src_argb[0], src_argb[1], src_argb[2], src_argb[3], c);
            src_argb += 4;
            dst_y += 1;
        }
    }
}

rgb_to_y_matrix :: (b0: u8, b1: u8, b2: u8, b3: u8, c: *Argb_Constants) -> u8 {
    return cast,no_check(u8) (((((((cast(s32) c.k_rgb_to_y[0]) * cast(s32) b0) + (cast(s32) c.k_rgb_to_y[1]) * cast(s32) b1) + (cast(s32) c.k_rgb_to_y[2]) * cast(s32) b2) + (cast(s32) c.k_rgb_to_y[3]) * cast(s32) b3) + cast(s32) c.k_add_y[0]) >> 8);
}

ARGBToUVMatrixRow_C :: (src_argb: *u8, src_stride_argb: s32, dst_u: *u8, dst_v: *u8, width: s32, c: *Argb_Constants) {
    src_argb1 := cast,no_check(*u8) ((src_argb + src_stride_argb));

    x: s32 = 0;
    while x < width - 1 {
        b0 :=
            cast,no_check(u8) ((((((cast(s32) src_argb[0]) + cast(s32) src_argb[4]) + cast(s32) src_argb1[0]) + cast(s32) src_argb1[4]) +
                2) >> 2);
        b1 :=
            cast,no_check(u8) ((((((cast(s32) src_argb[1]) + cast(s32) src_argb[5]) + cast(s32) src_argb1[1]) + cast(s32) src_argb1[5]) +
                2) >> 2);
        b2 :=
            cast,no_check(u8) ((((((cast(s32) src_argb[2]) + cast(s32) src_argb[6]) + cast(s32) src_argb1[2]) + cast(s32) src_argb1[6]) +
                2) >> 2);
        b3 :=
            cast,no_check(u8) ((((((cast(s32) src_argb[3]) + cast(s32) src_argb[7]) + cast(s32) src_argb1[3]) + cast(s32) src_argb1[7]) +
                2) >> 2);
        dst_u[0] = rgb_to_u_matrix(b0, b1, b2, b3, c);
        dst_v[0] = rgb_to_v_matrix(b0, b1, b2, b3, c);
        src_argb += 8;
        src_argb1 += 8;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast,no_check(u8) ((((cast(s32) src_argb[0]) + cast(s32) src_argb1[0]) + 1) >> 1);
        b1 := cast,no_check(u8) ((((cast(s32) src_argb[1]) + cast(s32) src_argb1[1]) + 1) >> 1);
        b2 := cast,no_check(u8) ((((cast(s32) src_argb[2]) + cast(s32) src_argb1[2]) + 1) >> 1);
        b3 := cast,no_check(u8) ((((cast(s32) src_argb[3]) + cast(s32) src_argb1[3]) + 1) >> 1);
        dst_u[0] = rgb_to_u_matrix(b0, b1, b2, b3, c);
        dst_v[0] = rgb_to_v_matrix(b0, b1, b2, b3, c);
    }
}

rgb_to_v_matrix :: (b0: u8, b1: u8, b2: u8, b3: u8, c: *Argb_Constants) -> u8 {
    return cast,no_check(u8) (((cast(s32) c.k_add_uv[0]) - (((((cast(s32) c.k_rgb_to_v[0]) * cast(s32) b0) + (cast(s32) c.k_rgb_to_v[1]) * cast(s32) b1) + (cast(s32) c.k_rgb_to_v[2]) * cast(s32) b2) + (cast(s32) c.k_rgb_to_v[3]) * cast(s32) b3)) >> 8);
}

rgb_to_u_matrix :: (b0: u8, b1: u8, b2: u8, b3: u8, c: *Argb_Constants) -> u8 {
    return cast,no_check(u8) (((cast(s32) c.k_add_uv[0]) - (((((cast(s32) c.k_rgb_to_u[0]) * cast(s32) b0) + (cast(s32) c.k_rgb_to_u[1]) * cast(s32) b1) + (cast(s32) c.k_rgb_to_u[2]) * cast(s32) b2) + (cast(s32) c.k_rgb_to_u[3]) * cast(s32) b3)) >> 8);
}

RGBToYMatrixRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32, c: *Argb_Constants) {
    row: [8192] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        RGB24ToARGBRow_C(src_rgb, row.data, twidth);
        ARGBToYMatrixRow_C(row.data, dst_y, twidth, c);
        src_rgb += twidth * 3;
        dst_y += twidth;
        width -= twidth;
    }
}

RGB24ToARGBRow_C :: (src_rgb24: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_rgb24[0];
            g := src_rgb24[1];
            r := src_rgb24[2];
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = 255;
            dst_argb += 4;
            src_rgb24 += 3;
        }
    }
}

RGBToUVMatrixRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32, c: *Argb_Constants) {
    row: [16384] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        RGB24ToARGBRow_C(src_rgb, row.data, twidth);
        RGB24ToARGBRow_C(src_rgb + src_stride_rgb, row.data + 2048 * 4, twidth);
        ARGBToUVMatrixRow_C(row.data, cast,no_check(s32) (2048 * 4), dst_u, dst_v, twidth, c);
        src_rgb += twidth * 3;
        dst_u += twidth / 2;
        dst_v += twidth / 2;
        width -= twidth;
    }
}

RGBToUV444MatrixRow_C :: (src_rgb: *u8, dst_u: *u8, dst_v: *u8, width: s32, c: *Argb_Constants) {
    row: [8192] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        RGB24ToARGBRow_C(src_rgb, row.data, twidth);
        ARGBToUV444MatrixRow_C(row.data, dst_u, dst_v, twidth, c);
        src_rgb += twidth * 3;
        dst_u += twidth;
        dst_v += twidth;
        width -= twidth;
    }
}

ARGBToUV444MatrixRow_C :: (src_argb: *u8, dst_u: *u8, dst_v: *u8, width: s32, c: *Argb_Constants) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_u[0] = rgb_to_u_matrix(src_argb[0], src_argb[1], src_argb[2], src_argb[3], c);
            dst_v[0] = rgb_to_v_matrix(src_argb[0], src_argb[1], src_argb[2], src_argb[3], c);
            src_argb += 4;
            dst_u += 1;
            dst_v += 1;
        }
    }
}

RGB565ToYMatrixRow_C :: (src_rgb565: *u8, dst_y: *u8, width: s32, c: *Argb_Constants) {
    row: [8192] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        RGB565ToARGBRow_C(src_rgb565, row.data, twidth);
        ARGBToYMatrixRow_C(row.data, dst_y, twidth, c);
        src_rgb565 += twidth * 2;
        dst_y += twidth;
        width -= twidth;
    }
}

RGB565ToARGBRow_C :: (src_rgb565: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u8) ((cast(s32) src_rgb565[0]) & 0x1f);
            g := cast,no_check(u8) ((cast(s32) src_rgb565[0]) >> 5 | ((cast(s32) src_rgb565[1]) & 0x7 << 3));
            r := cast,no_check(u8) ((cast(s32) src_rgb565[1]) >> 3);
            dst_argb[0] = cast,no_check(u8) ((cast(s32) b) << 3 | ((cast(s32) b) >> 2));
            dst_argb[1] = cast,no_check(u8) ((cast(s32) g) << 2 | ((cast(s32) g) >> 4));
            dst_argb[2] = cast,no_check(u8) ((cast(s32) r) << 3 | ((cast(s32) r) >> 2));
            dst_argb[3] = 255;
            dst_argb += 4;
            src_rgb565 += 2;
        }
    }
}

ARGB1555ToYMatrixRow_C :: (src_argb1555: *u8, dst_y: *u8, width: s32, c: *Argb_Constants) {
    row: [8192] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        ARGB1555ToARGBRow_C(src_argb1555, row.data, twidth);
        ARGBToYMatrixRow_C(row.data, dst_y, twidth, c);
        src_argb1555 += twidth * 2;
        dst_y += twidth;
        width -= twidth;
    }
}

ARGB1555ToARGBRow_C :: (src_argb1555: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u8) ((cast(s32) src_argb1555[0]) & 0x1f);
            g := cast,no_check(u8) ((cast(s32) src_argb1555[0]) >> 5 | ((cast(s32) src_argb1555[1]) & 0x3 << 3));
            r := cast,no_check(u8) ((cast(s32) src_argb1555[1]) & 0x7c >> 2);
            a := cast,no_check(u8) ((cast(s32) src_argb1555[1]) >> 7);
            dst_argb[0] = cast,no_check(u8) ((cast(s32) b) << 3 | ((cast(s32) b) >> 2));
            dst_argb[1] = cast,no_check(u8) ((cast(s32) g) << 3 | ((cast(s32) g) >> 2));
            dst_argb[2] = cast,no_check(u8) ((cast(s32) r) << 3 | ((cast(s32) r) >> 2));
            dst_argb[3] = cast,no_check(u8) (-(cast,no_check(s32) a));
            dst_argb += 4;
            src_argb1555 += 2;
        }
    }
}

ARGB1555ToUVMatrixRow_C :: (
    src_argb1555: *u8,
    src_stride_argb1555: s32,
    dst_u: *u8,
    dst_v: *u8,
    width: s32,
    c: *Argb_Constants
) {
    row: [16384] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        ARGB1555ToARGBRow_C(src_argb1555, row.data, twidth);
        ARGB1555ToARGBRow_C(src_argb1555 + src_stride_argb1555, row.data + 2048 * 4, twidth);
        ARGBToUVMatrixRow_C(row.data, cast,no_check(s32) (2048 * 4), dst_u, dst_v, twidth, c);
        src_argb1555 += twidth * 2;
        dst_u += twidth / 2;
        dst_v += twidth / 2;
        width -= twidth;
    }
}

ARGB4444ToYMatrixRow_C :: (src_argb4444: *u8, dst_y: *u8, width: s32, c: *Argb_Constants) {
    row: [8192] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        ARGB4444ToARGBRow_C(src_argb4444, row.data, twidth);
        ARGBToYMatrixRow_C(row.data, dst_y, twidth, c);
        src_argb4444 += twidth * 2;
        dst_y += twidth;
        width -= twidth;
    }
}

ARGB4444ToARGBRow_C :: (src_argb4444: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u8) ((cast(s32) src_argb4444[0]) & 0xf);
            g := cast,no_check(u8) ((cast(s32) src_argb4444[0]) >> 4);
            r := cast,no_check(u8) ((cast(s32) src_argb4444[1]) & 0xf);
            a := cast,no_check(u8) ((cast(s32) src_argb4444[1]) >> 4);
            dst_argb[0] = cast,no_check(u8) ((cast(s32) b) << 4 | cast(s32) b);
            dst_argb[1] = cast,no_check(u8) ((cast(s32) g) << 4 | cast(s32) g);
            dst_argb[2] = cast,no_check(u8) ((cast(s32) r) << 4 | cast(s32) r);
            dst_argb[3] = cast,no_check(u8) ((cast(s32) a) << 4 | cast(s32) a);
            dst_argb += 4;
            src_argb4444 += 2;
        }
    }
}

ARGB4444ToUVMatrixRow_C :: (
    src_argb4444: *u8,
    src_stride_argb4444: s32,
    dst_u: *u8,
    dst_v: *u8,
    width: s32,
    c: *Argb_Constants
) {
    row: [16384] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        ARGB4444ToARGBRow_C(src_argb4444, row.data, twidth);
        ARGB4444ToARGBRow_C(src_argb4444 + src_stride_argb4444, row.data + 2048 * 4, twidth);
        ARGBToUVMatrixRow_C(row.data, cast,no_check(s32) (2048 * 4), dst_u, dst_v, twidth, c);
        src_argb4444 += twidth * 2;
        dst_u += twidth / 2;
        dst_v += twidth / 2;
        width -= twidth;
    }
}

RGB565ToUVMatrixRow_C :: (
    src_rgb565: *u8,
    src_stride_rgb565: s32,
    dst_u: *u8,
    dst_v: *u8,
    width: s32,
    c: *Argb_Constants
) {
    row: [16384] u8 = ---;
    while width > 0 {
        twidth := (ifx width > 2048 then 2048 else width);
        RGB565ToARGBRow_C(src_rgb565, row.data, twidth);
        RGB565ToARGBRow_C(src_rgb565 + src_stride_rgb565, row.data + 2048 * 4, twidth);
        ARGBToUVMatrixRow_C(row.data, cast,no_check(s32) (2048 * 4), dst_u, dst_v, twidth, c);
        src_rgb565 += twidth * 2;
        dst_u += twidth / 2;
        dst_v += twidth / 2;
        width -= twidth;
    }
}

ABGRToYJRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_yj(src_rgb[0], src_rgb[1], src_rgb[2]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

rgb_to_yj :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((77 * cast(s32) r) + 150 * cast(s32) g) + 29 * cast(s32) b) + 128) >> 8);
}

RGBAToYJRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_yj(src_rgb[3], src_rgb[2], src_rgb[1]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

BGRAToYRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_y(src_rgb[1], src_rgb[2], src_rgb[3]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

rgb_to_y :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((66 * cast(s32) r) + 129 * cast(s32) g) + 25 * cast(s32) b) + 0x1080) >> 8);
}

ABGRToYRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_y(src_rgb[0], src_rgb[1], src_rgb[2]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

RGBAToYRow_C :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_y(src_rgb[3], src_rgb[2], src_rgb[1]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

RGB565ToYRow_C :: (src_rgb565: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast(u8) (src_rgb565[0] & 0x1f);
            g := cast,no_check(u8) ((cast(s32) src_rgb565[0]) >> 5 | ((cast(s32) src_rgb565[1]) & 0x7 << 3));
            r := cast(u8) (src_rgb565[1] >> 3);
            b = cast,no_check(u8) ((cast(s32) b) << 3 | ((cast(s32) b) >> 2));
            g = cast,no_check(u8) ((cast(s32) g) << 2 | ((cast(s32) g) >> 4));
            r = cast,no_check(u8) ((cast(s32) r) << 3 | ((cast(s32) r) >> 2));
            dst_y[0] = rgb_to_y(r, g, b);
            src_rgb565 += 2;
            dst_y += 1;
        }
    }
}

ARGB1555ToYRow_C :: (src_argb1555: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast(u8) (src_argb1555[0] & 0x1f);
            g := cast,no_check(u8) ((cast(s32) src_argb1555[0]) >> 5 | ((cast(s32) src_argb1555[1]) & 0x3 << 3));
            r := cast,no_check(u8) ((cast(s32) src_argb1555[1]) & 0x7c >> 2);
            b = cast,no_check(u8) ((cast(s32) b) << 3 | ((cast(s32) b) >> 2));
            g = cast,no_check(u8) ((cast(s32) g) << 3 | ((cast(s32) g) >> 2));
            r = cast,no_check(u8) ((cast(s32) r) << 3 | ((cast(s32) r) >> 2));
            dst_y[0] = rgb_to_y(r, g, b);
            src_argb1555 += 2;
            dst_y += 1;
        }
    }
}

ARGB4444ToYRow_C :: (src_argb4444: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast(u8) (src_argb4444[0] & 0xf);
            g := cast(u8) (src_argb4444[0] >> 4);
            r := cast(u8) (src_argb4444[1] & 0xf);
            b = cast,no_check(u8) ((cast(s32) b) << 4 | cast(s32) b);
            g = cast,no_check(u8) ((cast(s32) g) << 4 | cast(s32) g);
            r = cast,no_check(u8) ((cast(s32) r) << 4 | cast(s32) r);
            dst_y[0] = rgb_to_y(r, g, b);
            src_argb4444 += 2;
            dst_y += 1;
        }
    }
}

ABGRToUVJRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[0]) + cast(s32) src_rgb[0 + 4]) + cast(s32) src_rgb1[0]) + cast(s32) src_rgb1[0 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_uj(ar, ag, ab);

        dst_v[0] = rgb_to_vj(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u16) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        ag := cast,no_check(u16) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ar := cast,no_check(u16) ((((cast(s32) src_rgb[0]) + cast(s32) src_rgb1[0]) + 1) >> 1);

        dst_u[0] = rgb_to_uj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);

        dst_v[0] = rgb_to_vj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);
    }
}

rgb_to_vj :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((128 * cast(s32) r) - 107 * cast(s32) g) - 21 * cast(s32) b) + 0x8000) >> 8);
}

rgb_to_uj :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((128 * cast(s32) b) - 85 * cast(s32) g) - 43 * cast(s32) r) + 0x8000) >> 8);
}

BGRAToUVRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[3]) + cast(s32) src_rgb[3 + 4]) + cast(s32) src_rgb1[3]) + cast(s32) src_rgb1[3 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u8) ((((cast(s32) src_rgb[3]) + cast(s32) src_rgb1[3]) + 1) >> 1);

        ag := cast,no_check(u8) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        ar := cast,no_check(u8) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

rgb_to_v :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((112 * cast(s32) r) - 94 * cast(s32) g) - 18 * cast(s32) b) + 0x8000) >> 8);
}

rgb_to_u :: (r: u8, g: u8, b: u8) -> u8 {
    return cast,no_check(u8) (((((112 * cast(s32) b) - 74 * cast(s32) g) - 38 * cast(s32) r) + 0x8000) >> 8);
}

ABGRToUVRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[0]) + cast(s32) src_rgb[0 + 4]) + cast(s32) src_rgb1[0]) + cast(s32) src_rgb1[0 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u8) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        ag := cast,no_check(u8) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ar := cast,no_check(u8) ((((cast(s32) src_rgb[0]) + cast(s32) src_rgb1[0]) + 1) >> 1);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

RGBAToUVRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[3]) + cast(s32) src_rgb[3 + 4]) + cast(s32) src_rgb1[3]) + cast(s32) src_rgb1[3 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u8) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ag := cast,no_check(u8) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        ar := cast,no_check(u8) ((((cast(s32) src_rgb[3]) + cast(s32) src_rgb1[3]) + 1) >> 1);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

RGBAToUVJRow_C :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[3]) + cast(s32) src_rgb[3 + 4]) + cast(s32) src_rgb1[3]) + cast(s32) src_rgb1[3 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_uj(ar, ag, ab);

        dst_v[0] = rgb_to_vj(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u16) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ag := cast,no_check(u16) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        ar := cast,no_check(u16) ((((cast(s32) src_rgb[3]) + cast(s32) src_rgb1[3]) + 1) >> 1);

        dst_u[0] = rgb_to_uj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);

        dst_v[0] = rgb_to_vj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);
    }
}

RGB565ToUVRow_C :: (src_rgb565: *u8, src_stride_rgb565: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    next_rgb565 := cast,no_check(*u8) ((src_rgb565 + src_stride_rgb565));

    x: s32 = 0;
    while x < width - 1 {
        b0 := cast,no_check(u8) ((cast(s32) src_rgb565[0]) & 0x1f);
        g0 := cast,no_check(u8) ((cast(s32) src_rgb565[0]) >> 5 | ((cast(s32) src_rgb565[1]) & 0x7 << 3));
        r0 := cast,no_check(u8) ((cast(s32) src_rgb565[1]) >> 3);
        b1 := cast,no_check(u8) ((cast(s32) src_rgb565[2]) & 0x1f);
        g1 := cast,no_check(u8) ((cast(s32) src_rgb565[2]) >> 5 | ((cast(s32) src_rgb565[3]) & 0x7 << 3));
        r1 := cast,no_check(u8) ((cast(s32) src_rgb565[3]) >> 3);
        b2 := cast,no_check(u8) ((cast(s32) next_rgb565[0]) & 0x1f);
        g2 := cast,no_check(u8) ((cast(s32) next_rgb565[0]) >> 5 | ((cast(s32) next_rgb565[1]) & 0x7 << 3));
        r2 := cast,no_check(u8) ((cast(s32) next_rgb565[1]) >> 3);
        b3 := cast,no_check(u8) ((cast(s32) next_rgb565[2]) & 0x1f);
        g3 := cast,no_check(u8) ((cast(s32) next_rgb565[2]) >> 5 | ((cast(s32) next_rgb565[3]) & 0x7 << 3));
        r3 := cast,no_check(u8) ((cast(s32) next_rgb565[3]) >> 3);

        b0 = cast,no_check(u8) ((cast(s32) b0) << 3 | ((cast(s32) b0) >> 2));
        g0 = cast,no_check(u8) ((cast(s32) g0) << 2 | ((cast(s32) g0) >> 4));
        r0 = cast,no_check(u8) ((cast(s32) r0) << 3 | ((cast(s32) r0) >> 2));
        b1 = cast,no_check(u8) ((cast(s32) b1) << 3 | ((cast(s32) b1) >> 2));
        g1 = cast,no_check(u8) ((cast(s32) g1) << 2 | ((cast(s32) g1) >> 4));
        r1 = cast,no_check(u8) ((cast(s32) r1) << 3 | ((cast(s32) r1) >> 2));
        b2 = cast,no_check(u8) ((cast(s32) b2) << 3 | ((cast(s32) b2) >> 2));
        g2 = cast,no_check(u8) ((cast(s32) g2) << 2 | ((cast(s32) g2) >> 4));
        r2 = cast,no_check(u8) ((cast(s32) r2) << 3 | ((cast(s32) r2) >> 2));
        b3 = cast,no_check(u8) ((cast(s32) b3) << 3 | ((cast(s32) b3) >> 2));
        g3 = cast,no_check(u8) ((cast(s32) g3) << 2 | ((cast(s32) g3) >> 4));
        r3 = cast,no_check(u8) ((cast(s32) r3) << 3 | ((cast(s32) r3) >> 2));

        b := cast,no_check(u8) ((((((cast(s32) b0) + cast(s32) b1) + cast(s32) b2) + cast(s32) b3) + 2) >> 2);
        g := cast,no_check(u8) ((((((cast(s32) g0) + cast(s32) g1) + cast(s32) g2) + cast(s32) g3) + 2) >> 2);
        r := cast,no_check(u8) ((((((cast(s32) r0) + cast(s32) r1) + cast(s32) r2) + cast(s32) r3) + 2) >> 2);
        dst_u[0] = rgb_to_u(r, g, b);
        dst_v[0] = rgb_to_v(r, g, b);

        src_rgb565 += 4;
        next_rgb565 += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast,no_check(u8) ((cast(s32) src_rgb565[0]) & 0x1f);
        g0 := cast,no_check(u8) ((cast(s32) src_rgb565[0]) >> 5 | ((cast(s32) src_rgb565[1]) & 0x7 << 3));
        r0 := cast,no_check(u8) ((cast(s32) src_rgb565[1]) >> 3);
        b2 := cast,no_check(u8) ((cast(s32) next_rgb565[0]) & 0x1f);
        g2 := cast,no_check(u8) ((cast(s32) next_rgb565[0]) >> 5 | ((cast(s32) next_rgb565[1]) & 0x7 << 3));
        r2 := cast,no_check(u8) ((cast(s32) next_rgb565[1]) >> 3);
        b0 = cast,no_check(u8) ((cast(s32) b0) << 3 | ((cast(s32) b0) >> 2));
        g0 = cast,no_check(u8) ((cast(s32) g0) << 2 | ((cast(s32) g0) >> 4));
        r0 = cast,no_check(u8) ((cast(s32) r0) << 3 | ((cast(s32) r0) >> 2));
        b2 = cast,no_check(u8) ((cast(s32) b2) << 3 | ((cast(s32) b2) >> 2));
        g2 = cast,no_check(u8) ((cast(s32) g2) << 2 | ((cast(s32) g2) >> 4));
        r2 = cast,no_check(u8) ((cast(s32) r2) << 3 | ((cast(s32) r2) >> 2));

        ab := cast,no_check(u8) ((((cast(s32) b0) + cast(s32) b2) + 1) >> 1);
        ag := cast,no_check(u8) ((((cast(s32) g0) + cast(s32) g2) + 1) >> 1);
        ar := cast,no_check(u8) ((((cast(s32) r0) + cast(s32) r2) + 1) >> 1);
        dst_u[0] = rgb_to_u(ar, ag, ab);
        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

ARGB1555ToUVRow_C :: (src_argb1555: *u8, src_stride_argb1555: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    next_argb1555 := cast,no_check(*u8) ((src_argb1555 + src_stride_argb1555));

    x: s32 = 0;
    while x < width - 1 {
        b0 := cast,no_check(u8) ((cast(s32) src_argb1555[0]) & 0x1f);
        g0 := cast,no_check(u8) ((cast(s32) src_argb1555[0]) >> 5 | ((cast(s32) src_argb1555[1]) & 0x3 << 3));
        r0 := cast,no_check(u8) ((cast(s32) src_argb1555[1]) & 0x7c >> 2);
        b1 := cast,no_check(u8) ((cast(s32) src_argb1555[2]) & 0x1f);
        g1 := cast,no_check(u8) ((cast(s32) src_argb1555[2]) >> 5 | ((cast(s32) src_argb1555[3]) & 0x3 << 3));
        r1 := cast,no_check(u8) ((cast(s32) src_argb1555[3]) & 0x7c >> 2);
        b2 := cast,no_check(u8) ((cast(s32) next_argb1555[0]) & 0x1f);
        g2 := cast,no_check(u8) ((cast(s32) next_argb1555[0]) >> 5 | ((cast(s32) next_argb1555[1]) & 0x3 << 3));
        r2 := cast,no_check(u8) ((cast(s32) next_argb1555[1]) & 0x7c >> 2);
        b3 := cast,no_check(u8) ((cast(s32) next_argb1555[2]) & 0x1f);
        g3 := cast,no_check(u8) ((cast(s32) next_argb1555[2]) >> 5 | ((cast(s32) next_argb1555[3]) & 0x3 << 3));
        r3 := cast,no_check(u8) ((cast(s32) next_argb1555[3]) & 0x7c >> 2);

        b0 = cast,no_check(u8) ((cast(s32) b0) << 3 | ((cast(s32) b0) >> 2));
        g0 = cast,no_check(u8) ((cast(s32) g0) << 3 | ((cast(s32) g0) >> 2));
        r0 = cast,no_check(u8) ((cast(s32) r0) << 3 | ((cast(s32) r0) >> 2));
        b1 = cast,no_check(u8) ((cast(s32) b1) << 3 | ((cast(s32) b1) >> 2));
        g1 = cast,no_check(u8) ((cast(s32) g1) << 3 | ((cast(s32) g1) >> 2));
        r1 = cast,no_check(u8) ((cast(s32) r1) << 3 | ((cast(s32) r1) >> 2));
        b2 = cast,no_check(u8) ((cast(s32) b2) << 3 | ((cast(s32) b2) >> 2));
        g2 = cast,no_check(u8) ((cast(s32) g2) << 3 | ((cast(s32) g2) >> 2));
        r2 = cast,no_check(u8) ((cast(s32) r2) << 3 | ((cast(s32) r2) >> 2));
        b3 = cast,no_check(u8) ((cast(s32) b3) << 3 | ((cast(s32) b3) >> 2));
        g3 = cast,no_check(u8) ((cast(s32) g3) << 3 | ((cast(s32) g3) >> 2));
        r3 = cast,no_check(u8) ((cast(s32) r3) << 3 | ((cast(s32) r3) >> 2));

        b := cast,no_check(u8) ((((((cast(s32) b0) + cast(s32) b1) + cast(s32) b2) + cast(s32) b3) + 2) >> 2);
        g := cast,no_check(u8) ((((((cast(s32) g0) + cast(s32) g1) + cast(s32) g2) + cast(s32) g3) + 2) >> 2);
        r := cast,no_check(u8) ((((((cast(s32) r0) + cast(s32) r1) + cast(s32) r2) + cast(s32) r3) + 2) >> 2);
        dst_u[0] = rgb_to_u(r, g, b);
        dst_v[0] = rgb_to_v(r, g, b);

        src_argb1555 += 4;
        next_argb1555 += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast,no_check(u8) ((cast(s32) src_argb1555[0]) & 0x1f);
        g0 := cast,no_check(u8) ((cast(s32) src_argb1555[0]) >> 5 | ((cast(s32) src_argb1555[1]) & 0x3 << 3));
        r0 := cast,no_check(u8) ((cast(s32) src_argb1555[1]) & 0x7c >> 2);
        b2 := cast,no_check(u8) ((cast(s32) next_argb1555[0]) & 0x1f);
        g2 := cast,no_check(u8) ((cast(s32) next_argb1555[0]) >> 5 | ((cast(s32) next_argb1555[1]) & 0x3 << 3));
        r2 := cast,no_check(u8) ((cast(s32) next_argb1555[1]) & 0x7c >> 2);

        b0 = cast,no_check(u8) ((cast(s32) b0) << 3 | ((cast(s32) b0) >> 2));
        g0 = cast,no_check(u8) ((cast(s32) g0) << 3 | ((cast(s32) g0) >> 2));
        r0 = cast,no_check(u8) ((cast(s32) r0) << 3 | ((cast(s32) r0) >> 2));
        b2 = cast,no_check(u8) ((cast(s32) b2) << 3 | ((cast(s32) b2) >> 2));
        g2 = cast,no_check(u8) ((cast(s32) g2) << 3 | ((cast(s32) g2) >> 2));
        r2 = cast,no_check(u8) ((cast(s32) r2) << 3 | ((cast(s32) r2) >> 2));

        ab := cast,no_check(u8) ((((cast(s32) b0) + cast(s32) b2) + 1) >> 1);
        ag := cast,no_check(u8) ((((cast(s32) g0) + cast(s32) g2) + 1) >> 1);
        ar := cast,no_check(u8) ((((cast(s32) r0) + cast(s32) r2) + 1) >> 1);
        dst_u[0] = rgb_to_u(ar, ag, ab);
        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

ARGB4444ToUVRow_C :: (src_argb4444: *u8, src_stride_argb4444: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    next_argb4444 := cast,no_check(*u8) ((src_argb4444 + src_stride_argb4444));

    x: s32 = 0;
    while x < width - 1 {
        b0 := cast(u8) (src_argb4444[0] & 0xf);
        g0 := cast(u8) (src_argb4444[0] >> 4);
        r0 := cast(u8) (src_argb4444[1] & 0xf);
        b1 := cast(u8) (src_argb4444[2] & 0xf);
        g1 := cast(u8) (src_argb4444[2] >> 4);
        r1 := cast(u8) (src_argb4444[3] & 0xf);
        b2 := cast(u8) (next_argb4444[0] & 0xf);
        g2 := cast(u8) (next_argb4444[0] >> 4);
        r2 := cast(u8) (next_argb4444[1] & 0xf);
        b3 := cast(u8) (next_argb4444[2] & 0xf);
        g3 := cast(u8) (next_argb4444[2] >> 4);
        r3 := cast(u8) (next_argb4444[3] & 0xf);

        b0 = cast,no_check(u8) ((cast(s32) b0) << 4 | cast(s32) b0);
        g0 = cast,no_check(u8) ((cast(s32) g0) << 4 | cast(s32) g0);
        r0 = cast,no_check(u8) ((cast(s32) r0) << 4 | cast(s32) r0);
        b1 = cast,no_check(u8) ((cast(s32) b1) << 4 | cast(s32) b1);
        g1 = cast,no_check(u8) ((cast(s32) g1) << 4 | cast(s32) g1);
        r1 = cast,no_check(u8) ((cast(s32) r1) << 4 | cast(s32) r1);
        b2 = cast,no_check(u8) ((cast(s32) b2) << 4 | cast(s32) b2);
        g2 = cast,no_check(u8) ((cast(s32) g2) << 4 | cast(s32) g2);
        r2 = cast,no_check(u8) ((cast(s32) r2) << 4 | cast(s32) r2);
        b3 = cast,no_check(u8) ((cast(s32) b3) << 4 | cast(s32) b3);
        g3 = cast,no_check(u8) ((cast(s32) g3) << 4 | cast(s32) g3);
        r3 = cast,no_check(u8) ((cast(s32) r3) << 4 | cast(s32) r3);

        b := cast,no_check(u8) ((((((cast(s32) b0) + cast(s32) b1) + cast(s32) b2) + cast(s32) b3) + 2) >> 2);
        g := cast,no_check(u8) ((((((cast(s32) g0) + cast(s32) g1) + cast(s32) g2) + cast(s32) g3) + 2) >> 2);
        r := cast,no_check(u8) ((((((cast(s32) r0) + cast(s32) r1) + cast(s32) r2) + cast(s32) r3) + 2) >> 2);
        dst_u[0] = rgb_to_u(r, g, b);
        dst_v[0] = rgb_to_v(r, g, b);

        src_argb4444 += 4;
        next_argb4444 += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast(u8) (src_argb4444[0] & 0xf);
        g0 := cast(u8) (src_argb4444[0] >> 4);
        r0 := cast(u8) (src_argb4444[1] & 0xf);
        b2 := cast(u8) (next_argb4444[0] & 0xf);
        g2 := cast(u8) (next_argb4444[0] >> 4);
        r2 := cast(u8) (next_argb4444[1] & 0xf);

        b0 = cast,no_check(u8) ((cast(s32) b0) << 4 | cast(s32) b0);
        g0 = cast,no_check(u8) ((cast(s32) g0) << 4 | cast(s32) g0);
        r0 = cast,no_check(u8) ((cast(s32) r0) << 4 | cast(s32) r0);
        b2 = cast,no_check(u8) ((cast(s32) b2) << 4 | cast(s32) b2);
        g2 = cast,no_check(u8) ((cast(s32) g2) << 4 | cast(s32) g2);
        r2 = cast,no_check(u8) ((cast(s32) r2) << 4 | cast(s32) r2);

        ab := cast,no_check(u8) ((((cast(s32) b0) + cast(s32) b2) + 1) >> 1);
        ag := cast,no_check(u8) ((((cast(s32) g0) + cast(s32) g2) + 1) >> 1);
        ar := cast,no_check(u8) ((((cast(s32) r0) + cast(s32) r2) + 1) >> 1);
        dst_u[0] = rgb_to_u(ar, ag, ab);
        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

MirrorRow_C :: (src: *u8, dst: *u8, width: s32) {
    src += width - 1;
    x: s32 = 0;
    while x < width - 1 {
        dst[x] = src[0];
        dst[x + 1] = src[-1];
        src -= 2;
        x += 2;
    }
    if width & 1 != 0 {
        dst[width - 1] = src[0];
    }
}

MirrorUVRow_C :: (src_uv: *u8, dst_uv: *u8, width: s32) {
    src_uv += (width - 1) << 1;
    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[0] = src_uv[0];
            dst_uv[1] = src_uv[1];
            src_uv -= 2;
            dst_uv += 2;
        }
    }
}

MirrorSplitUVRow_C :: (src_uv: *u8, dst_u: *u8, dst_v: *u8, width: s32) {
    src_uv += (width - 1) << 1;
    x: s32 = 0;
    while x < width - 1 {
        dst_u[x] = src_uv[0];
        dst_u[x + 1] = src_uv[-2];
        dst_v[x] = src_uv[1];
        dst_v[x + 1] = src_uv[-2 + 1];
        src_uv -= 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_u[width - 1] = src_uv[0];
        dst_v[width - 1] = src_uv[1];
    }
}

MirrorRow_16_C :: (src: *u16, dst: *u16, width: s32) {
    src += width - 1;
    x: s32 = 0;
    while x < width - 1 {
        dst[x] = src[0];
        dst[x + 1] = src[-1];
        src -= 2;
        x += 2;
    }
    if width & 1 != 0 {
        dst[width - 1] = src[0];
    }
}

ARGBMirrorRow_C :: (src: *u8, dst: *u8, width: s32) {
    s := cast,no_check(*u8) ((src + (cast,no_check(s64) (width - 1)) * 4));
    d := cast,no_check(*u8) (dst);
    if 0 < width {
        for x: 0..width - 1 {
            d[0] = s[0];
            d[1] = s[1];
            d[2] = s[2];
            d[3] = s[3];
            s -= 4;
            d += 4;
        }
    }
}

RGB24MirrorRow_C :: (src_rgb24: *u8, dst_rgb24: *u8, width: s32) {
    src_rgb24 += ((cast,no_check(s64) width) * 3) - 3;
    if 0 < width {
        for x: 0..width - 1 {
            b := src_rgb24[0];
            g := src_rgb24[1];
            r := src_rgb24[2];
            dst_rgb24[0] = b;
            dst_rgb24[1] = g;
            dst_rgb24[2] = r;
            src_rgb24 -= 3;
            dst_rgb24 += 3;
        }
    }
}

SplitUVRow_C :: (src_uv: *u8, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_u[x] = src_uv[0];
        dst_u[x + 1] = src_uv[2];
        dst_v[x] = src_uv[1];
        dst_v[x + 1] = src_uv[3];
        src_uv += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_u[width - 1] = src_uv[0];
        dst_v[width - 1] = src_uv[1];
    }
}

DetileRow_C :: (src: *u8, src_tile_stride: s64, dst: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 15 {
        copy_memory(dst, src, 16);
        dst += 16;
        src += src_tile_stride;
        x += 16;
    }
    if width & 15 != 0 {
        copy_memory(dst, src, cast,no_check(u64) (width & 15));
    }
}

DetileRow_16_C :: (src: *u16, src_tile_stride: s64, dst: *u16, width: s32) {
    x: s32 = 0;
    while x < width - 15 {
        copy_memory(dst, src, (cast,no_check(u64) (16)) * 2);
        dst += 16;
        src += src_tile_stride;
        x += 16;
    }
    if width & 15 != 0 {
        copy_memory(dst, src, (cast,no_check(u64) (width & 15)) * 2);
    }
}

DetileSplitUVRow_C :: (src_uv: *u8, src_tile_stride: s64, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 15 {
        SplitUVRow_C(src_uv, dst_u, dst_v, 8);
        dst_u += 8;
        dst_v += 8;
        src_uv += src_tile_stride;
        x += 16;
    }
    if width & 15 != 0 {
        SplitUVRow_C(src_uv, dst_u, dst_v, (width & 15 + 1) / 2);
    }
}

DetileToYUY2_C :: (
    src_y: *u8,
    src_y_tile_stride: s64,
    src_uv: *u8,
    src_uv_tile_stride: s64,
    dst_yuy2: *u8,
    width: s32
) {
    {
        x: s32 = 0;
        while x < width - 15 {
            for i: 0..cast(s32) 8 - 1 {
                dst_yuy2[0] = src_y[0];
                dst_yuy2[1] = src_uv[0];
                dst_yuy2[2] = src_y[1];
                dst_yuy2[3] = src_uv[1];
                dst_yuy2 += 4;
                src_y += 2;
                src_uv += 2;
            }
            src_y += src_y_tile_stride - 16;
            src_uv += src_uv_tile_stride - 16;
            x += 16;
        }
    }
}

UnpackMT2T_C :: (src: *u8, dst: *u16, size: u64) {
    {
        i: u64 = 0;
        while i < size {
            src_lower_bits := cast,no_check(*u8) (src);
            src_upper_bits := cast,no_check(*u8) ((src + 16));

            for j: 0..cast(s32) 4 - 1 {
                for k: 0..cast(s32) 16 - 1 {
                    dst.* = cast,no_check(u16) ((cast(s32) src_lower_bits[k]) >> (((j * 2)) & 31) & 0x3 << 6 | ((cast(s32) (cast,no_check(u16) src_upper_bits.*)) << 8) | ((cast(s32) (cast,no_check(u16) src_upper_bits.*)) >> 2));
                    dst += 1;
                    src_upper_bits += 1;
                }
            }

            src += 80;
            i += 80;
        }
    }
}

MergeUVRow_C :: (src_u: *u8, src_v: *u8, dst_uv: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_uv[0] = src_u[x];
        dst_uv[1] = src_v[x];
        dst_uv[2] = src_u[x + 1];
        dst_uv[3] = src_v[x + 1];
        dst_uv += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_uv[0] = src_u[width - 1];
        dst_uv[1] = src_v[width - 1];
    }
}

HalfMergeUVRow_C :: (src_u: *u8, src_stride_u: s32, src_v: *u8, src_stride_v: s32, dst_uv: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        src_u_next := cast,no_check(*u8) ((src_u + src_stride_u));
        dst_uv[0] =
            cast,no_check(u8) ((((((cast(s32) src_u[0]) + cast(s32) src_u[1]) + cast(s32) src_u_next[0]) + cast(s32) src_u_next[1]) +
                2) >> 2);
        src_v_next := cast,no_check(*u8) ((src_v + src_stride_v));
        dst_uv[1] =
            cast,no_check(u8) ((((((cast(s32) src_v[0]) + cast(s32) src_v[1]) + cast(s32) src_v_next[0]) + cast(s32) src_v_next[1]) +
                2) >> 2);
        src_u += 2;
        src_v += 2;
        dst_uv += 2;
        x += 2;
    }
    if width & 1 != 0 {
        src_u_next := cast,no_check(*u8) ((src_u + src_stride_u));
        dst_uv[0] = cast,no_check(u8) ((((cast(s32) src_u[0]) + cast(s32) src_u_next[0]) + 1) >> 1);
        src_v_next := cast,no_check(*u8) ((src_v + src_stride_v));
        dst_uv[1] = cast,no_check(u8) ((((cast(s32) src_v[0]) + cast(s32) src_v_next[0]) + 1) >> 1);
    }
}

SplitRGBRow_C :: (src_rgb: *u8, dst_r: *u8, dst_g: *u8, dst_b: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_r[x] = src_rgb[0];
            dst_g[x] = src_rgb[1];
            dst_b[x] = src_rgb[2];
            src_rgb += 3;
        }
    }
}

MergeRGBRow_C :: (src_r: *u8, src_g: *u8, src_b: *u8, dst_rgb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_rgb[0] = src_r[x];
            dst_rgb[1] = src_g[x];
            dst_rgb[2] = src_b[x];
            dst_rgb += 3;
        }
    }
}

MergeARGBRow_C :: (src_r: *u8, src_g: *u8, src_b: *u8, src_a: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_argb[0] = src_b[x];
            dst_argb[1] = src_g[x];
            dst_argb[2] = src_r[x];
            dst_argb[3] = src_a[x];
            dst_argb += 4;
        }
    }
}

SplitARGBRow_C :: (src_argb: *u8, dst_r: *u8, dst_g: *u8, dst_b: *u8, dst_a: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_b[x] = src_argb[0];
            dst_g[x] = src_argb[1];
            dst_r[x] = src_argb[2];
            dst_a[x] = src_argb[3];
            src_argb += 4;
        }
    }
}

MergeXRGBRow_C :: (src_r: *u8, src_g: *u8, src_b: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_argb[0] = src_b[x];
            dst_argb[1] = src_g[x];
            dst_argb[2] = src_r[x];
            dst_argb[3] = 255;
            dst_argb += 4;
        }
    }
}

SplitXRGBRow_C :: (src_argb: *u8, dst_r: *u8, dst_g: *u8, dst_b: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_b[x] = src_argb[0];
            dst_g[x] = src_argb[1];
            dst_r[x] = src_argb[2];
            src_argb += 4;
        }
    }
}

MergeXR30Row_C :: (src_r: *u16, src_g: *u16, src_b: *u16, dst_ar30: *u8, depth: s32, width: s32) {
    assert(depth >= 10);
    assert(depth <= 16);

    shift := depth - 10;
    dst_ar30_32 := cast,no_check(*u32) (cast(*u32) dst_ar30);
    if 0 < width {
        for x: 0..width - 1 {
            r := cast,no_check(u32) clamp1023((cast(s32) src_r[x]) >> ((shift) & 31));
            g := cast,no_check(u32) clamp1023((cast(s32) src_g[x]) >> ((shift) & 31));
            b := cast,no_check(u32) clamp1023((cast(s32) src_b[x]) >> ((shift) & 31));
            dst_ar30_32[x] = b | (g << 10) | (r << 20) | 0xc0000000;
        }
    }
}

clamp1023 :: (v: s32) -> s32 {
    return -(cast(s32) (v >= 1023)) | v & 1023;
}

MergeAR64Row_C :: (src_r: *u16, src_g: *u16, src_b: *u16, src_a: *u16, dst_ar64: *u16, depth: s32, width: s32) {
    assert(depth >= 1);
    assert(depth <= 16);

    shift := 16 - depth;
    max := (cast(s32) 1) << ((depth) & 31) - 1;
    if 0 < width {
        for x: 0..width - 1 {
            dst_ar64[0] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_b[x], max) << ((shift) & 31));
            dst_ar64[1] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_g[x], max) << ((shift) & 31));
            dst_ar64[2] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_r[x], max) << ((shift) & 31));
            dst_ar64[3] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_a[x], max) << ((shift) & 31));
            dst_ar64 += 4;
        }
    }
}

clamp_max :: (v: s32, max: s32) -> s32 {
    return -(cast(s32) (v >= max)) | v & max;
}

MergeARGB16To8Row_C :: (src_r: *u16, src_g: *u16, src_b: *u16, src_a: *u16, dst_argb: *u8, depth: s32, width: s32) {
    assert(depth >= 8);
    assert(depth <= 16);

    shift := depth - 8;
    if 0 < width {
        for x: 0..width - 1 {
            dst_argb[0] = cast,no_check(u8) clamp255((cast(s32) src_b[x]) >> ((shift) & 31));
            dst_argb[1] = cast,no_check(u8) clamp255((cast(s32) src_g[x]) >> ((shift) & 31));
            dst_argb[2] = cast,no_check(u8) clamp255((cast(s32) src_r[x]) >> ((shift) & 31));
            dst_argb[3] = cast,no_check(u8) clamp255((cast(s32) src_a[x]) >> ((shift) & 31));
            dst_argb += 4;
        }
    }
}

clamp255 :: (v: s32) -> s32 {
    return -(cast(s32) (v >= 255)) | v & 255;
}

MergeXR64Row_C :: (src_r: *u16, src_g: *u16, src_b: *u16, dst_ar64: *u16, depth: s32, width: s32) {
    assert(depth >= 1);
    assert(depth <= 16);

    shift := 16 - depth;
    max := (cast(s32) 1) << ((depth) & 31) - 1;
    if 0 < width {
        for x: 0..width - 1 {
            dst_ar64[0] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_b[x], max) << ((shift) & 31));
            dst_ar64[1] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_g[x], max) << ((shift) & 31));
            dst_ar64[2] = cast,no_check(u16) (clamp_max(cast,no_check(s32) src_r[x], max) << ((shift) & 31));
            dst_ar64[3] = 0xffff;
            dst_ar64 += 4;
        }
    }
}

MergeXRGB16To8Row_C :: (src_r: *u16, src_g: *u16, src_b: *u16, dst_argb: *u8, depth: s32, width: s32) {
    assert(depth >= 8);
    assert(depth <= 16);

    shift := depth - 8;
    if 0 < width {
        for x: 0..width - 1 {
            dst_argb[0] = cast,no_check(u8) clamp255((cast(s32) src_b[x]) >> ((shift) & 31));
            dst_argb[1] = cast,no_check(u8) clamp255((cast(s32) src_g[x]) >> ((shift) & 31));
            dst_argb[2] = cast,no_check(u8) clamp255((cast(s32) src_r[x]) >> ((shift) & 31));
            dst_argb[3] = 0xff;
            dst_argb += 4;
        }
    }
}

MergeUVRow_16_C :: (src_u: *u16, src_v: *u16, dst_uv: *u16, depth: s32, width: s32) {
    shift := 16 - depth;
    assert(depth >= 8);
    assert(depth <= 16);

    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[0] = cast,no_check(u16) ((cast(s32) src_u[x]) << ((shift) & 31));
            dst_uv[1] = cast,no_check(u16) ((cast(s32) src_v[x]) << ((shift) & 31));
            dst_uv += 2;
        }
    }
}

SplitUVRow_16_C :: (src_uv: *u16, dst_u: *u16, dst_v: *u16, depth: s32, width: s32) {
    shift := 16 - depth;

    assert(depth >= 8);
    assert(depth <= 16);
    if 0 < width {
        for x: 0..width - 1 {
            dst_u[x] = cast,no_check(u16) ((cast(s32) src_uv[0]) >> ((shift) & 31));
            dst_v[x] = cast,no_check(u16) ((cast(s32) src_uv[1]) >> ((shift) & 31));
            src_uv += 2;
        }
    }
}

MultiplyRow_16_C :: (src_y: *u16, dst_y: *u16, scale: s32, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = cast,no_check(u16) ((cast(s32) src_y[x]) * scale);
        }
    }
}

DivideRow_16_C :: (src_y: *u16, dst_y: *u16, scale: s32, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = cast,no_check(u16) (((cast(s32) src_y[x]) * scale) >> 16);
        }
    }
}

Convert8To16Row_C :: (src_y: *u8, dst_y: *u16, bits: s32, width: s32) {
    shift := 16 - bits;
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = cast,no_check(u16) (((cast(s32) src_y[x]) * 0x101) >> ((shift) & 31));
        }
    }
}

Convert16To8Row_C :: (src_y: *u16, dst_y: *u8, scale: s32, width: s32) {
    assert(scale >= 256);
    assert(scale <= 32768);

    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = cast,no_check(u8) clamp255(((cast(s32) src_y[x]) * scale) >> 16);
        }
    }
}

HalfRow_16To8_C :: (src_uv: *u16, src_uv_stride: s64, dst_uv: *u8, scale: s32, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[x] =
                cast,no_check(u8) clamp255(
                    (((((cast(s32) src_uv[x]) + cast(s32) src_uv[src_uv_stride + cast(s64) x]) + 1) >> 1) * scale) >> 16
                );
        }
    }
}

HalfWidthRow_16To8_C :: (src_uv: *u16, src_uv_stride: s64, dst_uv: *u8, scale: s32, width: s32) {
    s := cast,no_check(*u16) (src_uv);
    t := cast,no_check(*u16) ((src_uv + src_uv_stride));

    x: s32 = 0;
    while x < width - 1 {
        dst_uv[0] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) + 2) >> 2) * scale) >> 16
            );
        dst_uv[1] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[2]) + cast(s32) s[3]) + cast(s32) t[2]) + cast(s32) t[3]) + 2) >> 2) * scale) >> 16
            );
        dst_uv += 2;
        s += 4;
        t += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_uv[0] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) + 2) >> 2) * scale) >> 16
            );
    }
}

HalfWidthRow_16To8_Odd_C :: (src_uv: *u16, src_uv_stride: s64, dst_uv: *u8, scale: s32, width: s32) {
    s := cast,no_check(*u16) (src_uv);
    t := cast,no_check(*u16) ((src_uv + src_uv_stride));

    width -= 1;
    x: s32 = 0;
    while x < width - 1 {
        dst_uv[0] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) + 2) >> 2) * scale) >> 16
            );
        dst_uv[1] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[2]) + cast(s32) s[3]) + cast(s32) t[2]) + cast(s32) t[3]) + 2) >> 2) * scale) >> 16
            );
        dst_uv += 2;
        s += 4;
        t += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_uv[0] =
            cast,no_check(u8) clamp255(
                (((((((cast(s32) s[0]) + cast(s32) s[1]) + cast(s32) t[0]) + cast(s32) t[1]) + 2) >> 2) * scale) >> 16
            );
        dst_uv += 1;
        s += 2;
        t += 2;
    }
    dst_uv[0] = cast,no_check(u8) clamp255((((((cast(s32) s[0]) + cast(s32) t[0]) + 1) >> 1) * scale) >> 16);
}

Convert8To8Row_C :: (src_y: *u8, dst_y: *u8, scale: s32, bias: s32, width: s32) {
    assert(scale >= 0);
    assert(scale <= 255);

    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = cast,no_check(u8) (((cast(s32) src_y[x]) * scale) >> 8 + bias);
        }
    }
}

CopyRow_C :: (src: *u8, dst: *u8, count: s32) {
    copy_memory(dst, src, cast,no_check(u64) count);
}

CopyRow_16_C :: (src: *u16, dst: *u16, count: s32) {
    copy_memory(dst, src, (cast,no_check(u64) count) * 2);
}

ARGBCopyAlphaRow_C :: (src: *u8, dst: *u8, width: s32) {
    i: s32 = 0;
    while i < width - 1 {
        dst[3] = src[3];
        dst[7] = src[7];
        dst += 8;
        src += 8;
        i += 2;
    }
    if width & 1 != 0 {
        dst[3] = src[3];
    }
}

ARGBExtractAlphaRow_C :: (src_argb: *u8, dst_a: *u8, width: s32) {
    i: s32 = 0;
    while i < width - 1 {
        dst_a[0] = src_argb[3];
        dst_a[1] = src_argb[7];
        dst_a += 2;
        src_argb += 8;
        i += 2;
    }
    if width & 1 != 0 {
        dst_a[0] = src_argb[3];
    }
}

ARGBCopyYToAlphaRow_C :: (src: *u8, dst: *u8, width: s32) {
    i: s32 = 0;
    while i < width - 1 {
        dst[3] = src[0];
        dst[7] = src[1];
        dst += 8;
        src += 2;
        i += 2;
    }
    if width & 1 != 0 {
        dst[3] = src[0];
    }
}

SetRow_C :: (dst: *u8, v8: u8, width: s32) {
    fill_memory(dst, cast,no_check(s32) v8, cast,no_check(u64) width);
}

ARGBSetRow_C :: (dst_argb: *u8, v32: u32, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            copy_memory(dst_argb + (cast,no_check(u64) x) * 4, *v32, 4);
        }
    }
}

ARGBShuffleRow_C :: (src_argb: *u8, dst_argb: *u8, shuffler: *u8, width: s32) {
    index0 := cast,no_check(s32) shuffler[0];
    index1 := cast,no_check(s32) shuffler[1];
    index2 := cast,no_check(s32) shuffler[2];
    index3 := cast,no_check(s32) shuffler[3];

    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[index0];
            g := src_argb[index1];
            r := src_argb[index2];
            a := src_argb[index3];
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = a;
            src_argb += 4;
            dst_argb += 4;
        }
    }
}

RAWToARGBRow_C :: (src_raw: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            r := src_raw[0];
            g := src_raw[1];
            b := src_raw[2];
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = 255;
            dst_argb += 4;
            src_raw += 3;
        }
    }
}

RAWToRGBARow_C :: (src_raw: *u8, dst_rgba: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            r := src_raw[0];
            g := src_raw[1];
            b := src_raw[2];
            dst_rgba[0] = 255;
            dst_rgba[1] = b;
            dst_rgba[2] = g;
            dst_rgba[3] = r;
            dst_rgba += 4;
            src_raw += 3;
        }
    }
}

RAWToRGB24Row_C :: (src_raw: *u8, dst_rgb24: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            r := src_raw[0];
            g := src_raw[1];
            b := src_raw[2];
            dst_rgb24[0] = b;
            dst_rgb24[1] = g;
            dst_rgb24[2] = r;
            dst_rgb24 += 3;
            src_raw += 3;
        }
    }
}

AR30ToARGBRow_C :: (src_ar30: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            ar30: u32 = ---;
            copy_memory(*ar30, src_ar30, 4);
            b := ar30 >> 2 & 0xff;
            g := ar30 >> 12 & 0xff;
            r := ar30 >> 22 & 0xff;
            a := ar30 >> 30 * 0x55;
            assignment_0: u32 = (b | (g << 8) | (r << 16) | (a << 24));
            ((cast,no_check(*u32) *((cast(*u32) dst_argb).*)).*) = assignment_0;
            dst_argb += 4;
            src_ar30 += 4;
        }
    }
}

AR30ToABGRRow_C :: (src_ar30: *u8, dst_abgr: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            ar30: u32 = ---;
            copy_memory(*ar30, src_ar30, 4);
            b := ar30 >> 2 & 0xff;
            g := ar30 >> 12 & 0xff;
            r := ar30 >> 22 & 0xff;
            a := ar30 >> 30 * 0x55;
            assignment_1: u32 = (r | (g << 8) | (b << 16) | (a << 24));
            ((cast,no_check(*u32) *((cast(*u32) dst_abgr).*)).*) = assignment_1;
            dst_abgr += 4;
            src_ar30 += 4;
        }
    }
}

ARGBToAR30Row_C :: (src_argb: *u8, dst_ar30: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b0 := (cast,no_check(u32) ((cast(s32) src_argb[0]) >> 6)) | ((cast,no_check(u32) src_argb[0]) << 2);
            g0 := (cast,no_check(u32) ((cast(s32) src_argb[1]) >> 6)) | ((cast,no_check(u32) src_argb[1]) << 2);
            r0 := (cast,no_check(u32) ((cast(s32) src_argb[2]) >> 6)) | ((cast,no_check(u32) src_argb[2]) << 2);
            a0 := cast(u32) (src_argb[3] >> 6);
            assignment_2: u32 = (b0 | (g0 << 10) | (r0 << 20) | (a0 << 30));
            ((cast,no_check(*u32) *((cast(*u32) dst_ar30).*)).*) = assignment_2;
            dst_ar30 += 4;
            src_argb += 4;
        }
    }
}

AR30ToAB30Row_C :: (src_ar30: *u8, dst_ab30: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            ar30: u32 = ---;
            copy_memory(*ar30, src_ar30, 4);
            b := ar30 & 0x3ff;
            ga := ar30 & 0xc00ffc00;
            r := ar30 >> 20 & 0x3ff;
            assignment_3: u32 = (r | ga | (b << 20));
            ((cast,no_check(*u32) *((cast(*u32) dst_ab30).*)).*) = assignment_3;
            dst_ab30 += 4;
            src_ar30 += 4;
        }
    }
}

ARGBToRGB565DitherRow_C :: (src_argb: *u8, dst_rgb: *u8, dither4: u32, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dither0 := cast,no_check(s32) ((cast(*u8) *dither4)[x & 3]);
        dither1 := cast,no_check(s32) ((cast(*u8) *dither4)[(x + 1) & 3]);
        b0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[0]) + dither0) >> 3);
        g0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[1]) + dither0) >> 2);
        r0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[2]) + dither0) >> 3);
        b1 := cast,no_check(u8) (clamp255((cast(s32) src_argb[4]) + dither1) >> 3);
        g1 := cast,no_check(u8) (clamp255((cast(s32) src_argb[5]) + dither1) >> 2);
        r1 := cast,no_check(u8) (clamp255((cast(s32) src_argb[6]) + dither1) >> 3);
        assignment_4: u16 = cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb)).*)).*) = assignment_4;
        assignment_5: u16 = cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 5) | ((cast(s32) r1) << 11));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb + 2)).*)).*) = assignment_5;
        dst_rgb += 4;
        src_argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        dither0 := cast,no_check(s32) ((cast(*u8) *dither4)[(width - 1) & 3]);
        b0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[0]) + dither0) >> 3);
        g0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[1]) + dither0) >> 2);
        r0 := cast,no_check(u8) (clamp255((cast(s32) src_argb[2]) + dither0) >> 3);
        assignment_6: u16 = cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11));
        ((cast,no_check(*u16) *((cast(*u16) dst_rgb).*)).*) = assignment_6;
    }
}

ARGBToABGRRow_C :: (src_argb: *u8, dst_abgr: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[0];
            g := src_argb[1];
            r := src_argb[2];
            a := src_argb[3];
            dst_abgr[0] = r;
            dst_abgr[1] = g;
            dst_abgr[2] = b;
            dst_abgr[3] = a;
            dst_abgr += 4;
            src_argb += 4;
        }
    }
}

ARGBToBGRARow_C :: (src_argb: *u8, dst_bgra: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[0];
            g := src_argb[1];
            r := src_argb[2];
            a := src_argb[3];
            dst_bgra[0] = a;
            dst_bgra[1] = r;
            dst_bgra[2] = g;
            dst_bgra[3] = b;
            dst_bgra += 4;
            src_argb += 4;
        }
    }
}

ARGBToRGBARow_C :: (src_argb: *u8, dst_rgba: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[0];
            g := src_argb[1];
            r := src_argb[2];
            a := src_argb[3];
            dst_rgba[0] = a;
            dst_rgba[1] = b;
            dst_rgba[2] = g;
            dst_rgba[3] = r;
            dst_rgba += 4;
            src_argb += 4;
        }
    }
}

ARGBToRGB24Row_C :: (src_argb: *u8, dst_rgb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[0];
            g := src_argb[1];
            r := src_argb[2];
            dst_rgb[0] = b;
            dst_rgb[1] = g;
            dst_rgb[2] = r;
            dst_rgb += 3;
            src_argb += 4;
        }
    }
}

ARGBToRAWRow_C :: (src_argb: *u8, dst_rgb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_argb[0];
            g := src_argb[1];
            r := src_argb[2];
            dst_rgb[0] = r;
            dst_rgb[1] = g;
            dst_rgb[2] = b;
            dst_rgb += 3;
            src_argb += 4;
        }
    }
}

ARGBToRGB565Row_C :: (src_argb: *u8, dst_rgb: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        b0 := cast(u8) (src_argb[0] >> 3);
        g0 := cast(u8) (src_argb[1] >> 2);
        r0 := cast(u8) (src_argb[2] >> 3);
        b1 := cast(u8) (src_argb[4] >> 3);
        g1 := cast(u8) (src_argb[5] >> 2);
        r1 := cast(u8) (src_argb[6] >> 3);
        writeword(
            dst_rgb,
            cast,no_check(u32) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11) | ((cast(s32) b1) << 16) | ((cast(s32) g1) << 21) | ((cast(s32) r1) << 27))
        );
        dst_rgb += 4;
        src_argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast(u8) (src_argb[0] >> 3);
        g0 := cast(u8) (src_argb[1] >> 2);
        r0 := cast(u8) (src_argb[2] >> 3);
        assignment_7: u16 = cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11));
        ((cast,no_check(*u16) *((cast(*u16) dst_rgb).*)).*) = assignment_7;
    }
}

writeword :: (p: *u8, v: u32) {
    copy_memory(p, *v, 4);
}

ARGBToARGB1555Row_C :: (src_argb: *u8, dst_rgb: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        b0 := cast(u8) (src_argb[0] >> 3);
        g0 := cast(u8) (src_argb[1] >> 3);
        r0 := cast(u8) (src_argb[2] >> 3);
        a0 := cast(u8) (src_argb[3] >> 7);
        b1 := cast(u8) (src_argb[4] >> 3);
        g1 := cast(u8) (src_argb[5] >> 3);
        r1 := cast(u8) (src_argb[6] >> 3);
        a1 := cast(u8) (src_argb[7] >> 7);
        assignment_8: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 10) | ((cast(s32) a0) << 15));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb)).*)).*) = assignment_8;
        assignment_9: u16 =
            cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 5) | ((cast(s32) r1) << 10) | ((cast(s32) a1) << 15));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb + 2)).*)).*) = assignment_9;
        dst_rgb += 4;
        src_argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast(u8) (src_argb[0] >> 3);
        g0 := cast(u8) (src_argb[1] >> 3);
        r0 := cast(u8) (src_argb[2] >> 3);
        a0 := cast(u8) (src_argb[3] >> 7);
        assignment_10: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 10) | ((cast(s32) a0) << 15));
        ((cast,no_check(*u16) *((cast(*u16) dst_rgb).*)).*) = assignment_10;
    }
}

ARGBToARGB4444Row_C :: (src_argb: *u8, dst_rgb: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        b0 := cast(u8) (src_argb[0] >> 4);
        g0 := cast(u8) (src_argb[1] >> 4);
        r0 := cast(u8) (src_argb[2] >> 4);
        a0 := cast(u8) (src_argb[3] >> 4);
        b1 := cast(u8) (src_argb[4] >> 4);
        g1 := cast(u8) (src_argb[5] >> 4);
        r1 := cast(u8) (src_argb[6] >> 4);
        a1 := cast(u8) (src_argb[7] >> 4);
        assignment_11: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 4) | ((cast(s32) r0) << 8) | ((cast(s32) a0) << 12));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb)).*)).*) = assignment_11;
        assignment_12: u16 =
            cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 4) | ((cast(s32) r1) << 8) | ((cast(s32) a1) << 12));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb + 2)).*)).*) = assignment_12;
        dst_rgb += 4;
        src_argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        b0 := cast(u8) (src_argb[0] >> 4);
        g0 := cast(u8) (src_argb[1] >> 4);
        r0 := cast(u8) (src_argb[2] >> 4);
        a0 := cast(u8) (src_argb[3] >> 4);
        assignment_13: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 4) | ((cast(s32) r0) << 8) | ((cast(s32) a0) << 12));
        ((cast,no_check(*u16) *((cast(*u16) dst_rgb).*)).*) = assignment_13;
    }
}

ABGRToAR30Row_C :: (src_abgr: *u8, dst_ar30: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            r0 := (cast,no_check(u32) ((cast(s32) src_abgr[0]) >> 6)) | ((cast,no_check(u32) src_abgr[0]) << 2);
            g0 := (cast,no_check(u32) ((cast(s32) src_abgr[1]) >> 6)) | ((cast,no_check(u32) src_abgr[1]) << 2);
            b0 := (cast,no_check(u32) ((cast(s32) src_abgr[2]) >> 6)) | ((cast,no_check(u32) src_abgr[2]) << 2);
            a0 := cast(u32) (src_abgr[3] >> 6);
            assignment_14: u32 = (b0 | (g0 << 10) | (r0 << 20) | (a0 << 30));
            ((cast,no_check(*u32) *((cast(*u32) dst_ar30).*)).*) = assignment_14;
            dst_ar30 += 4;
            src_abgr += 4;
        }
    }
}

ARGBToAR64Row_C :: (src_argb: *u8, dst_ar64: *u16, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u16) ((cast(s32) src_argb[0]) * 0x101);
            g := cast,no_check(u16) ((cast(s32) src_argb[1]) * 0x101);
            r := cast,no_check(u16) ((cast(s32) src_argb[2]) * 0x101);
            a := cast,no_check(u16) ((cast(s32) src_argb[3]) * 0x101);
            dst_ar64[0] = b;
            dst_ar64[1] = g;
            dst_ar64[2] = r;
            dst_ar64[3] = a;
            dst_ar64 += 4;
            src_argb += 4;
        }
    }
}

ARGBToAB64Row_C :: (src_argb: *u8, dst_ab64: *u16, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u16) ((cast(s32) src_argb[0]) * 0x101);
            g := cast,no_check(u16) ((cast(s32) src_argb[1]) * 0x101);
            r := cast,no_check(u16) ((cast(s32) src_argb[2]) * 0x101);
            a := cast,no_check(u16) ((cast(s32) src_argb[3]) * 0x101);
            dst_ab64[0] = r;
            dst_ab64[1] = g;
            dst_ab64[2] = b;
            dst_ab64[3] = a;
            dst_ab64 += 4;
            src_argb += 4;
        }
    }
}

AR64ToARGBRow_C :: (src_ar64: *u16, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(u8) ((cast(s32) src_ar64[0]) >> 8);
            g := cast,no_check(u8) ((cast(s32) src_ar64[1]) >> 8);
            r := cast,no_check(u8) ((cast(s32) src_ar64[2]) >> 8);
            a := cast,no_check(u8) ((cast(s32) src_ar64[3]) >> 8);
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = a;
            dst_argb += 4;
            src_ar64 += 4;
        }
    }
}

AB64ToARGBRow_C :: (src_ab64: *u16, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            r := cast,no_check(u8) ((cast(s32) src_ab64[0]) >> 8);
            g := cast,no_check(u8) ((cast(s32) src_ab64[1]) >> 8);
            b := cast,no_check(u8) ((cast(s32) src_ab64[2]) >> 8);
            a := cast,no_check(u8) ((cast(s32) src_ab64[3]) >> 8);
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = a;
            dst_argb += 4;
            src_ab64 += 4;
        }
    }
}

AR64ToAB64Row_C :: (src_ar64: *u16, dst_ab64: *u16, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := src_ar64[0];
            g := src_ar64[1];
            r := src_ar64[2];
            a := src_ar64[3];
            dst_ab64[0] = r;
            dst_ab64[1] = g;
            dst_ab64[2] = b;
            dst_ab64[3] = a;
            dst_ab64 += 4;
            src_ar64 += 4;
        }
    }
}

RGBAToARGBRow_C :: (src_rgba: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            a := src_rgba[0];
            b := src_rgba[1];
            g := src_rgba[2];
            r := src_rgba[3];
            dst_argb[0] = b;
            dst_argb[1] = g;
            dst_argb[2] = r;
            dst_argb[3] = a;
            dst_argb += 4;
            src_rgba += 4;
        }
    }
}

AR64ShuffleRow_C :: (src_ar64: *u8, dst_ar64: *u8, shuffler: *u8, width: s32) {
    src_ar64_16 := cast,no_check(*u16) (cast(*u16) src_ar64);
    dst_ar64_16 := cast,no_check(*u16) (cast(*u16) dst_ar64);
    index0 := (cast(s32) shuffler[0]) / 2;
    index1 := (cast(s32) shuffler[2]) / 2;
    index2 := (cast(s32) shuffler[4]) / 2;
    index3 := (cast(s32) shuffler[6]) / 2;

    x: s32 = 0;
    while x < width / 2 {
        b := src_ar64_16[index0];
        g := src_ar64_16[index1];
        r := src_ar64_16[index2];
        a := src_ar64_16[index3];
        dst_ar64_16[0] = b;
        dst_ar64_16[1] = g;
        dst_ar64_16[2] = r;
        dst_ar64_16[3] = a;
        src_ar64_16 += 4;
        dst_ar64_16 += 4;
        x += 1;
    }
}

J400ToARGBRow_C :: (src_y: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            y := src_y[0];
            dst_argb[0] = y;
            dst_argb[1] = dst_argb[0];
            dst_argb[2] = dst_argb[1];
            dst_argb[3] = 255;
            dst_argb += 4;
            src_y += 1;
        }
    }
}

I444ToARGBRow_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
            rgb_buf[3] = 255;
            src_y += 1;
            src_u += 1;
            src_v += 1;
            rgb_buf += 4;
        }
    }
}

yuv_pixel :: (y: u8, u: u8, v: u8, b: *u8, g: *u8, r: *u8, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    y32 := cast,no_check(u32) ((cast(s32) y) * 0x101);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = cast,no_check(u8) clamp(b16 >> 6);
    g.* = cast,no_check(u8) clamp(g16 >> 6);
    r.* = cast,no_check(u8) clamp(r16 >> 6);
}

clamp :: (val: s32) -> u32 {
    v: s32 = clamp0(val);
    return cast,no_check(u32) clamp255(v);
}

clamp0 :: (v: s32) -> s32 {
    return -(cast(s32) (v >= 0)) & v;
}

I444ToRGB24Row_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
            src_y += 1;
            src_u += 1;
            src_v += 1;
            rgb_buf += 3;
        }
    }
}

I422ToARGBRow_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel(src_y[1], src_u[0], src_v[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

I422ToAR30Row_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel8_16(src_y[0], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf, b, g, r);
        yuv_pixel8_16(src_y[1], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf + 4, b, g, r);
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel8_16(src_y[0], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf, b, g, r);
    }
}

store_ar30 :: (rgb_buf: *u8, b: s32, g: s32, r: s32) {
    b = b >> 4;
    g = g >> 4;
    r = r >> 4;
    b = cast,no_check(s32) clamp10(b);
    g = cast,no_check(s32) clamp10(g);
    r = cast,no_check(s32) clamp10(r);
    ar30 := (cast,no_check(u32) b) | ((cast,no_check(u32) g) << 10) | ((cast,no_check(u32) r) << 20) | 0xc0000000;
    assignment_15: u32 = ar30;
    ((cast,no_check(*u32) *((cast(*u32) rgb_buf).*)).*) = assignment_15;
}

clamp10 :: (val: s32) -> u32 {
    v: s32 = clamp0(val);
    return cast,no_check(u32) clamp1023(v);
}

yuv_pixel8_16 :: (y: u8, u: u8, v: u8, b: *s32, g: *s32, r: *s32, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := (cast(s32) yuvconstants.k_y_bias_to_rgb[0]) - 24;
    y32 := cast,no_check(u32) ((cast(s32) y) * 0x101);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = b16;
    g.* = g16;
    r.* = r16;
}

I210ToAR30Row_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel10_16(src_y[0], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf, b, g, r);
        yuv_pixel10_16(src_y[1], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf + 4, b, g, r);
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel10_16(src_y[0], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
        store_ar30(rgb_buf, b, g, r);
    }
}

yuv_pixel10_16 :: (y: u16, u: u16, v: u16, b: *s32, g: *s32, r: *s32, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    y32 := cast,no_check(u32) ((cast(s32) y) << 6 | ((cast(s32) y) >> 4));
    u = cast,no_check(u16) cast,no_check(u8) clamp255((cast(s32) u) >> 2);
    v = cast,no_check(u16) cast,no_check(u8) clamp255((cast(s32) v) >> 2);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = b16;
    g.* = g16;
    r.* = r16;
}

I210ToARGBRow_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel10(src_y[1], src_u[0], src_v[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

yuv_pixel10 :: (y: u16, u: u16, v: u16, b: *u8, g: *u8, r: *u8, yuvconstants: *Yuv_Constants) {
    b16: s32 = ---;
    g16: s32 = ---;
    r16: s32 = ---;
    yuv_pixel10_16(y, u, v, *b16, *g16, *r16, yuvconstants);
    b.* = cast,no_check(u8) clamp(b16 >> 6);
    g.* = cast,no_check(u8) clamp(g16 >> 6);
    r.* = cast,no_check(u8) clamp(r16 >> 6);
}

I212ToAR30Row_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel12_16(
            cast,no_check(s16) src_y[0],
            cast,no_check(s16) src_u[0],
            cast,no_check(s16) src_v[0],
            *b,
            *g,
            *r,
            yuvconstants
        );
        store_ar30(rgb_buf, b, g, r);
        yuv_pixel12_16(
            cast,no_check(s16) src_y[1],
            cast,no_check(s16) src_u[0],
            cast,no_check(s16) src_v[0],
            *b,
            *g,
            *r,
            yuvconstants
        );
        store_ar30(rgb_buf + 4, b, g, r);
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel12_16(
            cast,no_check(s16) src_y[0],
            cast,no_check(s16) src_u[0],
            cast,no_check(s16) src_v[0],
            *b,
            *g,
            *r,
            yuvconstants
        );
        store_ar30(rgb_buf, b, g, r);
    }
}

yuv_pixel12_16 :: (y: s16, u: s16, v: s16, b: *s32, g: *s32, r: *s32, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    y32 := cast,no_check(u32) ((cast(s32) y) << 4 | ((cast(s32) y) >> 8));
    u = cast,no_check(s16) cast,no_check(u8) clamp255((cast(s32) u) >> 4);
    v = cast,no_check(s16) cast,no_check(u8) clamp255((cast(s32) v) >> 4);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = b16;
    g.* = g16;
    r.* = r16;
}

I212ToARGBRow_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel12(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel12(src_y[1], src_u[0], src_v[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel12(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

yuv_pixel12 :: (y: u16, u: u16, v: u16, b: *u8, g: *u8, r: *u8, yuvconstants: *Yuv_Constants) {
    b16: s32 = ---;
    g16: s32 = ---;
    r16: s32 = ---;
    yuv_pixel12_16(cast,no_check(s16) y, cast,no_check(s16) u, cast,no_check(s16) v, *b16, *g16, *r16, yuvconstants);
    b.* = cast,no_check(u8) clamp(b16 >> 6);
    g.* = cast,no_check(u8) clamp(g16 >> 6);
    r.* = cast,no_check(u8) clamp(r16 >> 6);
}

I410ToAR30Row_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel10_16(src_y[0], src_u[0], src_v[0], *b, *g, *r, yuvconstants);
            store_ar30(rgb_buf, b, g, r);
            src_y += 1;
            src_u += 1;
            src_v += 1;
            rgb_buf += 4;
        }
    }
}

I410ToARGBRow_C :: (src_y: *u16, src_u: *u16, src_v: *u16, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
            rgb_buf[3] = 255;
            src_y += 1;
            src_u += 1;
            src_v += 1;
            rgb_buf += 4;
        }
    }
}

I210AlphaToARGBRow_C :: (
    src_y: *u16,
    src_u: *u16,
    src_v: *u16,
    src_a: *u16,
    rgb_buf: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = cast,no_check(u8) clamp255((cast(s32) src_a[0]) >> 2);
        yuv_pixel10(src_y[1], src_u[0], src_v[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = cast,no_check(u8) clamp255((cast(s32) src_a[1]) >> 2);
        src_y += 2;
        src_u += 1;
        src_v += 1;
        src_a += 2;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = cast,no_check(u8) clamp255((cast(s32) src_a[0]) >> 2);
    }
}

I410AlphaToARGBRow_C :: (
    src_y: *u16,
    src_u: *u16,
    src_v: *u16,
    src_a: *u16,
    rgb_buf: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel10(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
            rgb_buf[3] = cast,no_check(u8) clamp255((cast(s32) src_a[0]) >> 2);
            src_y += 1;
            src_u += 1;
            src_v += 1;
            src_a += 1;
            rgb_buf += 4;
        }
    }
}

I444AlphaToARGBRow_C :: (
    src_y: *u8,
    src_u: *u8,
    src_v: *u8,
    src_a: *u8,
    rgb_buf: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
            rgb_buf[3] = src_a[0];
            src_y += 1;
            src_u += 1;
            src_v += 1;
            src_a += 1;
            rgb_buf += 4;
        }
    }
}

I422AlphaToARGBRow_C :: (
    src_y: *u8,
    src_u: *u8,
    src_v: *u8,
    src_a: *u8,
    rgb_buf: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = src_a[0];
        yuv_pixel(src_y[1], src_u[0], src_v[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = src_a[1];
        src_y += 2;
        src_u += 1;
        src_v += 1;
        src_a += 2;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = src_a[0];
    }
}

NV12ToARGBRow_C :: (src_y: *u8, src_uv: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel(src_y[1], src_uv[0], src_uv[1], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        src_uv += 2;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

NV12ToRGB565Row_C :: (src_y: *u8, src_uv: *u8, dst_rgb565: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b0: u8 = ---;
    g0: u8 = ---;
    r0: u8 = ---;
    b1: u8 = ---;
    g1: u8 = ---;
    r1: u8 = ---;

    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], *b0, *g0, *r0, yuvconstants);
        yuv_pixel(src_y[1], src_uv[0], src_uv[1], *b1, *g1, *r1, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 2);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        b1 = cast,no_check(u8) ((cast(s32) b1) >> 3);
        g1 = cast,no_check(u8) ((cast(s32) g1) >> 2);
        r1 = cast,no_check(u8) ((cast(s32) r1) >> 3);
        assignment_16: u16 =
            cast,no_check(u16) (((cast(s32) (cast,no_check(u16) b0)) | cast(s32) (cast,no_check(u16) ((cast(s32) g0) << 5))) | cast(s32) (cast,no_check(u16) ((cast(s32) r0) << 11)));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb565)).*)).*) = assignment_16;
        assignment_17: u16 =
            cast,no_check(u16) (((cast(s32) (cast,no_check(u16) b1)) | cast(s32) (cast,no_check(u16) ((cast(s32) g1) << 5))) | cast(s32) (cast,no_check(u16) ((cast(s32) r1) << 11)));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb565 + 2)).*)).*) = assignment_17;
        src_y += 2;
        src_uv += 2;
        dst_rgb565 += 4;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], *b0, *g0, *r0, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 2);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        assignment_18: u16 =
            cast,no_check(u16) (((cast(s32) (cast,no_check(u16) b0)) | cast(s32) (cast,no_check(u16) ((cast(s32) g0) << 5))) | cast(s32) (cast,no_check(u16) ((cast(s32) r0) << 11)));
        ((cast,no_check(*u16) *((cast(*u16) dst_rgb565).*)).*) = assignment_18;
    }
}

NV21ToARGBRow_C :: (src_y: *u8, src_vu: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_vu[1], src_vu[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel(src_y[1], src_vu[1], src_vu[0], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        src_vu += 2;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_vu[1], src_vu[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

NV12ToRGB24Row_C :: (src_y: *u8, src_uv: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        yuv_pixel(src_y[1], src_uv[0], src_uv[1], rgb_buf + 3, rgb_buf + 4, rgb_buf + 5, yuvconstants);
        src_y += 2;
        src_uv += 2;
        rgb_buf += 6;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_uv[0], src_uv[1], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
    }
}

NV21ToRGB24Row_C :: (src_y: *u8, src_vu: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_vu[1], src_vu[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        yuv_pixel(src_y[1], src_vu[1], src_vu[0], rgb_buf + 3, rgb_buf + 4, rgb_buf + 5, yuvconstants);
        src_y += 2;
        src_vu += 2;
        rgb_buf += 6;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_vu[1], src_vu[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
    }
}

NV21ToYUV24Row_C :: (src_y: *u8, src_vu: *u8, dst_yuv24: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_yuv24[0] = src_vu[0];
        dst_yuv24[1] = src_vu[1];
        dst_yuv24[2] = src_y[0];
        dst_yuv24[3] = src_vu[0];
        dst_yuv24[4] = src_vu[1];
        dst_yuv24[5] = src_y[1];
        src_y += 2;
        src_vu += 2;
        dst_yuv24 += 6;
        x += 2;
    }
    if width & 1 != 0 {
        dst_yuv24[0] = src_vu[0];
        dst_yuv24[1] = src_vu[1];
        dst_yuv24[2] = src_y[0];
    }
}

YUY2ToARGBRow_C :: (src_yuy2: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_yuy2[0], src_yuy2[1], src_yuy2[3], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel(src_yuy2[2], src_yuy2[1], src_yuy2[3], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_yuy2 += 4;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_yuy2[0], src_yuy2[1], src_yuy2[3], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

UYVYToARGBRow_C :: (src_uyvy: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_uyvy[1], src_uyvy[0], src_uyvy[2], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        yuv_pixel(src_uyvy[3], src_uyvy[0], src_uyvy[2], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_uyvy += 4;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_uyvy[1], src_uyvy[0], src_uyvy[2], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

P210ToARGBRow_C :: (src_y: *u16, src_uv: *u16, dst_argb: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel16_8(src_y[0], src_uv[0], src_uv[1], dst_argb, dst_argb + 1, dst_argb + 2, yuvconstants);
        dst_argb[3] = 255;
        yuv_pixel16_8(src_y[1], src_uv[0], src_uv[1], dst_argb + 4, dst_argb + 5, dst_argb + 6, yuvconstants);
        dst_argb[7] = 255;
        src_y += 2;
        src_uv += 2;
        dst_argb += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel16_8(src_y[0], src_uv[0], src_uv[1], dst_argb, dst_argb + 1, dst_argb + 2, yuvconstants);
        dst_argb[3] = 255;
    }
}

yuv_pixel16_8 :: (y: u16, u: u16, v: u16, b: *u8, g: *u8, r: *u8, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    y32 := cast,no_check(u32) y;
    u = cast,no_check(u16) clamp255((cast(s32) u) >> 8);
    v = cast,no_check(u16) clamp255((cast(s32) v) >> 8);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = cast,no_check(u8) clamp(b16 >> 6);
    g.* = cast,no_check(u8) clamp(g16 >> 6);
    r.* = cast,no_check(u8) clamp(r16 >> 6);
}

P410ToARGBRow_C :: (src_y: *u16, src_uv: *u16, dst_argb: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel16_8(src_y[0], src_uv[0], src_uv[1], dst_argb, dst_argb + 1, dst_argb + 2, yuvconstants);
            dst_argb[3] = 255;
            src_y += 1;
            src_uv += 2;
            dst_argb += 4;
        }
    }
}

P210ToAR30Row_C :: (src_y: *u16, src_uv: *u16, dst_ar30: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel16_16(src_y[0], src_uv[0], src_uv[1], *b, *g, *r, yuvconstants);
        store_ar30(dst_ar30, b, g, r);
        yuv_pixel16_16(src_y[1], src_uv[0], src_uv[1], *b, *g, *r, yuvconstants);
        store_ar30(dst_ar30 + 4, b, g, r);
        src_y += 2;
        src_uv += 2;
        dst_ar30 += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel16_16(src_y[0], src_uv[0], src_uv[1], *b, *g, *r, yuvconstants);
        store_ar30(dst_ar30, b, g, r);
    }
}

yuv_pixel16_16 :: (y: u16, u: u16, v: u16, b: *s32, g: *s32, r: *s32, yuvconstants: *Yuv_Constants) {
    ub := cast,no_check(s32) yuvconstants.k_uv_to_b[0];

    ug := cast,no_check(s32) yuvconstants.k_uv_to_g[0];

    vg := cast,no_check(s32) yuvconstants.k_uv_to_g[1];

    vr := cast,no_check(s32) yuvconstants.k_uv_to_r[1];

    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    yb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    y32 := cast,no_check(u32) y;
    u = cast,no_check(u16) clamp255((cast(s32) u) >> 8);
    v = cast,no_check(u16) clamp255((cast(s32) v) >> 8);
    y1 := cast,no_check(s32) (((y32 * cast,no_check(u32) yg) >> 16) + cast,no_check(u32) yb);

    ui := cast,no_check(s8) u;

    vi := cast,no_check(s8) v;

    ui = cast,no_check(s8) ((cast,no_check(s32) ui) - 0x80);

    vi = cast,no_check(s8) ((cast,no_check(s32) vi) - 0x80);

    b16: s32 = y1 + (cast(s32) ui) * ub;

    g16: s32 = y1 - ((cast(s32) ui) * ug + (cast(s32) vi) * vg);

    r16: s32 = y1 + (cast(s32) vi) * vr;
    b.* = b16;
    g.* = g16;
    r.* = r16;
}

P410ToAR30Row_C :: (src_y: *u16, src_uv: *u16, dst_ar30: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b: s32 = ---;
    g: s32 = ---;
    r: s32 = ---;
    if 0 < width {
        for x: 0..width - 1 {
            yuv_pixel16_16(src_y[0], src_uv[0], src_uv[1], *b, *g, *r, yuvconstants);
            store_ar30(dst_ar30, b, g, r);
            src_y += 1;
            src_uv += 2;
            dst_ar30 += 4;
        }
    }
}

I422ToRGBARow_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf + 1, rgb_buf + 2, rgb_buf + 3, yuvconstants);
        rgb_buf[0] = 255;
        yuv_pixel(src_y[1], src_u[0], src_v[0], rgb_buf + 5, rgb_buf + 6, rgb_buf + 7, yuvconstants);
        rgb_buf[4] = 255;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf + 1, rgb_buf + 2, rgb_buf + 3, yuvconstants);
        rgb_buf[0] = 255;
    }
}

I422ToRGB24Row_C :: (src_y: *u8, src_u: *u8, src_v: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        yuv_pixel(src_y[1], src_u[0], src_v[0], rgb_buf + 3, rgb_buf + 4, rgb_buf + 5, yuvconstants);
        src_y += 2;
        src_u += 1;
        src_v += 1;
        rgb_buf += 6;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
    }
}

I422ToARGB4444Row_C :: (
    src_y: *u8,
    src_u: *u8,
    src_v: *u8,
    dst_argb4444: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    b0: u8 = ---;
    g0: u8 = ---;
    r0: u8 = ---;
    b1: u8 = ---;
    g1: u8 = ---;
    r1: u8 = ---;

    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        yuv_pixel(src_y[1], src_u[0], src_v[0], *b1, *g1, *r1, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 4);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 4);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 4);
        b1 = cast,no_check(u8) ((cast(s32) b1) >> 4);
        g1 = cast,no_check(u8) ((cast(s32) g1) >> 4);
        r1 = cast,no_check(u8) ((cast(s32) r1) >> 4);
        assignment_19: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 4) | ((cast(s32) r0) << 8) | 0xf000);
        ((cast,no_check(*u16) *((cast(*u16) (dst_argb4444)).*)).*) = assignment_19;
        assignment_20: u16 =
            cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 4) | ((cast(s32) r1) << 8) | 0xf000);
        ((cast,no_check(*u16) *((cast(*u16) (dst_argb4444 + 2)).*)).*) = assignment_20;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        dst_argb4444 += 4;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 4);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 4);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 4);
        assignment_21: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 4) | ((cast(s32) r0) << 8) | 0xf000);
        ((cast,no_check(*u16) *((cast(*u16) dst_argb4444).*)).*) = assignment_21;
    }
}

I422ToARGB1555Row_C :: (
    src_y: *u8,
    src_u: *u8,
    src_v: *u8,
    dst_argb1555: *u8,
    yuvconstants: *Yuv_Constants,
    width: s32
) {
    b0: u8 = ---;
    g0: u8 = ---;
    r0: u8 = ---;
    b1: u8 = ---;
    g1: u8 = ---;
    r1: u8 = ---;

    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        yuv_pixel(src_y[1], src_u[0], src_v[0], *b1, *g1, *r1, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 3);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        b1 = cast,no_check(u8) ((cast(s32) b1) >> 3);
        g1 = cast,no_check(u8) ((cast(s32) g1) >> 3);
        r1 = cast,no_check(u8) ((cast(s32) r1) >> 3);
        assignment_22: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 10) | 0x8000);
        ((cast,no_check(*u16) *((cast(*u16) (dst_argb1555)).*)).*) = assignment_22;
        assignment_23: u16 =
            cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 5) | ((cast(s32) r1) << 10) | 0x8000);
        ((cast,no_check(*u16) *((cast(*u16) (dst_argb1555 + 2)).*)).*) = assignment_23;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        dst_argb1555 += 4;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 3);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        assignment_24: u16 =
            cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 10) | 0x8000);
        ((cast,no_check(*u16) *((cast(*u16) dst_argb1555).*)).*) = assignment_24;
    }
}

I422ToRGB565Row_C :: (src_y: *u8, src_u: *u8, src_v: *u8, dst_rgb565: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    b0: u8 = ---;
    g0: u8 = ---;
    r0: u8 = ---;
    b1: u8 = ---;
    g1: u8 = ---;
    r1: u8 = ---;

    x: s32 = 0;
    while x < width - 1 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        yuv_pixel(src_y[1], src_u[0], src_v[0], *b1, *g1, *r1, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 2);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        b1 = cast,no_check(u8) ((cast(s32) b1) >> 3);
        g1 = cast,no_check(u8) ((cast(s32) g1) >> 2);
        r1 = cast,no_check(u8) ((cast(s32) r1) >> 3);
        assignment_25: u16 = cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb565)).*)).*) = assignment_25;
        assignment_26: u16 = cast,no_check(u16) ((cast(s32) b1) | ((cast(s32) g1) << 5) | ((cast(s32) r1) << 11));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb565 + 2)).*)).*) = assignment_26;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        dst_rgb565 += 4;
        x += 2;
    }
    if width & 1 != 0 {
        yuv_pixel(src_y[0], src_u[0], src_v[0], *b0, *g0, *r0, yuvconstants);
        b0 = cast,no_check(u8) ((cast(s32) b0) >> 3);
        g0 = cast,no_check(u8) ((cast(s32) g0) >> 2);
        r0 = cast,no_check(u8) ((cast(s32) r0) >> 3);
        assignment_27: u16 = cast,no_check(u16) ((cast(s32) b0) | ((cast(s32) g0) << 5) | ((cast(s32) r0) << 11));
        ((cast,no_check(*u16) *((cast(*u16) (dst_rgb565)).*)).*) = assignment_27;
    }
}

I400ToARGBRow_C :: (src_y: *u8, rgb_buf: *u8, yuvconstants: *Yuv_Constants, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        y_pixel(src_y[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
        y_pixel(src_y[1], rgb_buf + 4, rgb_buf + 5, rgb_buf + 6, yuvconstants);
        rgb_buf[7] = 255;
        src_y += 2;
        rgb_buf += 8;
        x += 2;
    }
    if width & 1 != 0 {
        y_pixel(src_y[0], rgb_buf, rgb_buf + 1, rgb_buf + 2, yuvconstants);
        rgb_buf[3] = 255;
    }
}

y_pixel :: (y: u8, b: *u8, g: *u8, r: *u8, yuvconstants: *Yuv_Constants) {
    ygb := cast,no_check(s32) yuvconstants.k_y_bias_to_rgb[0];
    yg := cast,no_check(s32) yuvconstants.k_y_to_rgb[0];

    y1 := (cast,no_check(u32) ((cast(s32) y) * 0x101 * yg)) >> 16;
    b8 := cast,no_check(u8) clamp(((cast,no_check(s32) y1) + ygb) >> 6);
    b.* = b8;
    g.* = b8;
    r.* = b8;
}

ARGBBlendRow_C :: (src_argb: *u8, src_argb1: *u8, dst_argb: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        fb := cast,no_check(u32) src_argb[0];
        fg := cast,no_check(u32) src_argb[1];
        fr := cast,no_check(u32) src_argb[2];
        a := cast,no_check(u32) src_argb[3];
        bb := cast,no_check(u32) src_argb1[0];
        bg := cast,no_check(u32) src_argb1[1];
        br := cast,no_check(u32) src_argb1[2];
        dst_argb[0] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bb) >> 8 + fb));
        dst_argb[1] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bg) >> 8 + fg));
        dst_argb[2] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * br) >> 8 + fr));
        dst_argb[3] = 255;

        fb = cast,no_check(u32) src_argb[4 + 0];
        fg = cast,no_check(u32) src_argb[4 + 1];
        fr = cast,no_check(u32) src_argb[4 + 2];
        a = cast,no_check(u32) src_argb[4 + 3];
        bb = cast,no_check(u32) src_argb1[4 + 0];
        bg = cast,no_check(u32) src_argb1[4 + 1];
        br = cast,no_check(u32) src_argb1[4 + 2];
        dst_argb[4 + 0] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bb) >> 8 + fb));
        dst_argb[4 + 1] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bg) >> 8 + fg));
        dst_argb[4 + 2] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * br) >> 8 + fr));
        dst_argb[4 + 3] = 255;
        src_argb += 8;
        src_argb1 += 8;
        dst_argb += 8;
        x += 2;
    }

    if width & 1 != 0 {
        fb := cast,no_check(u32) src_argb[0];
        fg := cast,no_check(u32) src_argb[1];
        fr := cast,no_check(u32) src_argb[2];
        a := cast,no_check(u32) src_argb[3];
        bb := cast,no_check(u32) src_argb1[0];
        bg := cast,no_check(u32) src_argb1[1];
        br := cast,no_check(u32) src_argb1[2];
        dst_argb[0] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bb) >> 8 + fb));
        dst_argb[1] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * bg) >> 8 + fg));
        dst_argb[2] = cast,no_check(u8) clamp255(cast,no_check(s32) (((256 - a) * br) >> 8 + fr));
        dst_argb[3] = 255;
    }
}

BlendPlaneRow_C :: (src0: *u8, src1: *u8, alpha: *u8, dst: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst[0] =
            cast,no_check(u8) (((((cast(s32) alpha[0]) * cast(s32) src0[0]) + (255 - cast(s32) alpha[0]) * cast(s32) src1[0]) +
                255) >> 8);
        dst[1] =
            cast,no_check(u8) (((((cast(s32) alpha[1]) * cast(s32) src0[1]) + (255 - cast(s32) alpha[1]) * cast(s32) src1[1]) +
                255) >> 8);
        src0 += 2;
        src1 += 2;
        alpha += 2;
        dst += 2;
        x += 2;
    }
    if width & 1 != 0 {
        dst[0] =
            cast,no_check(u8) (((((cast(s32) alpha[0]) * cast(s32) src0[0]) + (255 - cast(s32) alpha[0]) * cast(s32) src1[0]) +
                255) >> 8);
    }
}

ARGBMultiplyRow_C :: (src_argb: *u8, src_argb1: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            B := cast,no_check(u32) src_argb[0];
            G := cast,no_check(u32) src_argb[1];
            R := cast,no_check(u32) src_argb[2];
            A := cast,no_check(u32) src_argb[3];
            B_SCALE := cast,no_check(u32) src_argb1[0];
            G_SCALE := cast,no_check(u32) src_argb1[1];
            R_SCALE := cast,no_check(u32) src_argb1[2];
            A_SCALE := cast,no_check(u32) src_argb1[3];
            dst_argb[0] = cast,no_check(u8) ((B * B_SCALE + 128) >> 8);
            dst_argb[1] = cast,no_check(u8) ((G * G_SCALE + 128) >> 8);
            dst_argb[2] = cast,no_check(u8) ((R * R_SCALE + 128) >> 8);
            dst_argb[3] = cast,no_check(u8) ((A * A_SCALE + 128) >> 8);
            src_argb += 4;
            src_argb1 += 4;
            dst_argb += 4;
        }
    }
}

ARGBAddRow_C :: (src_argb: *u8, src_argb1: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            B := cast,no_check(s32) src_argb[0];
            G := cast,no_check(s32) src_argb[1];
            R := cast,no_check(s32) src_argb[2];
            A := cast,no_check(s32) src_argb[3];
            B_ADD := cast,no_check(s32) src_argb1[0];
            G_ADD := cast,no_check(s32) src_argb1[1];
            R_ADD := cast,no_check(s32) src_argb1[2];
            A_ADD := cast,no_check(s32) src_argb1[3];
            dst_argb[0] = cast,no_check(u8) clamp255(B_ADD + B);
            dst_argb[1] = cast,no_check(u8) clamp255(G_ADD + G);
            dst_argb[2] = cast,no_check(u8) clamp255(R_ADD + R);
            dst_argb[3] = cast,no_check(u8) clamp255(A_ADD + A);
            src_argb += 4;
            src_argb1 += 4;
            dst_argb += 4;
        }
    }
}

ARGBSubtractRow_C :: (src_argb: *u8, src_argb1: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            B := cast,no_check(s32) src_argb[0];
            G := cast,no_check(s32) src_argb[1];
            R := cast,no_check(s32) src_argb[2];
            A := cast,no_check(s32) src_argb[3];
            B_SUB := cast,no_check(s32) src_argb1[0];
            G_SUB := cast,no_check(s32) src_argb1[1];
            R_SUB := cast,no_check(s32) src_argb1[2];
            A_SUB := cast,no_check(s32) src_argb1[3];
            dst_argb[0] = cast,no_check(u8) clamp0(B - B_SUB);
            dst_argb[1] = cast,no_check(u8) clamp0(G - G_SUB);
            dst_argb[2] = cast,no_check(u8) clamp0(R - R_SUB);
            dst_argb[3] = cast,no_check(u8) clamp0(A - A_SUB);
            src_argb += 4;
            src_argb1 += 4;
            dst_argb += 4;
        }
    }
}

YUY2ToYRow_C :: (src_yuy2: *u8, dst_y: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_y[x] = src_yuy2[0];
        dst_y[x + 1] = src_yuy2[2];
        src_yuy2 += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_y[width - 1] = src_yuy2[0];
    }
}

YUY2ToUVRow_C :: (src_yuy2: *u8, src_stride_yuy2: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width {
        src_yuy2_next := cast,no_check(*u8) ((src_yuy2 + src_stride_yuy2));
        dst_u[0] = cast,no_check(u8) ((((cast(s32) src_yuy2[1]) + cast(s32) src_yuy2_next[1]) + 1) >> 1);
        dst_v[0] = cast,no_check(u8) ((((cast(s32) src_yuy2[3]) + cast(s32) src_yuy2_next[3]) + 1) >> 1);
        src_yuy2 += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
}

YUY2ToNVUVRow_C :: (src_yuy2: *u8, src_stride_yuy2: s32, dst_uv: *u8, width: s32) {
    x: s32 = 0;
    while x < width {
        src_yuy2_next := cast,no_check(*u8) ((src_yuy2 + src_stride_yuy2));
        dst_uv[0] = cast,no_check(u8) ((((cast(s32) src_yuy2[1]) + cast(s32) src_yuy2_next[1]) + 1) >> 1);
        dst_uv[1] = cast,no_check(u8) ((((cast(s32) src_yuy2[3]) + cast(s32) src_yuy2_next[3]) + 1) >> 1);
        src_yuy2 += 4;
        dst_uv += 2;
        x += 2;
    }
}

YUY2ToUV422Row_C :: (src_yuy2: *u8, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width {
        dst_u[0] = src_yuy2[1];
        dst_v[0] = src_yuy2[3];
        src_yuy2 += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
}

UYVYToYRow_C :: (src_uyvy: *u8, dst_y: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_y[x] = src_uyvy[1];
        dst_y[x + 1] = src_uyvy[3];
        src_uyvy += 4;
        x += 2;
    }
    if width & 1 != 0 {
        dst_y[width - 1] = src_uyvy[1];
    }
}

UYVYToUVRow_C :: (src_uyvy: *u8, src_stride_uyvy: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width {
        src_uyvy_next := cast,no_check(*u8) ((src_uyvy + src_stride_uyvy));
        dst_u[0] = cast,no_check(u8) ((((cast(s32) src_uyvy[0]) + cast(s32) src_uyvy_next[0]) + 1) >> 1);
        dst_v[0] = cast,no_check(u8) ((((cast(s32) src_uyvy[2]) + cast(s32) src_uyvy_next[2]) + 1) >> 1);
        src_uyvy += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
}

UYVYToUV422Row_C :: (src_uyvy: *u8, dst_u: *u8, dst_v: *u8, width: s32) {
    x: s32 = 0;
    while x < width {
        dst_u[0] = src_uyvy[0];
        dst_v[0] = src_uyvy[2];
        src_uyvy += 4;
        dst_u += 1;
        dst_v += 1;
        x += 2;
    }
}

SwapUVRow_C :: (src_uv: *u8, dst_vu: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            u := src_uv[0];
            v := src_uv[1];
            dst_vu[0] = v;
            dst_vu[1] = u;
            src_uv += 2;
            dst_vu += 2;
        }
    }
}

AYUVToYRow_C :: (src_ayuv: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[x] = src_ayuv[2];
            src_ayuv += 4;
        }
    }
}

AYUVToUVRow_C :: (src_ayuv: *u8, src_stride_ayuv: s32, dst_uv: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        src_ayuv_next := cast,no_check(*u8) ((src_ayuv + src_stride_ayuv));
        dst_uv[0] =
            cast,no_check(u8) ((((((cast(s32) src_ayuv[1]) + cast(s32) src_ayuv[5]) + cast(s32) src_ayuv_next[1]) + cast(s32) src_ayuv_next[5]) +
                2) >> 2);
        dst_uv[1] =
            cast,no_check(u8) ((((((cast(s32) src_ayuv[0]) + cast(s32) src_ayuv[4]) + cast(s32) src_ayuv_next[0]) + cast(s32) src_ayuv_next[4]) +
                2) >> 2);
        src_ayuv += 8;
        dst_uv += 2;
        x += 2;
    }
    if width & 1 != 0 {
        src_ayuv_next := cast,no_check(*u8) ((src_ayuv + src_stride_ayuv));
        dst_uv[0] = cast,no_check(u8) ((((cast(s32) src_ayuv[1]) + cast(s32) src_ayuv_next[1]) + 1) >> 1);
        dst_uv[1] = cast,no_check(u8) ((((cast(s32) src_ayuv[0]) + cast(s32) src_ayuv_next[0]) + 1) >> 1);
    }
}

AYUVToVURow_C :: (src_ayuv: *u8, src_stride_ayuv: s32, dst_vu: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        src_ayuv_next := cast,no_check(*u8) ((src_ayuv + src_stride_ayuv));
        dst_vu[0] =
            cast,no_check(u8) ((((((cast(s32) src_ayuv[0]) + cast(s32) src_ayuv[4]) + cast(s32) src_ayuv_next[0]) + cast(s32) src_ayuv_next[4]) +
                2) >> 2);
        dst_vu[1] =
            cast,no_check(u8) ((((((cast(s32) src_ayuv[1]) + cast(s32) src_ayuv[5]) + cast(s32) src_ayuv_next[1]) + cast(s32) src_ayuv_next[5]) +
                2) >> 2);
        src_ayuv += 8;
        dst_vu += 2;
        x += 2;
    }
    if width & 1 != 0 {
        src_ayuv_next := cast,no_check(*u8) ((src_ayuv + src_stride_ayuv));
        dst_vu[0] = cast,no_check(u8) ((((cast(s32) src_ayuv[0]) + cast(s32) src_ayuv_next[0]) + 1) >> 1);
        dst_vu[1] = cast,no_check(u8) ((((cast(s32) src_ayuv[1]) + cast(s32) src_ayuv_next[1]) + 1) >> 1);
    }
}

I422ToYUY2Row_C :: (src_y: *u8, src_u: *u8, src_v: *u8, dst_frame: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_frame[0] = src_y[0];
        dst_frame[1] = src_u[0];
        dst_frame[2] = src_y[1];
        dst_frame[3] = src_v[0];
        dst_frame += 4;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        dst_frame[0] = src_y[0];
        dst_frame[1] = src_u[0];
        dst_frame[2] = 0;
        dst_frame[3] = src_v[0];
    }
}

I422ToUYVYRow_C :: (src_y: *u8, src_u: *u8, src_v: *u8, dst_frame: *u8, width: s32) {
    x: s32 = 0;
    while x < width - 1 {
        dst_frame[0] = src_u[0];
        dst_frame[1] = src_y[0];
        dst_frame[2] = src_v[0];
        dst_frame[3] = src_y[1];
        dst_frame += 4;
        src_y += 2;
        src_u += 1;
        src_v += 1;
        x += 2;
    }
    if width & 1 != 0 {
        dst_frame[0] = src_u[0];
        dst_frame[1] = src_y[0];
        dst_frame[2] = src_v[0];
        dst_frame[3] = 0;
    }
}

ARGBAttenuateRow_C :: (src_argb: *u8, dst_argb: *u8, width: s32) {
    i: s32 = 0;
    while i < width - 1 {
        b := cast,no_check(u32) src_argb[0];
        g := cast,no_check(u32) src_argb[1];
        r := cast,no_check(u32) src_argb[2];
        a := cast,no_check(u32) src_argb[3];
        dst_argb[0] = cast,no_check(u8) ((b * a + 255) >> 8);
        dst_argb[1] = cast,no_check(u8) ((g * a + 255) >> 8);
        dst_argb[2] = cast,no_check(u8) ((r * a + 255) >> 8);
        dst_argb[3] = cast,no_check(u8) a;
        b = cast,no_check(u32) src_argb[4];
        g = cast,no_check(u32) src_argb[5];
        r = cast,no_check(u32) src_argb[6];
        a = cast,no_check(u32) src_argb[7];
        dst_argb[4] = cast,no_check(u8) ((b * a + 255) >> 8);
        dst_argb[5] = cast,no_check(u8) ((g * a + 255) >> 8);
        dst_argb[6] = cast,no_check(u8) ((r * a + 255) >> 8);
        dst_argb[7] = cast,no_check(u8) a;
        src_argb += 8;
        dst_argb += 8;
        i += 2;
    }

    if width & 1 != 0 {
        B := cast,no_check(u32) src_argb[0];
        G := cast,no_check(u32) src_argb[1];
        R := cast,no_check(u32) src_argb[2];
        A := cast,no_check(u32) src_argb[3];
        dst_argb[0] = cast,no_check(u8) ((B * A + 255) >> 8);
        dst_argb[1] = cast,no_check(u8) ((G * A + 255) >> 8);
        dst_argb[2] = cast,no_check(u8) ((R * A + 255) >> 8);
        dst_argb[3] = cast,no_check(u8) A;
    }
}

ARGBUnattenuateRow_C :: (src_argb: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            b := cast,no_check(u32) src_argb[0];
            g := cast,no_check(u32) src_argb[1];
            r := cast,no_check(u32) src_argb[2];
            A := cast,no_check(u32) src_argb[3];
            IA := FIXED_INVTBL8[A] & 0xffff;

            dst_argb[0] = cast,no_check(u8) clamp255(cast,no_check(s32) ((b | (b << 8) * IA) >> 16));
            dst_argb[1] = cast,no_check(u8) clamp255(cast,no_check(s32) ((g | (g << 8) * IA) >> 16));
            dst_argb[2] = cast,no_check(u8) clamp255(cast,no_check(s32) ((r | (r << 8) * IA) >> 16));
            dst_argb[3] = cast,no_check(u8) A;
            src_argb += 4;
            dst_argb += 4;
        }
    }
}

ARGBGrayRow_C :: (src_argb: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            y := rgb_to_yj(src_argb[2], src_argb[1], src_argb[0]);
            dst_argb[0] = y;
            dst_argb[1] = dst_argb[0];
            dst_argb[2] = dst_argb[1];
            dst_argb[3] = src_argb[3];
            dst_argb += 4;
            src_argb += 4;
        }
    }
}

ARGBSepiaRow_C :: (dst_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(s32) dst_argb[0];
            g := cast,no_check(s32) dst_argb[1];
            r := cast,no_check(s32) dst_argb[2];
            sb := (b * 17 + g * 68 + r * 35) >> 7;
            sg := (b * 22 + g * 88 + r * 45) >> 7;
            sr := (b * 24 + g * 98 + r * 50) >> 7;

            dst_argb[0] = cast,no_check(u8) sb;
            dst_argb[1] = cast,no_check(u8) clamp255(sg);
            dst_argb[2] = cast,no_check(u8) clamp255(sr);
            dst_argb += 4;
        }
    }
}

ARGBColorMatrixRow_C :: (src_argb: *u8, dst_argb: *u8, matrix_argb: *s8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(s32) src_argb[0];
            g := cast,no_check(s32) src_argb[1];
            r := cast,no_check(s32) src_argb[2];
            a := cast,no_check(s32) src_argb[3];
            sb :=
                ((((b * cast(s32) matrix_argb[0]) + g * cast(s32) matrix_argb[1]) + r * cast(s32) matrix_argb[2]) +
                    a * cast(s32) matrix_argb[3]) >> 6;
            sg :=
                ((((b * cast(s32) matrix_argb[4]) + g * cast(s32) matrix_argb[5]) + r * cast(s32) matrix_argb[6]) +
                    a * cast(s32) matrix_argb[7]) >> 6;
            sr :=
                ((((b * cast(s32) matrix_argb[8]) + g * cast(s32) matrix_argb[9]) + r * cast(s32) matrix_argb[10]) +
                    a * cast(s32) matrix_argb[11]) >> 6;
            sa :=
                ((((b * cast(s32) matrix_argb[12]) + g * cast(s32) matrix_argb[13]) + r * cast(s32) matrix_argb[14]) +
                    a * cast(s32) matrix_argb[15]) >> 6;
            dst_argb[0] = cast,no_check(u8) clamp(sb);
            dst_argb[1] = cast,no_check(u8) clamp(sg);
            dst_argb[2] = cast,no_check(u8) clamp(sr);
            dst_argb[3] = cast,no_check(u8) clamp(sa);
            src_argb += 4;
            dst_argb += 4;
        }
    }
}

ARGBColorTableRow_C :: (dst_argb: *u8, table_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(s32) dst_argb[0];
            g := cast,no_check(s32) dst_argb[1];
            r := cast,no_check(s32) dst_argb[2];
            a := cast,no_check(s32) dst_argb[3];
            dst_argb[0] = table_argb[b * 4 + 0];
            dst_argb[1] = table_argb[g * 4 + 1];
            dst_argb[2] = table_argb[r * 4 + 2];
            dst_argb[3] = table_argb[a * 4 + 3];
            dst_argb += 4;
        }
    }
}

RGBColorTableRow_C :: (dst_argb: *u8, table_argb: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(s32) dst_argb[0];
            g := cast,no_check(s32) dst_argb[1];
            r := cast,no_check(s32) dst_argb[2];
            dst_argb[0] = table_argb[b * 4 + 0];
            dst_argb[1] = table_argb[g * 4 + 1];
            dst_argb[2] = table_argb[r * 4 + 2];
            dst_argb += 4;
        }
    }
}

ARGBQuantizeRow_C :: (dst_argb: *u8, scale: s32, interval_size: s32, interval_offset: s32, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            b := cast,no_check(s32) dst_argb[0];
            g := cast,no_check(s32) dst_argb[1];
            r := cast,no_check(s32) dst_argb[2];
            dst_argb[0] = cast,no_check(u8) ((b * scale) >> 16 * interval_size + interval_offset);
            dst_argb[1] = cast,no_check(u8) ((g * scale) >> 16 * interval_size + interval_offset);
            dst_argb[2] = cast,no_check(u8) ((r * scale) >> 16 * interval_size + interval_offset);
            dst_argb += 4;
        }
    }
}

ARGBShadeRow_C :: (src_argb: *u8, dst_argb: *u8, width: s32, value: u32) {
    B_SCALE := (value & 0xff) | ((value & 0xff) << 8);
    G_SCALE := (value >> 8 & 0xff) | ((value >> 8 & 0xff) << 8);
    R_SCALE := (value >> 16 & 0xff) | ((value >> 16 & 0xff) << 8);
    A_SCALE := value >> 24 | (value >> 24 << 8);

    if 0 < width {
        for i: 0..width - 1 {
            B := cast,no_check(u32) ((cast(s32) src_argb[0]) | ((cast(s32) src_argb[0]) << 8));
            G := cast,no_check(u32) ((cast(s32) src_argb[1]) | ((cast(s32) src_argb[1]) << 8));
            R := cast,no_check(u32) ((cast(s32) src_argb[2]) | ((cast(s32) src_argb[2]) << 8));
            A := cast,no_check(u32) ((cast(s32) src_argb[3]) | ((cast(s32) src_argb[3]) << 8));
            dst_argb[0] = cast,no_check(u8) ((B_SCALE * B) >> 24);
            dst_argb[1] = cast,no_check(u8) ((G_SCALE * G) >> 24);
            dst_argb[2] = cast,no_check(u8) ((R_SCALE * R) >> 24);
            dst_argb[3] = cast,no_check(u8) ((A_SCALE * A) >> 24);
            src_argb += 4;
            dst_argb += 4;
        }
    }
}

CumulativeSumToAverageRow_C :: (tl: *s32, bl: *s32, w: s32, area: s32, dst: *u8, count: s32) {
    assert(area != 0);

    ooa := 1.0 / cast,no_check(float32) area;
    if 0 < count {
        for i: 0..count - 1 {
            dst[0] = cast,no_check(u8) ((cast,no_check(float32) (bl[w + 0] + tl[0] - bl[0] - tl[w + 0])) * ooa);
            dst[1] = cast,no_check(u8) ((cast,no_check(float32) (bl[w + 1] + tl[1] - bl[1] - tl[w + 1])) * ooa);
            dst[2] = cast,no_check(u8) ((cast,no_check(float32) (bl[w + 2] + tl[2] - bl[2] - tl[w + 2])) * ooa);
            dst[3] = cast,no_check(u8) ((cast,no_check(float32) (bl[w + 3] + tl[3] - bl[3] - tl[w + 3])) * ooa);
            dst += 4;
            tl += 4;
            bl += 4;
        }
    }
}

ComputeCumulativeSumRow_C :: (row: *u8, cumsum: *s32, previous_cumsum: *s32, width: s32) {
    row_sum := s32.[ 0, 0, 0, 0 ];

    if 0 < width {
        for x: 0..width - 1 {
            row_sum[0] = cast,no_check(s32) (row_sum[0] + cast,no_check(s32) row[x * 4 + 0]);
            row_sum[1] = cast,no_check(s32) (row_sum[1] + cast,no_check(s32) row[x * 4 + 1]);
            row_sum[2] = cast,no_check(s32) (row_sum[2] + cast,no_check(s32) row[x * 4 + 2]);
            row_sum[3] = cast,no_check(s32) (row_sum[3] + cast,no_check(s32) row[x * 4 + 3]);
            cumsum[x * 4 + 0] = row_sum[0] + previous_cumsum[x * 4 + 0];
            cumsum[x * 4 + 1] = row_sum[1] + previous_cumsum[x * 4 + 1];
            cumsum[x * 4 + 2] = row_sum[2] + previous_cumsum[x * 4 + 2];
            cumsum[x * 4 + 3] = row_sum[3] + previous_cumsum[x * 4 + 3];
        }
    }
}

ARGBAffineRow_C :: (src_argb: *u8, src_argb_stride: s32, dst_argb: *u8, uv_dudv: *float32, width: s32) {
    uv: [2] float32 = ---;
    uv[0] = uv_dudv[0];
    uv[1] = uv_dudv[1];
    if 0 < width {
        for i: 0..width - 1 {
            x := cast,no_check(s32) uv[0];
            y := cast,no_check(s32) uv[1];
            assignment_28: u32 =
                (cast(*u32) ((src_argb + (cast,no_check(s64) y) * cast(s64) src_argb_stride) +
                    (cast,no_check(s64) x) * 4)).*;
            ((cast,no_check(*u32) *((cast(*u32) dst_argb).*)).*) = assignment_28;
            dst_argb += 4;
            uv[0] += uv_dudv[2];
            uv[1] += uv_dudv[3];
        }
    }
}

InterpolateRow_C :: (dst_ptr: *u8, src_ptr: *u8, src_stride: s64, width: s32, source_y_fraction: s32) {
    y1_fraction := source_y_fraction;
    y0_fraction := 256 - y1_fraction;
    src_ptr1 := cast,no_check(*u8) ((src_ptr + src_stride));

    assert(source_y_fraction >= 0);
    assert(source_y_fraction < 256);

    if y1_fraction == 0 {
        copy_memory(dst_ptr, src_ptr, cast,no_check(u64) width);
        return;
    }
    if y1_fraction == 128 {
        half_row_c_in_row_common(src_ptr, src_stride, dst_ptr, width);
        return;
    }
    if 0 < width {
        for x: 0..width - 1 {
            dst_ptr[0] =
                cast,no_check(u8) (((cast(s32) src_ptr[0]) * y0_fraction +
                    (cast(s32) src_ptr1[0]) * y1_fraction + 128) >> 8);
            src_ptr += 1;
            src_ptr1 += 1;
            dst_ptr += 1;
        }
    }
}

half_row_c_in_row_common :: (src_uv: *u8, src_uv_stride: s64, dst_uv: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[x] =
                cast,no_check(u8) ((((cast(s32) src_uv[x]) + cast(s32) src_uv[src_uv_stride + cast(s64) x]) +
                    1) >> 1);
        }
    }
}

InterpolateRow_16_C :: (dst_ptr: *u16, src_ptr: *u16, src_stride: s64, width: s32, source_y_fraction: s32) {
    y1_fraction := source_y_fraction;
    y0_fraction := 256 - y1_fraction;
    src_ptr1 := cast,no_check(*u16) ((src_ptr + src_stride));

    assert(source_y_fraction >= 0);
    assert(source_y_fraction < 256);

    if y1_fraction == 0 {
        copy_memory(dst_ptr, src_ptr, (cast,no_check(u64) width) * 2);
        return;
    }
    if y1_fraction == 128 {
        half_row_16_c(src_ptr, src_stride, dst_ptr, width);
        return;
    }
    if 0 < width {
        for x: 0..width - 1 {
            dst_ptr[0] =
                cast,no_check(u16) (((cast(s32) src_ptr[0]) * y0_fraction +
                    (cast(s32) src_ptr1[0]) * y1_fraction + 128) >> 8);
            src_ptr += 1;
            src_ptr1 += 1;
            dst_ptr += 1;
        }
    }
}

half_row_16_c :: (src_uv: *u16, src_uv_stride: s64, dst_uv: *u16, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_uv[x] =
                cast,no_check(u16) ((((cast(s32) src_uv[x]) + cast(s32) src_uv[src_uv_stride + cast(s64) x]) +
                    1) >> 1);
        }
    }
}

SobelXRow_C :: (src_y0: *u8, src_y1: *u8, src_y2: *u8, dst_sobelx: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            a := cast,no_check(s32) src_y0[i];
            b := cast,no_check(s32) src_y1[i];
            c := cast,no_check(s32) src_y2[i];
            a_sub := cast,no_check(s32) src_y0[i + 2];
            b_sub := cast,no_check(s32) src_y1[i + 2];
            c_sub := cast,no_check(s32) src_y2[i + 2];
            a_diff := a - a_sub;
            b_diff := b - b_sub;
            c_diff := c - c_sub;
            sobel := cast,no_check(s32) abs_in_row_common(a_diff + b_diff * 2 + c_diff);
            dst_sobelx[i] = cast,no_check(u8) clamp255(sobel);
        }
    }
}

abs_in_row_common :: (v: s32) -> u32 {
    m := -(cast(s32) (v < 0));
    return cast,no_check(u32) ((v + m) ^ m);
}

SobelYRow_C :: (src_y0: *u8, src_y1: *u8, dst_sobely: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            a := cast,no_check(s32) src_y0[i + 0];
            b := cast,no_check(s32) src_y0[i + 1];
            c := cast,no_check(s32) src_y0[i + 2];
            a_sub := cast,no_check(s32) src_y1[i + 0];
            b_sub := cast,no_check(s32) src_y1[i + 1];
            c_sub := cast,no_check(s32) src_y1[i + 2];
            a_diff := a - a_sub;
            b_diff := b - b_sub;
            c_diff := c - c_sub;
            sobel := cast,no_check(s32) abs_in_row_common(a_diff + b_diff * 2 + c_diff);
            dst_sobely[i] = cast,no_check(u8) clamp255(sobel);
        }
    }
}

SobelRow_C :: (src_sobelx: *u8, src_sobely: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            r := cast,no_check(s32) src_sobelx[i];
            b := cast,no_check(s32) src_sobely[i];
            s: s32 = clamp255(r + b);
            dst_argb[0] = cast,no_check(u8) s;
            dst_argb[1] = cast,no_check(u8) s;
            dst_argb[2] = cast,no_check(u8) s;
            dst_argb[3] = cast(u8) 255;
            dst_argb += 4;
        }
    }
}

SobelToPlaneRow_C :: (src_sobelx: *u8, src_sobely: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            r := cast,no_check(s32) src_sobelx[i];
            b := cast,no_check(s32) src_sobely[i];
            s: s32 = clamp255(r + b);
            dst_y[i] = cast,no_check(u8) s;
        }
    }
}

SobelXYRow_C :: (src_sobelx: *u8, src_sobely: *u8, dst_argb: *u8, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            r := cast,no_check(s32) src_sobelx[i];
            b := cast,no_check(s32) src_sobely[i];
            g: s32 = clamp255(r + b);
            dst_argb[0] = cast,no_check(u8) b;
            dst_argb[1] = cast,no_check(u8) g;
            dst_argb[2] = cast,no_check(u8) r;
            dst_argb[3] = cast(u8) 255;
            dst_argb += 4;
        }
    }
}

ARGBPolynomialRow_C :: (src_argb: *u8, dst_argb: *u8, poly: *float32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            b := cast,no_check(float32) src_argb[0];
            g := cast,no_check(float32) src_argb[1];
            r := cast,no_check(float32) src_argb[2];
            a := cast,no_check(float32) src_argb[3];
            b2 := b * b;
            g2 := g * g;
            r2 := r * r;
            a2 := a * a;
            db := poly[0] + poly[4] * b;
            dg := poly[1] + poly[5] * g;
            dr := poly[2] + poly[6] * r;
            da := poly[3] + poly[7] * a;
            b3 := b2 * b;
            g3 := g2 * g;
            r3 := r2 * r;
            a3 := a2 * a;
            db += poly[8] * b2;
            dg += poly[9] * g2;
            dr += poly[10] * r2;
            da += poly[11] * a2;
            db += poly[12] * b3;
            dg += poly[13] * g3;
            dr += poly[14] * r3;
            da += poly[15] * a3;

            dst_argb[0] = cast,no_check(u8) clamp(cast,no_check(s32) db);
            dst_argb[1] = cast,no_check(u8) clamp(cast,no_check(s32) dg);
            dst_argb[2] = cast,no_check(u8) clamp(cast,no_check(s32) dr);
            dst_argb[3] = cast,no_check(u8) clamp(cast,no_check(s32) da);
            src_argb += 4;
            dst_argb += 4;
        }
    }
}

HalfFloatRow_C :: (src: *u16, dst: *u16, scale: float32, width: s32) {
    mult := (cast(float32) 1.925929944387236e-34) * scale;
    if 0 < width {
        for i: 0..width - 1 {
            value := src[i] * mult;
            dst[i] = cast,no_check(u16) ((cast(*Uint32_Alias_T) *value).* >> 13);
        }
    }
}

ByteToFloatRow_C :: (src: *u8, dst: *float32, scale: float32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            value := src[i] * scale;
            dst[i] = value;
        }
    }
}

ARGBLumaColorTableRow_C :: (src_argb: *u8, dst_argb: *u8, width: s32, luma: *u8, lumacoeff: u32) {
    bc := lumacoeff & 0xff;
    gc := lumacoeff >> 8 & 0xff;
    rc := lumacoeff >> 16 & 0xff;

    i: s32 = 0;
    while i < width - 1 {
        luma0 :=
            cast,no_check(*u8) ((((cast(u32) src_argb[0]) * bc + (cast(u32) src_argb[1]) * gc + (cast(u32) src_argb[2]) * rc) & 0x7f00 +
                luma));

        dst_argb[0] = luma0[src_argb[0]];
        dst_argb[1] = luma0[src_argb[1]];
        dst_argb[2] = luma0[src_argb[2]];
        dst_argb[3] = src_argb[3];
        luma1 :=
            cast,no_check(*u8) ((((cast(u32) src_argb[4]) * bc + (cast(u32) src_argb[5]) * gc + (cast(u32) src_argb[6]) * rc) & 0x7f00 +
                luma));
        dst_argb[4] = luma1[src_argb[4]];
        dst_argb[5] = luma1[src_argb[5]];
        dst_argb[6] = luma1[src_argb[6]];
        dst_argb[7] = src_argb[7];
        src_argb += 8;
        dst_argb += 8;
        i += 2;
    }
    if width & 1 != 0 {
        luma0 :=
            cast,no_check(*u8) ((((cast(u32) src_argb[0]) * bc + (cast(u32) src_argb[1]) * gc + (cast(u32) src_argb[2]) * rc) & 0x7f00 +
                luma));
        dst_argb[0] = luma0[src_argb[0]];
        dst_argb[1] = luma0[src_argb[1]];
        dst_argb[2] = luma0[src_argb[2]];
        dst_argb[3] = src_argb[3];
    }
}

ScaleMaxSamples_C :: (src: *float32, dst: *float32, scale: float32, width: s32) -> float32 {
    fmax: float32 = 0.0;

    if 0 < width {
        for i: 0..width - 1 {
            v := (c_transpiler_post_increment(*(src))).*;
            vs := v * scale;
            fmax = ifx c_transpiler_float_greater(v, fmax) then v else fmax;
            dst.* = vs;
            dst += 1;
        }
    }
    return fmax;
}

ScaleSumSamples_C :: (src: *float32, dst: *float32, scale: float32, width: s32) -> float32 {
    fsum: float32 = 0.0;

    if 0 < width {
        for i: 0..width - 1 {
            v := (c_transpiler_post_increment(*(src))).*;
            fsum += v * v;
            dst.* = v * scale;
            dst += 1;
        }
    }
    return fsum;
}

ScaleSamples_C :: (src: *float32, dst: *float32, scale: float32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            assignment_29: float32 = ((c_transpiler_post_increment(*(src))).* * scale);
            ((cast,no_check(*float32) *((c_transpiler_post_increment(*(dst))).*)).*) = assignment_29;
        }
    }
}

GaussRow_F32_C :: (src: *float32, dst: *float32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst.* = (src[0] + src[1] * 4.0 + src[2] * 6.0 + src[3] * 4.0 + src[4]) * 0.00390625;
            dst += 1;
            src += 1;
        }
    }
}

GaussCol_F32_C :: (
    src0: *float32,
    src1: *float32,
    src2: *float32,
    src3: *float32,
    src4: *float32,
    dst: *float32,
    width: s32
) {
    if 0 < width {
        for i: 0..width - 1 {
            assignment_30: float32 =
                ((c_transpiler_post_increment(*(src0))).* + (c_transpiler_post_increment(*(src1))).* * 4.0 + (c_transpiler_post_increment(*(src2))).* * 6.0 +
                    (c_transpiler_post_increment(*(src3))).* * 4.0 + (c_transpiler_post_increment(*(src4))).*);
            ((cast,no_check(*float32) *((c_transpiler_post_increment(*(dst))).*)).*) = assignment_30;
        }
    }
}

GaussRow_C :: (src: *u32, dst: *u16, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst.* = cast,no_check(u16) (((((src[0] + src[1] * 4) + src[2] * 6) + src[3] * 4) + src[4] + 128) >> 8);
            dst += 1;
            src += 1;
        }
    }
}

GaussCol_C :: (src0: *u16, src1: *u16, src2: *u16, src3: *u16, src4: *u16, dst: *u32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            assignment_31: u32 =
                cast,no_check(u32) ((cast(s32) ((c_transpiler_post_increment(*(src0))).*)) + (cast(s32) ((c_transpiler_post_increment(*(src1))).*)) * 4 +
                    (cast(s32) ((c_transpiler_post_increment(*(src2))).*)) * 6 + (cast(s32) ((c_transpiler_post_increment(*(src3))).*)) * 4 + cast(s32) ((c_transpiler_post_increment(*(src4))).*));
            ((cast,no_check(*u32) *((c_transpiler_post_increment(*(dst))).*)).*) = assignment_31;
        }
    }
}

argb_to_y_row_c :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_y(src_rgb[2], src_rgb[1], src_rgb[0]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

argb_to_uv_row_c :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[0]) + cast(s32) src_rgb[0 + 4]) + cast(s32) src_rgb1[0]) + cast(s32) src_rgb1[0 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u8) ((((cast(s32) src_rgb[0]) + cast(s32) src_rgb1[0]) + 1) >> 1);

        ag := cast,no_check(u8) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ar := cast,no_check(u8) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        dst_u[0] = rgb_to_u(ar, ag, ab);

        dst_v[0] = rgb_to_v(ar, ag, ab);
    }
}

argb_to_yj_row_c :: (src_rgb: *u8, dst_y: *u8, width: s32) {
    if 0 < width {
        for x: 0..width - 1 {
            dst_y[0] = rgb_to_yj(src_rgb[2], src_rgb[1], src_rgb[0]);

            src_rgb += 4;

            dst_y += 1;
        }
    }
}

argb_to_uvj_row_c :: (src_rgb: *u8, src_stride_rgb: s32, dst_u: *u8, dst_v: *u8, width: s32) {
    src_rgb1 := cast,no_check(*u8) ((src_rgb + src_stride_rgb));

    x: s32 = 0;
    while x < width - 1 {
        ab :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[0]) + cast(s32) src_rgb[0 + 4]) + cast(s32) src_rgb1[0]) + cast(s32) src_rgb1[0 + 4]) +
                2) >> 2);

        ag :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[1]) + cast(s32) src_rgb[1 + 4]) + cast(s32) src_rgb1[1]) + cast(s32) src_rgb1[1 + 4]) +
                2) >> 2);

        ar :=
            cast,no_check(u8) ((((((cast(s32) src_rgb[2]) + cast(s32) src_rgb[2 + 4]) + cast(s32) src_rgb1[2]) + cast(s32) src_rgb1[2 + 4]) +
                2) >> 2);

        dst_u[0] = rgb_to_uj(ar, ag, ab);

        dst_v[0] = rgb_to_vj(ar, ag, ab);

        src_rgb += 4 * 2;

        src_rgb1 += 4 * 2;

        dst_u += 1;

        dst_v += 1;
        x += 2;
    }

    if width & 1 != 0 {
        ab := cast,no_check(u16) ((((cast(s32) src_rgb[0]) + cast(s32) src_rgb1[0]) + 1) >> 1);

        ag := cast,no_check(u16) ((((cast(s32) src_rgb[1]) + cast(s32) src_rgb1[1]) + 1) >> 1);

        ar := cast,no_check(u16) ((((cast(s32) src_rgb[2]) + cast(s32) src_rgb1[2]) + 1) >> 1);

        dst_u[0] = rgb_to_uj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);

        dst_v[0] = rgb_to_vj(cast,no_check(u8) ar, cast,no_check(u8) ag, cast,no_check(u8) ab);
    }
}

globals_initialization_state_for_row_common: u32;
initialize_globals_for_row_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_row_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_row_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_row_common) != 2 {}
            return;
        }
    }
    K_RGBA_I601_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66 ],
            k_rgb_to_u =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_I601_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0, 25, 129, 66, 0 ],
            k_rgb_to_u =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0, -112, cast,no_check(s8) (-(-cast(s32) 74)), cast,no_check(s8) (-(-cast(s32) 38)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0, cast,no_check(s8) (-(-cast(s32) 18)), cast,no_check(s8) (-(-cast(s32) 94)), -112, 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_I601_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0 ],
            k_rgb_to_v =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_I601_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25, 0, 66, 129, 25 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112, 0, cast,no_check(s8) (-(-cast(s32) 38)), cast,no_check(s8) (-(-cast(s32) 74)), -112 ],
            k_rgb_to_v =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)), 0, -112, cast,no_check(s8) (-(-cast(s32) 94)), cast,no_check(s8) (-(-cast(s32) 18)) ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_RGBA_JPEG_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77 ],
            k_rgb_to_u =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_JPEG_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0, 29, 150, 77, 0 ],
            k_rgb_to_u =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0, -128, cast,no_check(s8) (-(-cast(s32) 85)), cast,no_check(s8) (-(-cast(s32) 43)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0, cast,no_check(s8) (-(-cast(s32) 21)), cast,no_check(s8) (-(-cast(s32) 107)), -128, 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_JPEG_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0 ],
            k_rgb_to_v =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_JPEG_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29, 0, 77, 150, 29 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128, 0, cast,no_check(s8) (-(-cast(s32) 43)), cast,no_check(s8) (-(-cast(s32) 85)), -128 ],
            k_rgb_to_v =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)), 0, -128, cast,no_check(s8) (-(-cast(s32) 107)), cast,no_check(s8) (-(-cast(s32) 21)) ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_H709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0 ],
            k_rgb_to_v =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_H709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16, 0, 47, 157, 16 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112, 0, cast,no_check(s8) (-(-cast(s32) 26)), cast,no_check(s8) (-(-cast(s32) 86)), -112 ],
            k_rgb_to_v =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -112, cast,no_check(s8) (-(-cast(s32) 102)), cast,no_check(s8) (-(-cast(s32) 10)) ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_H709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0 ],
            k_rgb_to_u =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_RGBA_H709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47, 0, 16, 157, 47 ],
            k_rgb_to_u =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)), 0, -112, cast,no_check(s8) (-(-cast(s32) 86)), cast,no_check(s8) (-(-cast(s32) 26)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 102)), -112 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_F709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0 ],
            k_rgb_to_u =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_F709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0 ],
            k_rgb_to_v =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_RGBA_F709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54, 0, 19, 183, 54 ],
            k_rgb_to_u =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)), 0, -128, cast,no_check(s8) (-(-cast(s32) 99)), cast,no_check(s8) (-(-cast(s32) 29)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128, 0, cast,no_check(s8) (-(-cast(s32) 12)), cast,no_check(s8) (-(-cast(s32) 116)), -128 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_F709_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19, 0, 54, 183, 19 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128, 0, cast,no_check(s8) (-(-cast(s32) 29)), cast,no_check(s8) (-(-cast(s32) 99)), -128 ],
            k_rgb_to_v =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)), 0, -128, cast,no_check(s8) (-(-cast(s32) 116)), cast,no_check(s8) (-(-cast(s32) 12)) ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_U2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0 ],
            k_rgb_to_u =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_U2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0 ],
            k_rgb_to_v =
                s8.[ -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_RGBA_U2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59, 0, 13, 148, 59 ],
            k_rgb_to_u =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)), 0, -112, cast,no_check(s8) (-(-cast(s32) 81)), cast,no_check(s8) (-(-cast(s32) 31)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112, 0, cast,no_check(s8) (-(-cast(s32) 9)), cast,no_check(s8) (-(-cast(s32) 103)), -112 ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_U2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13, 0, 59, 148, 13 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112, 0, cast,no_check(s8) (-(-cast(s32) 31)), cast,no_check(s8) (-(-cast(s32) 81)), -112 ],
            k_rgb_to_v =
                s8.[ 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)), 0, -112, cast,no_check(s8) (-(-cast(s32) 103)), cast,no_check(s8) (-(-cast(s32) 9)) ],
            k_add_y =
                u16.[ 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224, 4224 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ARGB_V2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0 ],
            k_rgb_to_u =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0 ],
            k_rgb_to_v =
                s8.[ cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_ABGR_V2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0 ],
            k_rgb_to_u =
                s8.[ cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0 ],
            k_rgb_to_v =
                s8.[ -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_RGBA_V2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67, 0, 15, 174, 67 ],
            k_rgb_to_u =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)), 0, -128, cast,no_check(s8) (-(-cast(s32) 92)), cast,no_check(s8) (-(-cast(s32) 36)) ],
            k_rgb_to_v =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128, 0, cast,no_check(s8) (-(-cast(s32) 10)), cast,no_check(s8) (-(-cast(s32) 118)), -128 ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_BGRA_V2020_CONSTANTS =
        Argb_Constants.{
            k_rgb_to_y =
                u8.[ 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15, 0, 67, 174, 15 ],
            k_rgb_to_u =
                s8.[ 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128, 0, cast,no_check(s8) (-(-cast(s32) 36)), cast,no_check(s8) (-(-cast(s32) 92)), -128 ],
            k_rgb_to_v =
                s8.[ 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)), 0, -128, cast,no_check(s8) (-(-cast(s32) 118)), cast,no_check(s8) (-(-cast(s32) 10)) ],
            k_add_y = u16.[ 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128 ],
            k_add_uv =
                u16.[ 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768, 32768 ]
        };
    K_YUV_I601_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0 ],
            k_uv_to_g =
                u8.[ 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52 ],
            k_uv_to_r =
                u8.[ 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102 ],
            k_y_to_rgb =
                s16.[ 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YVU_I601_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0, 102, 0 ],
            k_uv_to_g =
                u8.[ 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25, 52, 25 ],
            k_uv_to_r =
                u8.[ 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128 ],
            k_y_to_rgb =
                s16.[ 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YUV_JPEG_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0 ],
            k_uv_to_g =
                u8.[ 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46 ],
            k_uv_to_r =
                u8.[ 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    K_YVU_JPEG_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0, 90, 0 ],
            k_uv_to_g =
                u8.[ 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22, 46, 22 ],
            k_uv_to_r =
                u8.[ 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113, 0, 113 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    K_YUV_H709_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0 ],
            k_uv_to_g =
                u8.[ 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34 ],
            k_uv_to_r =
                u8.[ 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115 ],
            k_y_to_rgb =
                s16.[ 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YVU_H709_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0, 115, 0 ],
            k_uv_to_g =
                u8.[ 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14, 34, 14 ],
            k_uv_to_r =
                u8.[ 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128 ],
            k_y_to_rgb =
                s16.[ 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997, 18997 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YUV_F709_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0 ],
            k_uv_to_g =
                u8.[ 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30 ],
            k_uv_to_r =
                u8.[ 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    K_YVU_F709_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0, 101, 0 ],
            k_uv_to_g =
                u8.[ 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12, 30, 12 ],
            k_uv_to_r =
                u8.[ 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119, 0, 119 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    K_YUV2020_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0 ],
            k_uv_to_g =
                u8.[ 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42 ],
            k_uv_to_r =
                u8.[ 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107 ],
            k_y_to_rgb =
                s16.[ 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YVU2020_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0, 107, 0 ],
            k_uv_to_g =
                u8.[ 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12, 42, 12 ],
            k_uv_to_r =
                u8.[ 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128, 0, 128 ],
            k_y_to_rgb =
                s16.[ 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003, 19003 ],
            k_y_bias_to_rgb =
                s16.[ -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160, -1160 ]
        };
    K_YUV_V2020_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0 ],
            k_uv_to_g =
                u8.[ 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37 ],
            k_uv_to_r =
                u8.[ 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    K_YVU_V2020_CONSTANTS =
        Yuv_Constants.{
            k_uv_to_b =
                u8.[ 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0, 94, 0 ],
            k_uv_to_g =
                u8.[ 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11, 37, 11 ],
            k_uv_to_r =
                u8.[ 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120, 0, 120 ],
            k_y_to_rgb =
                s16.[ 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320, 16320 ],
            k_y_bias_to_rgb = s16.[ 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32 ]
        };
    FIXED_INVTBL8 =
        u32.[
            0x1000000,
            0x100ffff,
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x10))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x11))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x12))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x13))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x14))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x15))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x16))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x17))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x18))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x19))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x1f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x20))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x21))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x22))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x23))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x24))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x25))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x26))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x27))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x28))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x29))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x2f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x30))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x31))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x32))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x33))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x34))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x35))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x36))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x37))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x38))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x39))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x3f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x40))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x41))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x42))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x43))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x44))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x45))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x46))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x47))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x48))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x49))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x4f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x50))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x51))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x52))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x53))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x54))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x55))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x56))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x57))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x58))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x59))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x5f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x60))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x61))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x62))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x63))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x64))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x65))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x66))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x67))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x68))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x69))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x6f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x70))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x71))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x72))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x73))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x74))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x75))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x76))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x77))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x78))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x79))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x7f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x80))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x81))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x82))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x83))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x84))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x85))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x86))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x87))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x88))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x89))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x8f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x90))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x91))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x92))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x93))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x94))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x95))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x96))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x97))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x98))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x99))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9a))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9b))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9c))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9d))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9e))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0x9f))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xa9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xaa))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xab))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xac))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xad))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xae))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xaf))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xb9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xba))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xbb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xbc))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xbd))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xbe))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xbf))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xc9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xca))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xcb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xcc))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xcd))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xce))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xcf))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xd9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xda))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xdb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xdc))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xdd))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xde))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xdf))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xe9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xea))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xeb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xec))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xed))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xee))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xef))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf0))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf1))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf2))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf3))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf4))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf5))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf6))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf7))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf8))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xf9))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xfa))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xfb))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xfc))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xfd))),
            cast,no_check(u32) (0x1000000 + cast,no_check(s32) ((0x10000 / 0xfe))),
            0x1000100
        ];
    atomic_store(*globals_initialization_state_for_row_common, 2);
}

