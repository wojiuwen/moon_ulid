///| 
/// ULID 生成器测试
///| 
fn test_ulid_generate() {
  let result = Ulid.generate()
  assert_true(result.is_ok())
}

fn test_ulid_generate_at() {
  let timestamp = 1720000000000
  let result = Ulid.generate_at(timestamp)
  assert_true(result.is_ok())
}

fn test_generate_random_bytes() {
  let randomness = generate_random_bytes()
  assert_eq(randomness.length(), 10)
  for i in 0..10 {
    assert_eq(randomness[i], UInt8.from_int(i))
  }
}