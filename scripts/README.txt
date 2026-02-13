ASS-RI Windows AI Inference Service
====================================

发布版本使用说明

1. 安装Windows服务（推荐）
   - 右键点击 "install-service.bat"
   - 选择"以管理员身份运行"
   - 按提示完成安装

2. 控制台模式运行
   - 双击运行 "ASS-RI.exe console"
   - 或命令行执行: .\ASS-RI.exe console

3. 服务管理命令
   - 安装: sc create ASS-RI binPath= "完整路径\ASS-RI.exe" start= auto
   - 启动: sc start ASS-RI
   - 停止: sc stop ASS-RI
   - 删除: sc delete ASS-RI
   - 状态: sc query ASS-RI

4. API访问
   - 服务地址: http://localhost:5000
   - Swagger文档: http://localhost:5000/swagger
   - 健康检查: http://localhost:5000/v1/health
   - 指标: http://localhost:5000/metrics

5. 配置文件
   - config.json - 服务配置文件（自动创建）

注意：
- Windows服务需要管理员权限安装
- 确保端口5000未被占用
- 首次运行会自动创建默认配置
