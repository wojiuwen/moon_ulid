///| 
/// ULID 字符串转换测试
///| 
fn test_ulid_parse() {
  let ulid_str = "01H2J3K4L5M6N7P8Q9R"
  let result = Ulid.parse(ulid_str)
  assert_true(result.is_ok())
}

fn test_ulid_parse_invalid_length() {
  let invalid_str = "01H2J3K4L5M6N7P8Q9" // 长度不足
  
  let result = Ulid.parse(invalid_str)
  assert_true(result.is_err())
  assert_eq(UlidError.code(result.unwrap_err()), "INVALID_LENGTH")
}

fn test_ulid_parse_invalid_character() {
  let invalid_str = "01H2J3K4L5M6N7P8Q9X" // 包含无效字符
  
  let result = Ulid.parse(invalid_str)
  assert_true(result.is_err())
  assert_eq(UlidError.code(result.unwrap_err()), "INVALID_CHARACTER")
}

fn test_ulid_to_string() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  let ulid = Ulid.from_parts(timestamp, randomness).unwrap()
  let str = Ulid.to_string(ulid)
  assert_eq(str, "01H2J3K4L5M6N7P8Q9R")
}

fn test_ulid_is_valid() {
  let valid_str = "01H2J3K4L5M6N7P8Q9R"
  let invalid_str = "01H2J3K4L5M6N7P8Q9X" // 包含无效字符
  
  assert_true(Ulid.is_valid(valid_str))
  assert_false(Ulid.is_valid(invalid_str))
}