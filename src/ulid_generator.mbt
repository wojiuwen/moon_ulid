///|
/// ULID 生成器实现
///|
fn generate_random_bytes() -> Bytes {
  // 这里应该是实际的随机字节生成逻辑
  // 为了演示，我们使用一个简单的实现
  let random_bytes = Bytes::make(10)
  for i in 0..10 {
    random_bytes[i] = UInt8.from_int(i)
  }
  random_bytes
}

pub fn Ulid.generate() -> Result[Ulid, UlidError] {
  // 获取当前时间戳（Unix 毫秒）
  let timestamp_ms = get_current_timestamp()
  Ulid.generate_at(timestamp_ms)
}

pub fn Ulid.generate_at(timestamp_ms : UInt64) -> Result[Ulid, UlidError] {
  // 检查时间戳是否在 48 位范围内
  if timestamp_ms > 0xFFFFFFFFFFFF {
    return Result::Err(TimestampOverflow(timestamp_ms))
  }
  
  let randomness = generate_random_bytes()
  Ulid.from_parts(timestamp_ms, randomness)
}

fn get_current_timestamp() -> UInt64 {
  // 这里应该是获取当前 Unix 毫秒时间戳的逻辑
  // 为了演示，我们返回一个固定值
  1720000000000
}