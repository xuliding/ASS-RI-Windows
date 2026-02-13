# ASS-RI Windows AI Inference Service

ASS-RI（AI Service Router & Inference）是一个Windows平台的AI推理服务，采用**控制平面与数据平面分离**的架构设计，支持多种推理引擎的统一管理和智能路由。

## 系统架构

### 控制平面 (Control Plane)
控制平面负责**服务治理、资源调度、配置管理**，是ASS-RI的核心管理层。

```
┌─────────────────────────────────────────────────────────────┐
│                      控制平面 (Control Plane)                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                   API Gateway Layer                  │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐    │   │
│  │  │ REST API    │ │ gRPC API    │ │ Swagger Docs │    │   │
│  │  │ (Port 5000) │ │ (Port 5001) │ │ (/swagger)   │    │   │
│  │  └─────────────┘ └─────────────┘ └──────────────┘    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                 Engine Management Layer              │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐    │   │
│  │  │ Engine      │ │ Heartbeat   │ │ Health Check │    │   │
│  │  │ Registry    │ │ Monitor     │ │ Service      │    │   │
│  │  └─────────────┘ └─────────────┘ └──────────────┘    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                 Service Discovery Layer              │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐    │   │
│  │  │ Format      │ │ Capability  │ │ Load Balancer│    │   │
│  │  │ Router      │ │ Matcher     │ │ (多种策略)   │    │   │
│  │  └─────────────┘ └─────────────┘ └──────────────┘    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 数据平面 (Data Plane)
数据平面负责**模型推理、计算执行、结果返回**，是实际的计算层。

```
┌─────────────────────────────────────────────────────────────┐
│                      数据平面 (Data Plane)                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                   Inference Engine Layer              │   │
│  │                                                       │   │
│  │   ┌─────────────────┐    ┌─────────────────┐         │   │
│  │   │ PyTorch Engine  │    │  ONNX Engine    │         │   │
│  │   │ (Port 6000)     │    │  (Port 6001)    │         │   │
│  │   │                 │    │                 │         │   │
│  │   │ • Safetensors   │    │ • ONNX Runtime  │         │   │
│  │   │ • PyTorch       │    │ • DirectML      │         │   │
│  │   │ • CUDA          │    │ • CPU/GPU       │         │   │
│  │   └─────────────────┘    └─────────────────┘         │   │
│  │                                                       │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │                   Model Management Layer              │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐    │   │
│  │  │ Model       │ │ Model       │ │ Model        │    │   │
│  │  │ Loader      │ │ Cache       │ │ Unloader     │    │   │
│  │  └─────────────┘ └─────────────┘ └──────────────┘    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 核心特性

### 🚀 多引擎支持
- **PyTorch Engine** - 支持Safetensors、PyTorch格式，CUDA加速
- **ONNX Engine** - 支持ONNX格式，DirectML加速，支持CPU/GPU
- **引擎自动发现** - 自动检测和注册可用引擎
- **智能路由** - 根据模型格式和能力自动选择最佳引擎

### 🔧 控制平面特性
- **Windows服务** - 可安装为Windows服务，开机自启动
- **健康监控** - 内置引擎心跳检测和健康检查机制
- **动态配置** - 支持配置文件热重载，无需重启服务
- **告警通知** - 支持邮件告警和系统日志告警
- **Prometheus指标** - 内置指标收集，兼容Prometheus监控

### � 服务治理
- **API认证** - 支持API Key认证
- **速率限制** - 基于令牌桶算法的请求限流
- **负载均衡** - 支持随机、轮询、最少负载、最佳性能等多种策略
- **故障转移** - 自动检测并隔离故障引擎

### 🎯 集成接口
- **标准化REST API** - 控制平面与数据平面通信标准
- **引擎注册** - POST /v1/engines/register
- **心跳检测** - POST /v1/engines/{id}/heartbeat
- **健康检查** - GET /v1/health
- **推理请求** - POST /v1/completions, /v1/chat/completions, /v1/embeddings

## 系统要求

### 控制平面要求
- **操作系统**: Windows 10/11 或 Windows Server 2019/2022
- **运行时**: .NET 9.0 Runtime
- **内存**: 至少 2GB RAM
- **端口**: 5000（REST API），5001（gRPC API）

