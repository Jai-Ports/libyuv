K_CPU_INITIALIZED_in_rotate_argb: s32;

K_CPU_HAS_ARM_in_rotate_argb: s32;

K_CPU_HAS_NEON_in_rotate_argb: s32;

K_CPU_HAS_NEON_DOT_PROD_in_rotate_argb: s32;

K_CPU_HAS_NEON_I8_MM_in_rotate_argb: s32;

K_CPU_HAS_SVE_in_rotate_argb: s32;

K_CPU_HAS_SVE2_in_rotate_argb: s32;

K_CPU_HAS_SME_in_rotate_argb: s32;

K_CPU_HAS_SME2_in_rotate_argb: s32;

K_CPU_HAS_SVEF32_MM_in_rotate_argb: s32;

K_CPU_HAS_RISCV_in_rotate_argb: s32;

K_CPU_HAS_RVV_in_rotate_argb: s32;

K_CPU_HAS_RVVZVFH_in_rotate_argb: s32;

K_CPU_HAS_X86_in_rotate_argb: s32;

K_CPU_HAS_SSE2_in_rotate_argb: s32;

K_CPU_HAS_SSSE3_in_rotate_argb: s32;

K_CPU_HAS_SSE41_in_rotate_argb: s32;

K_CPU_HAS_SSE42_in_rotate_argb: s32;

K_CPU_HAS_AVX_in_rotate_argb: s32;

K_CPU_HAS_AVX2_in_rotate_argb: s32;

K_CPU_HAS_ERMS_in_rotate_argb: s32;

K_CPU_HAS_FSMR_in_rotate_argb: s32;

K_CPU_HAS_FMA3_in_rotate_argb: s32;

K_CPU_HAS_F16_C_in_rotate_argb: s32;

K_CPU_HAS_AVX512_BW_in_rotate_argb: s32;

K_CPU_HAS_AVX512_VL_in_rotate_argb: s32;

K_CPU_HAS_AVX512_VNNI_in_rotate_argb: s32;

K_CPU_HAS_AVX512_VBMI_in_rotate_argb: s32;

K_CPU_HAS_AVX512_VBMI2_in_rotate_argb: s32;

K_CPU_HAS_AVX512_VBITALG_in_rotate_argb: s32;

K_CPU_HAS_AVX10_in_rotate_argb: s32;

K_CPU_HAS_AVX10_2_in_rotate_argb: s32;

K_CPU_HAS_AVXVNNI_in_rotate_argb: s32;

K_CPU_HAS_AVXVNNIINT8_in_rotate_argb: s32;

K_CPU_HAS_AMXINT8_in_rotate_argb: s32;

K_CPU_HAS_AVX512_BMM_in_rotate_argb: s32;

K_CPU_HAS_LOONGARCH_in_rotate_argb: s32;

K_CPU_HAS_LSX_in_rotate_argb: s32;

K_CPU_HAS_LASX_in_rotate_argb: s32;

