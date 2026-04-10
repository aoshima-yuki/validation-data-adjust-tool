# Memo

## 概要
本リポジトリは、空間ID変換を行うためのデータ整備ツール（data-adjust-tool）を検証するための環境を構築するものです。

本来はローカル環境での構築が可能ですが、以下の理由により GitHub Codespaces 上で構築を実施しました。

- 管理者権限（Java / Python / NiFi のインストール）が必要
- 環境依存を排除したい

そのため、本リポジトリでは Codespaces を用いた再現可能な検証環境を提供します。

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

* `nifi-2.0.0-bin.zip` は GitHub には保存していないため、Codespaces 起動後に手動アップロードが必要です。  
  本来はスクリプト内でダウンロードする構成も検討しましたが、Codespaces 環境から Apache 配布サーバ（archive.apache.org 等）への接続が不安定となる場合があり、安定した再現性を確保するため本方式としています。  
  そのため、事前にローカル環境等で `nifi-2.0.0-bin.zip` を取得し、Codespaces にアップロードして利用してください。
* 既存の `nifi-2.0.0` や `data-adjust-tool` が残っていると再実行時に失敗することがあるため、必要に応じて削除してから `bash setup.sh` を実行する。


