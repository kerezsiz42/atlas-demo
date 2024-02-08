package models

import "gorm.io/gorm"

type Foo struct {
	gorm.Model
	Name   string `gorm:"not null"`
	Number *int   // `gorm:"not null"`
	IsTrue bool   `gorm:"not null"`
	Bazs   []Baz  `gorm:"foreignKey:FooID"`
}
