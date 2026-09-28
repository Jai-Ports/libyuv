K_CPU_INITIALIZED_in_cpu_id: s32;

K_CPU_HAS_ARM_in_cpu_id: s32;

K_CPU_HAS_NEON_in_cpu_id: s32;

K_CPU_HAS_NEON_DOT_PROD_in_cpu_id: s32;

K_CPU_HAS_NEON_I8_MM_in_cpu_id: s32;

K_CPU_HAS_SVE_in_cpu_id: s32;

K_CPU_HAS_SVE2_in_cpu_id: s32;

K_CPU_HAS_SME_in_cpu_id: s32;

K_CPU_HAS_SME2_in_cpu_id: s32;

K_CPU_HAS_SVEF32_MM_in_cpu_id: s32;

K_CPU_HAS_RISCV_in_cpu_id: s32;

K_CPU_HAS_RVV_in_cpu_id: s32;

K_CPU_HAS_RVVZVFH_in_cpu_id: s32;

K_CPU_HAS_X86_in_cpu_id: s32;

K_CPU_HAS_SSE2_in_cpu_id: s32;

K_CPU_HAS_SSSE3_in_cpu_id: s32;

K_CPU_HAS_SSE41_in_cpu_id: s32;

K_CPU_HAS_SSE42_in_cpu_id: s32;

K_CPU_HAS_AVX_in_cpu_id: s32;

K_CPU_HAS_AVX2_in_cpu_id: s32;

K_CPU_HAS_ERMS_in_cpu_id: s32;

K_CPU_HAS_FSMR_in_cpu_id: s32;

K_CPU_HAS_FMA3_in_cpu_id: s32;

K_CPU_HAS_F16_C_in_cpu_id: s32;

K_CPU_HAS_AVX512_BW_in_cpu_id: s32;

K_CPU_HAS_AVX512_VL_in_cpu_id: s32;

K_CPU_HAS_AVX512_VNNI_in_cpu_id: s32;

K_CPU_HAS_AVX512_VBMI_in_cpu_id: s32;

K_CPU_HAS_AVX512_VBMI2_in_cpu_id: s32;

K_CPU_HAS_AVX512_VBITALG_in_cpu_id: s32;

K_CPU_HAS_AVX10_in_cpu_id: s32;

K_CPU_HAS_AVX10_2_in_cpu_id: s32;

K_CPU_HAS_AVXVNNI_in_cpu_id: s32;

K_CPU_HAS_AVXVNNIINT8_in_cpu_id: s32;

K_CPU_HAS_AMXINT8_in_cpu_id: s32;

K_CPU_HAS_AVX512_BMM_in_cpu_id: s32;

K_CPU_HAS_LOONGARCH_in_cpu_id: s32;

K_CPU_HAS_LSX_in_cpu_id: s32;

K_CPU_HAS_LASX_in_cpu_id: s32;

cpu_info: s32;

InitCpuFlags :: () -> s32 {
    return MaskCpuFlags(-1);
}

MaskCpuFlags :: (enable_flags: s32) -> s32 {
    cpu_info := get_cpu_flags() & enable_flags;
    set_cpu_flags_in_cpu_id(cpu_info);
    return cpu_info;
}

get_cpu_flags :: () -> s32 {
    cpu_info: s32 = 0;

    cpu_info |= cast(s32) 0x1;
    return cpu_info;
}

set_cpu_flags_in_cpu_id :: (cpu_flags: s32) {

    c_transpiler_atomic_store(*cpu_info, cpu_flags);
}

test_cpu_flag_in_cpu_id :: (test_flag: s32) -> s32 {

    cpu_info_value := atomic_load(*cpu_info);

    return (ifx cpu_info_value == 0 then InitCpuFlags() else cpu_info_value) & test_flag;
}

ArmCpuCaps :: (cpuinfo_name: *s8) -> s32 {
    cpuinfo_line: [512] s8 = ---;
    f := cast,no_check(*FILE) (fopen(cpuinfo_name, c_string("re")));
    if f == null {
        return cast(s32) 0x100;
    }
    fill_memory(cpuinfo_line.data, 0, 512);
    features: s32 = 0;
    while ((fgets(cpuinfo_line.data, 512, f)) != null) {
        if c_transpiler_memcmp(cast(*void) cpuinfo_line.data, cast(*void) (c_string("Features")), 8) == 0 {
            if cpuinfo_search(cpuinfo_line.data, c_string(" neon"), 5) != 0 {
                features |= cast(s32) 0x100;
            }
        }
    }
    fclose(f);
    return features;
}

