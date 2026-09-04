///| 
/// ULID 核心实现
///| 
pub struct Ulid {
  timestamp : UInt64
  randomness : Bytes
}

pub enum UlidError {
  InvalidLength(expected : Int, actual : Int)
  InvalidCharacter(position : Int, character : Char)
  InvalidLeadingValue
  TimestampOverflow(value : UInt64)
  InvalidByteLength(expected : Int, actual : Int)
  InvalidUuidFormat
  UnsupportedUuidVersion(version : Int)
  UnsupportedUuidVariant
  UuidTimestampOutOfRange(value : UInt64)
}

pub fn UlidError.message(self : UlidError) -> String {
  match self {
    InvalidLength(expected, actual) => "Invalid length: expected ${expected}, got ${actual}"
    InvalidCharacter(position, character) => "Invalid character at position ${position}: '${character}'"
    InvalidLeadingValue => "Invalid leading value"
    TimestampOverflow(value) => "Timestamp overflow: ${value}"
    InvalidByteLength(expected, actual) => "Invalid byte length: expected ${expected}, got ${actual}"
    InvalidUuidFormat => "Invalid UUID format"
    UnsupportedUuidVersion(version) => "Unsupported UUID version: ${version}"
    UnsupportedUuidVariant => "Unsupported UUID variant"
    UuidTimestampOutOfRange(value) => "UUID timestamp out of range: ${value}"
  }
}

pub fn UlidError.code(self : UlidError) -> String {
  match self {
    InvalidLength(_, _) => "INVALID_LENGTH"
    InvalidCharacter(_, _) => "INVALID_CHARACTER"
    InvalidLeadingValue => "INVALID_LEADING_VALUE"
    TimestampOverflow(_) => "TIMESTAMP_OVERFLOW"
    InvalidByteLength(_, _) => "INVALID_BYTE_LENGTH"
    InvalidUuidFormat => "INVALID_UUID_FORMAT"
    UnsupportedUuidVersion(_) => "UNSUPPORTED_UUID_VERSION"
    UnsupportedUuidVariant => "UNSUPPORTED_UUID_VARIANT"
    UuidTimestampOutOfRange(_) => "UUID_TIMESTAMP_OUT_OF_RANGE"
  }
}