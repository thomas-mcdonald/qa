apt-get -yq install postgresql postgresql-contrib-9.1 libpq-dev postgresql-server-dev-9.1
su postgres -c "createuser --createdb --superuser -Upostgres vagrant"
su postgres -c "psql -c \"ALTER USER vagrant WITH PASSWORD 'password';\""
su postgres -c "psql -c \"create database qa_development owner vagrant encoding 'UTF8' TEMPLATE template0;\""
su postgres -c "psql -c \"create database qa_test        owner vagrant encoding 'UTF8' TEMPLATE template0;\""
su postgres -c "psql -d qa_development -c \"CREATE EXTENSION hstore;\""