///| 
/// ULID 创建和验证功能
///| 
pub fn Ulid.from_parts(
  timestamp_ms : UInt64,
  randomness : Bytes,
) -> Result[Ulid, UlidError] {
  // 检查随机字节长度
  if randomness.length() != 10 {
    return Result::Err(InvalidByteLength(10, randomness.length()))
  }
  
  // 检查时间戳是否在 48 位范围内
  if timestamp_ms > 0xFFFFFFFFFFFF {
    return Result::Err(TimestampOverflow(timestamp_ms))
  }
  
  Result::Ok(Ulid {
    timestamp: timestamp_ms,
    randomness: randomness
  })
}

pub fn Ulid.is_valid(value : String) -> Bool {
  // 检查长度
  if value.length() != 26 {
    return false
  }
  
  // 检查所有字符是否为有效的 Crockford Base32 字符
  let valid_chars = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
  for i in 0..value.length() {
    let char = value[i]
    if !valid_chars.contains(char) {
      return false
    }
  }
  
  true
}
