.PHONY: start-db
start-db: ## Start postgres and pgadmin
	docker compose up -d database pgadmin

.PHONY: stop-db
stop-db: ## Stop postgres and pgadmin
	docker compose down database pgadmin

.PHONY: clear-db
clear-db: stop-db ## Remove all postgres data from the volume
	rm -rf ./postgres-data

.PHONY: run
run:
	go run cmd/main/main.go

.PHONY: migrate-diff
migrate-diff: ## Create and populate the next sql file in migrations folder if there is a difference between models and the currently available migration files
	atlas migrate diff --env gorm

.PHONY: migrate-status
migrate-status:
	atlas migrate status --url $$PROD_DATABASE_URL

.PHONY: migrate-apply
migrate-apply:
	atlas migrate apply --url $$PROD_DATABASE_URL