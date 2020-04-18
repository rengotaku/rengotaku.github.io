package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

var outputFolder = "../content/posts"

type Post struct {
	ID         int        `gorm:"AUTO_INCREMENT" json:"id"`
	Title      string     `json:title`
	Content    string     `json:content`
	IsDraft    bool       `json:is_draft`
	CreatedAt  *time.Time `json:created_at`
	UpdatedAt  *time.Time `json:updated_at`
	Uuid       string     `json:uuid`
	RawContent string     `json:raw_content`
	IsPrivate  bool       `json:is_private`
	Tags       string     `json:tags`
}

func init() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, `Usage of %s:
%s [database name]
`, os.Args[0], os.Args[0])
		flag.PrintDefaults()
	}
}

func main() {
	flag.Parse()
	if flag.NArg() < 1 {
		flag.Usage()
		return
	}
	args := flag.Args()
	dbName := args[0]

	os.Mkdir(outputFolder, 0777)

	db, err := connection(dbName)
	if err != nil {
		panic(err)
		return
	}
	defer db.Close()

	rows, err := db.Raw("select p.*, group_concat(t.name) as tags from posts as p inner join tag_relationships as tr on tr.post_id = p.id inner join tags as t on t.id = tr.tag_id group by p.id").Rows()
	defer rows.Close()
	for rows.Next() {
		var post Post
		db.ScanRows(rows, &post)
		fmt.Println(fmt.Sprintf("%s/%d.md", outputFolder, post.ID))
		file, err := os.Create(fmt.Sprintf("%s/%d.md", outputFolder, post.ID))
		if err != nil {
			// Openエラー処理
		}
		defer file.Close()

		file.Write(([]byte)(formatToMarkDown(&post)))
	}
}

func connection(name string) (*gorm.DB, error) {
	db, err := gorm.Open("sqlite3", name)
	if err != nil {
		return nil, err
	}

	return db, nil
}

func formatToMarkDown(post *Post) string {
	keywords := strings.Split(post.Tags, ",")
	keywords = append(keywords, "ベジプロ")
	keywords = append(keywords, "プログ")
	keywords = append(keywords, "プログラム")

	return fmt.Sprintf(`---
title: "%s"
draft: %t
tags: [%s]
private: %t
slug: "%s"
date: "%s"
lastmod: "%s"
keywords: [%s]
# headless: true
---

%s
`, safeEncode(post.Title), post.IsDraft, concatWithQuotation(strings.Split(post.Tags, ",")), post.IsPrivate, post.Uuid, toJst(post.CreatedAt), toJst(post.UpdatedAt), concatWithQuotation(keywords), post.Content)
}

func concatWithQuotation(arr []string) string {
	var rel []string
	for _, v := range arr {
		rel = append(rel, "\""+v+"\"")
	}

	return strings.Join(rel, ",")
}

func safeEncode(be string) string {
	af := strings.Replace(be, "\\", "\\\\", -1)
	af = strings.Replace(af, "\"", "\\\"", -1)
	return af
}

func toJst(t *time.Time) *time.Time {
	jst := time.FixedZone("Asia/Tokyo", 9*60*60)
	tt := t.In(jst)
	return &tt
}
