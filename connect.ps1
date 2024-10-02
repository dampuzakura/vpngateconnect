# 接続先を尋ねる
if ($args.Length -eq 0) {
    Write-Host "VPNGate https://www.vpngate.net/ja/"
    $vpnServer = Read-Host "VPNサーバーのアドレスを入力してください。"
} else {
    $vpnServer = $args[0]
    Write-Host "引数からVPNサーバーのアドレスを取得しました: $vpnServer"
}

# VPN接続の設定
$vpnName = "vpngate-"+$vpnServer  # VPN接続名
$username = "vpn"  # ユーザー名
$password = "vpn"  # パスワード
$preSharedKey = "vpn"  # 事前共有鍵

# VPN接続の作成（VPN接続がすでに存在する場合は飛ばす）
if (Get-VpnConnection -Name $vpnName -ErrorAction SilentlyContinue) {
    Write-Host "VPN接続がすでに存在します。"
} else {
    Add-VpnConnection -Name $vpnName -ServerAddress $vpnServer -TunnelType L2tp -EncryptionLevel Required -AuthenticationMethod MSChapv2 -SplitTunneling -RememberCredential -PassThru
}

# 認証情報の保存
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $securePassword)

# VPN接続の開始
rasdial $vpnName $username $password

# 接続確認
if (Get-VpnConnection -Name $vpnName | Where-Object { $_.ConnectionStatus -eq "Connected" }) {
    Write-Host "VPNに接続しました。"
} else {
    Write-Host "VPN接続に失敗しました。"
}
