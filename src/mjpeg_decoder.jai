// Generated directly from C++ by cpp_transpiler.
K_UNKNOWN_DATA_SIZE: u32;

globals_initialization_state_for_mjpeg_decoder: u32;
initialize_globals_for_mjpeg_decoder :: () {
    {
        state := atomic_load(*globals_initialization_state_for_mjpeg_decoder);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_mjpeg_decoder, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_mjpeg_decoder) != 2 {}
            return;
        }
    }
    K_UNKNOWN_DATA_SIZE = 0xffffffff;
    atomic_store(*globals_initialization_state_for_mjpeg_decoder, 2);
}

