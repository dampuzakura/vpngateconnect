# "vpngate-" から始まるすべてのVPN接続を取得する
$vpnNames = Get-VpnConnection | Where-Object { $_.Name -like "vpngate-*" } | Select-Object -ExpandProperty Name
if ($vpnNames.Length -eq 0) {
    Write-Host "VPN接続がありません。"
    exit
} else {
    Write-Host "VPN接続を削除します: $vpnNames"
}

$vpnNames | ForEach-Object {
    rasdial $_ /DISCONNECT
    Remove-VpnConnection -Name $_
}

# 接続確認
if (Get-VpnConnection | Where-Object { $_.Name -like "vpngate-*" }) {
    Write-Host "VPN接続の削除に失敗しました。"
} else {
    Write-Host "VPN接続を削除しました。"
}
