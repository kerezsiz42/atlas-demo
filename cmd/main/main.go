package main

import (
	"github.com/google/uuid"
	"github.com/kerezsiz42/atlas-demo/models"
	util "github.com/kerezsiz42/atlas-demo/utils"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	dsn := "host=localhost user=user password=password dbname=postgres port=5432 sslmode=disable"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err)
	}

	bar := &models.Bar{ID: uuid.New()}
	db.Create(bar)

	baz := &models.Baz{Name: util.Ptr("baz"), Text: "asdf1234"}
	db.Create(baz)

	foo := &models.Foo{Name: "foo", Number: nil, IsTrue: false, Bazs: []models.Baz{*baz}}
	db.Create(foo)
}
