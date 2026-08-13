FROM debian:bullseye
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y postgresql postgresql-contrib python3 python3-pip python3-venv bash && \
    rm -rf /var/lib/apt/lists/*
RUN service postgresql start && \
    su - postgres -c "psql -c \"ALTER USER postgres WITH PASSWORD 'postgres';\"" && \
    su - postgres -c "psql -c \"CREATE DATABASE testdb;\""

WORKDIR /prizm-app
RUN echo 'SECRET_KEY="your key"\n DATABASE_URL="postgresql://username:password@127.0.0.1:5432/testdb"' > .env
#or
# ENV SECRET_KEY="your key" 
# ENV DATABASE_URL="postgresql://your username for db or default -> postgres:your password for user @127.0.0.1:5432/testdb"
RUN python3 -m venv env
COPY . /prizm-app
SHELL ["/bin/bash", "-c"]
RUN source env/bin/activate
RUN python3 -m pip install -r requirements.txt
ENV FLASK_APP=prizm:create_app
ENV FLASK_ENV=development 
EXPOSE 5000
EXPOSE 5432
CMD ["bash", "-c", "service postgresql start && exec flask run --host=0.0.0.0 --port=5000"]



