# Liferay Docker Template

- [Liferay Docker Template](#liferay-docker-template)
  - [Versioni](#versioni)
  - [Struttura Cartelle](#struttura-cartelle)
  - [Comandi Principali](#comandi-principali)
    - [CLI](#cli)
    - [Docker Compose](#docker-compose)
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

## Comandi Principali

### [CLI](doc/CLI.md)

### [Docker Compose](doc/Compose.md)

---

## FAQ

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

  È possibile far eseguire qualsiasi comando al patching-tool e sovrascriverne direttamente i files inserendoli in `mount/files/patching-tool`.
</details>

---

## Link Utili

- Docker CLI Documentazione: https://docs.docker.com/engine/reference/commandline/cli/
- Tabella Compatibilità: https://www.liferay.com/it/compatibility-matrix
- Liferay Docker: https://hub.docker.com/u/liferay
- Liferay CE Docker: https://hub.docker.com/r/liferay/portal
- Liferay DXP Docker: https://hub.docker.com/r/liferay/dxp
- Liferay Portal Properties: https://docs.liferay.com/portal/
- Lista Porte TCP/UDP conosciute: https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers