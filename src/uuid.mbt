///|
/// UUID 核心实现
///|
pub struct Uuid {
  bytes : Bytes
}

pub fn Uuid.version(self : Uuid) -> Int {
  // 获取 UUID 版本位（第 6-7 字节的高 4 位）
  let version_byte = self.bytes[6]
  (version_byte >> 4) & 0x0F
}

pub fn Uuid.is_rfc_variant(self : Uuid) -> Bool {
  // 检查变体位（第 8 字节的最高 2 位）
  let variant_byte = self.bytes[8]
  (variant_byte & 0xC0) == 0x80
}