---
name: mono-behaviour
purpose: Baseline structure for a new scene-bound Unity component (Inspector refs, cached components, symmetric event lifecycle).
when_to_use: Any new gameplay or UI MonoBehaviour that does not match a more specific template.
rules_ref: [prototype-code, asset-integrity]
tags: [unity, lifecycle, serialized-field, mono]
---

## Skeleton
```csharp
using UnityEngine;

public sealed class __NAME__ : MonoBehaviour
{
    [SerializeField] private __TYPE__ _reference;

    private void Awake()     { /* cache component refs; null-guard required scene refs */ }
    private void OnEnable()  { /* subscribe to events owned by this component */ }
    private void OnDisable() { /* unsubscribe, stop routines, kill tweens */ }
}
```

## Key Patterns
- New Inspector fields: `[SerializeField] private`; never rename existing serialized fields without a migration plan.
- Frame-loop work allocation-free; cache in `Awake`.
- Guard required references and log an actionable error.
