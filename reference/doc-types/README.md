# 文档类型配置（doc-types）

本目录用于为不同“文档类型”提供针对性支撑。`doc.constitution / doc.clarify / doc.outline / doc.qacheck` 会读取对应的 YAML 配置文件，以决定默认的可见性、篇幅、输出文件名、必备章节与方法论要求。

## 现有类型
- `tech-proposal.yaml`：技术方案
- `product-plan.yaml`：产品方案
- `dept-plan.yaml`：部门规划（3 年分段）

## 如何新增类型（只需新增一个配置文件）
1) 复制 `template.yaml` 为 `<new-type>.yaml`
2) 修改 `doc_type` 为唯一值（建议小写 + 连字符）
3) 填写默认值与 `required_h1_sections`
4) 在 `doc.constitution` 中把 `doc_type` 设置为该值即可生效（或让用户在澄清阶段选择）

注意：若 `default_visibility=external+internal` 且存在仅内部内容，内部内容必须放在独立章节，并在标题末尾追加 `internal_section_suffix`。

