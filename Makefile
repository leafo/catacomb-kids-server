.PHONY: init_schema migrate test_db

SHELL := /bin/bash
CURRENT_DB=$(shell luajit -e 'print(require("lapis.config").get().postgres.database)')

migrate:
	lapis migrate
	pg_dump -s -U postgres catacombkids > schema.sql
	pg_dump -a -t lapis_migrations -U postgres catacombkids >> schema.sql

init_db:
	-dropdb -U postgres catacombkids
	createdb -U postgres catacombkids
	make migrate

# copy dev db schema into test db
test_db::
	-dropdb -U postgres catacombkids_test
	createdb -U postgres catacombkids_test
	pg_dump -s -U postgres $(CURRENT_DB) | psql -U postgres catacombkids_test
	pg_dump -a -t lapis_migrations -U postgres $(CURRENT_DB) | psql -U postgres catacombkids_test


