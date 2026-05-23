# Changelog

All notable changes to this project will be documented in this file.

---

## [2.0.0] - 2026-05-23

### Security
- **BREAKING**: Removed `bypassPermissions` from settings.json default. Now uses `askEveryTime` with read-only allowlist.

### Added
- **Presets**: 3 ready-to-use configurations (minimal / standard / power) in `presets/`
- **Test suite**: 10 validation prompts + automated script in `tests/`
- **Scenarios**: Code style and doc generation rules as optional add-ons in `custom_prompts/scenarios/`
- **Clean templates**: MEMORY.md, DEPENDENCY_MAP.md, KNOWLEDGE_INDEX.md usable by any project
- **Version management**: VERSION file, CHANGELOG.md, update script

### Changed
- **global-CLAUDE.md**: Slimmed down. Removed DeepSeek-specific section and scenario rules (moved to separate files). Added Security and Error Recovery sections.
- **SELF_CHECK.md**: Slimmed down from ~150 lines to ~70 lines. Removed verbose example (moved to examples/). Removed performative "执行承诺" section.
- **Hooks**: All 5 hooks parameterized with env vars (`CLAUDE_STATE_FILE`, `CLAUDE_CONNECTORS_DIR`, `CLAUDE_REVIEW_PATTERNS`). No more hardcoded project paths.
- **settings-README.md**: Updated to reflect new permissions model and configurable hooks.

### Moved
- Personal project content (MEMORY.md, DEPENDENCY_MAP.md, KNOWLEDGE_INDEX.md, AAR-stress-test.md) moved to `examples/personal/`
- Verbose check example moved to `examples/checklist-example.md`

---

## [1.0.0] - 2026-05-21

### Added
- Initial release
- Custom prompts: global-CLAUDE.md, project-CLAUDE.md, SELF_CHECK.md, AGENT_TEAM.md, SKILLS_SOP.md, FINETUNING_DATA.md
- Config: settings.json with hooks, agents, rules, skills
- Examples: training dialogues, AAR template, memory template
- Docs: Quick start guide, glossary
