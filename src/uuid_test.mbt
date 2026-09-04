///| 
/// UUID 测试
///| 
fn test_uuid_version() {
  let uuid = Uuid { bytes: Bytes::make(16) }
  // 设置版本为 6
  uuid.bytes[6] = 0x60
  
  assert_eq(Uuid.version(uuid), 6)
}

fn test_uuid_rfc_variant() {
  let uuid = Uuid { bytes: Bytes::make(16) }
  // 设置变体为 RFC 变体
  uuid.bytes[8] = 0x80
  
  assert_true(Uuid.is_rfc_variant(uuid))
}