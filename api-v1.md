# mbt-ulid 第一版 API 文档

## 1. 文档定位

本文档定义 `mbt-ulid` 第一版稳定 API，只包含第一版需要实现并保证稳定的接口。

第一版优先保证：

- ULID 的生成、解析、校验和序列化。
- ULID 时间戳的读取。
- UUID 的解析和格式化。
- UUID v6 到 ULID 的明确转换规则。
- 结构化错误和可验证行为。

## 2. 额外拓展内容

以下功能可作为第一版发布后的额外拓展内容：

- 批量 API（如 `generate_many`）
- Wasm JavaScript 接口
- CLI 命令接口
- RFC3339 解析
- 单调生成器
- Base32 编解码函数
- 时间格式转换（Unix 时间）

## 2. 稳定性约定

本文件中的 `pub` 类型和函数属于第一版公开 API。函数名称、参数类型、返回类型和错误代码在 `1.0.0` 前应尽量保持兼容。

以下内容属于实现细节，不保证稳定：

- `Base32` 的内部函数。
- 时间源和随机源的具体实现。
- UUID v6 与 ULID 转换的内部位运算。
- CLI、Wasm 和基准测试接口。

所有公开解析和转换函数使用 `Result` 返回错误，不通过异常字符串判断失败类型。

## 3. 核心类型

### 3.1 `Ulid`

```moonbit
pub struct Ulid {
  timestamp : UInt64
  randomness : Bytes
}
```

实现必须保证：

- `timestamp` 不超过 ULID 支持的 48 位范围。
- `randomness` 恰好包含 10 字节。
- 外部调用者不能绕过校验构造非法值。

### 3.2 `Uuid`

```moonbit
pub struct Uuid {
  bytes : Bytes
}
```

第一版能够读取 UUID 的版本和变体，并要求使用 RFC 变体。UUID v6 转 ULID 时只接受版本为 6 的 UUID；其他版本返回错误。

### 3.3 `UlidError`

```moonbit
pub enum UlidError {
  InvalidLength(expected : Int, actual : Int)
  InvalidCharacter(position : Int, character : Char)
  InvalidLeadingValue
  TimestampOverflow(value : UInt64)
  InvalidByteLength(expected : Int, actual : Int)
  InvalidUuidFormat
  UnsupportedUuidVersion(version : Int)
  UnsupportedUuidVariant
  UuidTimestampOutOfRange(value : UInt64)
}
```

错误接口：

```moonbit
pub fn UlidError.message(self : UlidError) -> String
pub fn UlidError.code(self : UlidError) -> String
```

`code` 的第一版取值固定为：

```
INVALID_LENGTH
INVALID_CHARACTER
INVALID_LEADING_VALUE
TIMESTAMP_OVERFLOW
INVALID_BYTE_LENGTH
INVALID_UUID_FORMAT
UNSUPPORTED_UUID_VERSION
UNSUPPORTED_UUID_VARIANT
UUID_TIMESTAMP_OUT_OF_RANGE
```

## 4. ULID 核心 API

### 4.1 生成

```moonbit
pub fn Ulid.generate() -> Result[Ulid, UlidError]
pub fn Ulid.generate_at(timestamp_ms : UInt64) -> Result[Ulid, UlidError]
```

`generate` 使用当前 Unix 毫秒时间和系统随机源。`generate_at` 使用调用者提供的毫秒时间戳，并生成随机部分。

### 4.2 确定性创建

```moonbit
pub fn Ulid.from_parts(
  timestamp_ms : UInt64,
  randomness : Bytes,
) -> Result[Ulid, UlidError]
```

`randomness` 必须恰好为 10 字节；函数不自动截断或填充输入。

### 4.3 字符串转换

```moonbit
pub fn Ulid.parse(value : String) -> Result[Ulid, UlidError]
pub fn Ulid.to_string(self : Ulid) -> String
pub fn Ulid.is_valid(value : String) -> Bool
```

约定：

- 输入长度必须为 26 个字符。
- 接受大小写输入，输出始终为大写。
- 使用 Crockford Base32 字符表。
- 非法字符和首字符溢出必须返回结构化错误。
- 第一版不接受混淆字符替换，不静默忽略空格或其他字符。

### 4.4 字节转换

```moonbit
pub fn Ulid.to_bytes(self : Ulid) -> Bytes
pub fn Ulid.from_bytes(value : Bytes) -> Result[Ulid, UlidError]
```

`to_bytes` 和 `from_bytes` 使用固定的 16 字节大端序表示。`from_bytes` 只接受 16 字节输入。

### 4.5 时间读取

```moonbit
pub fn Ulid.timestamp_ms(self : Ulid) -> UInt64
pub fn Ulid.timestamp_seconds(self : Ulid) -> UInt64
```

`timestamp_seconds` 返回毫秒时间戳除以 `1000` 后的整数结果，不进行四舍五入。

## 5. UUID 核心 API

### 5.1 UUID 字符串转换

```moonbit
pub fn Uuid.parse(value : String) -> Result[Uuid, UlidError]
pub fn Uuid.to_string(self : Uuid) -> String
pub fn Uuid.version(self : Uuid) -> Int
pub fn Uuid.is_rfc_variant(self : Uuid) -> Bool
```

第一版支持标准 36 字符格式：

```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

无连字符、花括号和 URN 格式不属于第一版稳定输入范围。

### 5.2 UUID v6 转 ULID

```moonbit
pub fn Ulid.from_uuid_v6(value : Uuid) -> Result[Ulid, UlidError]
```

转换规则：

- 输入必须是 RFC 变体的 UUID v6。
- UUID v6 的 60 位时间戳按 UUID 标准解释为自 Gregorian epoch 起的 100 纳秒单位。
- 转换为 Unix 毫秒时使用整数除法，丢弃不足 1 毫秒的精度。
- 如果 UUID 时间戳早于 Unix epoch，或转换结果超过 ULID 的 48 位时间范围，返回 `UuidTimestampOutOfRange`。
- UUID v6 中除版本位和变体位之外的 62 位数据，放入 ULID 随机部分的高 62 位。
- ULID 随机部分的低 18 位固定为零，因此该转换是确定性的，但不是无损转换。
- 不提供 ULID 转 UUID 的第一版公开 API。

## 6. 稳定性约定

本文件中的 `pub` 类型和函数属于第一版公开 API。函数名称、参数类型、返回类型和错误代码在 `1.0.0` 前应尽量保持兼容。

以下内容属于实现细节，不保证稳定：

- `Base32` 的内部函数。
- 时间源和随机源的具体实现。
- UUID v6 与 ULID 转换的内部位运算。
- CLI、Wasm 和基准测试接口。

所有公开解析和转换函数使用 `Result` 返回错误，不通过异常字符串判断失败类型。