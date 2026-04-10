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

## セットアップ手順

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

## 実行手順
---

### 1. Codespaces を起動
- 「Code」→「Codespaces」→「Create codespace on main」

---

### 2. セットアップ実行

```bash
bash setup.sh
````

---

### 3. ポート開放

Codespaces の「PORTS」タブで

```
8443
```

を開く

---

### 4. NiFi にアクセス

```
https://<codespace-url>-8443.app.github.dev/nifi
```

---

### 5. ログイン

* Username: admin
* Password: Password123!

---

### 6. 動作確認

NiFi画面で右クリック → Add Processor

以下が表示されることを確認：

* ConvertLinkCSVToSpatialID
* GenerateCylindricalSpatialID

---




