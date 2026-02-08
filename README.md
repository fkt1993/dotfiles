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

### 前提条件

- macOS
- Command Line Tools (`xcode-select --install`)

### フルインストール

```bash
git clone https://github.com/<user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

これにより以下の 3 ステップが順番に実行されます。

### 1. Homebrew パッケージのインストール (`setup-brew.sh`)

Homebrew が未インストールの場合は自動でインストールされます。その後、`Brewfile` の共通パッケージを導入し、プロファイル選択を求められます。

```
Select profile:
  1) personal
  2) work
  3) skip (common packages only)
```

- **personal** — `Brewfile.personal` を追加導入 (開発ツール、エディタ、個人用アプリケーション等)
- **work** — `Brewfile.work` を追加導入 (業務用パッケージ)
- **skip** — 共通パッケージのみ

環境変数 `DOTFILES_PROFILE` を事前にセットすることで対話なしで選択できます。

```bash
DOTFILES_PROFILE=personal ./scripts/setup-brew.sh
```

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

## マシン固有の設定

以下のファイルでマシンごとの差分を管理できます。いずれもリポジトリには含まれません。

- **`~/.zshrc.local`** — `.zshrc` の末尾で読み込まれるローカル設定
- **`~/.gitconfig.local`** — Git のユーザー名・メールアドレス等のローカル設定
