original OpenTTD repository: https://github.com/OpenTTD/OpenTTD

# openttd-docker
Basic `Dockerfile` to start openttd from pre-built libraries

# build/run

## with `docker build`/`docker run`
```sh
docker build -t "parrrate/openttd-docker" .
docker run \
    --name openttd\
    -v "./config/:/home/openttd/.config/openttd/:ro" \
    -p "3979:3979/tcp" \
    -p "3979:3979/udp" \
    -i \
    -t \
    "parrrate/openttd-docker"
```

## with `docker compose`
```yaml
services:
  openttd:
    build: .
    container_name: openttd
    volumes:
      - './config/:/home/openttd/.config/openttd/:ro'
    ports:
      - '3979:3979/tcp'
      - '3979:3979/udp'
    stdin_open: true
    tty: true
    image: parrrate/openttd-docker
```
```sh
docker compose up -d --build
```

# config
Inside the container, configuration is stored under the path `/home/openttd/.config/openttd/`.

## with `Dockerfile`
```dockerfile
COPY ./config/ /home/openttd/.config/openttd/
```

## with `docker run`
```sh
docker run -v ./config/:/home/openttd/.config/openttd/:ro ...
```

## with `docker-compose.yml`
```yaml
volumes:
  - './config/:/home/openttd/.config/openttd/:ro'
```

# ports

## with `docker run`
```sh
docker run -p "3979:3979/tcp" -p "3979:3979/udp" ...
```

## with `docker-compose.yml`
```yaml
ports:
  - '3979:3979/tcp'
  - '3979:3979/udp'
```
