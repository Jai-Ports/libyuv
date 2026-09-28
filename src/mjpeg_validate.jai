K_UNKNOWN_DATA_SIZE_storage: u32;

ValidateJpeg :: (src_mjpg: *u8, src_size_mjpg: u64) -> s32 {
    K_MAX_JPEG_SIZE: u64 = 0x7fffffff;
    K_BACK_SEARCH_SIZE: u64 = 1024;
    if src_size_mjpg < 64 || src_size_mjpg > K_MAX_JPEG_SIZE || src_mjpg == null {
        return 0;
    }

    if src_mjpg[0] != 0xff || src_mjpg[1] != 0xd8 || src_mjpg[2] != 0xff {
        return 0;
    }

    if src_size_mjpg > K_BACK_SEARCH_SIZE {
        if scan_eoi(src_mjpg + src_size_mjpg - K_BACK_SEARCH_SIZE, K_BACK_SEARCH_SIZE) != 0 {
            return 1;
        }

        src_size_mjpg = src_size_mjpg - K_BACK_SEARCH_SIZE + 1;
    }

    return scan_eoi(src_mjpg + 2, src_size_mjpg - 2);
}

scan_eoi :: (src_mjpg: *u8, src_size_mjpg: u64) -> s32 {
    if src_size_mjpg >= 2 {
        end := cast,no_check(*u8) ((src_mjpg + src_size_mjpg - 1));
        it_ := cast,no_check(*u8) (src_mjpg);
        while it_ < end {
            it_ =
                cast,no_check(*u8) (cast(*u8) c_transpiler_memchr(cast(*void) it_, 0xff, cast,no_check(u64) (end -
                    it_)));
            if it_ == null {
                break;
            }
            if it_[1] == 0xd9 {
                return 1;
            }
            it_ += 1;
        }
    }

    return 0;
}

globals_initialization_state_for_mjpeg_validate: u32;
initialize_globals_for_mjpeg_validate :: () {
    {
        state := atomic_load(*globals_initialization_state_for_mjpeg_validate);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_mjpeg_validate, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_mjpeg_validate) != 2 {}
            return;
        }
    }
    K_UNKNOWN_DATA_SIZE_storage = 0xffffffff;
    atomic_store(*globals_initialization_state_for_mjpeg_validate, 2);
}

