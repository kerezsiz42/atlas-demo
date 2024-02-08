package main

import (
	"fmt"
	"io"
	"os"

	"github.com/kerezsiz42/atlas-demo/models"

	_ "ariga.io/atlas-go-sdk/recordriver"
	"ariga.io/atlas-provider-gorm/gormschema"
)

// This program outputs sql table definitions based on the current models
func main() {
	stmts, err := gormschema.New("postgres").Load(
		&models.Foo{},
		&models.Bar{},
		&models.Baz{},
	)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to load gorm schema: %v\n", err)
		os.Exit(1)
	}
	io.WriteString(os.Stdout, stmts)
}
