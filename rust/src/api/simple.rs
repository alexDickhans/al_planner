use flutter_rust_bridge::frb;
use motion_profiling::{
    combined_mp::CombinedMP,
    motion_profile::MotionProfile,
    path::Path
};

fn actual_work(path: Path) -> u128 {
    CombinedMP::new_2d(path).get_duration().as_millis()
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn get_duration(path: Path) -> u128 {
    actual_work(path)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