ARGBRotate :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32,
    mode: Rotation_Mode
) -> s32 {
    if src_argb == null || width <= 0 || height == 0 || height == -2147483647 - 1 || dst_argb == null {
        return -1;
    }

    if height < 0 {
        height = -height;
        src_argb = cast,no_check(*u8) ((src_argb + (cast,no_check(s64) (height - 1)) * cast(s64) src_stride_argb));
        src_stride_argb = -src_stride_argb;
    }

    if cast,no_check(s32) mode == {
        case cast,no_check(s32) K_ROTATE0;
            return ARGBCopy(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
        case cast,no_check(s32) K_ROTATE90;
            return argb_rotate90(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
        case cast,no_check(s32) K_ROTATE270;
            return argb_rotate270(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
        case cast,no_check(s32) K_ROTATE180;
            return argb_rotate180(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
        case;
    }
    return -1;
}

argb_rotate180 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    src_bot := cast,no_check(*u8) ((src_argb + (cast,no_check(s64) src_stride_argb) * cast(s64) (height - 1)));
    dst_bot := cast,no_check(*u8) ((dst_argb + (cast,no_check(s64) dst_stride_argb) * cast(s64) (height - 1)));
    half_height := (height + 1) >> 1;

    argb_mirror_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) ARGBMirrorRow_C;
    copy_row: #type (_: *u8, _: *u8, _: s32) = cast,no_check(#type (_: *u8, _: *u8, _: s32)) CopyRow_C;
    if width > 2147483647 / 4 {
        return -1;
    }
    row_mem_size := cast,no_check(u64) (width * 4);

    row_mem: *void =
        cast,no_check(*void) ((ifx row_mem_size > (cast(u64) 18446744073709551615) -
            63 then cast,no_check(*void) (null) else cast,no_check(*void) (c_transpiler_allocate_memory(row_mem_size + 63))));

    row :=
        cast,no_check(*u8) (cast,no_check(*u8) cast,no_check(u64) ((((cast,no_check(s64) row_mem) +
            63) & cast,no_check(s64) (~(cast(s32) 63)))));
    if row == null {
        return 1;
    }

    if 0 < half_height {
        for y: 0..half_height - 1 {
            argb_mirror_row(src_argb, row, width);
            argb_mirror_row(src_bot, dst_argb, width);
            copy_row(row, dst_bot, width * 4);
            src_argb += src_stride_argb;
            dst_argb += dst_stride_argb;
            src_bot -= src_stride_argb;
            dst_bot -= dst_stride_argb;
        }
    }
    c_transpiler_deallocate_memory(row_mem);

    row = cast,no_check(*u8) (cast(*u8) null);
    return 0;
}

argb_rotate270 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    dst_argb += (cast,no_check(s64) dst_stride_argb) * cast(s64) (width - 1);
    dst_stride_argb = -dst_stride_argb;
    return argb_transpose(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
}

argb_transpose :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    src_pixel_step := src_stride_argb >> 2;
    scale_argb_row_down_even: #type (_: *u8, _: s64, _: s32, _: *u8, _: s32) =
        cast,no_check(#type (_: *u8, _: s64, _: s32, _: *u8, _: s32)) ScaleARGBRowDownEven_C;

    if src_stride_argb & 3 != 0 {
        return -1;
    }

    if 0 < width {
        for i: 0..width - 1 {
            scale_argb_row_down_even(src_argb, 0, src_pixel_step, dst_argb, height);
            dst_argb += dst_stride_argb;
            src_argb += 4;
        }
    }
    return 0;
}

argb_rotate90 :: (
    src_argb: *u8,
    src_stride_argb: s32,
    dst_argb: *u8,
    dst_stride_argb: s32,
    width: s32,
    height: s32
) -> s32 {
    src_argb += (cast,no_check(s64) src_stride_argb) * cast(s64) (height - 1);
    src_stride_argb = -src_stride_argb;
    return argb_transpose(src_argb, src_stride_argb, dst_argb, dst_stride_argb, width, height);
}

test_cpu_flag_in_rotate_argb :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

set_cpu_flags_in_rotate_argb :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

globals_initialization_state_for_rotate_argb: u32;
initialize_globals_for_rotate_argb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_rotate_argb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_rotate_argb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_rotate_argb) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_rotate_argb = 0x1;
    K_CPU_HAS_ARM_in_rotate_argb = 0x2;
    K_CPU_HAS_NEON_in_rotate_argb = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_rotate_argb = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_rotate_argb = 0x400;
    K_CPU_HAS_SVE_in_rotate_argb = 0x800;
    K_CPU_HAS_SVE2_in_rotate_argb = 0x1000;
    K_CPU_HAS_SME_in_rotate_argb = 0x2000;
    K_CPU_HAS_SME2_in_rotate_argb = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_rotate_argb = 0x8000;
    K_CPU_HAS_RISCV_in_rotate_argb = 0x4;
    K_CPU_HAS_RVV_in_rotate_argb = 0x100;
    K_CPU_HAS_RVVZVFH_in_rotate_argb = 0x200;
    K_CPU_HAS_X86_in_rotate_argb = 0x8;
    K_CPU_HAS_SSE2_in_rotate_argb = 0x100;
    K_CPU_HAS_SSSE3_in_rotate_argb = 0x200;
    K_CPU_HAS_SSE41_in_rotate_argb = 0x400;
    K_CPU_HAS_SSE42_in_rotate_argb = 0x800;
    K_CPU_HAS_AVX_in_rotate_argb = 0x1000;
    K_CPU_HAS_AVX2_in_rotate_argb = 0x2000;
    K_CPU_HAS_ERMS_in_rotate_argb = 0x4000;
    K_CPU_HAS_FSMR_in_rotate_argb = 0x8000;
    K_CPU_HAS_FMA3_in_rotate_argb = 0x10000;
    K_CPU_HAS_F16_C_in_rotate_argb = 0x20000;
    K_CPU_HAS_AVX512_BW_in_rotate_argb = 0x40000;
    K_CPU_HAS_AVX512_VL_in_rotate_argb = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_rotate_argb = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_rotate_argb = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_rotate_argb = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_rotate_argb = 0x800000;
    K_CPU_HAS_AVX10_in_rotate_argb = 0x1000000;
    K_CPU_HAS_AVX10_2_in_rotate_argb = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_rotate_argb = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_rotate_argb = 0x8000000;
    K_CPU_HAS_AMXINT8_in_rotate_argb = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_rotate_argb = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_rotate_argb = 0x20;
    K_CPU_HAS_LSX_in_rotate_argb = 0x100;
    K_CPU_HAS_LASX_in_rotate_argb = 0x200;
    atomic_store(*globals_initialization_state_for_rotate_argb, 2);
}

