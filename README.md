# ASS-RI Windows AI Engine Control Plane

ASS-RI（AI Service Router & Inference）是一个Windows平台的**AI推理引擎统一管理服务和控制平面**，为多种推理引擎提供标准化的注册、监控和路由能力。

## 核心价值

- 🎯 **统一管理** - 集中管理多个推理引擎，标准化接口
- 🔄 **智能路由** - 根据模型格式和能力自动选择最佳引擎
- 🚀 **即插即用** - 引擎自动发现和注册机制
- 🛡️ **服务治理** - 健康监控、告警通知、负载均衡
- 🔧 **Windows集成** - 原生Windows服务支持，系统资源监控

## 快速开始

### 1. 安装控制平面

**方法一：便携模式（测试）**
```bash
# 1. 下载发布包
# 从 GitHub Releases 下载 ASS-RI-v1.0.0-win-x64.zip

# 2. 解压并运行
unzip ASS-RI-v1.0.0-win-x64.zip -d C:\ASS-RI
cd C:\ASS-RI
ASS-RI.exe console

# 3. 访问管理界面
# 打开浏览器访问 http://localhost:5000/swagger
```

**方法二：Windows服务（生产环境）**
```bash
# 1. 解压到目标目录
# 2. 管理员权限运行
install-service.bat

# 3. 服务将自动启动
```

### 2. 注册推理引擎

**引擎注册示例**
```bash
curl -X POST http://localhost:5000/v1/engines/register \
  -H "Content-Type: application/json" \
  -d '{
    "Id": "pytorch-engine-1",
    "Name": "PyTorch Engine",
    "Version": "1.0.0",
    "Formats": ["safetensors", "pytorch"],
    "Endpoint": "http://localhost:6000",
    "HealthEndpoint": "http://localhost:6000/health",
    "Capabilities": {
      "MaxBatchSize": 16,
      "MaxTokens": 8192,
      "SupportsStreaming": true,
      "GpuEnabled": true,
      "MemoryRequirement": 16384
    },
    "Status": "healthy"
  }'
```

### 3. 开始使用

**推理请求示例**
```bash
# 聊天完成
curl -X POST http://localhost:5000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt2",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'

# 文本补全
curl -X POST http://localhost:5000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt2",
    "prompt": "Hello, world!"
  }'
```

## 接口规范

### 引擎管理接口

#### 1. 引擎注册
**端点**: `POST /v1/engines/register`

**请求体**:
```json
{
  "Id": "string (required)",
  "Name": "string",
  "Version": "string",
  "Formats": ["string"],
  "Endpoint": "string (required)",
  "HealthEndpoint": "string",
  "Capabilities": {
    "MaxBatchSize": "integer",
    "MaxTokens": "integer",
    "SupportsStreaming": "boolean",
    "GpuEnabled": "boolean",
    "MemoryRequirement": "integer"
  },
  "Status": "string"
}
```

**响应**:
```json
{
  "success": "boolean",
  "message": "string",
  "engine_id": "string"
}
```

#### 2. 心跳检测
**端点**: `POST /v1/engines/{engineId}/heartbeat`

**响应**:
```json
{
  "success": "boolean",
  "message": "string"
}
```

#### 3. 获取引擎列表
**端点**: `GET /v1/engines`

**响应**:
```json
{
  "engines": ["array<EngineInfo>"],
  "total": "integer"
}
```

#### 4. 获取可用引擎
**端点**: `GET /v1/engines/available`

#### 5. 按格式获取引擎
**端点**: `GET /v1/engines/format/{format}`

#### 6. 获取引擎详情
**端点**: `GET /v1/engines/{engineId}`

#### 7. 移除引擎
**端点**: `DELETE /v1/engines/{engineId}`

#### 8. 健康检查
**端点**: `POST /v1/engines/check-health`

### 推理接口

#### 1. 聊天完成
**端点**: `POST /v1/chat/completions`

**请求体**:
```json
{
  "model": "string (required)",
  "messages": ["array (required)"],
  "temperature": "number",
  "max_tokens": "integer",
  "top_p": "number",
  "frequency_penalty": "number",
  "presence_penalty": "number",
  "stream": "boolean"
}
```

#### 2. 文本补全
**端点**: `POST /v1/completions`

**请求体**:
```json
{
  "model": "string (required)",
  "prompt": "string (required)",
  "max_tokens": "integer",
  "temperature": "number",
  "top_p": "number",
  "stop": "array"
}
```

### 模型管理接口

#### 1. 获取模型列表
**端点**: `GET /v1/models`

#### 2. 获取模型详情
**端点**: `GET /v1/models/{modelId}`

#### 3. 加载模型
**端点**: `POST /v1/models/{modelId}/load`

#### 4. 卸载模型
**端点**: `POST /v1/models/{modelId}/unload`

#### 5. 获取模型状态
**端点**: `GET /v1/models/{modelId}/status`

