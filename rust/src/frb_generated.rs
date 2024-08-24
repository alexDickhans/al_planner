// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.3.0.

#![allow(
    non_camel_case_types,
    unused,
    non_snake_case,
    clippy::needless_return,
    clippy::redundant_closure_call,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::unused_unit,
    clippy::double_parens,
    clippy::let_and_return,
    clippy::too_many_arguments,
    clippy::match_single_binding,
    clippy::clone_on_copy,
    clippy::let_unit_value,
    clippy::deref_addrof,
    clippy::explicit_auto_deref,
    clippy::borrow_deref_ref,
    clippy::needless_borrow
)]

// Section: imports

use flutter_rust_bridge::for_generated::byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
use flutter_rust_bridge::{Handler, IntoIntoDart};

// Section: boilerplate

flutter_rust_bridge::frb_generated_boilerplate!(
    default_stream_sink_codec = SseCodec,
    default_rust_opaque = RustOpaqueMoi,
    default_rust_auto_opaque = RustAutoOpaqueMoi,
);
pub(crate) const FLUTTER_RUST_BRIDGE_CODEGEN_VERSION: &str = "2.3.0";
pub(crate) const FLUTTER_RUST_BRIDGE_CODEGEN_CONTENT_HASH: i32 = 37731952;

// Section: executor

flutter_rust_bridge::frb_generated_default_handler!();

// Section: wire_funcs

fn wire__crate__api__simple__get_duration_impl(
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_sync::<flutter_rust_bridge::for_generated::SseCodec, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_duration",
            port: None,
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Sync,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_path = <motion_profiling::path::Path>::sse_decode(&mut deserializer);
            deserializer.end();
            transform_result_sse::<_, ()>((move || {
                let output_ok = Result::<_, ()>::Ok(crate::api::simple::get_duration(api_path))?;
                Ok(output_ok)
            })())
        },
    )
}
fn wire__crate__api__simple__get_pose_impl(
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_sync::<flutter_rust_bridge::for_generated::SseCodec, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_pose",
            port: None,
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Sync,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_t = <f64>::sse_decode(&mut deserializer);
            deserializer.end();
            transform_result_sse::<_, ()>((move || {
                let output_ok = Result::<_, ()>::Ok(crate::api::simple::get_pose(api_t))?;
                Ok(output_ok)
            })())
        },
    )
}
fn wire__crate__api__simple__get_velocity_impl(
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_sync::<flutter_rust_bridge::for_generated::SseCodec, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "get_velocity",
            port: None,
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Sync,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            let api_t = <f64>::sse_decode(&mut deserializer);
            deserializer.end();
            transform_result_sse::<_, ()>((move || {
                let output_ok = Result::<_, ()>::Ok(crate::api::simple::get_velocity(api_t))?;
                Ok(output_ok)
            })())
        },
    )
}
fn wire__crate__api__simple__init_app_impl(
    port_: flutter_rust_bridge::for_generated::MessagePort,
    ptr_: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len_: i32,
    data_len_: i32,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap_normal::<flutter_rust_bridge::for_generated::SseCodec, _, _>(
        flutter_rust_bridge::for_generated::TaskInfo {
            debug_name: "init_app",
            port: Some(port_),
            mode: flutter_rust_bridge::for_generated::FfiCallMode::Normal,
        },
        move || {
            let message = unsafe {
                flutter_rust_bridge::for_generated::Dart2RustMessageSse::from_wire(
                    ptr_,
                    rust_vec_len_,
                    data_len_,
                )
            };
            let mut deserializer =
                flutter_rust_bridge::for_generated::SseDeserializer::new(message);
            deserializer.end();
            move |context| {
                transform_result_sse::<_, ()>((move || {
                    let output_ok = Result::<_, ()>::Ok({
                        crate::api::simple::init_app();
                    })?;
                    Ok(output_ok)
                })())
            }
        },
    )
}

// Section: static_checks