cpuinfo_search :: (cpuinfo_line: *s8, needle: *s8, needle_len: s32) -> s32 {
    p := cast,no_check(*s8) (find_cstring(cpuinfo_line, needle));
    return cast(s32) (p != null && (p[needle_len] == #char " " || p[needle_len] == cast(s8) 10));
}

RiscvCpuCaps :: (cpuinfo_name: *s8) -> s32 {
    cpuinfo_line: [512] s8 = ---;
    flag: s32 = 0;
    f := cast,no_check(*FILE) (fopen(cpuinfo_name, c_string("re")));
    if f == null {
        return 0;
    }
    fill_memory(cpuinfo_line.data, 0, 512);
    while ((fgets(cpuinfo_line.data, 512, f)) != null) {
        if c_transpiler_memcmp(cast(*void) cpuinfo_line.data, cast(*void) (c_string("isa")), 3) == 0 {
            isa := cast,no_check(*s8) (find_cstring(cpuinfo_line.data, c_string("rv64")));
            if isa != null {
                isa_len := cstring_length(isa);

                extensions_len: u64 = 0;

                if isa[isa_len - 1] == cast(s8) 10 {
                    isa[c_transpiler_pre_decrement(*(isa_len))] = 0;
                }

                if isa_len < 5 {
                    fclose(f);
                    return 0;
                }

                isa += 5;

                extensions := cast,no_check(*s8) (strpbrk(isa, c_string("zxs")));
                if extensions != null {
                    extensions_len = cstring_length(extensions);

                    ext := cast,no_check(*s8) (extensions);
                    while ext != null {
                        next := cast,no_check(*s8) (c_transpiler_strchr(ext, #char "_"));
                        if next != null {
                            next.* = 0;
                            next += 1;
                        }

                        if compare_cstrings(ext, c_string("zvfh")) == 0 {
                            flag |= cast(s32) 0x200;
                        }
                        ext = cast,no_check(*s8) (next);
                    }
                }
                std_isa_len := isa_len - extensions_len - 5;

                if ((c_transpiler_memchr(cast(*void) isa, #char "v", std_isa_len)) != null) {
                    flag |= cast(s32) 0x100;
                }
            }
        }
    }
    fclose(f);
    return flag;
}

CpuId :: (eax: s32, ecx: s32, cpu_info: *s32) {
    cpu_info[3] = 0;
    cpu_info[2] = cpu_info[3];
    cpu_info[1] = cpu_info[2];
    cpu_info[0] = cpu_info[1];
}

globals_initialization_state_for_cpu_id: u32;
initialize_globals_for_cpu_id :: () {
    {
        state := atomic_load(*globals_initialization_state_for_cpu_id);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_cpu_id, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_cpu_id) != 2 {}
            return;
        }
    }
    K_CPU_INITIALIZED_in_cpu_id = 0x1;
    K_CPU_HAS_ARM_in_cpu_id = 0x2;
    K_CPU_HAS_NEON_in_cpu_id = 0x100;
    K_CPU_HAS_NEON_DOT_PROD_in_cpu_id = 0x200;
    K_CPU_HAS_NEON_I8_MM_in_cpu_id = 0x400;
    K_CPU_HAS_SVE_in_cpu_id = 0x800;
    K_CPU_HAS_SVE2_in_cpu_id = 0x1000;
    K_CPU_HAS_SME_in_cpu_id = 0x2000;
    K_CPU_HAS_SME2_in_cpu_id = 0x4000;
    K_CPU_HAS_SVEF32_MM_in_cpu_id = 0x8000;
    K_CPU_HAS_RISCV_in_cpu_id = 0x4;
    K_CPU_HAS_RVV_in_cpu_id = 0x100;
    K_CPU_HAS_RVVZVFH_in_cpu_id = 0x200;
    K_CPU_HAS_X86_in_cpu_id = 0x8;
    K_CPU_HAS_SSE2_in_cpu_id = 0x100;
    K_CPU_HAS_SSSE3_in_cpu_id = 0x200;
    K_CPU_HAS_SSE41_in_cpu_id = 0x400;
    K_CPU_HAS_SSE42_in_cpu_id = 0x800;
    K_CPU_HAS_AVX_in_cpu_id = 0x1000;
    K_CPU_HAS_AVX2_in_cpu_id = 0x2000;
    K_CPU_HAS_ERMS_in_cpu_id = 0x4000;
    K_CPU_HAS_FSMR_in_cpu_id = 0x8000;
    K_CPU_HAS_FMA3_in_cpu_id = 0x10000;
    K_CPU_HAS_F16_C_in_cpu_id = 0x20000;
    K_CPU_HAS_AVX512_BW_in_cpu_id = 0x40000;
    K_CPU_HAS_AVX512_VL_in_cpu_id = 0x80000;
    K_CPU_HAS_AVX512_VNNI_in_cpu_id = 0x100000;
    K_CPU_HAS_AVX512_VBMI_in_cpu_id = 0x200000;
    K_CPU_HAS_AVX512_VBMI2_in_cpu_id = 0x400000;
    K_CPU_HAS_AVX512_VBITALG_in_cpu_id = 0x800000;
    K_CPU_HAS_AVX10_in_cpu_id = 0x1000000;
    K_CPU_HAS_AVX10_2_in_cpu_id = 0x2000000;
    K_CPU_HAS_AVXVNNI_in_cpu_id = 0x4000000;
    K_CPU_HAS_AVXVNNIINT8_in_cpu_id = 0x8000000;
    K_CPU_HAS_AMXINT8_in_cpu_id = 0x10000000;
    K_CPU_HAS_AVX512_BMM_in_cpu_id = 0x20000000;
    K_CPU_HAS_LOONGARCH_in_cpu_id = 0x20;
    K_CPU_HAS_LSX_in_cpu_id = 0x100;
    K_CPU_HAS_LASX_in_cpu_id = 0x200;
    cpu_info = 0;
    atomic_store(*globals_initialization_state_for_cpu_id, 2);
}

System_Library_Compiler :: #import "Compiler";
#run System_Library_Compiler.compiler_add_library_search_directory("/usr/lib");
System_Library_libc_so_6 :: #library,system "libc.so.6";
fopen :: (filename: *s8, modes: *s8) -> *FILE #foreign System_Library_libc_so_6;

fgets :: (s: *s8, n: s32, stream: *FILE) -> *s8 #foreign System_Library_libc_so_6;

fclose :: (stream: *FILE) -> s32 #foreign System_Library_libc_so_6;

strpbrk :: (s: *s8, accept: *s8) -> *s8 #foreign System_Library_libc_so_6;

FILE :: C_Transpiler_POSIX.FILE;

