#### La empresa CashToday quiere ofrecer envío de remesas online a todas las personas de Estados Unidos hacia diferentes países de LATAM, desde su dispositivo móvil. Para esto la empresa contrato una empresa de desarrollo que creará una APP en React Native, la empresa CashToday necesitará proveer una API con los endpoints necesarios para realizar la búsqueda de sus clientes. Y te pide a ti como Lead del equipo de BE que diseñes y crees la solución.

Datos Técnicos:

1. Diseña la base de datos que necesitarías implementar para la solución (solo debes implementar la parte del cliente)
2. Los datos de clientes deberán estar almacenados en DynamoDb (diseña su definición y toma en cuenta los datos que se utilizarán para búsquedas masivas de datos) los datos mínimos de búsqueda deben ser, codigo postal, país, ciudad, Numero de identificación y nombre + apellido
3. Debes diseñar y construir una API Serverless (Lambda) con 4 endpoints para buscar, eliminar, agregar y modificar clientes.
4. Debes poder subir una foto temporal de un cliente la cual se debe eliminar de forma automática después 3 dias

Entregables.

- Envía un documento con la descripción de tu solución con los pros y contras de tu implementación.
- Adjunta un diagrama de la solución general de tu implementación.
- Copia de tu código generado (puede ser en un repo o en un zip file)
- Acceso a la cuenta en donde desplegaste la infraestructura de tu solución y sea testeable
1. Describe que medidas de seguridad implementarias en la solución anterior para protección de datos en reposo y en transito
2. Describe que herramientas implementarías para llevar control de los logs y poder monitorear tu solución.

Que evaluaremos:

- Uso de correcto de Clean Code, SOLID y 12 factor app
- Implementación correcta del AWS Well-Architected y los seis pilares
- Uso de IAC para la implementación de la solución. (CDK, SAM, Serverless Framework, etc). Toda la infraestructura que utilices deberá estar definida acá.