---
title: Projects - Scheme to Interface project
description: This tool allows you to convert Komodo 9 color scheme to Komodo 10.
project:
    id: komodo-scheme-to-interface
    repo: komodo-scheme-to-interface
    name: Scheme to Interface project
    lang: Ruby
---

Scheme To Interface
===

This tool allows you to convert Komodo 9 color scheme to Komodo 10.
The difference between them is `InterfaceStyles` block, which you
can configure to change style of different Komodo UI elements.

This tool takes some colors from the scheme you want, convert them
to base16-like colors (lighten/darken background/foreground) and
generate a new ksf file.

## Installation

```bash
git clone https://github.com/Defman21/komodo-scheme-to-interface
```

## Requirements

* Ruby 1.9.3 or above
* Python **2.7**

## Usage

```bash
./main.rb
```

## Note

Font size should be like `10pt`, `1rem` or `1em`.

