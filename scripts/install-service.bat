@echo off
chcp 65001 >nul
echo ========================================
echo    ASS-RI Windows服务安装
echo ========================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员权限运行此脚本！
    echo 右键点击脚本，选择"以管理员身份运行"
    pause
    exit /b 1
)

set "SERVICE_NAME=ASS-RI"
set "DISPLAY_NAME=ASS-RI AI Inference Service"
set "DESCRIPTION=ASS-RI Windows AI Inference Service - Provides AI model inference capabilities"
set "EXE_PATH=%~dp0ASS-RI.exe"

echo 服务名称: %SERVICE_NAME%
echo 显示名称: %DISPLAY_NAME%
echo 程序路径: %EXE_PATH%
echo.

:: 检查服务是否已存在
sc query %SERVICE_NAME% >nul 2>&1
if %errorLevel% equ 0 (
    echo [提示] 服务已存在，先卸载...
    sc stop %SERVICE_NAME% >nul 2>&1
    timeout /t 2 /nobreak >nul
    sc delete %SERVICE_NAME%
    timeout /t 2 /nobreak >nul
)

:: 安装服务
echo [安装] 正在创建服务...
sc create %SERVICE_NAME% binPath= "\"%EXE_PATH%\"" start= auto DisplayName= "%DISPLAY_NAME%"

if %errorLevel% neq 0 (
    echo [错误] 服务创建失败！
    pause
    exit /b 1
)

:: 设置服务描述
sc description %SERVICE_NAME% "%DESCRIPTION%"

echo.
echo [成功] 服务安装完成！
echo.
echo 服务信息:
echo   名称: %SERVICE_NAME%
echo   显示名: %DISPLAY_NAME%
echo   启动类型: 自动
echo.
echo 管理命令:
echo   启动: sc start %SERVICE_NAME%
echo   停止: sc stop %SERVICE_NAME%
echo   删除: sc delete %SERVICE_NAME%
echo   状态: sc query %SERVICE_NAME%
echo.
echo 按任意键启动服务...
pause >nul

:: 启动服务
echo [启动] 正在启动服务...
sc start %SERVICE_NAME%

if %errorLevel% equ 0 (
    echo [成功] 服务启动命令已发送
    timeout /t 3 /nobreak >nul
    echo.
    echo 服务状态:
    sc query %SERVICE_NAME% | findstr "STATE"
) else (
    echo [错误] 服务启动失败！
)

echo.
pause
