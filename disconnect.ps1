# 接続中のVPNを取得し、切断する
$vpnName = Get-VpnConnection | Where-Object { $_.ConnectionStatus -eq "Connected" } | Select-Object -ExpandProperty Name
if ($vpnName -eq $null) {
    Write-Host "接続中のVPNがありません。"
    exit
} else {
    Write-Host "接続中のVPNを切断します: $vpnName"
}

rasdial $vpnName /DISCONNECT

# 接続確認
if (Get-VpnConnection -Name $vpnName | Where-Object { $_.ConnectionStatus -eq "Disconnected" }) {
    Write-Host "VPNを切断しました。"
} else {
    Write-Host "VPN切断に失敗しました。"
}
