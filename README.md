# mikutter BurntToastプラグイン
PowerShellから通知を送るユーティリティコマンド [BurntToast](https://github.com/Windos/BurntToast) を利用して、WSL上で動くmikutterからWindows10へ通知を送るプラグインです。

なお、中身はmikutter本体同梱の `core/plugin/libnotify/notify-send.rb` とほぼ同じです。

## 使い方
まずPowerShellを管理者権限で開き、以下のコマンドを実行してBurntToastをインストールします。

```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
> Install-Module -Name BurntToast
```

次にWSL上で以下のコマンドを実行して、このプラグインをmikutterにインストールします。

```shell-session
$ mkdir -p ~/.mikutter/plugin && git clone git://github.com/cobodo/mikutter-burnt-toast ~/.mikutter/plugin/burnt_toast
```

設定＞BurntToastから、Windows側から見たWSLのrootfsへのパスを設定してください。筆者の環境では以下のような値でした。

`C:\Users\cobodo\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs`

