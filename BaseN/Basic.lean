import Std.Data.HashMap

open Std

/-!
# BaseN Definitions

This module contains basic definition for base-n encoding and decoding.
-/

namespace BaseN

instance : Hashable Char where
  hash c := hash c.val

/-- `True` if all element in the `List` are dictinct. -/
@[simp] def listDistinct [BEq α] : List α → Prop
  | x :: xs => xs.notElem x
  | [] => True

namespace Alphabet

@[simp] def mkBackward (cs : List Char) : HashMap Char UInt8 :=
  cs.foldl (λ m c => m.insert c m.size.toUInt8) HashMap.empty

@[simp] def optionNotElem : List Char → Option Char → Bool
  | cs, some c => cs.notElem c
  | _, _ => True

end Alphabet

/-- The `Alphabet` is used to convert base encoded numbers to `String`. -/
structure Alphabet where
  /-- Convert base encoded number to `Char`. -/
  list : List Char
  /-- The padding character. -/
  padChar : Option Char
  /-- Reverse map for quick look up. -/
  inverse : HashMap Char UInt8 := Alphabet.mkBackward list
  /-- The size of `list` should be 16, 32 or 64. -/
  hSize :
    list.length = 16 ∨ 
    list.length = 32 ∨ 
    list.length = 64 := by simp
  /-- The padding is required if base32 or base64 is used. -/
  hNeedPadding :
    if list.length ≠ 16
    then padChar.isSome
    else True := by simp
  /-- `list` and `padChar` should be distinct. -/
  hDistinct :
    listDistinct list ∧ Alphabet.optionNotElem list padChar := by simp

namespace Alphabet

/-- The length of the `Alphabet`. -/
@[simp] def length (a : Alphabet) : Nat :=
  a.list.length

/-- Transform `ByteArray` into `String`. -/
def forward (a : Alphabet) (b : ByteArray) : String :=
  ⟨ b.toList.map λ u => a.list.get! u.toNat ⟩ 

instance : Monad Option where
  pure := some
  bind := Option.bind
  
/-- Transform `String` back to `ByteArray`. -/
def backward (a : Alphabet) (s : String) (rejectOutside : Bool) : Option ByteArray :=
  if rejectOutside then
    s.data.mapM (λ c => a.inverse.find? c) |>.bind (·.toByteArray)
  else
    s.data.filterMap (λ c => a.inverse.find? c) |>.toByteArray

end Alphabet

/--
Used to customize the encoding process.
-/
structure Config where
  alphabet : Alphabet
  usePaddding : Bool := true
  rejectOutside : Bool := true

end BaseN