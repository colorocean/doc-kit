---
name: doc-kit
description: 中文技术方案/产品设计/战略规划文档的提示词与模板，支持澄清-大纲-分段-压缩-QA 全流程。
metadata:
  short-description: 中文专业文档写作提示与模板
---

# doc-kit（本地）

一组可复制使用的提示词与模板，覆盖中文「技术方案 / 产品设计 / 战略规划」文档的写作、压缩、QA 与事实核查。后续可用 skill-creator 打包为正式技能。

## Prompts（位于 `prompts/`）
- `doc.clarify`：澄清读者/目标/交付形态
- `doc.outline`：生成含关键问题的大纲
- `doc.section`：按「结论-证据-风险-行动」撰写段落
- `doc.compress`：在保信息前提下压缩与统一语气
- `doc.style`：风格一致性与术语统一
- `doc.facts`：列出需引用/来源的语句并标注缺口
- `doc.qacheck`：结构/覆盖面 QA 检查

## Reference（位于 `reference/`）
- 大纲/段落模板：`outline-template.md`、`section-template.md`
- 风格与语气：`style-guide.md`
- QA/事实核查：`qa-checklist.md`、`citations.md`
- 文档类型模板：`tech-proposal-template.md`、`product-design-template.md`、`strategy-plan-template.md`

## Examples（位于 `examples/`）
- `tech-proposal.md`、`product-design.md`、`strategy-plan.md`

## 使用建议
1) 先用 `doc.clarify` 收集读者与交付物约束，再用 `doc.outline` 生成大纲。  
2) 针对每节用 `doc.section` 输出「结论-证据-风险-行动」。  
3) 初稿完成后用 `doc.compress`、`doc.style`、`doc.facts`、`doc.qacheck` 依次收敛。  
4) 若要安装为技能，可用 skill-creator 生成标准目录（当前结构已对齐）。***
