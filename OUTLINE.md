# bamsx Project Outline

## Objective
Maintain and evolve a PureBasic frontend (`bamsx`) for the `fMSX` emulator, with a modern card-based UI, persistent settings, and practical Help windows.

## Session Snapshot
- Workspace: `E:\bamsx`
- Main source: `main.pb`
- Current app version: `0.1.7`
- Current build: `0x6A0D14CB` (Unix UTC seconds in hexadecimal)

## Requested Work History (Copilot)

### 1. About cards clickable copy
Request:
- Make About cards individually clickable to copy each field value (example: click Build to copy value).

Implemented:
- Added hit-test for About cards.
- Added hover state and visual highlight.
- On click, copies card value to clipboard and confirms via dialog.

Technical notes:
- Added hover tracking global for About cards.
- Added position-to-card mapping procedure.
- Added canvas events for `MouseMove`, `MouseLeave`, `LeftButtonDown`.

---

### 2. Build fix after About changes
Issue:
- Compile error: `BlendColor() is not a function` due to call before definition.

Implemented:
- Moved/declared `BlendColor` before first usage in About card drawing path.
- Recompiled successfully.

---

### 3. Improve Setup screen + translate UI to English
Request:
- Improve Setup with card-like organization.
- Translate visible program text to English.

Implemented:
- Setup redesigned with grouped sections (card-like `FrameGadget` blocks).
- UI strings translated to English across Main, Setup, Keys, About, status/messages/dialog labels.
- Legacy normalization aliases preserved for compatibility with old saved PT-BR values.

---

### 4. Make Setup wider and more compact
Request:
- Increase width, reduce total height, put more options side-by-side.

Implemented:
- Setup resized and reorganized for denser horizontal layout.
- More controls arranged in parallel columns.
- Media/peripheral file rows split left/right to reduce vertical scrolling.

---

### 5. Create Help > CLI with cards (same model as Keys)
Request:
- New CLI help window in card format, mainly informational.
- Use supplied `fMSX` usage/options list.

Implemented:
- Added new `Help > CLI` window.
- Added card list model with categories, search, filter, hover/select, copy to clipboard.
- Added category taxonomy: `All`, `General`, `Files`, `Emulation`, `Video`, `Debug`, `Platform`.
- Added theme integration and resize handling.

---

### 6. Update README and bump version/build
Request:
- Update `README.md` with latest changes.
- Change general program version to `0.1.5` and latest build.

Implemented:
- `main.pb`: version set to `0.1.5`.
- README updated with latest features (Setup compact, About copy cards, CLI help cards, English UI).
- `CHANGELOG.md` updated for `v0.1.5`.

---

### 7. Build format requirement (Unix hex)
Request:
- Build must be Unix time seconds since epoch, converted to hexadecimal.
- Correct in program and README.

Implemented:
- Build set to `0x6A0D0A96`.
- Synchronized across:
  - `main.pb` (`#App_Build`)
  - `README.md`
  - `CHANGELOG.md`

---

### 8. Update README/OUTLINE and bump release to 0.1.7
Request:
- Update `README.md` with the latest process/history.
- Update `OUTLINE.md`.
- Change the general version to `0.1.7` and set the current build.

Implemented:
- `main.pb`: version updated to `0.1.7`.
- `main.pb`: build updated to `0x6A0D14CB`.
- `README.md`: header/version/build refreshed and latest release process added.
- `OUTLINE.md`: snapshot and work history updated for the new release.
- `CHANGELOG.md` updated with `v0.1.7`.

---

### 9. Implement GameDB ROM database download from romdb.vampier.net
Request:
- Add support to update/download the ROM GameDB from `https://romdb.vampier.net/`.

Implemented:
- Added `Update GameDB` flow in the app menu.
- Downloaded the SQL archive from `https://romdb.vampier.net/Archive/sql-msxromdb.zip`.
- Downloaded the JSON archive from `https://romdb.vampier.net/Archive/json-msxromsdb.zip`.
- Added progress/status UI for download, extraction, cancel, and completion.
- Imported extracted SQL into `bamsx.db` and extracted JSON data into the local data directory.

## Current State Summary
- App compiles successfully with `pbcompiler.exe .\main.pb`.
- App version/build are now synchronized at `0.1.7` / `0x6A0D14CB`.
- GameDB update now downloads ROM database packages directly from `romdb.vampier.net`.
- UI language is predominantly English.
- Card system now exists in three areas:
  - About (copy value on click)
  - Keys (filter/search/select/copy)
  - CLI Help (filter/search/select/copy)
- Setup is wider and compact with more side-by-side controls.

## Important Files
- `main.pb`: all core logic, UI, events, theming, persistence.
- `README.md`: project overview, requirements, changelog summary.
- `CHANGELOG.md`: release notes log.

## Suggested Next Steps
1. Polish CLI cards text wrapping/truncation behavior for long descriptions.
2. Standardize all remaining comments in source to English (optional cleanup).
3. Add small UX improvements:
   - double-click card to copy
   - toast-style non-blocking copy feedback
4. Consider extracting card rendering logic into shared reusable procedures.
5. Add an export/import settings feature for portability.

## Quick Resume Checklist (Another Computer)
1. Clone/open repository.
2. Ensure PureBasic 6.40 is installed.
3. Ensure SQLite runtime support is available and `sqlite3.exe` is in project path.
4. Compile `main.pb`.
5. Verify from UI:
   - `Help > About` card copy
   - `Help > Keys` card search/filter/copy
   - `Help > CLI` card search/filter/copy
   - `Tools > Setup` compact wide layout

## Known Issues / Pending Bugs
1. CLI cards can truncate long descriptions; no wrapped multiline rendering yet.
2. Copy feedback still uses blocking `MessageRequester`; this interrupts fast multi-copy workflows.
3. Keys/CLI card rendering logic is duplicated and should be refactored into shared procedures.
4. Some source comments remain in Portuguese while UI is now English.
5. Setup compact layout is optimized for wide screens; behavior on small window widths needs a tighter responsive fallback.
6. Build value is currently manually updated; no automated pre-build step to refresh Unix-hex build.
7. No explicit tests for settings persistence regressions after large UI changes.

## Notes
- This file captures planning/requests and implementation outcomes from this Copilot-assisted development sequence.
- Keep app version/build synchronized between `main.pb`, `README.md`, and `CHANGELOG.md` on each release.
