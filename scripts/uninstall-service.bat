@echo off
chcp 65001 >nul
echo ========================================
echo    ASS-RI Windows服务卸载
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

echo 服务名称: %SERVICE_NAME%
echo.

:: 检查服务是否存在
sc query %SERVICE_NAME% >nul 2>&1
if %errorLevel% neq 0 (
    echo [提示] 服务不存在，无需卸载
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 0
)

:: 停止服务
echo [停止] 正在停止服务...
sc stop %SERVICE_NAME% >nul 2>&1
timeout /t 3 /nobreak >nul

:: 删除服务
echo [卸载] 正在删除服务...
sc delete %SERVICE_NAME%

if %errorLevel% equ 0 (
    echo.
    echo [成功] 服务已卸载！
) else (
    echo.
    echo [错误] 服务卸载失败！
)

echo.
echo 按任意键退出...
pause >nul
