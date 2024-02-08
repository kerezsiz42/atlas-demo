# The atlas.go program outputs the desired state based on gorm models
data "external_schema" "gorm" {
  program = ["go", "run", "cmd/atlas/atlas.go"]
}

env "gorm" {
  src = data.external_schema.gorm.url
  # Connection string of our dev database
  dev = "postgres://user:password@localhost:5432/dev?sslmode=disable"
  migration {
    dir = "file://migrations"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}