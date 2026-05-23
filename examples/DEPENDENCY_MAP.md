# DEPENDENCY_MAP.md — 组件依赖图

> 改动前必查。防止改 A 坏 B。

---

## 使用方法

1. 改动任何组件前，先查此文件找到下游依赖
2. 改动完成后，更新依赖方的相关代码
3. 新增组件时，在此文件添加条目

---

## 模板

```
组件名
├── 文件路径
├── 下游依赖 (谁依赖我)
│   ├── 依赖方A — 影响范围描述
│   └── 依赖方B — 影响范围描述
├── 上游依赖 (我依赖谁)
│   ├── 依赖X
│   └── 依赖Y
└── 环境变量
    ├── VAR_NAME — 用途
```

---

## 示例

```
auth-middleware
├── src/middleware/auth.ts
├── 下游依赖
│   ├── api-routes — 所有 /api/* 路由使用此中间件
│   └── websocket — WS 握手时验证 token
├── 上游依赖
│   ├── jsonwebtoken
│   └── redis (token 黑名单)
└── 环境变量
    ├── JWT_SECRET — 签名密钥
    └── TOKEN_EXPIRY — 过期时间 (默认 24h)
```

---

## 变更影响矩阵

| 改动组件 | 直接影响 | 需要测试 |
|---------|---------|---------|
| auth-middleware | api-routes, websocket | 登录流程、token 刷新、WS 连接 |
| db-connector | 所有数据操作 | CRUD 操作、事务、迁移 |

<!-- 根据你的项目填写上表 -->
