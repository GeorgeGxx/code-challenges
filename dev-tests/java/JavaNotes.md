# Notas Dev

## Conceptos para Java

### POO: // Programación Orienta a Comportamiento

Es un paradigma de programación que usa objetos para crear aplicaciones.

- Abstracción: Consiste en seleccionar datos de un conjunto más grande para mostrar solo los detalles relevantes del objeto. Ayuda a reducir la complejidad y el esfuerzo de programación. En Java, la abstracción se logra usando clases e interfaces abstractas.

- Polimorfismo: Es cuando un mismo identificador comparte varios significados diferentes, Inyección de dependencias, Autowired en el Controller para no tener issues en Unit Testing.

- Herencia: Consiste en que una clase puede heredar las variables y los métodos de otra clase, Super, clase principal, subclase con extends accede a todos los miembros.

- Does Java have multiple inheritance?
  - Java no permite la herencia múltiple para evitar la complejidad y ambigüedad asociadas a ella, particularmente el "problema del diamante", donde una clase hereda de dos clases que tienen un ancestro común, lo que genera conflictos en la herencia de métodos.

- Encapsulamiento: Consiste en ocultar atributos de un objeto de manera que solo se pueda cambiar mediante operaciones definidas en ese objeto. Está estrechamente relacionado con la visibilidad, Public, Protected, Private, no declarado.

---

### `Elementos`

- Objeto: Es lo mismo que un objeto en el mundo real, en un sistema de compra sería el carrito de compras, cliente y producto.
  
  - Dentro de un Objeto hay Atributos (Estado), Comportamiento (Funciones) y dentro de una clase hay metodos y objetos, Constructor.

- Atributos: Campos, componentes de un objeto que almacenan datos.

- Clase: Es una plantilla que define la forma de un objeto; en ella se agrupan datos y métodos que operarán sobre esos datos.
  
  - Ellipsis o ...: VarArgs dentro del método es como si fuera un array.

- POJO: Es una instancia de una clase que no extiende ni implementa nada en especial, sirve para enfatizar el uso de clases simples y que no dependen de un framework en especial.

- Clase abstracta: Declara la existencia de métodos pero no la implementación de dichos métodos (o sea, las llaves { } y las sentencias entre ellas), una clase común la cual posee atributos, métodos, constructores y por lo menos un método abstracto. Una clase abstracta no puede ser instanciada, solo heredada.

- Which are the members of a class?: Fields and Methods / Campos y metodos

- Por valor: 
  - Cuando los argumentos son pasados por valor a los métodos, significa que se realiza una copia de la variable y esta es enviada al método y no la original, entonces todo los cambios realizados dentro del método solo afectan a la copia actual.

- Por referencia: 
  - Cuando los argumentos son pasados por referencia, significa que la referencia o el puntero a la variable original son pasadas a los métodos y no la data original.

- Clase abstracta vs Interface:
  
  - Una clase abstracta puede heredar o extender cualquier clase (independientemente de que esta sea abstracta o no), mientras que una interfaz solamente puede extender o implementar otras interfaces.
  
  - Las interfaces funcionales son interfaces que tienen un método a implementar, es decir, un método abstracto.
  
  - Talk me about some of the interfaces in the Collections API and their behavior?   
    
    - Interface: Es una lista de acciones que puede llevar a cabo un determinado objeto pero no el como, @Repository extends JPA.

      - Does a method in an interface can have an implementation?
        - Todos los métodos de una interfaz no contienen implementación (cuerpos de método) a partir de todas las versiones anteriores a Java 8. A partir de Java 8, los métodos predeterminados y estáticos pueden tener implementación en la definición de la interfaz.
    
  - Colecciones y flujos de datos. https://dcodingames.com/java-collections-framework-una-introduccion/
    
  - List: 
  
    - List y Arraylist (Genéricas y Contenedor) colección para almacenar y manipular grandes volúmenes de datos.
    
    - IMaps, ligar key/value, representa un objeto que sirve para ligar (“hacer un mapeo”) un valor clave (key) y un valor u objeto (value).
      
	- Map: 
    
    - Map: Paginación ejemplo from Cliente LIMIT 10 OFFSET 15, trabaja con Spring Data. https://jarroba.com/map-en-java-con-ejemplos/
    
    - Set:

    - Use of comparator and comparable:

- What is the difference between extends and implements?:
  - Implements significa que estás usando los elementos de una interfaz Java en tu clase. 
  - Extends significa que estás creando una subclase de la clase base que estás extendiendo.

- Inversion de Dependencias: 

- Inversion de Control: Externaliza (agente externo: framework) la construcción y manejo de objetos. caso código por consola y forma grafica.

