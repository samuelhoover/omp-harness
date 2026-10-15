---
name: py-basedpyright-standard
description: "Python you write must be clean under basedpyright typeCheckingMode=standard — annotated signatures, no implicit Optional, no possibly-unbound names; verify with uvx basedpyright"
condition: ["(?s).+"]
scope: ["tool:edit(*.py)", "tool:write(*.py)"]
---

Any `.py` file you write or edit — script, module, or test — must be clean under basedpyright at `typeCheckingMode = "standard"`: zero errors, zero warnings. Verify with `uvx basedpyright <path>` and fix what it reports before finishing; never add a bare `# type: ignore` — a rule-scoped `# pyright: ignore[reportX]` is allowed only where a stub is genuinely wrong. With no config basedpyright defaults to the stricter `recommended`, so check at exactly this level by setting `typeCheckingMode = "standard"` in the project (`[tool.basedpyright]` in pyproject.toml, `basedpyright.toml`, or `pyrightconfig.json`); add `--level warning` to surface non-error diagnostics.

What standard mode enforces (the rules that bite):
- Annotate every parameter and return type: an unannotated parameter is `Unknown`, so uses of it go unchecked (`reportMissingParameterType`/`reportUnknown*` only become errors at strict — write the annotations anyway).
- No implicit Optional (`strictParameterNoneValue`): `def f(x: str = None)` is an error — write `x: str | None = None`.
- No possibly-unbound names (`reportPossiblyUnboundVariable`): a name assigned only inside one `try`/`if` branch and used afterwards is an error; assign on every path or restructure the flow.
- Optional safety: member access, subscript, call, iteration and arithmetic on `X | None` are errors without a guard (`reportOptional*`) — narrow with an early `if x is None: return`/`raise`.
- Type mismatches are errors: argument, assignment, return, index, operator — plus inconsistent or unimplemented overloads and subclass members that break base-class compatibility (`reportIncompatibleMethodOverride`, `reportIncompatibleVariableOverride`).
- Imports must resolve (`reportMissingImports`): no missing module, no bad name.
- Prefer explicit generics — `dict[str, Any]`, `list[str]`, never bare `dict`/`list`; it is an error at strict, so write it that way now.
