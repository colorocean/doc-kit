# doc-kit（AI 辅助中文专业文档写作）

面向中文技术/产品/战略文档的提示词与模板集合，可直接复制使用，也可后续用 skill-creator 封装为 Codex 技能。

## 在 Codex 里怎么用（重要）
`prompts/doc.*` 是仓库里的「提示词文件路径」，不是 Codex 的可执行指令。

在 Codex 对话里建议用 skill 入口 `$doc-kit` 来调用这些模板：
- 查看帮助：`$doc-kit --help`
- 使用某个模板（两种写法都可以）：
  - `$doc-kit doc.clarify` / `$doc-kit doc.outline` / `$doc-kit doc.section` …
  - 或直接说「请按 `doc.clarify` 模板先澄清需求：...」
- 也可以显式调用帮助模板：`$doc-kit doc.help`
- 进入写作前先约束全流程：`$doc-kit doc.constitution`
- 兜底方式：直接打开 `prompts/doc.clarify` 等文件，把内容复制到对话里再补充你的背景信息。

## 自动落盘（中间文档会写到当前工作目录）
从本版本开始，doc-kit 以“磁盘文件”为事实来源，避免只依赖对话上下文（因为你可能会手工改文件）。

- 中间产物目录：`./doc-kit/`
- 常见文件：`constitution.md`、`clarify.md`、`outline.md`、`draft.md`、`compress.md`、`style.md`、`facts.md`、`qacheck.md`、`sections/*.md`
- 面向用户交互的最终/最新文档：生成在当前工作目录下（例如 `./tech-proposal.md`），并会在 `doc.section/doc.compress/doc.style` 等步骤中自动更新

## 目录
- `SKILL.md`：技能描述（供 skill-creator/installer 使用）
- `prompts/`：可直接粘贴的提示词
- `reference/`：大纲、段落、风格、QA 检查清单，含三类文档的专用模板
- `examples/`：示例稿（技术方案、产品设计、战略规划）
- `scripts/`：本机部署/卸载脚本

## 推荐工作流
0) 全流程约束：用 `doc.constitution`（`prompts/doc.constitution`）先确定“写作宪章/过程规则”  
1) 澄清：用 `doc.clarify`（对应文件：`prompts/doc.clarify`）获取读者/目标/交付形态  
2) 大纲：用 `doc.outline`（`prompts/doc.outline`），先确认大纲  
3) 分段撰写：按大纲逐节用 `doc.section`（`prompts/doc.section`）输出「结论-证据-风险-行动」  
4) 压缩润色：用 `doc.compress`（`prompts/doc.compress`）控制长度和语气  
5) 风格与术语：用 `doc.style`（`prompts/doc.style`）统一语气与术语表  
6) QA/事实核查：用 `doc.qacheck`（`prompts/doc.qacheck`）和 `doc.facts`（`prompts/doc.facts`）进行缺口与来源检查  
7) （可选）渲染成 CEO 汇报稿：用 `doc.render.ceo`（`prompts/doc.render.ceo`）把“执行版/机制版”重排为可读汇报稿（正文精简、细节下沉附录）  
8) 按文档类型套模板：参考 `reference/*-template.md`  

## 使用示例：写一份「实时日志聚合与告警」技术方案
场景：你是 SRE/平台团队，需要在 2 个月内为核心服务落地统一日志聚合与实时告警；已知约束为「日均 2TB、峰值 5x、仅内部云、预算 < ¥30k/月」。

在 Codex 对话中按下面顺序操作（推荐用 `$doc-kit` 入口；或手动复制 `prompts/` 下的提示词文件内容）：

0) 约束全流程（`doc.constitution` / 文件：`prompts/doc.constitution`）
```text
主题：实时日志聚合与告警（统一平台能力建设）
目标读者与决策：CTO + 研发负责人；两周内要决定采用哪套日志聚合方案并批准资源。
交付形态与长度：技术方案，目标 6-8 页，语气简洁、偏决策导向。
硬性约束：2 个月交付；内部云；日均 2TB 峰值 5x；预算 < ¥30k/月；必须包含回滚策略与里程碑。
已有事实/数据口径：如无请标注待确认；不得编造数字与引用。
```

1) 澄清需求（`doc.clarify` / 文件：`prompts/doc.clarify`）
```text
目标读者与决策：CTO + 研发负责人；需要在两周内决定采用哪套日志聚合方案并批准资源。
交付形态与长度：技术方案，目标 6-8 页，语气简洁、偏决策导向。
硬性约束：2 个月交付；内部云；日均 2TB 峰值 5x；预算 < ¥30k/月；必须包含回滚策略与里程碑。
```

2) 生成并确认大纲（`doc.outline` / 文件：`prompts/doc.outline`）
- 把上一步澄清结果作为输入，让模型输出 6-10 个一级标题的大纲，并根据回复调整标题与关键问题。
- 需要的话直接套用 `reference/tech-proposal-template.md` 的结构。

3) 分节撰写（`doc.section` / 文件：`prompts/doc.section`）
- 对每个一级标题重复一次，让输出稳定落在「结论-证据-风险-行动」四段。
- 示例（写“方案选项与对比”一节时，可附上你希望对比的选项清单）：
```text
本节标题：方案选项与对比
请至少对比：Loki/ELK/云托管日志服务（如可用）
必须覆盖：成本、运维复杂度、查询能力、告警延迟、数据保留与合规
```

4) 压缩成决策稿（`doc.compress` / 文件：`prompts/doc.compress`）
- 把全文（或摘要+关键章节）交给 `doc.compress`，例如把 `X` 设为 60%，得到更短的决策版。

5) 做事实与 QA（`doc.facts` + `doc.qacheck` / 文件：`prompts/doc.facts` + `prompts/doc.qacheck`）
- 用 `doc.facts` 自动标注哪些数字/主张需要来源或验证（会插入 `[citation needed]` / `[source:?]`）。
- 用 `doc.qacheck` 检查是否缺少：风险缓解、依赖与前提、里程碑与 Owner、成功指标口径等。

## 涵盖文档类型
- 技术方案：约束、选项对比、决策准则、风险与里程碑
- 产品设计：场景/用户旅程、需求优先级、交互/信息架构、验证计划
- 战略规划：目标与北极星指标、外部态势、路径与里程碑、资源与风险

## 后续封装为技能
本仓库已是标准 Codex skill 目录结构（根目录包含 `SKILL.md`）。可直接安装到本机 `~/.codex/skills` 使用；也可在此基础上继续扩展脚本/参考资料等。

## 部署（安装到本机 Codex）
要求：本机已安装 `codex`，并使用默认 `CODEX_HOME=~/.codex`（如有自定义也支持）。

1) 安装/更新（复制安装，默认覆盖旧版本）：
- `bash scripts/deploy.sh --force`

2) 开发模式（可选：用软链接，便于本仓库改动立刻生效）：
- `bash scripts/deploy.sh --link --force`

3) 卸载：
- `bash scripts/uninstall.sh`

安装完成后重启 Codex，使新 skill 生效。