#[allow(clippy::unnecessary_literal_unwrap)]
const _: fn() = || {
    {
        let Command = None::<motion_profiling::path::Command>.unwrap();
        let _: f64 = Command.t;
        let _: String = Command.name;
    }
    {
        let Constraints = None::<motion_profiling::path::Constraints>.unwrap();
        let _: f64 = Constraints.velocity;
        let _: f64 = Constraints.accel;
    }
    {
        let Path = None::<motion_profiling::path::Path>.unwrap();
        let _: f64 = Path.start_speed;
        let _: f64 = Path.end_speed;
        let _: Vec<motion_profiling::path::PathSegment> = Path.segments;
        let _: Vec<motion_profiling::path::Command> = Path.commands;
    }
    {
        let PathSegment = None::<motion_profiling::path::PathSegment>.unwrap();
        let _: bool = PathSegment.inverted;
        let _: bool = PathSegment.stop_end;
        let _: Vec<motion_profiling::path::Point> = PathSegment.path;
        let _: motion_profiling::path::Constraints = PathSegment.constraints;
    }
    {
        let Point = None::<motion_profiling::path::Point>.unwrap();
        let _: f64 = Point.x;
        let _: f64 = Point.y;
    }
};

// Section: dart2rust

impl SseDecode for String {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <Vec<u8>>::sse_decode(deserializer);
        return String::from_utf8(inner).unwrap();
    }
}

impl SseDecode for u128 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut inner = <String>::sse_decode(deserializer);
        return inner.parse().unwrap();
    }
}

impl SseDecode for bool {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap() != 0
    }
}

impl SseDecode for motion_profiling::path::Command {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_t = <f64>::sse_decode(deserializer);
        let mut var_name = <String>::sse_decode(deserializer);
        return motion_profiling::path::Command {
            t: var_t,
            name: var_name,
        };
    }
}

impl SseDecode for motion_profiling::path::Constraints {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_velocity = <f64>::sse_decode(deserializer);
        let mut var_accel = <f64>::sse_decode(deserializer);
        return motion_profiling::path::Constraints {
            velocity: var_velocity,
            accel: var_accel,
        };
    }
}

impl SseDecode for f64 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_f64::<NativeEndian>().unwrap()
    }
}

impl SseDecode for Vec<motion_profiling::path::Command> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<motion_profiling::path::Command>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<motion_profiling::path::PathSegment> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<motion_profiling::path::PathSegment>::sse_decode(
                deserializer,
            ));
        }
        return ans_;
    }
}

impl SseDecode for Vec<motion_profiling::path::Point> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<motion_profiling::path::Point>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for Vec<u8> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut len_ = <i32>::sse_decode(deserializer);
        let mut ans_ = vec![];
        for idx_ in 0..len_ {
            ans_.push(<u8>::sse_decode(deserializer));
        }
        return ans_;
    }
}

impl SseDecode for motion_profiling::path::Path {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_startSpeed = <f64>::sse_decode(deserializer);
        let mut var_endSpeed = <f64>::sse_decode(deserializer);
        let mut var_segments = <Vec<motion_profiling::path::PathSegment>>::sse_decode(deserializer);
        let mut var_commands = <Vec<motion_profiling::path::Command>>::sse_decode(deserializer);
        return motion_profiling::path::Path {
            start_speed: var_startSpeed,
            end_speed: var_endSpeed,
            segments: var_segments,
            commands: var_commands,
        };
    }
}

impl SseDecode for motion_profiling::path::PathSegment {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_inverted = <bool>::sse_decode(deserializer);
        let mut var_stopEnd = <bool>::sse_decode(deserializer);
        let mut var_path = <Vec<motion_profiling::path::Point>>::sse_decode(deserializer);
        let mut var_constraints = <motion_profiling::path::Constraints>::sse_decode(deserializer);
        return motion_profiling::path::PathSegment {
            inverted: var_inverted,
            stop_end: var_stopEnd,
            path: var_path,
            constraints: var_constraints,
        };
    }
}

impl SseDecode for motion_profiling::path::Point {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_x = <f64>::sse_decode(deserializer);
        let mut var_y = <f64>::sse_decode(deserializer);
        return motion_profiling::path::Point { x: var_x, y: var_y };
    }
}

impl SseDecode for crate::api::simple::Pose {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        let mut var_x = <f64>::sse_decode(deserializer);
        let mut var_y = <f64>::sse_decode(deserializer);
        let mut var_theta = <f64>::sse_decode(deserializer);
        return crate::api::simple::Pose {
            x: var_x,
            y: var_y,
            theta: var_theta,
        };
    }
}

impl SseDecode for u8 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_u8().unwrap()
    }
}

impl SseDecode for () {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {}
}

impl SseDecode for i32 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_decode(deserializer: &mut flutter_rust_bridge::for_generated::SseDeserializer) -> Self {
        deserializer.cursor.read_i32::<NativeEndian>().unwrap()
    }
}

