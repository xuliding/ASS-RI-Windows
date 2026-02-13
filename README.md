# ASS-RI Windows AI Inference Service

ASS-RI（AI Service Router & Inference）是一个Windows平台的AI推理服务，支持多种模型格式，提供统一的API接口。

## 功能特性

- 🚀 **多引擎支持** - 支持PyTorch、ONNX、GGUF等多种模型格式
- 🔧 **Windows服务** - 可安装为Windows服务，开机自启动
- 📊 **健康监控** - 内置健康检查和告警机制
- ⚙️ **动态配置** - 支持配置文件热重载，无需重启服务
- 📈 **Prometheus指标** - 内置指标收集，支持监控集成
- 🔀 **智能路由** - 支持多种负载均衡策略
- 🔐 **API认证** - 支持API Key认证和速率限制

## 系统要求

- **操作系统**: Windows 10/11 或 Windows Server 2019/2022
- **运行时**: .NET 9.0 Runtime（如使用非自包含版本）
- **内存**: 至少 4GB RAM
- **端口**: 5000（可配置）

## 快速开始

### 方式一：便携模式运行（推荐测试）

1. 下载 `ASS-RI-v1.0.0-win-x64.zip`
2. 解压到任意目录，如 `C:\ASS-RI\`
3. 双击运行 `ASS-RI.exe console`
4. 打开浏览器访问 http://localhost:5000/swagger

### 方式二：安装为Windows服务（推荐生产环境）

1. 下载并解压到目标目录
2. **右键**点击 `install-service.bat` → 选择**"以管理员身份运行"**
3. 按提示完成安装，服务将自动启动
4. 访问 http://localhost:5000 验证服务状态

## 服务管理

安装为Windows服务后，可使用以下命令管理：

```cmd
# 查看服务状态
sc query ASS-RI

# 启动服务
sc start ASS-RI

# 停止服务
sc stop ASS-RI

# 删除服务（管理员权限）
sc delete ASS-RI
```

## 配置说明

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

### 配置项说明

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `ServicePort` | 服务监听端口 | 5000 |
| `ModelDirectory` | 模型文件存放目录 | F:\modelscope |
| `LogLevel` | 日志级别 | Information |
| `EnableSwagger` | 启用Swagger文档 | true |
| `ApiAuthentication.Enabled` | 启用API认证 | false |
| `RateLimit.Enabled` | 启用速率限制 | true |

修改配置后，服务会自动重载（无需重启）。

## API接口

### 核心接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/v1/health` | GET | 健康检查 |
| `/v1/engines` | GET | 获取引擎列表 |
| `/v1/models` | GET | 获取模型列表 |
| `/v1/completions` | POST | 文本补全 |
| `/v1/chat/completions` | POST | 聊天补全 |
| `/v1/embeddings` | POST | 文本嵌入 |
| `/metrics` | GET | Prometheus指标 |

### 示例请求

```bash
# 健康检查
curl http://localhost:5000/v1/health

# 获取模型列表
curl http://localhost:5000/v1/models

# 文本补全
curl -X POST http://localhost:5000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt2", "prompt": "Hello", "max_tokens": 50}'
```

## 目录结构

```
ASS-RI/
├── ASS-RI.exe              # 主程序
├── ASS-RI.dll              # 程序集
├── config.json             # 配置文件（自动生成）
├── install-service.bat     # 服务安装脚本
├── uninstall-service.bat   # 服务卸载脚本
├── conf/                   # 配置目录
├── data/                   # 数据目录（日志等）
└── [依赖DLL文件...]        # 运行依赖
```

## 日志查看

服务日志保存在 `data\logs\` 目录下：

- `ASS-RI-YYYYMMDD.log` - 应用日志
- `ASS-RI-Errors-YYYYMMDD.log` - 错误日志

## 常见问题

### Q: 服务无法启动？

A: 检查以下几点：
1. 端口5000是否被占用：`netstat -ano | findstr 5000`
2. 是否有管理员权限（安装服务时需要）
3. 查看日志文件了解具体错误

### Q: 如何修改服务端口？

A: 编辑 `config.json` 文件，修改 `ServicePort` 值，保存后自动生效。

### Q: 如何添加API认证？

A: 在 `config.json` 中设置：
```json
"ApiAuthentication": {
  "Enabled": true,
  "ApiKeys": ["your-api-key-1", "your-api-key-2"]
}
```

然后在请求头中添加：`X-API-Key: your-api-key-1`

## 版本历史

### v1.0.0 (2026-02-13)
- ✅ 初始版本发布
- ✅ Windows服务支持
- ✅ 健康检查和告警
- ✅ 动态配置重载
- ✅ Prometheus指标导出
- ✅ API认证和速率限制
- ✅ 多引擎路由支持

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 支持与反馈

如有问题或建议，欢迎提交 Issue。
