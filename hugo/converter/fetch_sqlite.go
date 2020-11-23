package test

import (
	"bufio"
	"context"
	"io"
	"log"
	"os"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

var outputFolder = "../content/posts"

func main() {
	credentialFilePath := "../gpf_api.json"

	// クライアントを作成する
	ctx := context.Background()
	client, err := storage.NewClient(ctx, option.WithCredentialsFile(credentialFilePath))
	if err != nil {
		log.Fatal(err)
	}

	// GCSオブジェクトを書き込むファイルの作成
	f, err := os.Create("sample.sqlite3")
	if err != nil {
		log.Fatal(err)
	}

	// オブジェクトのReaderを作成
	bucketName := "blog.v41.me"
	objectPath := "databases/web/db_20200419.sqlite3"
	obj := client.Bucket(bucketName).Object(objectPath)
	reader, err := obj.NewReader(ctx)
	if err != nil {
		log.Fatal(err)
	}
	defer reader.Close()

	// 書き込み
	tee := io.TeeReader(reader, f)
	s := bufio.NewScanner(tee)
	for s.Scan() {
	}
	if err := s.Err(); err != nil {
		log.Fatal(err)
	}

	log.Println("done")
}
