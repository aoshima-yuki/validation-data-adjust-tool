# Memo

## 概要
本リポジトリは、空間ID変換を行うためのデータ整備ツール（data-adjust-tool）を検証するための環境を構築するものです。

本来はローカル環境での構築が可能ですが、以下の理由により GitHub Codespaces 上で構築を実施しました。

- 管理者権限（Java / Python / NiFi のインストール）が必要
- 環境依存を排除したい

そのため、本リポジトリでは Codespaces を用いた再現可能な検証環境を提供します。

---
## GitHub Codespaces とは

**GitHub Codespaces** は、GitHub Codespaces が提供する **クラウド上の開発環境（ブラウザで使える仮想マシン）** です。

主な特徴は以下の通りです。

* ブラウザだけで開発環境を起動可能（ローカルに環境構築不要）
* リポジトリごとに事前定義された開発環境を再現できる
* VS Code ベースの UI で操作可能
* ポート公開により Web アプリ（今回の NiFi など）へ外部アクセス可能

本手順では、この Codespaces 上に NiFi 環境を構築し、ブラウザ経由で動作確認を行います。

---

## 環境
- GitHub Codespaces
- Java 21
- Python 3.11
- Apache NiFi 2.0.0

---

## 検証環境構築手順メモ

### 1. Codespaces を起動
本リポジトリを開き、Codespaces を起動する

---

### 2. NiFi を配置
ローカルから NiFi をアップロード

```
nifi-2.0.0-bin.zip
````

---

### 3. 解凍

```bash
unzip nifi-2.0.0-bin.zip
````

---

### 4. data-adjust-tool を取得

```bash
git clone https://github.com/ODS-IS-IMDX/data-adjust-tool.git
```

---

### 5. NiFi に配置

```bash
cp -r data-adjust-tool/api nifi-2.0.0/python/
cp -r data-adjust-tool/extensions nifi-2.0.0/python/
```

---

### 6. Python 設定

```bash
sed -i 's|^nifi.python.command=.*|nifi.python.command=python3|' nifi-2.0.0/conf/nifi.properties
```

---

### 7. NiFi 起動

```bash
cd nifi-2.0.0/bin
./nifi.sh start
```

---

### 8. ポート設定

Codespaces の PORTS タブで 8443 を開く

---

### 9. ログインユーザー設定(例)

```bash
./nifi.sh set-single-user-credentials admin Password123!
```

---

### 10. ログイン

ブラウザで以下にアクセス

```
https://<codespace-url>-8443.app.github.dev/nifi
```

---

## 確認

NiFi の「Add Processor」画面にて以下が表示されることを確認

* ConvertLinkCSVToSpatialID
* GenerateCylindricalSpatialID
* その他 data-adjust-tool の Processor

---

## 備考

* Python は Codespaces の devcontainer により 3.11 を利用
* システム標準の python3（minimal版）は使用不可

---

## 検証環境の立ち上げ手順

### 1. Codespaces を起動
本リポジトリを開き、`Code` → `Codespaces` → `Create codespace on main` を選択する。

### 2. NiFi を配置
ローカルに保存した以下のファイルを Codespaces のリポジトリ直下にアップロードする。

```text
nifi-2.0.0-bin.zip
````

### 3. セットアップスクリプトを実行

必要に応じて既存フォルダを削除したうえで、以下を実行する。

```bash
rm -rf nifi-2.0.0 data-adjust-tool
bash setup.sh
```

### 4. ポートを開く

Codespaces の `PORTS` タブで `8443` を開く。

### 5. NiFi にアクセス

以下のURLにアクセスする。

```text
https://<codespace-url>-8443.app.github.dev/nifi
```

### 6. ログイン

以下でログインする。

* Username: `admin`
* Password: `Password123!`

### 7. 動作確認

NiFi 画面で右クリックし、`Add Processor` を開く。
以下の Processor が表示されることを確認する。

* `ConvertLinkCSVToSpatialID`
* `GenerateCylindricalSpatialID`

## setup.sh で実施する内容

`setup.sh` では以下を自動実行する。

* NiFi の展開
* `data-adjust-tool` の clone
* `api` / `extensions` の NiFi への配置
* `nifi.python.command=python3` の設定
* NiFi ログインユーザーの設定
* NiFi の起動

## 注意事項

* `nifi-2.0.0-bin.zip` は GitHub リポジトリには含めていません。
  本ファイルはサイズが大きく、通常の Git リポジトリでの管理に適さないためです。

* GitHub Release 等での配布も可能ですが、本検証では **利用するファイルを明示的に固定し、取得失敗の影響を避けること** を優先し、Codespaces 起動後に手動アップロードする方式を採用しています。

* また、スクリプト内での自動ダウンロードも検討しましたが、Codespaces 環境から Apache 配布サーバ（`archive.apache.org` 等）への接続が不安定となる場合があり、再現性に課題があるため採用していません。

* そのため、事前にローカル環境等で `nifi-2.0.0-bin.zip` を取得し、Codespaces にアップロードしてから利用してください。

* 既存の `nifi-2.0.0` や `data-adjust-tool` ディレクトリが残っていると、再実行時に失敗する場合があります。必要に応じて削除してから `bash setup.sh` を実行してください。

---



