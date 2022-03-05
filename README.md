# BaseN.lean

Encoding and decoding for `base16`, `base32`, `base32hex`, `base64` and `base64url`, compliant to [RFC 4648](https://datatracker.ietf.org/doc/html/rfc4648). 

## Usage

```lean
import BaseN
open BaseN

#eval encode64 "Man".toUTF8  -- "TWFu"
#eval decode64 "TWFu" |>.map String.fromUTF8Unchecked  -- some "Man"

#eval encode64 "Ma".toUTF8  -- "TWE="
#eval decode64 "TWE=" |>.map String.fromUTF8Unchecked  -- some "Ma"
```

To customize alphabet and other configutation:

```lean

let myAlphabet := {
  list := "ABCDEFGHIJKLMNOPQRSTUV0123456789".data  -- length of `list` can be 16, 32 or 64
  padChar := '='  -- padChar can be `none` when list.length = 16
}  -- all character in `list` and `padChar` should be distinct to each other

def myEncode32 := encodeConfig {
  alphabet := myAlphabet
  usePaddding := false  -- do not pad `=` at the end
}

def myDecode32 := decodeConfig {
  alphabet := myAlphabet
  rejectOutside := false  -- ignore characters not in alphabet, otherwise fail the decoding
}

#eval myEncode32 "Ma".toUTF8
#eval myDecode32 "E70B" |>.map String.fromUTF8Unchecked
```