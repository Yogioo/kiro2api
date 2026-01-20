# kiro2api - 查看 Token 池状态
# 使用方法: .\test-token-pool.ps1

$baseUrl = "http://localhost:8080"

Write-Host "=== 查看 Token 池状态 ===" -ForegroundColor Cyan
Write-Host ""

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/tokens" -Method GET
    Write-Host "✓ 成功" -ForegroundColor Green
    Write-Host $response.Content
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
}
