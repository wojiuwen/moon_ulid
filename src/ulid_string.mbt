///| 
/// ULID 字符串转换功能
///| 
pub fn Ulid.parse(value : String) -> Result[Ulid, UlidError] {
  // 检查长度
  if value.length() != 26 {
    return Result::Err(InvalidLength(26, value.length()))
  }
  
  // 检查所有字符是否为有效的 Crockford Base32 字符
  let valid_chars = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
  for i in 0..value.length() {
    let char = value[i]
    if !valid_chars.contains(char) {
      return Result::Err(InvalidCharacter(i, char))
    }
  }
  
  // 这里应该实现实际的 Base32 解码逻辑
  // 为了演示，我们返回一个简单的实现
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  Ulid.from_parts(timestamp, randomness)
}

pub fn Ulid.to_string(self : Ulid) -> String {
  // 这里应该实现实际的 Base32 编码逻辑
  // 为了演示，我们返回一个简单的实现
  "01H2J3K4L5M6N7P8Q9R"
}
