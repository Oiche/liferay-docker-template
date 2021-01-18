# CLI

> Per utilizzare gli stessi comandi su Windows bisogna o rimuovere i ritorni a capo (i backslash) e sostiturli con i caratteri indicati di seguito senza lo spazio finale:
>
> Powershell: ` backtick o accento grave
> 
> Batch: ^ circumflex o accento circonflesso
>
> Inoltre per batch è necessario sostituire `$(pwd)` con `%cd%`

Namespace utilizzato: project-name

## 1. Creazione rete

```shell
docker network create project-name_liferay-network
```

## 2. Creazione volumi

```shell
docker volume create project-name_database-data
docker volume create project-name_liferay-document-library
docker volume create project-name_liferay-configs
docker volume create project-name_liferay-modules
docker volume create project-name_liferay-war
```

## 3. Creazione container Postgres

```shell
docker create \ 
  --name project-name_postgres \ 
  --hostname postgres \ 
  --env POSTGRES_USER=puser \ 
  --env POSTGRES_PASSWORD=ppsw \ 
  --env POSTGRES_DB=lportal \ 
  --publish 20001:5432 \ 
  --volume project-name_database-data:/var/lib/postgresql/data \ 
  --network project-name_liferay-network \ 
  postgres:12
```

## 4. Creazione container Liferay

```shell
docker create \ 
  --name project-name_liferay \ 
  --hostname liferay \ 
  --env JPDA_ADDRESS=0.0.0.0:8000 \ 
  --env LIFERAY_JPDA_ENABLED=true \ 
  --publish 20002:8080 \ 
  --publish 20003:8000 \ 
  --publish 20004:11311 \ 
  --volume $(pwd)/mount:/mnt/liferay \ 
  --volume project-name_liferay-document-library:/opt/liferay/data/document_library \ 
  --volume project-name_liferay-configs:/opt/liferay/osgi/configs \ 
  --volume project-name_liferay-modules:/opt/liferay/osgi/modules \ 
  --volume project-name_liferay-war:/opt/liferay/osgi/war \ 
  --network project-name_liferay-network \ 
  liferay/portal:7.3.5-ga6
```

## 5. Avvio containers

```shell
docker start project-name_postgres
docker start project-name_liferay
```

## 6. Lettura dei logs

```shell
docker logs \ 
  --follow \ 
  --since 1m \ 
  project-name_liferay
```