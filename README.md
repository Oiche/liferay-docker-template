# Liferay Docker Template

- [Liferay Docker Template](#liferay-docker-template)
  - [Versioni](#versioni)
  - [Struttura Cartelle](#struttura-cartelle)
  - [Configurazione](#configurazione)
  - [Comandi Principali](#comandi-principali)
    - [Creare ed avviare i container](#creare-ed-avviare-i-container)
    - [Cancellare i container e le reti mantenendo i volumi](#cancellare-i-container-e-le-reti-mantenendo-i-volumi)
    - [Fermare i container senza cancellarli](#fermare-i-container-senza-cancellarli)
    - [Avviare i container](#avviare-i-container)
    - [Vedere i logs](#vedere-i-logs)
    - [Collegarsi alla shell](#collegarsi-alla-shell)
  - [FAQ](#faq)
  - [Link Utili](#link-utili)

## Versioni

Versioni immagini utilizzate nel `docker-compose.yml`:

- Liferay: 7.3.5-ga6
- Postgres: 12

> Prese dalla [Tabella Compatibilità](https://www.liferay.com/it/compatibility-matrix)

## Struttura Cartelle

- mount
  - deploy
  - files
    - [portal-developer.properties](mount/files/portal-developer.properties)
    - [portal-ext.properties](mount/files/portal-ext.properties)
    - [portal-runtime.properties](mount/files/portal-runtime.properties)
    - [portal-setup-wizard.properties](mount/files/portal-setup-wizard.properties)
  - scripts
- [docker-compose.yml](docker-compose.yml)
- [patch.sh](patch.sh)

`deploy`: Cartella per il rilascio di pacchetti, licenze, etc.

`files`: Cartella per sovrascrivere i files di configurazione o dati come file properties, configurazione, etc.

`scripts`: Contiene script da lanciare prima dell'avvio di liferay.

---

## Configurazione

1. Aprire il file `docker-compose.yml`
2. Modificare i tag (versioni) delle immagini
3. Modificare le porte dell'host
   > Consigliato l'utilizzo di porte nel range [20001 e 20559](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) poichè non utilizzate da altri programmi conosciuti.
4. Aprire il file `portal-runtime.properties`
5. Personalizzare le properties jdbc

---

## Comandi Principali

Lista dei principali comandi da terminale di Docker Compose.

Per maggiori informazioni consultare la [documentazione](https://docs.docker.com/compose/reference/) o utilizzare il parametro `--help`.

Esempio: `docker-compose up --help`

### Creare ed avviare i container

```
docker-compose up
```
> Aggiungere `-d` o `--detach` per avviare i container in background

### Cancellare i container e le reti mantenendo i volumi

```
docker-compose down
```

> Aggiungere `-v` o `--volumes` per cancellare anche i volumi.

###  Fermare i container senza cancellarli

```
docker-compose stop
```

###  Avviare i container

```
docker-compose start
```

### Vedere i logs

```
docker-compose logs --follow nome-servizio
```

> Alias di `--follow` è `-f` per rimanere in lettura dell'output.

### Collegarsi alla shell

```
docker-compose exec --interactive nome-servizio /bin/bash
```

> Un'alternativa è `/bin/sh`

---

## FAQ

<details>
  <summary>Se non utilizzo Postgres?</summary>

  > Ricordarsi di modificare anche il file `portal-runtime.properties`

  MariaDB
  ```yaml
  mariadb:
    image: mariadb:10.4
    environment:
      - MYSQL_DATABASE=lportal
      - MYSQL_ROOT_PASSWORD=ppsw
    ports:
      - "20001:3306"
    volumes:
      - database-data:/var/lib/mysql
    networks:
      - liferay-network
  ```

  MySQL
  ```yaml
  mysql:
    image: mysql:8
    command: --default-authentication-plugin=mysql_native_password
    environment:
      - MYSQL_DATABASE=lportal
      - MYSQL_ROOT_PASSWORD=ppsw
    ports:
      - "20001:3306"
    volumes:
      - database-data:/var/lib/mysql
    networks:
      - liferay-network
  ```

  Oracle DB

  > Rimando ad un articolo di Antonio Musarra riguardo la creazione di immagini e configurazione iniziale: [How to setup Docker container Oracle Database 19c for Liferay Development Environment](https://www.dontesta.it/2020/03/15/how-to-setup-docker-container-oracle-database-19c-for-liferay-development-environment/)

  ```yaml
  oracle:
    image: oracle/database:19.3.0-ee
    environment:
	    - ORACLE_SID=ORALFRDEV
	    - ORACLE_PDB=ORALFRDEVPDB
      - ORACLE_PWD=LwB_27i5Wi8=1
    ports:
      - "20001:1521"
    volumes:
      - database-data:/opt/oracle/oradata
      - ./sql:/opt/oracle/scripts/setup
      # Ricordarsi di creare la cartella sql nel percorso corrente
    networks:
      - liferay-network 
  ```

  SQL Server

  > Rimando ad un articolo di Antonio Musarra riguardo la creazione di immagini e configurazione iniziale: [How to setup Docker container SQL Server 2017 for Liferay Development Environment](https://www.dontesta.it/2019/10/03/how-to-setup-docker-container-sql-server-2017-for-liferay-development-environment/)

  ```yaml
  oracle:
    image: mcr.microsoft.com/mssql/server:2017-latest
    environment:
	    - ACCEPT_EULA=Y
	    - SA_PASSWORD=ppsw
    ports:
      - "20001:1433"
    volumes:
      - database-data:/var/opt/mssql
    networks:
      - liferay-network 
  ```
</details>

<details>
  <summary>Come posso ricreare lo stesso ambiente con Docker senza Compose?</summary>

  È possibile trovare tutta la lista di comandi [qui](CLI.md)
</details>

<details>
  <summary>Come posso gestire far aspettare a Liferay l'avvio del Database?</summary>

  In generale non è necessario regolare l'ordine d'avvio dei container.
  Tuttavia alcune versioni vecchie di Liferay vanno in crash se non riescono a connettersi al database nell'immediato.

  Per risolvere questo problema si possono utilizzare degli script appositi come [wait-for](https://github.com/eficode/wait-for) e [wait-for-it](https://github.com/vishnubob/wait-for-it).

  Per fare un esempio utilizzerò `wait-for` scaricando il file dalla repository ed inserendolo nella cartella `mount/files` e modificando il file `docker-compose.yml` aggiungendo la proprietà sottostante al servizio `liferay`.

  ```yaml
  entrypoint: 
    - /bin/sh
    - -c
    - '/mnt/liferay/files/wait-for postgres:5432 -- /usr/local/bin/liferay_entrypoint.sh'
  ```

  In questo modo viene eseguito l'entrypoint originale di Liferay solo una volta diventato disponibile il database.
</details>

<details>
  <summary>DXP: Come installo i fixpack?</summary>

  Per installare i fixpack è bisogna inserirli nella cartella `mount/files/patching-tool/patches` ed incollare il file `patch.sh` nella cartella `mount/files/scripts`.

  È possibile far eseguire qualsiasi comando al patching-tool o sovrascriverne i files inserendoli nella cartella `mount/files/patching-tool`.
</details>

---

## Link Utili

- Docker CLI Documentazione: https://docs.docker.com/engine/reference/commandline/cli/
- Docker Compose CLI Documentazione: https://docs.docker.com/compose/reference/
- Tabella Compatibilità: https://www.liferay.com/it/compatibility-matrix
- Liferay Docker: https://hub.docker.com/u/liferay
- Liferay CE Docker: https://hub.docker.com/r/liferay/portal
- Liferay DXP Docker: https://hub.docker.com/r/liferay/dxp
- Liferay Portal Properties: https://docs.liferay.com/portal/
- Lista Porte TCP/UDP conosciute: https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers