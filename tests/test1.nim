import unittest
from ansiutils/codes import nil
import strutils
from ansiutils/cp437 import nil

const content = staticRead("luke-and-yoda.ans")
cp437.write(stdout, cp437.toUtf8(content))

test "Dedupe codes":
  const text = "\e[31m\e[32m\e[41;42;43mHello, world!\e[31m"
  let newText = codes.dedupeCodes(text)
  check newText.escape == "\e[32;43mHello, world!\e[31m".escape

  const text2 = "\e[0;1;22;36;1;22;1;22;1;22;1;46m"
  let newText2 = codes.dedupeCodes(text2)
  check newText2.escape == "\e[0;36;22;1;46m".escape

test "Dedupe RGB codes correctly":
  const text = "\e[38;2;255;255;255m"
  let newText = codes.dedupeCodes(text)
  check newText.escape == text.escape

  const text2 = "\e[0;38;2;4;6;8;48;2;114;129;163;38;2;114;129;163m"
  let newText2 = codes.dedupeCodes(text2)
  check newText2.escape == "\e[0;48;2;114;129;163;38;2;114;129;163m".escape

test "remove pointless clears":
  const
    before = "\e[0mH\e[0me\e[0ml\e[0ml\e[0mo!\e[30mWassup\e[0mG\e[0mr\e[0me\e[0metings"
    after = "\e[0mHello!\e[30mWassup\e[0mGreetings"
  check codes.dedupeCodes(before).escape == after.escape
