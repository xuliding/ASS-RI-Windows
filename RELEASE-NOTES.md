# ASS-RI v1.0.0 Release Notes

## 下载

- 📦 [ASS-RI-v1.0.0-win-x64.zip](ASS-RI-v1.0.0-win-x64.zip) (2.82 MB)

## 快速开始

### 方式一：便携模式（推荐测试）
```bash
# 1. 解压
unzip ASS-RI-v1.0.0-win-x64.zip -d C:\ASS-RI

# 2. 运行
cd C:\ASS-RI
ASS-RI.exe console

# 3. 访问
# 打开浏览器访问 http://localhost:5000/swagger
```

### 方式二：Windows服务（推荐生产环境）
```bash
# 1. 解压到目标目录
# 2. 管理员权限运行
install-service.bat

# 3. 服务将自动启动
# 4. 访问 http://localhost:5000
```

## 新特性

### 🚀 核心功能
- ✅ **Windows服务支持** - 可安装为Windows服务，支持开机自启动
- ✅ **健康检查** - 内置系统和引擎健康监控
- ✅ **动态配置** - 配置文件热重载，无需重启服务
- ✅ **告警通知** - 支持邮件告警和系统日志告警
- ✅ **Prometheus指标** - 内置指标收集，兼容Prometheus监控

### 🔧 服务治理
- ✅ **API认证** - 支持API Key认证
- ✅ **速率限制** - 基于令牌桶算法的请求限流
- ✅ **引擎路由** - 支持多种负载均衡策略（随机、轮询、最少负载、最佳性能）
- ✅ **故障转移** - 自动检测并隔离故障引擎

### 📊 管理接口
- ✅ **Swagger文档** - 自动生成API文档
- ✅ **健康检查端点** - `/v1/health`
- ✅ **指标导出** - `/metrics` (Prometheus格式)
- ✅ **告警统计** - `/v1/alerts/stats`
- ✅ **路由统计** - `/v1/route/stats`

## 系统要求

- Windows 10/11 或 Windows Server 2019/2022
- .NET 9.0 Runtime（如使用非自包含版本）
- 至少 4GB RAM
- 可用端口 5000

## 配置说明

服务首次启动会自动创建 `config.json`：

```json
{
  "ServicePort": 5000,
  "ModelDirectory": "F:\\modelscope",
  "LogLevel": "Information",
  "EnableSwagger": true
}
```

## API示例

### 健康检查
```bash
curl http://localhost:5000/v1/health
```

### 获取模型列表
```bash
curl http://localhost:5000/v1/models
```

### 文本补全
```bash
curl -X POST http://localhost:5000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt2",
    "prompt": "Hello world",
    "max_tokens": 50
  }'
```

## 文件校验

```
SHA256: [待计算]
MD5: [待计算]
```

## 已知问题

- 暂无

## 反馈

如有问题或建议，请提交 Issue。

---

**Full Changelog**: [v1.0.0]
