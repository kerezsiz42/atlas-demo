-- Create "bars" table
CREATE TABLE "public"."bars" (
  "id" uuid NOT NULL,
  "name" text NOT NULL,
  PRIMARY KEY ("id")
);
-- Create "foos" table
CREATE TABLE "public"."foos" (
  "id" bigserial NOT NULL,
  "created_at" timestamptz NULL,
  "updated_at" timestamptz NULL,
  "deleted_at" timestamptz NULL,
  "name" text NOT NULL,
  "number" bigint NULL,
  "is_true" boolean NOT NULL,
  PRIMARY KEY ("id")
);
-- Create index "idx_foos_deleted_at" to table: "foos"
CREATE INDEX "idx_foos_deleted_at" ON "public"."foos" ("deleted_at");
-- Create "bazs" table
CREATE TABLE "public"."bazs" (
  "id" bigserial NOT NULL,
  "created_at" timestamptz NULL,
  "updated_at" timestamptz NULL,
  "deleted_at" timestamptz NULL,
  "name" text NULL,
  "text" character(255) NULL,
  "timestamp" timestamptz NOT NULL,
  "foo_id" bigint NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_foos_bazs" FOREIGN KEY ("foo_id") REFERENCES "public"."foos" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Create index "idx_bazs_deleted_at" to table: "bazs"
CREATE INDEX "idx_bazs_deleted_at" ON "public"."bazs" ("deleted_at");