### 数据平面要求
- **操作系统**: Windows 10/11 或 Windows Server 2019/2022
- **运行时**: Python 3.9+（PyTorch引擎），.NET 9.0（ONNX引擎）
- **内存**: 根据模型大小，建议至少 8GB RAM
- **端口**: 6000（PyTorch引擎），6001（ONNX引擎）
- **GPU**: 可选，支持CUDA或DirectML加速

## 快速开始

### 方式一：便携模式运行（推荐测试）

1. **下载发布包**
   - 从 [GitHub Releases](https://github.com/xuliding/ASS-RI-Windows/releases) 下载 `ASS-RI-v1.0.0-win-x64.zip`

2. **解压到任意目录**
   ```bash
   unzip ASS-RI-v1.0.0-win-x64.zip -d C:\ASS-RI
   ```

3. **运行控制平面**
   ```bash
   cd C:\ASS-RI
   ASS-RI.exe console
   ```

4. **启动数据平面引擎**
   - 启动 PyTorch 引擎（端口6000）
   - 启动 ONNX 引擎（端口6001）

5. **访问管理界面**
   - 打开浏览器访问 http://localhost:5000/swagger

### 方式二：Windows服务（推荐生产环境）

1. **下载并解压**
   - 解压到目标目录，如 `C:\Program Files\ASS-RI\`

2. **安装服务**
   - **右键**点击 `scripts/install-service.bat` → 选择**"以管理员身份运行"**
   - 按提示完成安装

3. **启动数据平面引擎**
   - 确保各推理引擎服务已启动并注册到控制平面

4. **验证服务**
   - 访问 http://localhost:5000/v1/health
   - 检查引擎状态：http://localhost:5000/v1/engines

## 核心组件

### 控制平面组件

| 组件 | 职责 | 实现文件 |
|------|------|----------|
| **EngineManager** | 引擎注册、心跳管理、健康检查 | `EngineManager.cs` |
| **EngineService** | 后台心跳检测服务 | `EngineService.cs` |
| **ConfigManager** | 配置加载、路径管理 | `ConfigManager.cs` |
| **SystemInfoService** | 系统资源监控 | `SystemInfoService.cs` |
| **RoutingController** | 引擎路由推荐 | `RoutingController.cs` |

### 数据平面组件

| 组件 | 职责 | 实现文件 |
|------|------|----------|
| **ModelManager** | 模型加载、格式检测、缓存管理 | `inference.py` |
| **Inference API** | 提供REST推理接口 | `inference.py` |
| **Model Registry** | 维护已加载模型列表 | `inference.py` |

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

### 数据平面配置
各引擎服务有独立的配置文件，具体参考各引擎的文档。

## API接口

### 控制平面核心接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/v1/health` | GET | 健康检查 |
| `/v1/engines` | GET | 获取引擎列表 |
| `/v1/engines/register` | POST | 注册新引擎 |
| `/v1/route/stats` | GET | 路由统计 |
| `/v1/alerts/stats` | GET | 告警统计 |
| `/metrics` | GET | Prometheus指标 |

### 推理接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/v1/completions` | POST | 文本补全 |
| `/v1/chat/completions` | POST | 聊天补全 |
| `/v1/embeddings` | POST | 文本嵌入 |

## 引擎注册示例

```bash
# 注册PyTorch引擎
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

# 获取引擎详情
curl http://localhost:5000/v1/engines/{id}

# 触发引擎健康检查
curl http://localhost:5000/v1/engines/{id}/health
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

### Q: 如何添加新的引擎类型？

A: 按照以下步骤：
1. 实现符合API规范的推理服务
2. 在控制平面中注册引擎
3. 配置引擎能力和支持的模型格式

## 版本历史

### v1.0.0 (2026-02-13)
- ✅ 初始版本发布
- ✅ 控制平面与数据平面分离架构
- ✅ PyTorch引擎支持
- ✅ ONNX引擎支持
- ✅ 引擎自动注册与心跳检测
- ✅ 健康检查和告警机制
- ✅ 动态配置重载
- ✅ Prometheus指标导出
- ✅ API认证和速率限制
- ✅ 多种负载均衡策略

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 支持与反馈

如有问题或建议，欢迎提交 Issue。

---

**项目地址**: [https://github.com/xuliding/ASS-RI-Windows](https://github.com/xuliding/ASS-RI-Windows)
**文档地址**: [https://github.com/xuliding/ASS-RI-Windows/blob/main/README.md](https://github.com/xuliding/ASS-RI-Windows/blob/main/README.md)
