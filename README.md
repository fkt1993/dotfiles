# dotfiles

macOS 向けの個人用 dotfiles リポジトリ。シェル設定、Git 設定、キーボードカスタマイズ、アプリケーション設定などをバージョン管理し、シンボリックリンクでホームディレクトリに展開します。

## 管理対象

| カテゴリ | 概要 |
|---|---|
| **Zsh** | `.zshrc` 本体と、エイリアス・fzf 連携などのモジュールファイル |
| **Git** | グローバル設定、fzf を活用した対話的エイリアス群、グローバル gitignore |
| **Karabiner-Elements** | macOS 全体で Emacs 風キーバインドを実現する設定 (ターミナル等は除外) |
| **Spectacle** | ウィンドウ管理のショートカット定義 |
| **Raycast** | ランチャー設定のバックアップ |
| **macOS Services** | 右クリックメニュー用ワークフロー (VSCode で開く) |
| **Homebrew** | パッケージ定義 (共通・personal・work のプロファイル別) |
| **macOS システム設定** | `defaults write` によるキーボード、Dock、Finder 等の設定 |

## セットアップ

### ワンライナーインストール

新しい Mac でターミナルを開いて以下を実行するだけでセットアップが完了します。Xcode Command Line Tools のインストールが求められた場合は、完了後に再実行してください。SSH 鍵の生成と GitHub への登録も自動で行われ、dotfiles リポジトリの remote が SSH に切り替わります。

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fkt1993/dotfiles/main/bootstrap.sh)
```

### 手動インストール

```bash
git clone https://github.com/fkt1993/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

これにより以下の 3 ステップが順番に実行されます。

### 1. Homebrew パッケージのインストール (`setup-brew.sh`)

Homebrew が未インストールの場合は自動でインストールされます。その後、`Brewfile` の共通パッケージを導入し、fzf によるプロファイル選択を求められます（fzf 未導入時は番号入力にフォールバック）。

- **personal** — `Brewfile.personal` を追加導入 (開発ツール、エディタ、個人用アプリケーション等)
- **work** — `Brewfile.work` を追加導入 (業務用パッケージ)
- **skip** — 共通パッケージのみ

選択結果は `.env` ファイル (`DOTFILES_PROFILE=personal`) に保存され、次回以降は自動で使われます。

### 2. シンボリックリンクの作成 (`setup-links.sh`)

リポジトリ内の設定ファイルをホームディレクトリにシンボリックリンクします。対象ディレクトリ配下のファイルを再帰的に探索し、同じパス構造で `~` にリンクを作成します。

| リポジトリ | リンク先 |
|---|---|
| `.config/` | `~/.config/` |
| `Library/` | `~/Library/` |
| `zsh/` | `~/zsh/` |
| `.zshrc` | `~/.zshrc` |

既存のファイルがある場合は上書きされます。`~/.ssh` ディレクトリが存在しない場合は自動で作成されます。

### 3. macOS システム設定の適用 (`setup-mac.sh`)

`defaults write` コマンドで以下のカテゴリの設定を適用します。

- **入力デバイス** — マウス・トラックパッドの速度調整
- **キーボード** — ¥キーをバックスラッシュにマッピング、キーリピート高速化、プレス＆ホールド無効化、スペルチェック・ライブ変換の無効化
- **メニューバー** — バッテリー残量%表示、時計の秒表示
- **Dock** — 左配置、自動的に隠す、サイズ・拡大表示の調整
- **Finder** — パスバー表示

一部の設定は再ログインまたは再起動後に反映されます。以下の項目は手動での設定が必要です。

- Night Shift の設定
- Finder のサイドバー

### 個別実行

各スクリプトは単独でも実行できます。

```bash
./scripts/setup-brew.sh    # Homebrew パッケージのみ
./scripts/setup-links.sh   # シンボリックリンクのみ
./scripts/setup-mac.sh     # macOS 設定のみ
```

## Brewfile 管理 (`brew-manage.sh`)

インストール済みパッケージを Brewfile で管理するためのユーティリティスクリプトです。

```bash
# 各 Brewfile のパッケージ数と未登録パッケージを確認
./scripts/brew-manage.sh status

# インストール済みパッケージをプロファイル別 Brewfile に書き出し（未登録分のみ追記）
./scripts/brew-manage.sh dump              # .env のプロファイルを使用
./scripts/brew-manage.sh dump personal     # プロファイルを明示的に指定

# personal と work の両方にあるパッケージを Brewfile（共通）に移動
./scripts/brew-manage.sh sync
```

### 想定ワークフロー

1. 個人マシンで `brew-manage.sh dump personal` → `Brewfile.personal` にパッケージを書き出し
2. 仕事マシンで `brew-manage.sh dump work` → `Brewfile.work` にパッケージを書き出し
3. `brew-manage.sh sync` → 両方に存在するパッケージが `Brewfile`（共通）に移動

## マシン固有の設定

以下のファイルでマシンごとの差分を管理できます。いずれもリポジトリには含まれません。

- **`.env`** — プロファイル設定 (`DOTFILES_PROFILE=personal|work`)
- **`~/.zshrc.local`** — `.zshrc` の末尾で読み込まれるローカル設定
- **`~/.gitconfig.local`** — Git のユーザー名・メールアドレス等のローカル設定
