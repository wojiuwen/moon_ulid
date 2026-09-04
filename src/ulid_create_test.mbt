///| 
/// ULID 创建和验证测试
///| 
fn test_ulid_from_parts() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  let result = Ulid.from_parts(timestamp, randomness)
  assert_true(result.is_ok())
}

fn test_ulid_from_parts_invalid_length() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(9) // 无效长度
  
  let result = Ulid.from_parts(timestamp, randomness)
  assert_true(result.is_err())
  assert_eq(UlidError.code(result.unwrap_err()), "INVALID_BYTE_LENGTH")
}

fn test_ulid_from_parts_timestamp_overflow() {
  let timestamp = 0xFFFFFFFFFFFF + 1 // 溢出时间戳
  let randomness = Bytes::make(10)
  
  let result = Ulid.from_parts(timestamp, randomness)
  assert_true(result.is_err())
  assert_eq(UlidError.code(result.unwrap_err()), "TIMESTAMP_OVERFLOW")
}

fn test_ulid_is_valid() {
  let valid_str = "01H2J3K4L5M6N7P8Q9R"
  let invalid_str = "01H2J3K4L5M6N7P8Q9X" // 包含无效字符
  
  assert_true(Ulid.is_valid(valid_str))
  assert_false(Ulid.is_valid(invalid_str))
}

fn test_ulid_is_valid_invalid_length() {
  let invalid_str = "01H2J3K4L5M6N7P8Q9" // 长度不足
  
  assert_false(Ulid.is_valid(invalid_str))
}