// RUN: mlir-opt -allow-unregistered-dialect %s -split-input-file | FileCheck %s

// -----
// All per-layer params specified:
//   [signed] storageType, storageTypeMin, storageTypeMax, expressedType, scale, zeroPoint
// CHECK: !quant.uniform<i8<-8:7>:f32, 9.987200e-01:127>
!qalias = !quant.uniform<i8<-8:7>:f32, 0.99872:127>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Trailing whitespace.
// CHECK: !quant.uniform<i8<-8:7>:f32, 9.987200e-01:127>
!qalias = !quant.uniform<i8<-8:7>:f32, 0.99872:127  >
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Required per-layer params specified:
//   [unsigned] storageType, expressedType, scale
// CHECK: !quant.uniform<u8:f32, 9.987200e-01>
!qalias = !quant.uniform<u8:f32, 0.99872>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Exponential scale (-)
// CHECK: !quant.uniform<u8:f32, 2.000000e-02>
!qalias = !quant.uniform<u8:f32, 2.0e-2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Exponential scale (+)
// CHECK: !quant.uniform<u8:f32, 2.000000e+02>
!qalias = !quant.uniform<u8:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Storage type: i16
// CHECK: !quant.uniform<i16:f32, 2.000000e+02>
!qalias = !quant.uniform<i16:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Storage type: u16
// CHECK: !quant.uniform<u16:f32, 2.000000e+02>
!qalias = !quant.uniform<u16:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Storage type: i32
// CHECK: !quant.uniform<i32:f32, 2.000000e+02>
!qalias = !quant.uniform<i32:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Storage type: u32
// CHECK: !quant.uniform<u32:f32, 2.000000e+02>
!qalias = !quant.uniform<u32:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Expressed type: f32
// CHECK: !quant.uniform<u8:f32, 2.000000e+02>
!qalias = !quant.uniform<u8:f32, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Expressed type: f32
// CHECK: !quant.uniform<u8:f32, 0x41646ABBA0000000:128>
!qalias = !quant.uniform<u8:f32, 0x41646ABBA0000000:128>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Expressed type: f16
// CHECK: !quant.uniform<u8:f16, 2.000000e+02>
!qalias = !quant.uniform<u8:f16, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Expressed type: f64
// CHECK: !quant.uniform<u8:f64, 2.000000e+02>
!qalias = !quant.uniform<u8:f64, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Expressed type: bf16
// CHECK: !quant.uniform<u8:bf16, 2.000000e+02>
!qalias = !quant.uniform<u8:bf16, 2.0e+2>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Per-axis scales and zero points (affine)
// CHECK: !quant.uniform<u8:f32:1, {2.000000e+02:-120,9.987200e-01:127}>
!qalias = !quant.uniform<u8:f32:1, {2.0e+2:-120,0.99872:127}>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Per-axis scales and no zero points (fixedpoint)
// CHECK: !quant.uniform<i8:f32:1, {2.000000e+02,9.987200e-01}>
!qalias = !quant.uniform<i8:f32:1, {2.0e+2,0.99872}>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Per-axis scales and zero points (mixed affine and fixedpoint)
// CHECK: !quant.uniform<i8:f32:1, {2.000000e+02,9.987200e-01:120}>
!qalias = !quant.uniform<i8:f32:1, {2.0e+2,0.99872:120}>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Sub-channel scales and zero points (mixed affine and fixedpoint)
// CHECK: !quant.uniform<u8:f32:{0:1, 1:2}, {{\{}}{2.000000e+00:120, 3.000000e+00:127}, {4.000000e+00, 5.000000e+00}}>
!qalias = !quant.uniform<u8:f32:{0:1, 1:2}, {{2.0:120,3.0:127}, {4.0,5.0}}>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}

// -----
// Empty block-size information in sub-channel quantization
// CHECK: !quant.uniform<u8:f32:{}, {{\{}}{2.000000e+00:120, 3.000000e+00:127}, {4.000000e+00, 5.000000e+00}}>
!qalias = !quant.uniform<u8:f32:{}, {{2.0:120,3.0:127}, {4.0,5.0}}>
func.func @parse() -> !qalias {
  %0 = "foo"() : () -> !qalias
  return %0 : !qalias
}
