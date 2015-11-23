.PHONY: init_schema migrate

migrate:
	lapis migrate
	pg_dump -s -U postgres catacombkids > schema.sql
	pg_dump -a -t lapis_migrations -U postgres catacombkids >> schema.sql

init_db:
	-dropdb -U postgres catacombkids
	createdb -U postgres catacombkids
	make migrate
