# kiro2api - 测试 OpenAI Chat Completions API
# 使用方法: .\test-openai.ps1

$baseUrl = "http://localhost:8080"
$token = "ASd123.."  # 修改为你的 KIRO_CLIENT_TOKEN

Write-Host "=== 测试 OpenAI Chat Completions API ===" -ForegroundColor Cyan
Write-Host ""

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