fn pde_ffi_dispatcher_primary_impl(
    func_id: i32,
    port: flutter_rust_bridge::for_generated::MessagePort,
    ptr: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len: i32,
    data_len: i32,
) {
    // Codec=Pde (Serialization + dispatch), see doc to use other codecs
    match func_id {
        4 => wire__crate__api__simple__init_app_impl(port, ptr, rust_vec_len, data_len),
        _ => unreachable!(),
    }
}

fn pde_ffi_dispatcher_sync_impl(
    func_id: i32,
    ptr: flutter_rust_bridge::for_generated::PlatformGeneralizedUint8ListPtr,
    rust_vec_len: i32,
    data_len: i32,
) -> flutter_rust_bridge::for_generated::WireSyncRust2DartSse {
    // Codec=Pde (Serialization + dispatch), see doc to use other codecs
    match func_id {
        1 => wire__crate__api__simple__get_duration_impl(ptr, rust_vec_len, data_len),
        2 => wire__crate__api__simple__get_pose_impl(ptr, rust_vec_len, data_len),
        3 => wire__crate__api__simple__get_velocity_impl(ptr, rust_vec_len, data_len),
        _ => unreachable!(),
    }
}

// Section: rust2dart

// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for FrbWrapper<motion_profiling::path::Command> {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.0.t.into_into_dart().into_dart(),
            self.0.name.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for FrbWrapper<motion_profiling::path::Command>
{
}
impl flutter_rust_bridge::IntoIntoDart<FrbWrapper<motion_profiling::path::Command>>
    for motion_profiling::path::Command
{
    fn into_into_dart(self) -> FrbWrapper<motion_profiling::path::Command> {
        self.into()
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for FrbWrapper<motion_profiling::path::Constraints> {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.0.velocity.into_into_dart().into_dart(),
            self.0.accel.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for FrbWrapper<motion_profiling::path::Constraints>
{
}
impl flutter_rust_bridge::IntoIntoDart<FrbWrapper<motion_profiling::path::Constraints>>
    for motion_profiling::path::Constraints
{
    fn into_into_dart(self) -> FrbWrapper<motion_profiling::path::Constraints> {
        self.into()
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for FrbWrapper<motion_profiling::path::Path> {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.0.start_speed.into_into_dart().into_dart(),
            self.0.end_speed.into_into_dart().into_dart(),
            self.0.segments.into_into_dart().into_dart(),
            self.0.commands.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for FrbWrapper<motion_profiling::path::Path>
{
}
impl flutter_rust_bridge::IntoIntoDart<FrbWrapper<motion_profiling::path::Path>>
    for motion_profiling::path::Path
{
    fn into_into_dart(self) -> FrbWrapper<motion_profiling::path::Path> {
        self.into()
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for FrbWrapper<motion_profiling::path::PathSegment> {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.0.inverted.into_into_dart().into_dart(),
            self.0.stop_end.into_into_dart().into_dart(),
            self.0.path.into_into_dart().into_dart(),
            self.0.constraints.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for FrbWrapper<motion_profiling::path::PathSegment>
{
}
impl flutter_rust_bridge::IntoIntoDart<FrbWrapper<motion_profiling::path::PathSegment>>
    for motion_profiling::path::PathSegment
{
    fn into_into_dart(self) -> FrbWrapper<motion_profiling::path::PathSegment> {
        self.into()
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for FrbWrapper<motion_profiling::path::Point> {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.0.x.into_into_dart().into_dart(),
            self.0.y.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive
    for FrbWrapper<motion_profiling::path::Point>
{
}
impl flutter_rust_bridge::IntoIntoDart<FrbWrapper<motion_profiling::path::Point>>
    for motion_profiling::path::Point
{
    fn into_into_dart(self) -> FrbWrapper<motion_profiling::path::Point> {
        self.into()
    }
}
// Codec=Dco (DartCObject based), see doc to use other codecs
impl flutter_rust_bridge::IntoDart for crate::api::simple::Pose {
    fn into_dart(self) -> flutter_rust_bridge::for_generated::DartAbi {
        [
            self.x.into_into_dart().into_dart(),
            self.y.into_into_dart().into_dart(),
            self.theta.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl flutter_rust_bridge::for_generated::IntoDartExceptPrimitive for crate::api::simple::Pose {}
impl flutter_rust_bridge::IntoIntoDart<crate::api::simple::Pose> for crate::api::simple::Pose {
    fn into_into_dart(self) -> crate::api::simple::Pose {
        self
    }
}

impl SseEncode for String {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <Vec<u8>>::sse_encode(self.into_bytes(), serializer);
    }
}

impl SseEncode for u128 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <String>::sse_encode(self.to_string(), serializer);
    }
}

impl SseEncode for bool {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self as _).unwrap();
    }
}

impl SseEncode for motion_profiling::path::Command {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <f64>::sse_encode(self.t, serializer);
        <String>::sse_encode(self.name, serializer);
    }
}

impl SseEncode for motion_profiling::path::Constraints {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <f64>::sse_encode(self.velocity, serializer);
        <f64>::sse_encode(self.accel, serializer);
    }
}

impl SseEncode for f64 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_f64::<NativeEndian>(self).unwrap();
    }
}

impl SseEncode for Vec<motion_profiling::path::Command> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <motion_profiling::path::Command>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<motion_profiling::path::PathSegment> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <motion_profiling::path::PathSegment>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<motion_profiling::path::Point> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <motion_profiling::path::Point>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for Vec<u8> {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <i32>::sse_encode(self.len() as _, serializer);
        for item in self {
            <u8>::sse_encode(item, serializer);
        }
    }
}

impl SseEncode for motion_profiling::path::Path {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <f64>::sse_encode(self.start_speed, serializer);
        <f64>::sse_encode(self.end_speed, serializer);
        <Vec<motion_profiling::path::PathSegment>>::sse_encode(self.segments, serializer);
        <Vec<motion_profiling::path::Command>>::sse_encode(self.commands, serializer);
    }
}

impl SseEncode for motion_profiling::path::PathSegment {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <bool>::sse_encode(self.inverted, serializer);
        <bool>::sse_encode(self.stop_end, serializer);
        <Vec<motion_profiling::path::Point>>::sse_encode(self.path, serializer);
        <motion_profiling::path::Constraints>::sse_encode(self.constraints, serializer);
    }
}

impl SseEncode for motion_profiling::path::Point {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <f64>::sse_encode(self.x, serializer);
        <f64>::sse_encode(self.y, serializer);
    }
}

impl SseEncode for crate::api::simple::Pose {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        <f64>::sse_encode(self.x, serializer);
        <f64>::sse_encode(self.y, serializer);
        <f64>::sse_encode(self.theta, serializer);
    }
}

impl SseEncode for u8 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_u8(self).unwrap();
    }
}

