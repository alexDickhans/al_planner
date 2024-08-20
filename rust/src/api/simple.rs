use std::time::Duration;
use flutter_rust_bridge::frb;
use motion_profiling::{
    combined_mp::CombinedMP,
    motion_profile::MotionProfile,
    path::Path
};

fn actual_work(path: Path) -> u128 {
    if let Some(mp) = CombinedMP::try_new_2d(path) {
        mp.get_duration().as_millis()
    } else {
        Duration::new(1000000, 0).as_millis()
    }
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