- Inyección de Dependencias: @autowired # para unit testing solo en el controller
  
  - Spring y config inyectan los objetos o dependencias que necesita la clase en lugar de usar el operador new.
  
  - Dependencias, Modularización, Objetos independientes que se comunican entre si para funcionar como uno mismo.

- Constructor privado: Si es posible, para evitar la inicialización de la instancia.

- Which types of Exceptions do we have in Java?: 
  - Check: 
  - Unchecked: 

- BEAN(S): Te da acceso a los servicios del Contenedor EJB (manejo de transacciones, seguridad, persistencia, etc) que simplifican la construcción de soluciones empresariales.
  
  - Which are the scopes of a bean?: singleton, prototype, request, session, application, websocket

  - Which is the default Scope?: singleton
  
  - How many ways to configure a bean exists and which are they?
    - Creating Bean Inside an XML Configuration File (beans.xml)
    - Using @Component Annotation
    - Using @Bean Annotation

- JPA: Java Persistence API, es una especificación de Java que describe la gestión de datos entre objetos y bases de datos relacionales.

- Hibernate: Es un framework de mapeo objeto-relacional (ORM) para la plataforma Java, facilita el mapeo de atributos entre una base de datos relacional tradicional y el modelo de objetos de una aplicación.

- Spring Data: Es un proyecto de Spring que simplifica el acceso a datos de aplicaciones basadas en Spring, proporciona una abstracción sobre los diferentes sistemas de almacenamiento de datos.

- SQL
  - Permisos (Delete sin Where :v)
  - Queries (pl/sql) 
  - Joins
  - Views
  - Stored Procedures
  - Triggers
  - Substring (Charindex)

- JSP // Basadas en solicitud de respuesta: JavaServer Pages, es una tecnología que ayuda a los desarrolladores de software a crear páginas web dinámicas basadas en HTML y XML.

- JSF // Basadas en eventos (PrimeFaces): JavaServer Faces, es un framework de Java para construir interfaces de usuario para aplicaciones web.

- Java Transaction API (JTA): Es una API de Java que permite a los desarrolladores de aplicaciones definir transacciones de manera programática.

- Servlet: Es una clase de Java que se utiliza para extender las capacidades de los servidores que alojan aplicaciones web.

- Portlet: Es un componente de interfaz de usuario de una página web que interactúa con el usuario y genera contenido dinámico.

- JSE: Java Standard Edition, es una colección de APIs de Java que proporciona las herramientas para el desarrollo de aplicaciones de escritorio y aplicaciones de servidor.

- JEE: Java Enterprise Edition, es una colección de APIs de Java que proporciona las herramientas para el desarrollo de aplicaciones empresariales.

- Maven: Sirve para gestionar y controlar la construcción además de descargar las dependencias de cualquier app.

- What is the difference entre spring boot y spring core?
  - SpringBoot: Spring Boot es un marco basado en Java que es ideal para crear aplicaciones independientes basadas en Spring en un período corto.
  - Spring Core: Spring es un marco liviano que ofrece un entorno elaborado para un modelo de programación y configuración robusto para aplicaciones basadas en Java.

### Stream API, Threads, Lambda

`Concurrencia y Paralelismo`

- Threads: Hilo / Tarea,
  - es la clase base de Java para definir hilos de ejecución concurrentes dentro de un mismo programa

- Java / Thread Deadlock
  - Un punto muerto generalmente ocurre cuando un hilo está esperando a que finalice el otro. En este caso, podemos usar join o sleep con un tiempo máximo que tardará un hilo.

`Programación funcional/declarativa`

- Expresiones Lambda (es el cómo lo hará), 
  - Son funciones anónimas que reciben parámetros y devuelven un valor, funciones que no necesitan una clase, hace nuestro código más preciso y legible, mejorando, en consecuencia, su mantenibilidad, hace más fácil la ejecución concurrente de tareas, necesita una @FunctionalInterface
  - Ej: 
    - (argumentos)->{cuerpo}
    - (int a, int b) -> a >b;
    - (int a, int b) -> System.out.println(a + b);  return a + b;

---

### Estructuras de datos:
  - Vector/Array
    - Es una estructura de datos que almacena de forma contigua, se guarda espacio fisico en memoria ram uno al lado del otro
    - Ventajas: El acceso por índice a cualquiera de sus elementos es constante
    - Desventajas: Debe cambiar periódicamente de lugar debido a que aumenta de tamaño el vector

  - Lista enlazada
    - Sus elementos están repartidos pero conectados por un puntero
  - Tablas de HASH
  - Pilas/Colas
  - Grafos
  - Heaps
  - Joins

---