impl SseEncode for () {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {}
}

impl SseEncode for i32 {
    // Codec=Sse (Serialization based), see doc to use other codecs
    fn sse_encode(self, serializer: &mut flutter_rust_bridge::for_generated::SseSerializer) {
        serializer.cursor.write_i32::<NativeEndian>(self).unwrap();
    }
}

#[cfg(not(target_family = "wasm"))]
mod io {
    // This file is automatically generated, so please do not edit it.
    // Generated by `flutter_rust_bridge`@ 2.3.0.

    // Section: imports

    use super::*;
    use flutter_rust_bridge::for_generated::byteorder::{
        NativeEndian, ReadBytesExt, WriteBytesExt,
    };
    use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
    use flutter_rust_bridge::{Handler, IntoIntoDart};

    // Section: boilerplate

    flutter_rust_bridge::frb_generated_boilerplate_io!();
}
#[cfg(not(target_family = "wasm"))]
pub use io::*;

/// cbindgen:ignore
#[cfg(target_family = "wasm")]
mod web {
    // This file is automatically generated, so please do not edit it.
    // Generated by `flutter_rust_bridge`@ 2.3.0.

    // Section: imports

    use super::*;
    use flutter_rust_bridge::for_generated::byteorder::{
        NativeEndian, ReadBytesExt, WriteBytesExt,
    };
    use flutter_rust_bridge::for_generated::wasm_bindgen;
    use flutter_rust_bridge::for_generated::wasm_bindgen::prelude::*;
    use flutter_rust_bridge::for_generated::{transform_result_dco, Lifetimeable, Lockable};
    use flutter_rust_bridge::{Handler, IntoIntoDart};

    // Section: boilerplate

    flutter_rust_bridge::frb_generated_boilerplate_web!();
}
#[cfg(target_family = "wasm")]
pub use web::*;
