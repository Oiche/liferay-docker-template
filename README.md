# Docker



## Struttura Cartelle

- project-name
  - mount
    - deploy
    - files
      - [portal-developer.properties](project-name/mount/files/portal-developer.properties)
      - [portal-ext.properties](project-name/mount/files/portal-ext.properties)
      - [portal-runtime.properties](project-name/mount/files/portal-runtime.properties)
      - [portal-setup-wizard.properties](project-name/mount/files/portal-setup-wizard.properties)
    - scripts
  - [docker-compose.yml](project-name/docker-compose.yml)

```deploy```: Cartella per il rilascio di pacchetti, licenze, etc.

```files```: Cartella per sovrascrivere i files di configurazione o dati come file properties, configurazione.

```scripts```: Contiene script da lanciare prima dell'avvio di liferay.

---

## CLI

> Per utilizzare gli stessi comandi su Windows bisogna o rimuovere i ritorni a capo (i backslash) o sostiturli con gli relativi caratteri senza lo spazio finale:
>
> Powershell: ` backtick o accento grave
> 
> Batch: ^ circumflex o accento circonflesso
>
> Inoltre per batch è necessario sostituire ```$(pwd)``` con ```%cd%```

### Crea ed avvia un container

```shell
docker run \ 
    --detach \ 
    --name liferay-nome-container \ 
    --publish 20001:8080 \ 
    --publish 20002:8000 \ 
    --publish 20003:11311 \ 
    --volume $(pwd)/mount:/mnt/liferay \ 
    nome-immagine
```

```--detach```  viene utilizzato per evitare di visualizzare direttamente l'output relativo al container e permettendo così di continuare ad utilizzare il terminale.

```--name nome-container``` viene utilizzato per dare un nome semplice da ricordare.

```--publish LOCALE:CONTAINER``` permette di legare una porta locale scelta con una delle porte esposte dal container.

```--volume LOCALE:CONTAINER``` permette la creazione di un volume per la copia dei file locali nel container. (LOCALE e CONTAINER sono dei percorsi assoluti)

```nome-immagine``` è composto da ```nome-repository``` e ```tag``` uniti dai due punti. Esempio: ```liferay/portal:7.3.5-ga6```

> È possibile aggiungere anche i seguenti parametri:
> 
> ```--rm``` per dire a docker di cancellare il container non appena viene fermato.
> 
> ```--env``` per impostare delle variabili d'ambiente.
> 
> Esempio:
> ```
>  --env JPDA_ADDRESS=0.0.0.0:8000 
>  --env LIFERAY_JPDA_ENABLED=true
> ```
> 
> Per impostare le variabili d'ambiente che attivano l'interfaccia di debug.

### Avvia il container

```shell
docker start \ 
  liferay-nome-container
```

### Ferma il container

```shell
docker stop \ 
  liferay-nome-container
```

### Mostra i log

```shell
docker logs \ 
    --follow \ 
    --since 1m \ 
    liferay-nome-container
```

```--follow``` viene utilizzato per continuare a leggere l'output del container.

```--since TEMPO``` viene utilizzato per leggere solo l'output vecchio di un certo tempo (1 minuto in questo caso). Permette di non dover visualizzare tutto l'output precedente prima di arrivare alla fine.

### Entra in SHELL

```shell
docker exec \ 
    --interactive \ 
    --tty \ 
    liferay-nome-container \ 
    /bin/bash
```

```--interactive``` e ```--tty``` permettono di mantere attivo l'input dell'utente dopo l'esecuzione del comando, che in questo caso è la shell.

---

## Compose



---

## Link Utili

- Docker CLI Documentazione: https://docs.docker.com/engine/reference/commandline/cli/
- Tabella Compatibilità: https://www.liferay.com/it/compatibility-matrix
- Liferay Docker: https://hub.docker.com/u/liferay
- Liferay CE Docker: https://hub.docker.com/r/liferay/portal
- Liferay DXP Docker: https://hub.docker.com/r/liferay/dxp
- Liferay Portal Properties: https://docs.liferay.com/portal/