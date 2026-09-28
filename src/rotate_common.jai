// Generated directly from C++ by cpp_transpiler.
TransposeWxH_C :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32, height: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            if 0 < height {
                for j: 0..height - 1 {
                    dst[i * dst_stride + j] = src[j * src_stride + i];
                }
            }
        }
    }
}

TransposeWx8_C :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst[0] = src[0 * src_stride];
            dst[1] = src[1 * src_stride];
            dst[2] = src[2 * src_stride];
            dst[3] = src[3 * src_stride];
            dst[4] = src[4 * src_stride];
            dst[5] = src[5 * src_stride];
            dst[6] = src[6 * src_stride];
            dst[7] = src[7 * src_stride];
            src += 1;
            dst += dst_stride;
        }
    }
}

TransposeWx16_C :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32) {
    TransposeWx8_C(src, src_stride, dst, dst_stride, width);
    TransposeWx8_C(src + 8 * src_stride, src_stride, dst + 8, dst_stride, width);
}

TransposeUVWxH_C :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32,
    height: s32
) {
    i: s32 = 0;
    while i < width * 2 {
        if 0 < height {
            for j: 0..height - 1 {
                dst_a[i >> 1 * dst_stride_a + j] = src[i + j * src_stride];
                dst_b[i >> 1 * dst_stride_b + j] = src[i + j * src_stride + 1];
            }
        }
        i += 2;
    }
}

TransposeUVWx8_C :: (
    src: *u8,
    src_stride: s32,
    dst_a: *u8,
    dst_stride_a: s32,
    dst_b: *u8,
    dst_stride_b: s32,
    width: s32
) {
    if 0 < width {
        for i: 0..width - 1 {
            dst_a[0] = src[0 * src_stride + 0];
            dst_b[0] = src[0 * src_stride + 1];
            dst_a[1] = src[1 * src_stride + 0];
            dst_b[1] = src[1 * src_stride + 1];
            dst_a[2] = src[2 * src_stride + 0];
            dst_b[2] = src[2 * src_stride + 1];
            dst_a[3] = src[3 * src_stride + 0];
            dst_b[3] = src[3 * src_stride + 1];
            dst_a[4] = src[4 * src_stride + 0];
            dst_b[4] = src[4 * src_stride + 1];
            dst_a[5] = src[5 * src_stride + 0];
            dst_b[5] = src[5 * src_stride + 1];
            dst_a[6] = src[6 * src_stride + 0];
            dst_b[6] = src[6 * src_stride + 1];
            dst_a[7] = src[7 * src_stride + 0];
            dst_b[7] = src[7 * src_stride + 1];
            src += 2;
            dst_a += dst_stride_a;
            dst_b += dst_stride_b;
        }
    }
}

TransposeWxH_16_C :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32, height: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            if 0 < height {
                for j: 0..height - 1 {
                    dst[i * dst_stride + j] = src[j * src_stride + i];
                }
            }
        }
    }
}

TransposeWx8_16_C :: (src: *u16, src_stride: s32, dst: *u16, dst_stride: s32, width: s32) {
    if 0 < width {
        for i: 0..width - 1 {
            dst[0] = src[0 * src_stride];
            dst[1] = src[1 * src_stride];
            dst[2] = src[2 * src_stride];
            dst[3] = src[3 * src_stride];
            dst[4] = src[4 * src_stride];
            dst[5] = src[5 * src_stride];
            dst[6] = src[6 * src_stride];
            dst[7] = src[7 * src_stride];
            src += 1;
            dst += dst_stride;
        }
    }
}

Transpose4x4_32_C :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32, width: s32) {
    src1 := cast,no_check(*u8) ((src + src_stride));
    src2 := cast,no_check(*u8) ((src1 + src_stride));
    src3 := cast,no_check(*u8) ((src2 + src_stride));
    dst1 := cast,no_check(*u8) ((dst + dst_stride));
    dst2 := cast,no_check(*u8) ((dst1 + dst_stride));
    dst3 := cast,no_check(*u8) ((dst2 + dst_stride));

    i: s32 = 0;
    while i < width {
        copy4(dst, src);
        copy4(dst + 4, src1);
        copy4(dst + 8, src2);
        copy4(dst + 12, src3);
        copy4(dst1, src + 4);
        copy4(dst1 + 4, src1 + 4);
        copy4(dst1 + 8, src2 + 4);
        copy4(dst1 + 12, src3 + 4);
        copy4(dst2, src + 8);
        copy4(dst2 + 4, src1 + 8);
        copy4(dst2 + 8, src2 + 8);
        copy4(dst2 + 12, src3 + 8);
        copy4(dst3, src + 12);
        copy4(dst3 + 4, src1 + 12);
        copy4(dst3 + 8, src2 + 12);
        copy4(dst3 + 12, src3 + 12);
        src += (cast,no_check(s64) src_stride) * 4;
        src1 += (cast,no_check(s64) src_stride) * 4;
        src2 += (cast,no_check(s64) src_stride) * 4;
        src3 += (cast,no_check(s64) src_stride) * 4;
        dst += 4 * 4;
        dst1 += 4 * 4;
        dst2 += 4 * 4;
        dst3 += 4 * 4;
        i += 4;
    }
}

copy4 :: (dst: *u8, src: *u8) {
    dst[0] = src[0];
    dst[1] = src[1];
    dst[2] = src[2];
    dst[3] = src[3];
}

