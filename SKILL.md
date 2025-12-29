---
name: doc-kit
description: 中文技术方案/产品设计/战略规划文档的提示词与模板，支持澄清-大纲-分段-压缩-QA 全流程。
license: Apache-2.0
metadata:
  short-description: 中文专业文档写作提示与模板
---

# doc-kit（本地）

一组可复制使用的提示词与模板，覆盖中文「技术方案 / 产品设计 / 战略规划」文档的写作、压缩、QA 与事实核查。后续可用 skill-creator 打包为正式技能。

## 在 Codex 里怎么用
在 Codex 对话中输入 `$doc-kit` 触发本 skill；再指定要用的模板（也可以直接复制 `prompts/` 下的提示词内容使用）：
- `$doc-kit --help`
- `$doc-kit doc.help`
- `$doc-kit doc.constitution`
- `$doc-kit doc.clarify` / `doc.outline` / `doc.section` / `doc.compress` / `doc.style` / `doc.facts` / `doc.qacheck` / `doc.render.ceo`

## 自动落盘
执行过程中会把中间产物写到当前工作目录的 `./doc-kit/` 下，并在进入下一步前从磁盘重新读取前序文件以吸收人工修改。

## Prompts（位于 `prompts/`）
- `doc.help`：查看使用说明/目录
- `doc.constitution`：全流程约束（先于澄清/大纲/分段）
- `doc.clarify`：澄清读者/目标/交付形态
- `doc.outline`：生成含关键问题的大纲
- `doc.section`：按「结论-证据-风险-行动」撰写段落
- `doc.compress`：在保信息前提下压缩与统一语气
- `doc.style`：风格一致性与术语统一
- `doc.facts`：列出需引用/来源的语句并标注缺口
- `doc.qacheck`：结构/覆盖面 QA 检查
- `doc.render.ceo`：将执行版重排为 CEO 汇报稿（正文精简、细节下沉附录）

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
4) 若要安装为 skill，可直接复制到 `~/.codex/skills/doc-kit`（见 `README.md` 的部署说明）。
