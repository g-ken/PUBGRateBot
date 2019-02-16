# pubgRateForDiscord

Discod用PUBGのレート監視Botです。

![create](https://user-images.githubusercontent.com/40693088/52773544-8f516700-307e-11e9-91f7-641316de1907.png "サンプル")

![rate](https://user-images.githubusercontent.com/40693088/52773845-3f26d480-307f-11e9-8350-3c6b03899942.png "サンプル")


## できること

- レートを自動で取得する

- レートをグラフで表示する

- レートを見る

## 動かすまで

### 必要なもの

- Rubyの動かせる環境（クラウド・ラズパイ等）
- DiscordのBot(https://discordapp.com/developers/applications)
- PUBGのAPIキー(https://developer.playbattlegrounds.com/)
- SQLite3

### 行うこと

```sh
git clone https://github.com/g-ken/PUBGRateBot.git
cd PUBGRateBot/
bundle install ./bundle/vendor
touch .env
```

.envファイルに以下の#{}の部分を埋めて貼り付ける。

```env
API_KEY = "#{PUBGのAPIキー}"
CLIENT_ID = "#{Discord用Botのclient id}"
CLINET_SECRET = "{Discord用Botのsecret id}"
TOKEN="Discord用Botのトークン"
DATABASE = "database.sqlite3"
PREFIX = "#{コマンドとして識別するための文字( !, /など)}"
SLEEP_SEC = "60"
```

埋めたら以下のコマンドで起動する。

```sh
bundle exec ruby bot.rb
```

## 使い方

- add
- rate
- create
- create_day
- create_week
- create_total

### add

``add PUBGネーム``

ユーザをBotに登録するのに使う。

### rate

``rate PUBGネーム``

ユーザのレートを見るのに使う。

### create

``create モード``

指定したモードのレート遷移を見る。

選べるモードは

- solo
- duo
- squad
- solo-fpp
- duo-fpp
- squad-fpp

### create_day

``create_day モード [yyyy-mm-dd]``

指定したモードの1日のレート遷移を見る。

選べるモードは

- solo
- duo
- squad
- solo-fpp
- duo-fpp
- squad-fpp

オプションで日付の指定が可能。例) 2018-01-01

### create_week

実行した日からの指定したモードのレート遷移を見る。

選べるモードは

- solo
- duo
- squad
- solo-fpp
- duo-fpp

### create_total

現状はcreateのエイリアスコマンドになっている。

## 今後の予定

- メンションを送ると``rate``コマンドと同様のことを行うようにする。
- シーズン情報を追加して``create``と``create_total``コマンドを分離する。