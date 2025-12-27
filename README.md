# doc-kit（AI 辅助中文专业文档写作）

面向中文技术/产品/战略文档的提示词与模板集合，可直接复制使用，也可后续用 skill-creator 封装为 Codex 技能。

## 目录
- `SKILL.md`：技能描述（供 skill-creator/installer 使用）
- `prompts/`：可直接粘贴的提示词
- `reference/`：大纲、段落、风格、QA 检查清单，含三类文档的专用模板
- `examples/`：示例稿（技术方案、产品设计、战略规划）

## 推荐工作流
1) 澄清：用 `prompts/doc.clarify` 获取读者/目标/交付形态  
2) 大纲：用 `prompts/doc.outline`，先确认大纲  
3) 分段撰写：按大纲逐节用 `prompts/doc.section` 输出「结论-证据-风险-行动」  
4) 压缩润色：用 `prompts/doc.compress` 控制长度和语气  
5) QA/事实核查：用 `prompts/doc.qacheck` 和 `prompts/doc.facts` 进行缺口与来源检查  
6) 按文档类型套模板：参考 `reference/*-template.md`  

## 涵盖文档类型
- 技术方案：约束、选项对比、决策准则、风险与里程碑
- 产品设计：场景/用户旅程、需求优先级、交互/信息架构、验证计划
- 战略规划：目标与北极星指标、外部态势、路径与里程碑、资源与风险

## 后续封装为技能
检查并微调内容后，可用 `skill-creator` 生成标准技能结构，便于 `codex skill install`。当前版本已按技能目录布局，后续只需补充 metadata/manifest。***
