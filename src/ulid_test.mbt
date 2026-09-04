///| 
/// ULID 测试
///| 
fn test_ulid_struct() {
  let timestamp = 1720000000000
  let randomness = Bytes::make(10)
  for i in 0..10 {
    randomness[i] = UInt8.from_int(i)
  }
  
  let ulid = Ulid {
    timestamp: timestamp,
    randomness: randomness
  }
  
  assert_eq(ulid.timestamp, timestamp)
  assert_eq(ulid.randomness.length(), 10)
}

fn test_ulid_error_codes() {
  let error = InvalidLength(26, 25)
  assert_eq(UlidError.code(error), "INVALID_LENGTH")
  assert_eq(UlidError.message(error), "Invalid length: expected 26, got 25")
  
  let error = InvalidCharacter(5, 'X')
  assert_eq(UlidError.code(error), "INVALID_CHARACTER")
  assert_eq(UlidError.message(error), "Invalid character at position 5: 'X'")
  
  let error = TimestampOverflow(0xFFFFFFFFFFFF + 1)
  assert_eq(UlidError.code(error), "TIMESTAMP_OVERFLOW")
  assert_eq(UlidError.message(error), "Timestamp overflow: 281474976710657")
}
