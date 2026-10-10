#!/usr/bin/env python3
"""The Rust runtime functions an entry reaches, for cutting to declarations.

Walks the call graph of an .ll file from the entry through every defined
function outside the runtime crates (std, core, alloc, panic_*), and
prints, comma-separated, the defined runtime functions it reaches: the
panic entry points.  Any defined personality function is included too.
"""
import re
import sys

RUNTIME = {'std', 'core', 'alloc', 'std_detect', 'panic_unwind', 'panic_abort'}


def crate(name):
  """The crate of a v0-mangled symbol, or None."""
  m = re.match(r'_R.*?Cs[0-9A-Za-z]+_(\d+)', name)
  return name[m.end():m.end() + int(m.group(1))] if m else None


def main(path, entry):
  text = open(path).read()
  funcs = {m.group(1).strip('"'): m.group(2) for m in re.finditer(
      r'^define [^@]*@("?[^"(]+"?)\((.*?)^\}', text, re.M | re.S)}
  seen, todo, cut = set(), [entry], []
  while todo:
    f = todo.pop()
    if f in seen or f not in funcs: continue
    seen.add(f)
    if crate(f) in RUNTIME or f == 'rust_eh_personality':
      cut.append(f)
      continue
    todo += [c.strip('"') for c in re.findall(r'@("?[A-Za-z0-9_.$]+"?)', funcs[f])]
  print(','.join(sorted(cut)))


if __name__ == '__main__':
  main(*sys.argv[1:])
