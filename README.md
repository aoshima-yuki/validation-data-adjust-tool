---

# README

---

## 概要

本リポジトリは、空間ID変換を行うためのデータ整備ツール（data-adjust-tool）を検証するための環境を構築するものです。

本来はローカル環境での構築も可能ですが、以下の理由により GitHub Codespaces 上で構築を実施します。

* 管理者権限（Java / Python / NiFi のインストール）が必要
* 環境依存を排除し、再現性を確保したい

そのため、本リポジトリでは Codespaces を用いた再現可能な検証環境を提供します。

---

## GitHub Codespaces とは

**GitHub Codespaces** は、クラウド上で動作する開発環境（ブラウザで利用可能な仮想マシン）です。

主な特徴：

* ブラウザだけで開発環境を起動可能
* 環境をリポジトリ単位で再現可能
* VS Code UI
* ポート公開でWebアプリ利用可能

---

## 環境

* GitHub Codespaces
* Java 21
* Python 3.11
* Apache NiFi 2.0.0

---

## 検証環境構築手順

### 1. Codespaces を起動

`Code → Codespaces → Create codespace on main`

---

### 2. NiFi を配置

```
nifi-2.0.0-bin.zip
```

をアップロード

---

### 3. セットアップ

```bash
rm -rf nifi-2.0.0 data-adjust-tool
bash setup.sh
```

---

### 4. ポートを開く

`PORTS` タブで `8443` を開く

---

### 5. NiFi にアクセス

```
https://<codespace-url>-8443.app.github.dev/nifi
```

---

### 6. ログイン

* Username: admin
* Password: Password123!

---

### 7. Processor確認

`Add Processor` → `SpatialID` 検索

---

## setup.sh の内容

* NiFi展開
* data-adjust-tool clone
* python/extensions配置
* nifi.properties設定
* NiFi起動

---

# ⚠️ 実行時の注意事項（重要）

---

## 1. CodespacesのNiFiアクセス問題

Codespacesでは認証ヘッダが自動付与され、NiFiでエラーになる。

```
Unauthorized error="invalid_token"
```

### 対処：nginxプロキシ

```bash
docker network create nifi-net

docker run -d --name nifi-http --network nifi-net \
  ghcr.io/aoshima-yuki/validation-data-adjust-tool-container:latest

cat > nginx.conf <<'EOF'
events {}
http {
  server {
    listen 18080;
    location / {
      proxy_pass http://nifi-http:8080;
      proxy_set_header Authorization "";
    }
  }
}
EOF

docker run -d --name nifi-proxy --network nifi-net \
  -p 18080:18080 \
  -v "$PWD/nginx.conf:/etc/nginx/nginx.conf:ro" \
  nginx:alpine
```

アクセス：

```
https://<codespace-url>-18080.app.github.dev/nifi/
```

---

## 2. 入力ファイルのパス問題

Codespacesのパスはコンテナから見えない。

### 対処

```bash
docker exec nifi-http mkdir -p /tmp/input

docker cp /workspaces/.../000276828.zip \
  nifi-http:/tmp/input/000276828.zip
```

NiFi設定：

```
Input Directory: /tmp/input
```

---

## 3. Flow JSON 読み込み

UIでは不可 → API使用

```bash
curl -X POST "http://localhost:18080/nifi-api/process-groups/root/process-groups/upload" \
  -F "groupName=空間ID変換" \
  -F "positionX=0" \
  -F "positionY=0" \
  -F "clientId=manual-upload" \
  -F "file=@flow.json;type=application/json"
```

---

## 4. Processorが動かない問題（最重要）

以下エラーが出る：

```
Missing Processor
```

### 原因

data-adjust-tool の Python Processor が読み込まれていない

### 影響

* ConvertShapeFileToGeoDataFrame ❌
* GenerateSpatialID ❌
* ConvertCRS ❌

👉 **空間ID CSVは出力されない**

---

## 5. 現状の限界

このコンテナでは：

| 機能     | 状態 |
| ------ | -- |
| NiFi起動 | OK |
| Flow読込 | OK |
| ファイル読込 | OK |
| 空間ID変換 | ❌  |

---

## 6. 解決方法

### 方法①（推奨）

NiFiにPython extensionsを正しく組み込む

### 方法②

コンテナを再構築

### 方法③

Python単体で処理実行

---

## 7. 本環境の位置付け

👉 **NiFi + data-adjust-tool の動作確認用（未完成）**

---

## 注意

* NiFi本体は軽量ではないため不安定な場合あり
* flow.json.gzは環境依存あり
* 本番利用不可

---

