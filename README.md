# job_board — Rails MCP サーバーサンプル

Rails アプリのデータを MCP(Model Context Protocol)経由で Claude Desktop から参照できるようにするサンプルです。ミニ求人ボードの求人・企業データを、Claude との会話から検索できます。

```
Claude Desktop ──(stdio / JSON-RPC)──> bin/mcp ──> Rails 環境 ──> SQLite
```

## 前提条件

- Ruby 3.2 以上(rbenv 想定。mise / asdf の場合は後述のランチャーを修正)
- Bundler
- Claude Desktop(macOS)

## セットアップ

### 1. clone する場所に注意

⚠️ **`~/Desktop`・`~/Documents`・`~/Downloads` 配下には置かないでください。**
macOS のプライバシー保護(TCC)により、Claude Desktop がスクリプトを実行できず `Operation not permitted` で接続に失敗します。ホーム直下の開発用ディレクトリなどに clone してください。

```bash
mkdir -p ~/Dev
cd ~/Dev
git clone <このリポジトリのURL>
cd job_board
```

### 2. 依存関係のインストールと DB 準備

```bash
bundle install
bin/rails db:prepare   # create + migrate
bin/rails db:seed      # サンプルデータ投入
```

### 3. スクリプトに実行権限を付与

```bash
chmod +x bin/mcp bin/mcp_launcher.sh
```

### 4. MCP サーバー単体での動作確認

Claude Desktop に繋ぐ前に、ターミナルで直接確認します。

```bash
bin/mcp_launcher.sh
```

起動して入力待ちになったら、以下を 1 行ずつ貼り付けて Enter:

```json
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","method":"notifications/initialized"}
{"jsonrpc":"2.0","id":2,"method":"tools/list"}
```

`tools/list` でツール一覧の JSON が返れば OK。`Ctrl+C` で終了します。

> rbenv 以外(mise / asdf)を使っている場合は、`bin/mcp_launcher.sh` 内の
> rbenv 初期化部分を自分の環境に合わせて書き換えてください。

### 5. Claude Desktop に登録

設定ファイルを開きます(Claude Desktop の「設定 → 開発者 → 設定を編集」からも開けます)。

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

`mcpServers` に以下を追加します。**パスは絶対パス**で、clone した場所に合わせて書き換えてください(`~` は使えません)。

```json
{
  "mcpServers": {
    "job-board": {
      "command": "/Users/<あなたのユーザー名>/Dev/job_board/bin/mcp_launcher.sh"
    }
  }
}
```

既に他のサーバーが登録されている場合は、カンマ区切りで兄弟として追加します。

### 6. Claude Desktop を再起動

`Cmd+Q` で完全終了してから起動し直します(ウィンドウを閉じるだけでは反映されません)。

「設定 → 開発者」に `job-board` がエラーなしで表示されていれば接続成功です。

## 使い方

Claude Desktop で次のように聞くと、ツールが呼び出されます(初回は許可ダイアログが出ます)。

| 質問例 | 呼ばれるツール |
|---|---|
| 「どんな企業が登録されてる?」 | `list_companies` |
| 「Ruby が使えてリモート可の求人ある?」 | `search_jobs` |
| 「年収 800 万以上の求人を教えて」 | `search_jobs` |
| 「ID 1 の求人を詳しく教えて」 | `get_job_detail` |

## 補足

- `rails server` の起動は **不要** です。Claude Desktop が `bin/mcp` を子プロセスとして起動し、そのプロセスが Rails 環境ごと DB を直接読みます
- ツールのコードを変更した場合は、Claude Desktop の再起動(または開発者設定からサーバーの再起動)が必要です

## トラブルシューティング

ログの場所: `~/Library/Logs/Claude/mcp-server-job-board.log`
(開発者設定画面の「ログを表示」からも見られます)

| 症状 / ログ | 原因と対処 |
|---|---|
| `Operation not permitted` | Desktop / Documents / Downloads 配下に置いている。保護対象外(例: `~/Dev`)へ移動し、config のパスも更新 |
| `Permission denied` | `chmod +x` 漏れ。手順 3 を実行 |
| `command not found: bundle` / `rbenv` | PATH 問題。`bin/mcp_launcher.sh` 内のバージョンマネージャ初期化を自分の環境に合わせる |
| `Could not locate Gemfile` | ランチャー内の `cd` が効いていない。config のパスが正しいか確認 |
| サーバーが一覧に出ない / すぐ切断 | stdout にログ等が混ざっている可能性。手順 4 の単体実行で JSON 以外の出力がないか確認 |
| DB エラー | `bin/rails db:prepare` と `db:seed` を実行済みか確認 |
