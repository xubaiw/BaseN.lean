import BaseN.Basic
import Lean.Data.Rat

open Lean

/-!
# BaseN Implementation

This module implements the encoding and decoding algorithms:

- `encodeConfig`
- `decodeConfig`
-/

-- XXX: better bit conversion

def Fin.val' (f : Fin n) : Nat :=
  match f.val with
  | 0 => n
  | i => i

namespace BaseN

def tetsFilter (t : Fin 8) (u : UInt8) : UInt8 :=
  let filter := 2 ^ t.val' - 1
  u &&& filter.toUInt8

def byteArrayToNat (t : Fin 8) (arr : ByteArray) : Nat :=
  arr.foldl (fun n u => n * (2 ^ t.val') + (tetsFilter t u).toNat) 0

def natToByteArray (t : Fin 8) (n : Nat) : ByteArray := Id.run do
  let b := 2 ^ t.val'
  let mut arr := Array.empty
  let mut x := n
  let mut i := 0
  while x ≠ 0 do
    arr := arr.push (x % b).toUInt8
    x := x / b
    i := i + 1
  ⟨arr.reverse⟩ 

/--
Transform `ByteArray` between different n-tets (e.g. octets to sextets).

`f` and `t` are the current #tet and target #tet.

The `truncate` parameter indicates whether to truncate or to pad 0 when 
the number of bits is not a multiple of `t`. 
-/
def transformTets (f t : Fin 8) (truncate : Bool) (data : ByteArray) : ByteArray :=
  let x := data.size * f.val' % t.val'
  let n := match (x, truncate, byteArrayToNat f data) with
  | (0, _, n) => n
  | (r, true, n) => n >>> r         -- truncate, to remove 0 padding
  | (r, false, n) => n <<< (t - r)  -- pad zero
  natToByteArray t n

/--
Encode the `ByteArray` into `String` with custom configuration.
-/
def encodeConfig (config : Config) (data : ByteArray) : String := 
  let targetTets := match config.alphabet.length with
    | 16 => 4
    | 32 => 5
    | 64 => 6
    | _ => unreachable! -- TODO: how to prove this?
  let transformed := transformTets 8 targetTets false data
  let unpadded := config.alphabet.forward transformed
  let groupSize := 8 / (targetTets.val.gcd 8)
  match config.usePaddding, config.alphabet.padChar with
  | true, some padChar =>
    if unpadded.length % groupSize ≠ 0 then
      unpadded ++ (String.mk <| List.replicate (groupSize - unpadded.length % groupSize) padChar)
    else
      unpadded
  | _, _ => unpadded

/--
Decode the encoded `String` back to `ByteArray` with custom `Config`.
-/
def decodeConfig (config : Config) (data : String) : Option ByteArray :=
  let unpadded := match config.alphabet.padChar with
  | some padChar => data.replace ⟨[padChar]⟩ "" 
  | _ => data
  let currentTets := match config.alphabet.length with
    | 16 => 4
    | 32 => 5
    | 64 => 6
    | _ => unreachable! -- TODO: how to prove this?
  config.alphabet.backward unpadded true |>.map λ x => transformTets currentTets 8 true x

end BaseN