---
paths:
  - "**/Assets/**"
---

# Asset and GUID Integrity

- Every asset and folder keeps its matching `.meta` file; never copy an asset without its `.meta`.
- Preserve GUIDs of existing scenes, prefabs, scripts, materials, imported assets.
- Before a move/rename, search serialized references (scenes, prefabs, ScriptableObjects, UnityEvents) and verify in Unity afterwards.
- Move/rename only through Unity (`AssetDatabase.MoveAsset` / Project window) so GUIDs and Build Settings entries follow; never move files on disk alone.
- Avoid hand-editing Unity YAML unless the format and all affected references are understood.
- Do not rename classes, public serialized fields, package IDs or asset paths of existing content without checking scene/prefab impact and build impact (use `FormerlySerializedAs` or a migration plan).
- Vendor packages that hard-code `Assets/<Vendor>/` paths stay where they are; project-owned assets follow the project's own folder convention (`<stt>_claude.md`).
- New scripts get new GUIDs; do not fake an original type to inherit old serialized data.
