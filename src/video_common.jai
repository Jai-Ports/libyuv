Four_CC_Alias_Entry :: struct {
    alias: u32;
    canonical: u32;
}

K_FOUR_CC_ALIASES: [18] Four_CC_Alias_Entry;

CanonicalFourCC :: (fourcc: u32) -> u32 {
    for i: 0..cast(s32) 18 - 1 {
        if K_FOUR_CC_ALIASES[i].alias == fourcc {
            return K_FOUR_CC_ALIASES[i].canonical;
        }
    }

    return fourcc;
}

globals_initialization_state_for_video_common: u32;
initialize_globals_for_video_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_video_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_video_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_video_common) != 2 {}
            return;
        }
    }
    K_FOUR_CC_ALIASES =
        Four_CC_Alias_Entry.[
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_IYUV, canonical = cast,no_check(u32) FOURCC_I420},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_YU12, canonical = cast,no_check(u32) FOURCC_I420},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_YU16, canonical = cast,no_check(u32) FOURCC_I422},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_YU24, canonical = cast,no_check(u32) FOURCC_I444},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_YUYV, canonical = cast,no_check(u32) FOURCC_YUY2},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_YUVS, canonical = cast,no_check(u32) FOURCC_YUY2},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_HDYC, canonical = cast,no_check(u32) FOURCC_UYVY},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_2VUY, canonical = cast,no_check(u32) FOURCC_UYVY},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_JPEG, canonical = cast,no_check(u32) FOURCC_MJPG},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_DMB1, canonical = cast,no_check(u32) FOURCC_MJPG},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_BA81, canonical = cast,no_check(u32) FOURCC_BGGR},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_RGB3, canonical = cast,no_check(u32) FOURCC_RAW},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_BGR3, canonical = cast,no_check(u32) FOURCC_24BG},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_CM32, canonical = cast,no_check(u32) FOURCC_BGRA},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_CM24, canonical = cast,no_check(u32) FOURCC_RAW},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_L555, canonical = cast,no_check(u32) FOURCC_RGBO},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_L565, canonical = cast,no_check(u32) FOURCC_RGBP},
            Four_CC_Alias_Entry.{alias = cast,no_check(u32) FOURCC_5551, canonical = cast,no_check(u32) FOURCC_RGBO}
        ];
    atomic_store(*globals_initialization_state_for_video_common, 2);
}

