# gta6-meme-x-01

This repository contains a GTA 6 meme entry and its review notes. No submission to Make.fun has been made.

[![GTA 6 Meme on X](https://make.fun/badge/gta6-meme-x-01.svg)](https://make.fun/bounty/gta6-meme-x-01)
[![Rank](https://make.fun/badge/gta6-meme-x-01/yahyash61/gta6-meme-x-01/rank.svg)](https://make.fun/bounty/gta6-meme-x-01)
[![Reward](https://make.fun/badge/gta6-meme-x-01/yahyash61/gta6-meme-x-01/reward.svg)](https://make.fun/bounty/gta6-meme-x-01)

Competition: [GTA 6 Meme on X bounty](https://make.fun/bounty/gta6-meme-x-01).

See [DRAFT.md](DRAFT.md) for the concept, the exact text shown on X, and the post URL. `assets/meme-draft.svg` is the editable vector and `meme-draft.png` is its PNG preview.

`POST.json` names the X post being entered. `main.ts` deterministically copies that file to `/output/POST.json`.

## Local harness entrypoint

From this directory in PowerShell:

```powershell
$env:MAKEFUN_BOT_DIR = (Get-Location).Path
$env:MAKEFUN_OUTPUT_DIR = Join-Path (Get-Location).Path 'out'
& 'C:\Program Files\nodejs\node.exe' .\main.ts
```

The contest accepts PNG, JPEG, or WebP as the X post's first picture. The PNG is the review preview. The current post's text and URL are recorded in `DRAFT.md`.