### APIs Types:
  - REST:
    - Representational State Transfer, es un estilo de arquitectura de software que define un conjunto de restricciones para crear servicios web.
  - SOAP:
    - Simple Object Access Protocol, es un protocolo de comunicación que permite la comunicación entre aplicaciones.
  - CORS: 
    - Command Query Responsibility Segregation, separa las operaciones de lectura y escritura en un sistema, se usa para mejorar la escalabilidad y el rendimiento de un sistema
      - REST = Interfaz de aplicaciones para transferir datos GET, solo lectura.
      - RESTFUL > GET, POST, PUT, DELETE, de lectura y escritura.

### Metodos HTTP: 
  - Get: Recuperar cualquier información, select
  - Post- Crea un nuevo recurso, create
  - Put - Actualiza un recurso existente, update
  - Delete - Elimina un recurso, delete

- Diferencia entre Put y Patch
  - PUT: Realiza el reemplazo total de los atributos del modelo
  - PATCH: Realiza la modificación parcial en un solo campo

- How do you declare an API endpoint?: 
  - En la clase Controller > @RequestMapping("/api/v1/customers")

- How do you test a REST API?
  - Step 1: Get Advanced REST Client
  - Step 2: Enter Your Information
  - Step 3: Enter and Confirm the Headers Set
  - Step 4: Enter the Body Content
  - Step 5: Start the Test
  - Step 6: Review the Results

- Status codes: 
  - 200 Ok
  - 404 Problema solicitud
  - 500 Error en Server

---

### `Hands-On`

- Orden de creación en un CRUD básico sin layers:
  - entity > User
  - application.properties
  - repository > Interface UserRepository
  - service // es la lógica de negocio
  - controller
  - Endpoints Postman
  
`Annotations` más usadas
  - @Controller
  - @RequestMapping
  - @Autowired
  - @GetMapping
  - @PostMapping
  - @Service
  - @Override
  - @Data // Lombok
  - @Configuration
  - @EnableWebSecurity
  - @Bean
  - @Entity
  - @Table
  - @Id
  - @GeneratedValue
  - @OneToMany
  - @ManyToOne

`Frameworks` más usados

  - Spring | SpringBoot | SpringCloud
  - Quarkus
  - Helidon

---

### Patrones de diseño y Arquitectura

`Principios y mejores practicas`

- KISS: 
  - Que se haga algo de forma sencilla.
- YAGNI 
  - No vas a necesitarlo, No se implementa en el momento, se implementa cuando se necesita.
- Principio SoC (separation of concerns). 
  - Separar por capas como MVC.
- SOLID:
  - SRP (Single Responsibility Principle). Las clases o módulos deben tener una única responsabilidad
  - Open/Close Principle, Abierto para su extensión, pero cerrado para su modificación, nos dice que el código está mejor diseñado si se puede modificar su comportamiento sin cambiar su código fuente
  - Liskov, El principio de sustitución de Liskov, una clase derivada no debe modificar el comportamiento de la clase base
  - ISP (Interface segregation principle), El principio de segregación de interfaces, dice que el una clase que implementa una interfaz no debe depender de métodos que no utiliza.
  - DIP (Dependency Inversion Principle), El principio de inversión de dependencias, que viene a decir que las clases de alto nivel, no deben depender de clases de bajo nivel
- Programación Orientada a Aspectos
  - Se basa en la idea de clases y jerarquías de clases, añade funcionalidad adicional con proxies dinámicos antes de los metodos, elimina la necesidad de duplicar código

`Elementos necesarios para una clean architecture.`

  - Escalabilidad (Alta cohensión y bajo acoplamiento)
  - Alta disponibilidad
  - Tolerancia a fallos
  - Código limpio (flexible, robuto, estable, reutilizable para mantenibilidad y eficiencia del código).

`Patrones de diseño: (+ usados)`

  - MVC // Model View Controller
    - Es un patrón de diseño que separa la lógica de negocio de la interfaz de usuario, permitiendo que los desarrolladores puedan trabajar de forma independiente en cada una de las partes.
    - Modelo: Representa la estructura de datos, la lógica de la aplicación y las reglas de negocio.
    - Vista: Presenta el modelo al usuario y también puede ser una entrada de datos.
    - Controlador: Actúa sobre el modelo y la vista, controla el flujo de datos en la aplicación.

  - DTO // Data Transfer Object
    - Es un estándar que nos ayuda en la exposición de los datos para el retorno de una API, o para montar el contenido de una página. 
    - DTO viene de Data Transfer Object y su objetivo es darnos más seguridad para la aplicación por no estar exponiendo las informaciones de nuestras entidades (imagina si devolvemos para la pantalla todas las informaciones sensibles de un usuario, como su username y contraseña). Y también tenemos más flexibilidad, porque podemos combinar informaciones de otras entidades para entregar contenidos más completos para el cliente.

  - DAO // Data Access Object
    - Es un estándar que tiene como finalidad centralizar la responsabilidad de acceso a la capa de datos, el modelo.
    - DAO es lo mismo que entity o model, son las entidades/clases como UsuarioDAO, DAO viene de Data Access Object y esta capa es la que realiza la conexión con la fuente de información. Sea una base de datos SQL, NoSQL, cache, archivo

