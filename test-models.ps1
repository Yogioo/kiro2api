# kiro2api - 测试模型列表
# 使用方法: .\test-models.ps1

$baseUrl = "http://localhost:8080"
$token = "ASd123.."  # 修改为你的 KIRO_CLIENT_TOKEN

Write-Host "=== 获取模型列表 ===" -ForegroundColor Cyan
Write-Host ""

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
