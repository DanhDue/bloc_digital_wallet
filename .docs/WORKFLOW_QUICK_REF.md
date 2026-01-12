# Proactive Workflow - Quick Reference

**Updated**: 2026-01-12  
**For**: AI Agents and Developers

---

## 🚀 The Proactive 4-Step Workflow

When user requests a feature without clear module context:

```
1. ANALYZE
   └─ Check lib/features/ proactively
   └─ Determine domain relationship
   └─ Identify best approach

2. PRESENT PLAN
   └─ Show comprehensive analysis
   └─ Present both options with recommendation
   └─ Explain benefits/drawbacks

3. ASK TO COLLECT MODULE INFORMATION AND CONFIRMATION
   └─ Request missing details
   └─ Confirm chosen approach
   └─ Wait for response

4. THEN PROCEED
   └─ Execute confirmed workflow
   └─ Use appropriate template
   └─ Implement and verify
```

---

## 📝 Response Template

```
"I'll analyze the codebase and present implementation options:

ANALYSIS:
• Found [existing module / no existing module]
• Feature [belongs to X domain / is new domain]
• Current structure: [details]

RECOMMENDATION: [Add as subfeature / Create new module]

OPTION 1 (Recommended): [Approach]
• Template: [mvi_feature / mvi_subfeature]
• Creates: [files]
• Modifies: [files, if subfeature]
• Benefits: [reasons]

OPTION 2: [Alternative]
• Template: [mvi_feature / mvi_subfeature]
• Note: [considerations]

Should I proceed with Option [X]?"
```

---

## ✅ Do This

- ✅ Analyze immediately
- ✅ Show your work
- ✅ Recommend best approach
- ✅ Explain reasoning
- ✅ Provide comprehensive options
- ✅ Ask for confirmation
- ✅ Then proceed

---

## ❌ Don't Do This

- ❌ Stop without analyzing
- ❌ Ask without providing context
- ❌ Show options without recommendation
- ❌ Implement without confirmation
- ❌ Be blocking instead of helpful

---

## 🎯 Key Principle

**Be proactive, not blocking**

Provide immediate value through analysis and recommendations,  
then ask for confirmation before proceeding.

---

**See full details**: `.docs/FINAL_WORKFLOW_SUMMARY.md`
