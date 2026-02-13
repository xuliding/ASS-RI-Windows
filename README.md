# ASS-RI Windows AI Engine Control Plane

ASS-RI（AI Service Router & Inference）是一个Windows平台的**AI推理引擎统一管理服务和控制平面**，为多种推理引擎提供标准化的注册、监控和路由能力。

## 核心价值

- 🎯 **统一管理** - 集中管理多个推理引擎，标准化接口
- 🔄 **智能路由** - 根据模型格式和能力自动选择最佳引擎
- 🚀 **即插即用** - 引擎自动发现和注册机制
- 🛡️ **服务治理** - 健康监控、告警通知、负载均衡
- 🔧 **Windows集成** - 原生Windows服务支持，系统资源监控
- 📊 **GPU监控** - 实时GPU状态监控和动态数据采集

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
      "MaxContextSize": 4096,
      "SupportsStreaming": true,
      "GPUAcceleration": true
    }
  }'
```

### 3. 配置管理

**config.json 配置示例**
```json
{
  "ServicePort": 5000,
  "ModelDirectory": "F:\\modelscope",
  "LogLevel": "Information",
  "ApiKey": null,
  "RateLimit": {
    "Enabled": true,
    "RequestsPerSecond": 10,
    "BurstSize": 20
  },
  "Alert": null,
  "Engines": {},
  "GPU": {
    "Enabled": true
  }
}
```

## 核心特性

### 控制平面
- ✅ 引擎注册和发现
- ✅ 健康监控和心跳检测
- ✅ 智能路由和负载均衡
- ✅ API 速率限制和认证
- ✅ 动态配置重载
- ✅ 告警通知机制
- ✅ Prometheus 指标导出

### 数据平面
- ✅ 标准 OpenAI 兼容 API
- ✅ 模型管理和版本控制
- ✅ 异步推理支持
- ✅ 多引擎并行处理

### GPU 监控
- ✅ 实时 GPU 状态监控
- ✅ 动态 GPU 数据采集
- ✅ 多 GPU 支持
- ✅ 性能指标跟踪

## 支持的引擎类型

- 🐍 **PyTorch Engine** - 支持 safetensors 格式
- 🚀 **ONNX Engine** - 支持 ONNX 格式
- 📦 **GGUF Engine** - 支持 GGUF 格式

## 接口文档

### 控制平面接口
- `GET /v1/engines` - 列出所有可用引擎
- `POST /v1/engines/register` - 注册新引擎
- `DELETE /v1/engines/{engineId}` - 注销引擎
- `GET /v1/system/health` - 系统健康检查
- `GET /v1/system/gpu` - GPU 状态监控

### 数据平面接口
- `GET /v1/models` - 列出所有可用模型
- `GET /v1/models/{modelId}` - 获取模型详情
- `POST /v1/chat/completions` - 聊天补全
- `POST /v1/completions` - 文本补全

## 系统要求

- **Windows 10/11** (64-bit)
- **.NET 8.0** or later
- **Python 3.8+** (for PyTorch Engine)
- **CUDA 11.7+** (for GPU acceleration)
- **4GB+ RAM**
- **GPU** (recommended for inference)

## 故障排查

### 常见问题

1. **服务无法启动**
   - 检查端口是否被占用
   - 检查 config.json 配置是否正确
   - 查看日志文件获取详细错误信息

2. **GPU 监控不工作**
   - 确保 CUDA 已正确安装
   - 检查 GPU 驱动是否最新
   - 验证 nvidia-smi 命令是否可用

3. **引擎注册失败**
   - 检查引擎端点是否可访问
   - 验证引擎健康检查接口是否正常

## 版本历史

### v1.0.0 (2026-02-13)
- 初始发布
- 支持引擎注册和发现
- 健康监控和告警
- GPU 状态监控
- Windows 服务支持

## 许可证

MIT License

## 联系方式

- **项目地址**: https://github.com/xuliding/ASS-RI-Windows
- **文档**: https://github.com/xuliding/ASS-RI-Windows/wiki

---

**ASS-RI** - 为 AI 推理引擎提供统一的管理和控制平面