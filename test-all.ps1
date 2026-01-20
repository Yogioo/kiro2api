# kiro2api Windows 测试脚本
# 使用方法: .\test-api.ps1

$baseUrl = "http://localhost:8080"
$token = "ASd123.."  # 修改为你的 KIRO_CLIENT_TOKEN

Write-Host "=== kiro2api API 测试 ===" -ForegroundColor Cyan
Write-Host ""

# 测试 1: 获取模型列表
Write-Host "测试 1: 获取模型列表" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/v1/models" `
        -Headers @{"Authorization"="Bearer $token"} `
        -Method GET
    Write-Host "✓ 成功" -ForegroundColor Green
    Write-Host ""
    
    # 解析 JSON 并格式化显示
    $models = ($response.Content | ConvertFrom-Json).data
    
    # 创建表格数据
    $tableData = @()
    foreach ($model in $models) {
        # 转换 Unix 时间戳（兼容旧版 PowerShell）
        $createdTime = "N/A"
        if ($model.created) {
            $epoch = Get-Date "1970-01-01 00:00:00"
            $createdTime = $epoch.AddSeconds($model.created).ToString("yyyy-MM-dd HH:mm:ss")
        }
        
        $tableData += [PSCustomObject]@{
            "模型ID" = $model.id
            "创建时间" = $createdTime
            "所有者" = $model.owned_by
        }
    }
    
    # 显示表格
    $tableData | Format-Table -AutoSize
    Write-Host "共 $($models.Count) 个可用模型" -ForegroundColor Cyan
    
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# 测试 2: Anthropic API 格式
Write-Host "测试 2: Anthropic Messages API" -ForegroundColor Yellow
try {
    $body = @{
        model = "claude-sonnet-4-20250514"
        max_tokens = 100
        messages = @(
            @{
                role = "user"
                content = "你好，请用一句话介绍你自己"
            }
        )
    } | ConvertTo-Json -Depth 10

    $response = Invoke-WebRequest -Uri "$baseUrl/v1/messages" `
        -Method POST `
        -Headers @{
            "Content-Type"="application/json"
            "Authorization"="Bearer $token"
        } `
        -Body $body
    
    Write-Host "✓ 成功" -ForegroundColor Green
    $result = $response.Content | ConvertFrom-Json
    Write-Host "回复: $($result.content[0].text)"
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# 测试 3: OpenAI API 格式
Write-Host "测试 3: OpenAI Chat Completions API" -ForegroundColor Yellow
try {
    $body = @{
        model = "claude-sonnet-4-20250514"
        messages = @(
            @{
                role = "user"
                content = "1+1等于几？"
            }
        )
    } | ConvertTo-Json -Depth 10

    $response = Invoke-WebRequest -Uri "$baseUrl/v1/chat/completions" `
        -Method POST `
        -Headers @{
            "Content-Type"="application/json"
            "Authorization"="Bearer $token"
        } `
        -Body $body
    
    Write-Host "✓ 成功" -ForegroundColor Green
    $result = $response.Content | ConvertFrom-Json
    Write-Host "回复: $($result.choices[0].message.content)"
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# 测试 4: Token 池状态
Write-Host "测试 4: 查看 Token 池状态" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/tokens" -Method GET
    Write-Host "✓ 成功" -ForegroundColor Green
    Write-Host $response.Content
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "=== 测试完成 ===" -ForegroundColor Cyan
