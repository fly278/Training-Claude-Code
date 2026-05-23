# 代码风格场景规则

> 仅在需要严格代码风格约束时追加到 CLAUDE.md。不建议所有项目都用。

---

## Python
- Use type hints for all function signatures
- Prefer `pathlib.Path` over `os.path`
- Use `dataclass` or `pydantic` for data containers instead of raw dicts
- Always handle exceptions with specific exception types, never bare `except:`
- Use f-strings, not `.format()` or `%` formatting

## TypeScript
- Prefer `interface` over `type` for object shapes
- Use `readonly` for props that shouldn't mutate
- Always specify return types on exported functions
- Use `unknown` instead of `any` — narrow with type guards
