import BaseN

open BaseN

def tests : List (String × String) := [
  ("", ""),
  ("f", "Zg=="),
  ("fo", "Zm8="),
  ("foo", "Zm9v"),
  ("foob", "Zm9vYg=="),
  ("fooba", "Zm9vYmE="),
  ("foobar",  "Zm9vYmFy")
]

def main : IO Unit := do
  for t in tests do
    if encode64 t.fst.toUTF8 ≠ t.snd then
      throw $ IO.userError s!"Failed encoding: {t.fst} → {t.snd}"
    if let some x := decode64 t.snd then
      if String.fromUTF8Unchecked x ≠ t.fst then
        throw $ IO.userError s!"Failed decoding: {t.snd} → {t.fst}"
    else 
      throw $ IO.userError s!"Failed decoding: {t.snd} → {t.fst}"