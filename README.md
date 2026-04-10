

# Memo

## 概要

本リポジトリは、空間ID変換を行うデータ整備ツール
（`data-adjust-tool`）の**検証環境を構築・利用するためのもの**です。

本来はローカル環境でも構築可能ですが、

* Java / Python / NiFi のインストール等に管理者権限が必要
* 環境差異による動作不整合が発生しやすい

といった課題があるため、
本リポジトリでは **GitHub Codespaces を用いた再現可能な検証環境** を提供します。

また、本 README では以下を記載しています。

1. 検証環境構築手順（参考）
   └ Codespaces 上で環境を構築した手順
2. 検証環境起動手順
   └ 実際に利用するための手順（setup.sh ベース）

---

## GitHub Codespaces とは

**GitHub Codespaces** は、ブラウザから利用可能なクラウド開発環境です。

主な特徴は以下の通りです。

* ブラウザのみで開発環境を起動可能（ローカル環境構築不要）
* リポジトリ単位で環境を再現可能
* VS Code ベースの UI
* ポート公開により Web アプリへ外部アクセス可能

本リポジトリでは、この Codespaces 上に NiFi 環境を構築し、動作確認を行います。

---

## 環境

* GitHub Codespaces
* Java 21
* Python 3.11
* Apache NiFi 2.0.0

---

# 1. 検証環境構築手順（参考）

※ 以下は手動で環境構築を行う場合の手順です
（理解・トラブルシュート用）

### 1. NiFi を配置

```bash
unzip nifi-2.0.0-bin.zip
```

### 2. data-adjust-tool を取得

```bash
git clone https://github.com/ODS-IS-IMDX/data-adjust-tool.git
```

### 3. NiFi に配置

```bash
cp -r data-adjust-tool/api nifi-2.0.0/python/
cp -r data-adjust-tool/extensions nifi-2.0.0/python/
```

### 4. Python 設定

```bash
sed -i 's|^nifi.python.command=.*|nifi.python.command=python3|' nifi-2.0.0/conf/nifi.properties
```

### 5. NiFi 起動

```bash
cd nifi-2.0.0/bin
./nifi.sh start
```

### 6. ユーザー設定

```bash
./nifi.sh set-single-user-credentials admin Password123!
```

---

# 2. 検証環境起動手順

### 1. Codespaces を起動

本リポジトリを開き、
`Code` → `Codespaces` → `Create codespace on main` を選択する。

---

### 2. NiFi を配置

以下ファイルを Codespaces にアップロードする。

```text
nifi-2.0.0-bin.zip
```

---

### 3. セットアップ実行

```bash
rm -rf nifi-2.0.0 data-adjust-tool
bash setup.sh
```

---

### 4. ポートを開く

`PORTS` タブで `8443` を開く。

---

### 5. NiFi にアクセス

```
https://<codespace-url>-8443.app.github.dev/nifi
```

---

### 6. ログイン

* Username: `admin`
* Password: `Password123!`

---

### 7. 動作確認

NiFi の `Add Processor` にて以下が表示されることを確認

* `ConvertLinkCSVToSpatialID`
* `GenerateCylindricalSpatialID`

---

## setup.sh の処理内容

* NiFi の展開
* `data-adjust-tool` の clone
* `api` / `extensions` の配置
* Python 設定
* ユーザー設定
* NiFi 起動

---

## 注意事項

* `nifi-2.0.0-bin.zip` は GitHub リポジトリには含めていません。
  サイズが大きく、通常の Git 管理に適さないためです。

* 以下より取得してください。
  [https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip](https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip)

* 本検証では、利用ファイルを固定し再現性を確保するため、
  手動アップロード方式を採用しています。

* Codespaces からの外部ダウンロードは不安定な場合があります。

* 既存ディレクトリがあると失敗する場合があります。

```bash
rm -rf nifi-2.0.0 data-adjust-tool
```

---
