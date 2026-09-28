// Generated multi-translation-unit C/C++ to Jai program loader.
// Initialize before publishing translated APIs/callbacks to other threads.
// Call initialize_program once from the host; generated main does this automatically.
#load "compare.jai";
#load "compare_common.jai";
#load "convert.jai";
#load "convert_argb.jai";
#load "convert_from.jai";
#load "convert_from_argb.jai";
#load "convert_jpeg.jai";
#load "convert_to_argb.jai";
#load "convert_to_i420.jai";
#load "cpu_id.jai";
#load "mjpeg_decoder.jai";
#load "mjpeg_validate.jai";
#load "planar_functions.jai";
#load "rotate.jai";
#load "rotate_any.jai";
#load "rotate_argb.jai";
#load "rotate_common.jai";
#load "row_any.jai";
#load "row_common.jai";
#load "scale.jai";
#load "scale_any.jai";
#load "scale_argb.jai";
#load "scale_common.jai";
#load "scale_rgb.jai";
#load "scale_uv.jai";
#load "video_common.jai";
program_initialization_state: u32;
program_initialization_owner: u32;
initialize_program :: () {
    state := atomic_load(*program_initialization_state);
    if state == 2 return;
    thread_id := cast(u32) thread_local_index() + 1;
    if state == 1 {
        if atomic_load(*program_initialization_owner) == thread_id return;
        while atomic_load(*program_initialization_state) != 2 {}
        return;
    }
    won, _ := compare_and_swap(*program_initialization_state, 0, 1);
    if !won {
        while atomic_load(*program_initialization_state) != 2 {}
        return;
    }
    atomic_store(*program_initialization_owner, thread_id);
    initialize_globals_for_compare();
    initialize_globals_for_convert();
    initialize_globals_for_convert_argb();
    initialize_globals_for_convert_from();
    initialize_globals_for_convert_from_argb();
    initialize_globals_for_convert_to_argb();
    initialize_globals_for_convert_to_i420();
    initialize_globals_for_cpu_id();
    initialize_globals_for_mjpeg_decoder();
    initialize_globals_for_mjpeg_validate();
    initialize_globals_for_planar_functions();
    initialize_globals_for_rotate();
    initialize_globals_for_rotate_argb();
    initialize_globals_for_row_common();
    initialize_globals_for_scale();
    initialize_globals_for_scale_argb();
    initialize_globals_for_scale_common();
    initialize_globals_for_scale_uv();
    initialize_globals_for_video_common();
    atomic_store(*program_initialization_owner, 0);
    atomic_store(*program_initialization_state, 2);
}
