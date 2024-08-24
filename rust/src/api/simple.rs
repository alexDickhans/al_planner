use std::sync::{RwLock};
use std::time::Duration;
use flutter_rust_bridge::frb;
use lazy_static::lazy_static;
use motion_profiling::{
    combined_mp::CombinedMP,
    motion_profile::MotionProfile,
    path::Path
};
use motion_profiling::mp_2d::MotionProfile2d;
use nalgebra::{Vector3};
use uom::si::velocity::*;

lazy_static!(
    static ref MP: RwLock<CombinedMP<MotionProfile2d>> = RwLock::new(CombinedMP::new(vec![]));
);

fn actual_work(path: Path) -> u128 {
    if let Some(new_mp) = CombinedMP::try_new_2d(path, 12.0/39.37) {
        *MP.write().unwrap() = new_mp;
        MP.read().unwrap().duration().as_millis()
    } else {
        Duration::new(1000000, 0).as_millis()
    }
}

fn actual_work_get_t(t: f64) -> Pose {
    if let Some(command) = MP.write().unwrap().get(Duration::from_millis((t * 1000.0) as u64)) {
        command.desired_pose.into()
    } else {
        Pose {
            x: 0.0,
            y: 0.0,
            theta: 0.0,
        }
    }
}

fn actual_work_get_v(t: f64) -> f64 {
    if let Some(command) = MP.write().unwrap().get(Duration::from_millis((t * 1000.0) as u64)) {
        command.desired_velocity.get::<inch_per_second>()
    } else {
        0.0
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
pub fn get_pose(t: f64) -> Pose {
    actual_work_get_t(t)
}


#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn get_velocity(t: f64) -> f64 {
    actual_work_get_v(t)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
