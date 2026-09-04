///| 
/// ULID 字节转换功能
///| 
pub fn Ulid.to_bytes(self : Ulid) -> Bytes {
  let bytes = Bytes::make(16)
  
  // 时间戳（48 位）转换为 6 字节
  bytes[0] = (self.timestamp >> 40) & 0xFF
  bytes[1] = (self.timestamp >> 32) & 0xFF
  bytes[2] = (self.timestamp >> 24) & 0xFF
  bytes[3] = (self.timestamp >> 16) & 0xFF
  bytes[4] = (self.timestamp >> 8) & 0xFF
  bytes[5] = self.timestamp & 0xFF
  
  // 随机数据（80 位）转换为 10 字节
  for i in 0..10 {
    bytes[6 + i] = self.randomness[i]
  }
  
  bytes
}

pub fn Ulid.from_bytes(value : Bytes) -> Result[Ulid, UlidError] {
  // 检查字节长度
  if value.length() != 16 {
    return Result::Err(InvalidByteLength(16, value.length()))
  }
  
  // 提取时间戳（前 6 字节）
  let timestamp = 
    (UInt64.from_int(value[0]) << 40) |
    (UInt64.from_int(value[1]) << 32) |
    (UInt64.from_int(value[2]) << 24) |
    (UInt64.from_int(value[3]) << 16) |
    (UInt64.from_int(value[4]) << 8) |
    UInt64.from_int(value[5])
  
  // 提取随机数据（后 10 字节）
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = value[6 + i]
  }
  
  Ulid.from_parts(timestamp, randomness)
}
