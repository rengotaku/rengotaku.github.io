---
title: "[IPA]応用情報技術者試験のセキュリティのシラバス(令和6年度春期向け)"
tags: ["security", "ipa", "exam"]
---

[応用情報技術者試験（レベル３）シラバス](https://www.ipa.go.jp/shiken/syllabus/t6hhco000000ijdp-att/syllabus_ap_ver6_3.pdf) より気になった単語を抜き取った

# 1. 情報セキュリティ
* （1）情報セキュリティの目的と考え方 
  * セキュリティのCIA三要素
    * 機密性（Confidentiality）
      * 情報が不正なアクセスや開示から保護されている状態を指す
      * 機密性が保たれることで、情報が許可された人々だけに利用されることが確保する
      * データの暗号化、アクセス制御、セキュリティポリシーの実施などの対策が必要
    * 完全性（Integrity）
      * 情報やデータが正確で完全であることを示します
      * データが改ざんされず、意図しない変更や損失から保護されていることを意味する
      * データの暗号化、アクセス制御、適切なバックアップなどの対策が必要
    * 可用性（Availability）
      * システムや情報が必要な時に利用可能である状態を指す
      * 可用性が確保されることで、サービスの中断や停止を最小限に抑えられる
      * DDoS、ランサムウェア攻撃、自然災害などにより可用性が低下する。
  * 真正性（Authenticity）
    * 情報やデータの送信元や作成者が本物であることを確認することを指す。
    * 真正性が確保されることで、データの信頼性が向上し、偽造や不正アクセスが防止されます。
    * データの署名や暗号化、公開鍵基盤（PKI）を使用した認証などの対策が必要
  * 責任追跡性（Accountability）
    * アクションやイベントの責任が追跡可能である状態を指す
    * 責任追跡性が確保されることで、誰が何を行ったかが記録され、必要に応じて責任を問える。
    * 適切なログの生成と保管、アクセス制御や認証の強化、セキュリティポリシーの徹底
  * 否認防止（NonRepudiation）
    * 送信者が送信を否認できないし、受信者も受信を否認できないことを保証する
    * デジタル署名、トランザクションログ、監査ログ、完全性保護により対応できる。
  * 信頼性（Reliability）
    * システムやプロセスが常に正しく動作し、期待どおりの結果を提供することを指します。
    * 信頼性が確保されることで、ユーザーはシステムやサービスに対して信頼を持つことができます。
    * フォールトトレランス、データの暗号化、アクセス制御により確保できる
  * OECD セキュリティガイドライン
    * 組織や国家レベルで情報セキュリティを向上させるための指針として利用されています。OECDセキュリティガイドラインは、情報セキュリティに関する国際的な基準
    * [IMO]情報がなさすぎる(有効なの？？？)
    * https://www.mofa.go.jp/mofaj/gaiko/oecd/security_gl_a.html
    * https://www.j-cic.com/pdf/report/OECD-Digital-Security.pdf
* （3）脅威
  * マルウェア（Malware）
    * 悪意を持って作成され、コンピューターシステムやデータに対して損害を与えるために設計されたソフトウェア
  * マクロウイルス（Macro Virus）
    * マクロと呼ばれる自動化されたタスクを実行するためのプログラムに悪意を持たせたウイルスの一種
    * マクロは、Microsoft Officeなどのアプリケーション内で使用されるスクリプト言語を指す
  * ルートキット（Rootkit）
    * コンピューターシステムに侵入して不正なアクセスを隠蔽し、システムの管理者権限（ルート権限）を奪取するために設計されたソフトウェアの一種
  * シャドーIT（Shadow IT）
    * 従業員が自身のニーズや業務効率向上のために、自らが導入したり利用したりするITリソースのこと
* （5）不正のメカニズム
  * 不正のトライアングル
    * 機会（Opportunity）
      * 内部統制が弱い、監査が不十分、セキュリティ対策が不足しているなど、不正行為を行うための障壁が低い状況が機会を提供する
    * 動機（Motive）
      * 個人的な利益を得るため、組織や個人に対する不満や不平等感、欲望などが動機となる
    * 合理化（Rationalization）
      * 不正行為を正当化する合理化がある
      * 「組織には十分なお金があり、私にもっと支払われるべきだ」という考え方や、「他の人も同じようなことをしているから」という考え方
  * 状況的犯罪予防（Situational Crime Prevention）
    * 犯罪を防止するために、犯罪が発生する状況や環境を変えることに焦点を当てたアプローチ
* （6）攻撃者の種類，攻撃の動機
  * スクリプトキディ（Script Kiddie）
    * 自分でプログラムを書くことなく、既存のソフトウェアやスクリプトを使って攻撃を行う
  * ボットハーダー（Bot Herder）
    * ボットネット（Botnet）と呼ばれる複数のコンピューターから構成されるネットワークを管理する人物のことを指す
    * ボットハーダーは、悪意のある目的でボットネットを利用し、マルウェアの配信、DDoS攻撃、個人情報の収集などを行う
  * ハクティビズム（Hacktivism）
    * ハッカー（クラッカー）がコンピューターシステムやネットワークに侵入し、政治的、社会的なメッセージを伝えるために行う活動
  * サイバーキルチェーン
    * サイバー攻撃を構成する一連のステップや段階のことを指す
      * 情報収集（Reconnaissance）
        * 攻撃者は、ターゲットに関する情報を収集します。
          * ターゲットのシステムやネットワークの構造、セキュリティ対策、潜在的な脆弱性などが含まれる
      * 侵入（Initial Access）
        * 攻撃者は、収集した情報を元にシステムに侵入するための手段を見つけます。
          * フィッシング攻撃やソーシャルエンジニアリングなどが使われる
      * 内部移動（Lateral Movement）
        * 攻撃者は、侵入したシステム内で権限を拡大し、他のシステムやネットワークに侵入します。
          * 攻撃者はシステム内での動きを制限されることなく活動する
      * 情報収集（Privilege Escalation）
        * 攻撃者は、権限を拡大して管理者権限を取得し、システム内での活動を制御します。
          * 攻撃者はシステム内での行動範囲が拡大し、攻撃の効果を高める
      * 攻撃（Execution）
        * 攻撃者は、目標に対して直接的な攻撃を行います
          * データの破壊、盗難、システムの停止などが含まれる
      * カバーリングトラック（Covering Tracks）
        * 自分の存在や行動を隠すために、ログの改ざんや痕跡の消去などの手段を使います
          * 攻撃が検出される可能性を低く抑えます。
* （7）攻撃手法
  * リバースブルートフォース攻撃（Reverse Brute Force Attack）
    * 一般的なブルートフォース攻撃の逆の手法を指す
    * リバースブルートフォース攻撃では、攻撃者は単一のパスワードを使用して、複数のユーザー名やアカウントに対して試行します。
      * 通常のブルートフォース攻撃では、攻撃者は複数のパスワードを試行し、正しいパスワードを見つけることを目指します。
  * クロスサイトリクエストフォージェリ（Cross-Site Request Forgery、CSRF）
    * Webアプリケーションの脆弱性の一種であり、攻撃者が被害者の認証済みセッションを利用して意図しないリクエストを送信する攻撃手法
    * CSRFトークンを導入することや、リクエストに対してリファラーチェックを行うことなど、対策を講じる必要がある
  * クリックジャッキング（Clickjacking）
    * Webページ上に透明なレイヤーをかぶせておき、その上には意図した操作とは異なるボタンやリンクが配置されているように見せかける攻撃手法
  * ドライブバイダウンロード（Drive-by Download）
    * Webサイトを訪れた際に、ユーザーの許可や知識なしに悪意のあるファイルを自動的にダウンロードさせる攻撃手法
    * 被害者は、特別な操作を行わずにウェブページを閲覧するだけで、コンピューターにマルウェアやスパイウェアがダウンロードされ、感染する可能性あり
      * 被害者が気付かずにマルウェアに感染する可能性が高い
  * MITB（Man-in-the-Browser）
    * ウェブブラウザ内で動作するマルウェアやスクリプトを利用して、ユーザーとウェブサイトとの通信を盗聴または改ざんする攻撃手法
    * 通信がすべてSSL/TLSで暗号化されていても有効な場合がある
    * この攻撃手法は、一般的なアンチウイルスソフトやファイアウォールでは検出しづらいため、セキュリティ対策を強化する必要がある
  * 第三者中継攻撃
    * 攻撃者が通信の途中に立ち入り、通信を傍受、盗聴、または改ざんする攻撃手法
    * ARPスプーフィング、DNSキャッシュポイズニング、SSLストリッピングなど
    * [NOTE]「中間者」は攻撃者を指す場合が多く、「第三者中継」は、通信の中継を行う第三者を指す。
  * IPスプーフィング（IP Spoofing）
    * インターネットプロトコル（IP）を使用してパケットを送信する際に、送信元IPアドレスを偽装する攻撃手法
    * 攻撃者は、偽装されたIPアドレスを使用することで、被害者を欺いたり、攻撃の追跡を難しくすることが可能
    * DDoS攻撃、セキュリティ侵害（偽装してファイアウォールをバイパス）、不正アクセスなど
  * リプレイ攻撃（Replay Attack）
    * 通信を傍受し、後で再送信することで攻撃を行う手法のことを指す
  * DoS（Denial of Service）攻撃
    * システムやネットワークに対して意図的に大量のトラフィックやリクエストを送信することで、正常なサービス提供を妨害する攻撃手法
    * 攻撃手法は、フラッド攻撃、アプリケーションレベルの攻撃（POSTリクエスト）、リソース枯渇攻撃など
    * [NOTE]DoS攻撃は、攻撃者が1つ、DDoSは複数。
  * リフレクション攻撃（Reflection Attack）
    * 攻撃者がネットワーク上の機器やサービスを利用して、攻撃対象のシステムに大量のデータを送信する攻撃手法
    * 攻撃対象のサーバーに代わって他のネットワーク機器やサービスにリクエストを送信し、攻撃対象のサーバーを過負荷状態に陥り、正常な通信を行えなくする
    * 攻撃手法は、DNSリフレクション攻撃、NTPリフレクション攻撃など
  * クリプトジャッキング（Cryptojacking）
    * 悪意のあるウェブサイトやコードが、被害者のコンピューター、スマートフォン、またはその他のデバイスで暗号通貨を採掘するために、そのリソースを不正に利用する攻撃手法
  * サイドチャネル攻撃（Side-channel Attack）
    * コンピューターシステムや暗号アルゴリズムの物理的な実装や動作に関連する情報を利用して、秘密情報を取得する攻撃手法
    * サイドチャネルは、通常の通信チャネルではなく、システムの電力消費、電磁放射、時間などの物理的な側面を指す
    * 攻撃手法は、電力解析攻撃、時間解析攻撃、電磁波解析攻撃、アコースティック解析攻撃など
* （8）情報セキュリティに関する技術
  * ① 暗号技術
    * CRYPTREC 暗号リスト
      * CRYPTREC（暗号技術研究開発推進センター）
        * 日本国内での暗号技術の評価や推進を行う組織であり、政府機関や産業界などが参加しています。CRYPTRECは、安全性や信頼性が確保された暗号技術の普及促進を目的として、暗号技術の評価基準や標準化、評価結果の公表などを行っています。
        * https://www.cryptrec.go.jp/list.html
      * CRYPTRECが発表する暗号技術のリストは、日本国内で推奨される暗号技術の一覧
    * RSA 暗号
      * 公開鍵と秘密鍵のペアを使用して情報を暗号化および復号化する方式です。
      * RSA暗号は計算コストが高いため、他の暗号方式が適している場合もある
    * 楕円曲線暗号（Elliptic Curve Cryptography、ECC）
      * 公開鍵暗号方式の一種であり、楕円曲線上の点の演算を基にしている
      * RSA暗号やDSA（Digital Signature Algorithm）などの従来の公開鍵暗号方式に比べて、同じセキュリティレベルを実現するために必要な鍵の長さが短くて済む
        * 同じセキュリティレベルを実現するための計算コストや通信コストが低くなります。
        * リソースが限られている環境やモバイルデバイスなどで広く利用される
    * Diffie-Hellman（ディフィー・ヘルマン）鍵交換
      * 公開鍵暗号の一種であり、2つの通信者が秘密の共通鍵を共有するために使用するプロトコル
      * インターネット上でセキュアな通信を行うためのプロトコルに広く使用される(SSL/TLS通信、VPN接続)
      * 特徴は、公開鍵暗号、中間者攻撃に対する脆弱性、鍵交換の秘密性がある
    * ハイブリッド暗号
      * 主に情報セキュリティの分野で広く活用している（インターネット通信、電子メール、デジタル署名、VPN、IoT）
      * 公開鍵暗号方式と対称鍵暗号方式の両方の利点を活用し、効率的で安全な通信やデータ保護を実現する
      * ハイブリッド暗号は幅広い分野で使われている一方で、Diffie-Hellman鍵交換は特定の用途やプロトコルにおいて重要な役割
    * SHA-256とAES
      * SHA-256はデータの整合性を確認するためのハッシュ関数であり、AESはデータの機密性を保護するための暗号アルゴリズム
    * 暗号利用モード（Cipher Block Chaining、CBC、Counter、CTR）
      * 対称鍵暗号アルゴリズム（例えばAES）を使ってブロック暗号をストリーム暗号に変換するための方式
      * ブロック暗号をストリーム暗号に変換することの利点
        * 逐次処理と並列処理の容易性
          * ストリーム暗号は、データをブロック単位でなくビット単位で処理できるため、逐次処理や並列処理が容易です。これにより、大容量のデータを効率的に暗号化および復号化できます。
        * ランダムアクセスのサポート
          * ストリーム暗号では、特定の位置からデータの暗号化や復号化を開始できるため、ランダムアクセスが可能です。これは、データベースやファイルシステムなど、ランダムアクセスが必要なアプリケーション(データベースシステム、ファイルシステム、仮想メモリシステム、マルチメディアアプリケーション)で重要です。
        * ストリーム化によるデータの伸縮性
          * ブロック暗号では、データを固定サイズのブロックに分割するため、最後のブロックが不完全な場合にはパディングが必要になります。一方、ストリーム暗号では、データをビット単位で処理できるため、不完全なブロックが発生しないため、パディングが不要です。
        * 暗号強度の向上
          * ストリーム暗号は、暗号鍵や初期化ベクトル（IV）をブロックごとに変更することが可能であり、これにより暗号強度が向上します。ブロック暗号では、同じ鍵とIVを使用して複数のブロックを暗号化する場合、同じ暗号文が生成される可能性がありますが、ストリーム暗号ではこの問題を回避できます。
  * ② 認証技術
    * メッセージ認証（Message Authentication）
      * メッセージが改ざんされていないことを確認するための手法や仕組みのことを指す
      * 通信の一方向性を確保し、データの信頼性を高めるために使用する
      * 方法としては、メッセージ認証コード（MAC）、電子署名など。
    * メッセージ認証コード（MAC）
      * メッセージやデータの完全性を確認するために使用される固定長の暗号学的なタグです。
      * メッセージ送信者は、メッセージと共にMACを受信者に送信します。受信者は、受信したメッセージとMACを使用して、メッセージが改ざんされていないことを確認します。
    * コードサイニング（Code Signing）
      * ソフトウェアやスクリプトなどのコードにデジタル署名を付けるプロセスです。
      * この署名は、コードの提供元を確認し、コードが改ざんされていないことを確認するために使用されます。
      * 提供元の確認、改ざん検出、安全性の向上のような目的でコードサイニングが行われます。
  * ⑤ 公開鍵基盤
    * 公開鍵基盤（Public Key Infrastructure、PKI）
      * 暗号技術を使用してデータのセキュリティを強化するための仕組みやプロセスのことを指します。
      * PKIは、公開鍵暗号方式を基盤としており、デジタル証明書や公開鍵、認証局（CA）などの要素から構成されています。
      * 認証局（Certification Authority、CA）、デジタル証明書（Digital Certificate）、登録機関（Registration Authority、RA）、証明書の管理システム、ディレクトリサービス（Directory Service）、などの要素がある
      * PKIは、データの機密性、完全性、認証性を確保するために広く使用されています。例えば、Webサーバーとブラウザ間の通信、電子メールの暗号化、デジタル署名などに利用されています。
    * コードサイニング証明書（Code Signing Certificate）
      * ソフトウェアやスクリプトなどのコードにデジタル署名を付けるために使用される証明書です。これにより、コードの提供元が確認され、コードが改ざんされていないことが保証されます。
    * ブリッジ認証局
      * 異なるPKI間で信頼関係を築くための中間的な役割を果たします。各PKIは自身のルート証明書に加えて、ブリッジ認証局の証明書も信頼することで、異なるPKI間で信頼関係を確立することができます。
      * ブリッジ認証局は、PKI間の認証を仲介することで、相互運用性を確保します。















