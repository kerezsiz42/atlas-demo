package models

import (
	"time"

	"gorm.io/gorm"
)

type Baz struct {
	gorm.Model
	Name      *string
	Text      string    `gorm:"type:CHAR(255)"`
	Timestamp time.Time `gorm:"not null"`
	FooID     *uint
}
