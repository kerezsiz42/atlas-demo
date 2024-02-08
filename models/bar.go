package models

import "github.com/google/uuid"

type Bar struct {
	ID   uuid.UUID `gorm:"type:uuid; primaryKey"`
	Name string    `gorm:"not null"`
	// Bazs []Baz `gorm:"many2many:bar_baz"`
}
