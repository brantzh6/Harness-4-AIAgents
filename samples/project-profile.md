# Project Profile — Template

> 基于 AgentSDLC instantiation/PROJECT_PROFILE.md 模板。
> 使用时请将所有 TBD 和默认值替换为项目实际值。

---

## 1. 项目基本信息

- **项目名称**: TBD
- **项目描述**: TBD
- **仓库**: TBD

---

## 2. 默认分类

| 维度 | 默认值 | 说明 |
|------|--------|------|
| Project Level | L2 | 持久个人项目 |
| Project Type | B | App/API/网站（根据实际调整） |
| Default Risk | R2 | 中风险 |
| Default Class | B | 运行时行为变更 |
| Default Template | T2 | 标准治理 |
| Default Gate Profile | G-Std | 标准 Gate |
| Project Phase | P2 | 成长阶段（P1 新建 / P2 成长 / P3 成熟迭代 / P4 遗留接管） |

---

## 3. 环境矩阵

| 环境 | 用途 | 路径/地址 |
|------|------|-----------|
| dev | 本地开发 | TBD |
| staging | 预发布 | TBD |
| production | 生产 | TBD |

---

## 4. 验证命令

```yaml
# 编译/构建
build: TBD

# 单元测试
test_unit: TBD

# 集成测试
test_integration: TBD

# Lint/格式检查
lint: TBD

# Smoke 测试
smoke: TBD
```

---

## 5. 回滚策略

- **代码回滚**: Git revert / reset 到上一个已知良好的 commit
- **数据回滚**: TBD
- **配置回滚**: Git 管理的配置文件直接 revert

---

## 6. Claude Worker 配置

```yaml
worker_path: worker.py
default_provider: qwen-bailian-coding
default_model: qwen3.6-plus
fallback_provider: z-ai
fallback_model: glm-5
default_effort: high
default_permission_mode: bypassPermissions
max_concurrent_workers: 1
```

---

## 7. 自动 R3 升级触发（项目特定）

除全局 SDLC 规定的 R3 触发条件外，本项目以下操作也自动升级到 R3：

- （待根据项目实际补充）

---

## 8. 项目约定

- **主分支**: main
- **提交规范**: Conventional Commits
- **PR 策略**: 所有变更通过 PR 合入
- **Review 要求**: T2+ 任务必须有 review 记录

---

## 9. 测试配置

```yaml
# 项目阶段（影响测试策略选择，详见 testing-standards.md）
project_phase: P2           # P1(新建) / P2(成长) / P3(成熟迭代) / P4(遗留接管)

# 覆盖率目标
coverage_target_new_code: 80%    # 新增代码覆盖率
coverage_target_overall: TBD     # 总体覆盖率（P3 项目建议设置）

# 测试基础设施
test_framework: TBD              # 如 pytest, jest, vitest 等
test_dir: TBD                    # 如 tests/, __tests__/
ci_pipeline: TBD                 # 如 GitHub Actions, GitLab CI
```
