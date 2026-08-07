# Jenkins Pipeline Challenge — README
==================================

## Resumen
-------
Esta entrega contiene:
 - Jenkinsfile    (Declarative Pipeline, Groovy)
 - monitor_npp.sh (helper Bash script)
 - README.txt     (este archivo)

## Objetivo
--------
Automatizar el monitoreo de la liberación de una nueva versión de Notepad++ Portable,
seguir la lógica de lock file y notificar por email los cambios conforme al brief. (brief original: Jenkins Pipeline Challenge). Referencia: :contentReference[oaicite:1]{index=1}

## Arquitectura y flujo
--------------------
1. Jenkins job ejecuta el `Jenkinsfile` en un agente Linux.
2. `monitor_npp.sh` realiza toda la lógica:
   - Si existe lock file:
     - verifica su antigüedad.
     - si >= 15 días: descarga latest + previous, extrae y genera `diff -ru` y envía email con los cambios.
     - si < 15 días: no hace nada.
   - Si no existe lock file:
     - descarga previous y latest.
     - compara por sha256 y luego por diff de contenidos extraídos.
     - si hay diferencia: crea lock file (timestamp + hashes), envía email de alerta informando que en 15 días se hará el diff y guarda el latest como artefacto (latest_npp.zip).
     - si no hay diferencia: no hace nada.
3. Limpieza de archivos temporales con `trap` y en el `post` del pipeline.

Decisiones y supuestos importantes
----------------------------------
 - Asumo un agente Linux con utilidades: curl, unzip o 7z, diff, mailx, sha256sum, stat.
 - El archivo "previous" puede ser un archivo dentro del workspace (p.ej. named `previous_notepadpp.zip`)
   o una URL. Esto permite inyectar la versión previa literal que indica el brief.
 - Para descarga robusta uso `curl --retry`, `--max-time` y `--fail`.
 - Para comparaciones uso hash (sha256) como chequeo rápido y `diff -ru` de los directorios extraídos
   para ver cambios de contenido/archivos.
 - El lock file es idempotente y contiene timestamp + hashes; su presencia evita re-alertas inmediatas.
 - En el primer hallazgo (no lock), se crea el lock e inmediatamente se notifica que en 15 días se enviará
   el diff. Esto sigue la lógica del brief: "If different, create the lock file, send an email alerting to the update in 15 days and exit."
 - Si tu entorno no tiene `mailx`, el script volcará el cuerpo del email a stdout y al archivo `mail_body.txt`.

Cómo ejecutar localmente (sin Jenkins)
--------------------------------------
1. Coloca `monitor_npp.sh` y el archivo `previous_notepadpp.zip` (o apunta a una URL real) en un directorio.
2. Ejecuta:
```bash
./monitor_npp.sh --download-url "https://.../notepadpp_portable.zip" \
                 --previous-archive "./previous_notepadpp.zip" \
                 --lock-file "./npp_update.lock" \
                 --email-to "you@domain.com" \
                 --tmpdir "./tmp_npp"
```
3. Revisa `monitor_output.log` y los artefactos (latest_npp.zip) para diagnóstico.

Cómo integrar en Jenkins
------------------------
 - Crea un job pipeline que use el `Jenkinsfile` (colocado en el repo).
 - Asegura que el agente tenga las utilidades requeridas y acceso saliente para descargar.
 - Define/envía variables si necesitas cambiar defaults:
   - NPP_DOWNLOAD_URL, PREVIOUS_ARCHIVE, LOCK_FILE, EMAIL_TO

Pruebas y notas
---------------
 - El pipeline y script están diseñados para ser idempotentes y tolerantes a re-ejecuciones.
 - Logs claros: se escriben mensajes como "Lock found", "hash changed", "email sent".
 - Si quieres pruebas automáticas, puedes simular `PREVIOUS_ARCHIVE` con dos archivos ZIP en el workspace
   y ejecutar la pipeline varias veces para ver la creación y expiración del lock.

Contacto
--------
Si necesitas que ajuste la notificación (adjuntar zip, usar SMTP credential store de Jenkins, usar plugins de correo),
o convertir el README a PDF / DOCX, lo preparo y lo subo inmediatamente.

-- Fin README --

----

# Workflow

1. Jenkinsfile (Declarative Pipeline — Groovy)

Nota: Si no usas libraryResource, simplemente sube monitor_npp.sh en el mismo repositorio que este Jenkinsfile. El writeFile con libraryResource es un placeholder que no rompe si no existe; el sh intentará ejecutar el script que esté en workspace.

2. monitor_npp.sh — helper script (bash)

Guarda este contenido como monitor_npp.sh. Explica/resuelve la lógica de lock file, descarga robusta (retries, timeout), comparación (hash + diff of extracted contents), envío de emails via mailx, limpieza e idempotencia.

Comentarios sobre el script:

- Usa curl con --retry, --max-time para descargas robustas.
- Detecta si unzip o 7z están disponibles y extrae según corresponda.
- Compara primero por sha256; si distinto, hace diff -ru de los contenidos extraídos.
- Si no hay lock y detecta cambio, crea lock con timestamp + hashes y envía correo alertando que dentro de 15 días se enviará el diff.
- Si lock existe y tiene ≥15 días, descarga latest y prev, hace diff y envía correo con el diff.
- Limpieza ejecutada vía trap cleanup EXIT y también en el post del Jenkinsfile.
- Salidas y logs claros (echo/log) para facilitar debugging en Jenkins console.

3. README (README.txt)

Guarda como README.txt (o README.pdf/README.docx si prefieres). Aquí está la versión en texto:

----

Notas finales / recomendaciones prácticas

1. Credenciales SMTP / mailx: en entornos reales usa las credenciales SMTP del servidor o el plugin de correo de Jenkins (o mail step). Aquí usé mailx por simplicidad, asumiendo que está configurado en el nodo.

2. Extracción de archives: he intentado cubrir unzip y 7z. Si tu notepad++ portable está empaquetado de otra forma, ajusta la función extract_archive.

3. Permisos: asegúrate de que Jenkins tenga permisos de escritura en workspace y que el lock file quede en el lugar donde quieras persistirlo entre ejecuciones (workspace vs NFS/shared path).

4. Persistencia del previous archive: en el brief se permite usar la "literal previous version". Lo más simple en Jenkins es mantener previous_notepadpp.zip en el repo o en un artifact storage que el script pueda leer.

5. Mejoras posibles:

- Subir latest_npp.zip a artifact repository o storage y versionarlo.
- Usar mail plugin de Jenkins y credenciales gestionadas.
- Añadir un parámetro de job para --force-diff para debug.