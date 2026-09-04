///| 
/// ULID 字节转换测试
///| 
fn test_ulid_to_bytes() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  let ulid = Ulid.from_parts(timestamp, randomness).unwrap()
  let bytes = Ulid.to_bytes(ulid)
  
  assert_eq(bytes.length(), 16)
}

fn test_ulid_from_bytes() {
  let bytes = Bytes::make(16)
  bytes[0] = 0x01
  bytes[1] = 0x02
  bytes[2] = 0x03
  bytes[3] = 0x04
  bytes[4] = 0x05
  bytes[5] = 0x06
  for i in 0..10 {
    bytes[6 + i] = UInt8.from_int(i)
  }
  
  let result = Ulid.from_bytes(bytes)
  assert_true(result.is_ok())
}

fn test_ulid_from_bytes_invalid_length() {
  let bytes = Bytes::make(15) // 无效长度
  
  let result = Ulid.from_bytes(bytes)
  assert_true(result.is_err())
  assert_eq(UlidError.code(result.unwrap_err()), "INVALID_BYTE_LENGTH")
}

fn test_ulid_bytes_roundtrip() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  let ulid = Ulid.from_parts(timestamp, randomness).unwrap()
  let bytes = Ulid.to_bytes(ulid)
  let ulid2 = Ulid.from_bytes(bytes).unwrap()
  
  assert_eq(ulid.timestamp, ulid2.timestamp)
  assert_eq(ulid.randomness.length(), ulid2.randomness.length())
}