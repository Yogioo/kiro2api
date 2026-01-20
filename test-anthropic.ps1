# kiro2api - 测试 Anthropic Messages API
# 使用方法: .\test-anthropic.ps1

$baseUrl = "http://localhost:8080"
$token = "ASd123.."  # 修改为你的 KIRO_CLIENT_TOKEN

Write-Host "=== 测试 Anthropic Messages API ===" -ForegroundColor Cyan
Write-Host ""

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