`Creacionales: Factory, Builder, Singleton, Abstract Factory.`

  - Factory
    - Este patrón nos permite crear diferentes objetos usando la palabra new, pero no directamente en la clase que lo necesita si no desde un método que podríamos llamar fabrica y esta a su vez nos devolverá el objeto solicitado, pero desde otra clase. A estos objetos devueltos se les denomina productos.

  - Builder
    - Es un patrón que se centra en la creación de un objeto complejo paso a paso. Nos evita crear por cada implementación personalizada de un objeto un constructor que satisfaga tal objeto y solo utilizáramos los parámetros que necesitamos para crearlos.

`Estructurales: Proxy, Adapter, Decorador.`

  - Proxy
    - Es un patrón de diseño que busca controlar el acceso a un objeto y permitiéndote hacer algo antes o después que el objeto original reciba una solicitud o el llamado desde otra clase.

  - Adapter
    - Este patrón de diseño te permite la comunicación entre objetos no compatibles a través de interfaces, por ejemplo, un traductor, cuando dos personas no hablan el mismo idioma, generalmente un intérprete los acompaña y traduce la conversación, lo que permite la comunicación entre ellos. También lo podemos ver en los servicios RESTful, tu estas programando en Python y Java y deseas compartir alguna información, entonces usan los servicios REST que funcionan como un puente y aumenta la interoperabilidad entre dos servicios externos.

  - Decorador
    - Este patrón permite añadir funcionalidades extras a objetos a través de objetos que encapsulan ciertas características que permiten evolucionar el estado del objeto agregándole nuevas características.

`Comportamiento: Command, Strategy, Observer.`

  - Strategy
    - Este patrón de diseño te permite encapsular una serie de algoritmos relacionados en diferentes clases y se pueden intercambiar en tiempo de ejecución. Un ejemplo son las distintas maneras que puedes hace un pago, con una tarjeta de crédito, débito o en efectivo, también se puede usar para añadir ciertas validaciones a un objeto en concreto.

  - Observer
    - Este patrón te permite definir un mecanismo para notificar a otras clases que se han suscrito con anterioridad a un objeto sobre algún evento o cambios internos dentro del mismo. Lo podemos encontrar en el nuevo paradigma de programación reactiva y la necesidad de crear sistemas asíncronos han llevado al fuerte uso del proyecto Reactor spring que nos permite hacer uso de la librería rxjava para todo este proceso de programación reactiva.

  - Singleton
    - Es un patrón de diseño que garantiza que una clase tenga una sola instancia y proporciona un punto de acceso global a ella.

---

### Arquitectura (Business Domain): // UML y Casos de Uso (UC)

- SOA: es una arquitectura diseñada para la integración de todos los distintos aplicativos que conforman la infraestructura del cliente, pero también busca la integración con aplicativos externos como de proveedores.

- Clean Architecture: Quien eres y que tipo, Usuario o Producto con capas Aplicación, Domain e Infraestructura

- Hexagonal: Aplicación o lógica de negocio, puertos (Customer API, DB API), adaptadores (GUI, REST)

- 3 Capas: Presentación (Interfaz de Usuario, Controller), Logica de negocio (Domain), Data (Acceso a datos o persistencia) MVC

- C4: Conjunto jerárquico de diagramas de arquitectura de software, Nivel 1: El diagrama de contexto del sistema, Nivel 2: El diagrama del contenedor, Nivel 3: El diagrama de componentes, Nivel 4: El código

- Microservicios: Es una arquitectura que permite dividir una aplicación en pequeños servicios independientes, cada uno de ellos con su propia lógica de negocio y base de datos.

- Vista 4+1: Vista de escenarios, Vista de componentes, Vista de procesos, Vista de desarrollo, Vista de despliegue

`Arquitectura Microservicios:`

- CQRS: Divide los métodos de petición, get separado de los demás métodos

- Patrón de diseño en Orquestación, Aggregator o Proxy, Eureka

- Patrón de diseño en Coreografía, los microservicios son consultados en cadena no tiene orquestador

- Patrón de diseño Publisher/Subscriber, mensajes, Kafka, rabbitmq

---

### `Definición de Requerimientos:`

- D: Deseables, estéticos, nice to have, si tenemos tiempo
- I: Importantes, valiosos, pueden esperar, se negocian por otros
- N: No implementables, poco valor, costo alto
- O: Obligatorios, sin ellos el producto no tiene sentido, editar y guardar información de clientes

---

