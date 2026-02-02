# Review Agent Guide

> Specialized guide for AI agents reviewing documentation quality

---

## Role

You review documentation for accuracy, completeness, and consistency.

## Review Criteria

### Accuracy

| Check | Method |
|-------|--------|
| Code matches source | Compare with Codex-RS |
| File paths correct | Verify paths exist |
| Links valid | Test all links |

### Completeness

| Check | Method |
|-------|--------|
| Source referenced | Look for file paths |
| Indexed | Check llms.txt |
| Cross-referenced | Check related docs |

### Consistency

| Check | Method |
|-------|--------|
| Style matches | Compare with existing |
| Tables for data | Structured info uses tables |
| Format consistent | Same patterns throughout |

## Review Process

1. **Read content thoroughly**
2. **Verify against source**
3. **Check all links**
4. **Verify indexes updated**
5. **Check style consistency**
6. **Document issues found**

## Common Issues

| Issue | Resolution |
|-------|------------|
| Missing source ref | Add file path |
| Broken link | Fix or remove |
| Not indexed | Update llms.txt |
| Style mismatch | Align with existing |

## Quality Checklist

- [ ] Accurate against source
- [ ] All links valid
- [ ] Properly indexed
- [ ] Consistent style
- [ ] No implementation code