#### 6. 卸载所有模型
**端点**: `POST /v1/models/unload-all`

### 路由管理接口

#### 1. 获取路由策略
**端点**: `GET /v1/routing/policy`

#### 2. 更新路由策略
**端点**: `PUT /v1/routing/policy`

#### 3. 获取推荐引擎
**端点**: `POST /v1/routing/recommend`

**请求体**:
```json
{
  "model_id": "string (required)",
  "model_format": "string (required)",
  "task_type": "string",
  "requirements": "object",
  "context": "object"
}
```

### 配置管理接口

#### 1. 获取模型目录配置
**端点**: `GET /v1/config/models`

#### 2. 获取引擎特定配置
**端点**: `GET /v1/config/engine/{engine_type}`

### 系统信息接口

#### 1. 获取系统信息
**端点**: `GET /v1/system/info`

#### 2. 获取GPU信息
**端点**: `GET /v1/system/gpu`

#### 3. 获取CPU信息
**端点**: `GET /v1/system/cpu`

#### 4. 获取内存信息
**端点**: `GET /v1/system/memory`

#### 5. 获取磁盘信息
**端点**: `GET /v1/system/disk`

#### 6. 获取网络信息
**端点**: `GET /v1/system/network`

## 接口文档

为了方便开发者按照ASS-RI的接口模式开发自己的推理引擎，我们提供了完整的接口定义文件：

- **接口定义文件**: [内外部服务接口.JSON](内外部服务接口.JSON)

**文件包含**: 
- 所有外部API接口的详细定义
- 请求和响应格式
- 数据模型结构
- 内部服务接口（仅供参考）

## 配置说明

### 控制平面配置

服务启动后会自动创建 `config.json` 配置文件：

```json
{
  "ServicePort": 5000,
  "ModelDirectory": "F:\\modelscope",
  "LogLevel": "Information",
  "EnableSwagger": true,
  "ApiAuthentication": {
    "Enabled": false,
    "ApiKeys": []
  },
  "RateLimit": {
    "Enabled": true,
    "RequestsPerSecond": 100
  }
}
```

### 推理引擎配置

开发者在开发自己的推理引擎时，需要确保实现以下核心接口：

1. **健康检查端点**: `/health` (GET)
2. **推理接口**: 
   - `/v1/completions` (POST)
   - `/v1/chat/completions` (POST)
   - `/v1/embeddings` (POST)

## 服务管理

### Windows服务命令

```bash
# 查看服务状态
sc query ASS-RI

# 启动服务
sc start ASS-RI

# 停止服务
sc stop ASS-RI

# 删除服务（管理员权限）
sc delete ASS-RI
```

### 引擎管理命令

```bash
# 获取引擎列表
curl http://localhost:5000/v1/engines

# 获取可用引擎
curl http://localhost:5000/v1/engines/available

# 获取引擎详情
curl http://localhost:5000/v1/engines/{engineId}

# 触发健康检查
curl -X POST http://localhost:5000/v1/engines/check-health
```

## 日志与监控

### 日志目录
```
data/logs/
├── ASS-RI-YYYYMMDD.log          # 应用日志
└── ASS-RI-Errors-YYYYMMDD.log    # 错误日志
```

### Prometheus监控
- 访问 `http://localhost:5000/metrics` 获取Prometheus格式指标
- 支持的指标：系统健康状态、引擎状态、请求统计等

## 常见问题

### Q: 如何开发兼容的推理引擎？

A: 按照以下步骤：
1. 实现核心推理接口 (`/v1/completions`, `/v1/chat/completions`)
2. 实现健康检查接口 (`/health`)
3. 调用 ASS-RI 的注册接口注册引擎
4. 定期发送心跳保持活跃状态

### Q: 引擎注册失败？

A: 检查以下几点：
1. 引擎服务是否正常运行
2. 网络连接是否正常
3. 注册请求格式是否正确
4. 引擎端点是否可访问

### Q: 推理请求失败？

A: 可能原因：
1. 没有可用的健康引擎
2. 模型格式不被支持
3. 引擎能力不足（如内存不足）
4. 请求参数错误

### Q: 如何选择路由策略？

A: 支持的策略：
- `Random` - 随机选择
- `RoundRobin` - 轮询
- `LeastLoaded` - 最少负载
- `BestPerformance` - 最佳性能

## 版本历史

### v1.0.0 (2026-02-13)
- ✅ 初始版本发布
- ✅ 引擎注册与管理
- ✅ 智能路由与负载均衡
- ✅ 健康监控与告警
- ✅ Windows服务支持
- ✅ 完整的REST API接口

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 支持与反馈

如有问题或建议，欢迎提交 Issue。

---

**项目地址**: [https://github.com/xuliding/ASS-RI-Windows](https://github.com/xuliding/ASS-RI-Windows)
**接口文档**: [内外部服务接口.JSON](内外部服务接口.JSON)
