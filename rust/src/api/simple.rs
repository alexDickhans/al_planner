use std::time::Duration;
use flutter_rust_bridge::frb;
use motion_profiling::{
    combined_mp::CombinedMP,
    motion_profile::MotionProfile,
    path::Path
};
use nalgebra::{Vector3};

fn actual_work(path: Path) -> u128 {
    if let Some(mp) = CombinedMP::try_new_2d(path, 12.0/39.37) {
        mp.duration().as_millis()
    } else {
        Duration::new(1000000, 0).as_millis()
    }
}

fn actual_work_get_t(path: Path, t: f64) -> Pose {
    if let Some(mut mp) = CombinedMP::try_new_2d(path, 12.0/39.37) {
        if let Some(command) = mp.get(Duration::from_millis((t * 1000.0) as u64)) {
            command.desired_pose.into()
        } else {
            Pose {
                x: 0.0,
                y: 0.0,
                theta: 0.0,
            }
        }
    } else {
        Pose {
            x: 0.0,
            y: 0.0,
            theta: 0.0,
        }
    }
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn get_duration(path: Path) -> u128 {
    actual_work(path)
}

pub struct Pose {
    pub x: f64,
    pub y: f64,
    pub theta: f64,
}

impl From<Vector3<f64>> for Pose {
    fn from(value: Vector3<f64>) -> Self {
        Self {
            x: value.x,
            y: value.y,
            theta: value.z,
        }
    }
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn get_pose(path: Path, t: f64) -> Pose {
    actual_work_get_t(path, t)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
