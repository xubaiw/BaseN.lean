import BaseN.Basic

namespace BaseN

/-- `Alphabet` for base16 encoding. -/
def base16Alphabet : Alphabet := {
  list := "0123456789ABCDEF".data
  padChar := none
}

/-- `Alphabet` for base32 encoding. -/
def base32Alphabet : Alphabet := {
  list := "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567".data
  padChar := '='
}

/-- `Alphabet` for base32 encoding with extended hex alphabet. -/
def base32HexAlphabet : Alphabet := {
  list := "0123456789ABCDEFGHIJKLMNOPQRSTUV".data
  padChar := '='
}

/-- `Alphabet` for base64 encoding. -/
def base64Alphabet : Alphabet := {
  list := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".data
  padChar := '='
}

/-- `Alphabet` for base64 encoding with URL and filename safe alphabet. -/
def base64UrlAlphabet : Alphabet := {
  list := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_".data
  padChar := '='
}

end BaseN