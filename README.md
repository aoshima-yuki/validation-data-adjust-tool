
# Memo

## 概要

本リポジトリは、空間ID変換を行うためのデータ整備ツール（data-adjust-tool）を検証するための環境を構築するものです。

本来はローカル環境での構築も可能ですが、以下の理由により GitHub Codespaces 上で構築を実施します。

* 管理者権限（Java / Python / NiFi のインストール）が必要
* 環境依存を排除し、再現性を確保したい

そのため、本リポジトリでは Codespaces を用いた再現可能な検証環境を提供します。

---

## GitHub Codespaces とは

**GitHub Codespaces** は、クラウド上で動作する開発環境（ブラウザで利用可能な仮想マシン）です。

主な特徴は以下の通りです。

* ブラウザだけで開発環境を起動可能（ローカル環境構築不要）
* リポジトリごとに定義された環境を再現可能
* VS Code ベースの UI で操作可能
* ポート公開により Web アプリ（NiFi 等）にアクセス可能

本手順では、この Codespaces 上に NiFi 環境を構築し、ブラウザ経由で動作確認を行います。

---

## 環境

* GitHub Codespaces
* Java 21
* Python 3.11
* Apache NiFi 2.0.0

---

## 検証環境構築手順（参考）

以下は手動で構築する場合の手順です。

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
echo "nifi.python.command=python3" >> nifi-2.0.0/conf/nifi.properties
echo "nifi.python.extensions.directory=./python/extensions" >> nifi-2.0.0/conf/nifi.properties
echo "nifi.python.framework.directory=./python/framework" >> nifi-2.0.0/conf/nifi.properties
```

### 5. NiFi 起動

```bash
cd nifi-2.0.0/bin
./nifi.sh start
```

---

## 検証環境の立ち上げ手順

### 1. Codespaces を起動

本リポジトリを開き、
`Code` → `Codespaces` → `Create codespace on main` を選択する。

---

### 2. NiFi を配置

以下のファイルを Codespaces のリポジトリ直下にアップロードする。

```
nifi-2.0.0-bin.zip
```

---

### 3. セットアップスクリプトを実行

```bash
rm -rf nifi-2.0.0 data-adjust-tool
bash setup.sh
```

---

### 4. ポートを開く

Codespaces の `PORTS` タブで `8443` を開く。

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

NiFi 画面で右クリックし、`Add Processor` を開く。
検索欄に `SpatialID` と入力し、Spatial ID 関連の Processor が表示されることを確認する。

例：

* `GenerateCylindricalSpatialID`
* `GenerateSpatialID`
* `ConvertLinkCSVToSpatialIDCenterPoint`

---

## setup.sh で実施する内容

`setup.sh` では以下を自動実行する。

* NiFi の展開
* `data-adjust-tool` の clone
* `api` / `extensions` の NiFi への配置
* `nifi.python.command=python3` の設定
* `nifi.python.extensions.directory=./python/extensions` の設定
* `nifi.python.framework.directory=./python/framework` の設定
* NiFi ログインユーザーの設定
* NiFi の起動

---

## 注意事項

* `nifi-2.0.0-bin.zip` は GitHub リポジトリには含めていません
  ファイルサイズが大きく、通常の Git 管理に適さないためです。

* 以下より取得してください
  [https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip](https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip)

* Codespaces 起動後にアップロードして利用してください

* スクリプト内での自動ダウンロードも検討しましたが、
  Codespaces 環境から Apache 配布サーバへの接続が不安定となる場合があるため採用していません

* 既存の `nifi-2.0.0` や `data-adjust-tool` が残っていると失敗することがあります
  必要に応じて削除してから `bash setup.sh` を実行してください

---

