import BaseN.Basic
import BaseN.Alphabets
import BaseN.Codec

/-!
# BaseN Encoding and Decoding

Compliant to: https://datatracker.ietf.org/doc/html/rfc4648

## Convenience Functions

Encoding: 

- `encode16`
- `encode32`
- `encode32Hex`
- `encode64`
- `encode64Url`

Decoding: 

- `decode16`
- `decode32`
- `decode32Hex`
- `decode64`
- `decode64Url`

## Advanced Usage

For customized encoding and decoding, see:

- `BaseN.encodeConfig`
- `BaseN.decodeConfig`
-/

namespace BaseN

/-- Encode `ByteArray` data to base16 encoded `String`. -/
def encode16 := encodeConfig { alphabet := base16Alphabet }

/-- Decode base16 encoded `String` to `ByteArray` data. -/
def decode16 := decodeConfig { alphabet := base16Alphabet }

/-- Encode `ByteArray` data to base32 encoded `String`. -/
def encode32 := encodeConfig { alphabet := base32Alphabet }

/-- Decode base32 encoded `String` to `ByteArray` data. -/
def decode32 := decodeConfig { alphabet := base32Alphabet }

/-- Encode `ByteArray` data to base32hex encoded `String`. -/
def encode32Hex := encodeConfig { alphabet := base32HexAlphabet }

/-- Decode base32hex encoded `String` to `ByteArray` data. -/
def decode32Hex := decodeConfig { alphabet := base32HexAlphabet }

/-- Encode `ByteArray` data to base64 encoded `String`. -/
def encode64 := encodeConfig { alphabet := base64Alphabet }

/-- Decode base64 encoded `String` to `ByteArray` data. -/
def decode64 := decodeConfig { alphabet := base64Alphabet }

/-- Encode `ByteArray` data to base64url encoded `String`. -/
def encode64Url := encodeConfig { alphabet := base64UrlAlphabet }

/-- Decode base64url encoded `String` to `ByteArray` data. -/
def decode64Url := decodeConfig { alphabet := base64UrlAlphabet }

end BaseN