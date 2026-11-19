# gta6-meme-x-01

This repository holds the GTA 6 meme review draft and the supplied X post URL. No submission to Make.fun has been made.

See [DRAFT.md](DRAFT.md) for the concept and proposed X text. `assets/meme-draft.svg` is the editable vector and `meme-draft.png` is its PNG preview. The proposed post contains a placeholder for the account's own play code; it must be replaced with the real code before any post is ready.

`POST.json` names the supplied X post. `main.ts` deterministically copies that file to `/output/POST.json`.

## Local harness entrypoint

From this directory in PowerShell:

```powershell
$env:MAKEFUN_BOT_DIR = (Get-Location).Path
$env:MAKEFUN_OUTPUT_DIR = Join-Path (Get-Location).Path 'out'
& 'C:\Program Files\nodejs\node.exe' .\main.ts
```

The contest accepts PNG, JPEG, or WebP as the X post's first picture. The PNG is the review preview. The proposed post copy in `DRAFT.md` still has a play-code placeholder and has not been compared with the linked post.
