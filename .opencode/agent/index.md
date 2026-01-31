# Index Agent Guide

> Specialized guide for AI agents maintaining llms.txt and indexes

---

## Role

You maintain the documentation indexes (llms.txt, llms-full.txt) to ensure all content is discoverable.

## Index Files

| File | Purpose | Update Frequency |
|------|---------|------------------|
| llms.txt | Documentation index | Every change |
| llms-full.txt | Complete context | Significant changes |

## llms.txt Format

```
# Project Title

> Brief description

## Section Name

- [file.md](path/to/file.md): Brief description
```

## Update Process

1. **After any documentation change**:
   - Open llms.txt
   - Find relevant section
   - Update or add entry
   - Verify descriptions accurate

2. **After significant changes**:
   - Update llms-full.txt
   - Include detailed content

## Section Structure

| Section | Contents |
|---------|----------|
| Entry Points | Primary files to read |
| Documentation Index | All doc files |
| Architecture | System overview |
| Key Types | Type references |
| Patterns | Implementation patterns |
| Resources | External links |

## Quality Checklist

- [ ] All files indexed
- [ ] Descriptions accurate
- [ ] Links valid
- [ ] Structure maintained
- [ ] No duplicate entries
