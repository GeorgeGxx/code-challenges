# Java Test

1. Estos son los diferentes alcances(scopes) de spring bean

Singleton, prototype, request, session, global-session

2. ¿Cuáles son las diferentes estrategias(strategies) de autowiring de Spring Bean?

byName, byType, by constructor, by autowired, by qualifier

3. Mencione algunos de los principales módulos de Spring

Spring Context, Spring AOP, Spring JDBC

4. ¿Podemos enviar un objeto como respuesta del método del controlador?

Sí podemos, usando @ResponseBody annotation. Así es como enviamos respuestas basadas en JSON o XML en restful web services

5. Permite que una aplicación web seleccione su vista (como un JSP) dinámicamente

View Resolver

6. Para el siguiente método de repositorio

@Query("select id, first_name from customer where first_name = :name or upper(first_name) like '%' || upper(:name) || '%'")

List<Customer> findByName(@Param("name") String name);

R: Se producirá un error porque el nombre de la entidad de consulta está en minúsculas

7. Para el siguiente método de repositorio

@Query("update Customer set name = :name where id = :id")

int updateCustomerById((@Param("id") int id, (@Param("name") String name);

El método de repositorio necesita la @Modifying annotation para actualizar operaciones

8. Para el siguiente método de repositorio

@Transactional(readOnly = true)
public interface UserRepository extends CrudRepository<User, Long> {
	List<User> findByLastName(String lastname);
	@Modifying
	@Transactional
	@Query("delete from User u where u.active = false")
	void deleteInactiveUsers();
}

R: Usando @Transactional annotation en la interfaz del repositorio es posible definir que todos los métodos sean transaccionales

Usando @Transactional annotation en el método de repositorio anula la configuración de la interfaz de transacción

Usando @Modifying annotation en el método de repositorio que estamos declarando para operaciones de actualización

9. Son metadatos de auditoría basados en anotaciones

@CreatedBy, @LastModifiedBy, @CreatedDate

10. @Repository, @Service and @Controller annotations son especificaciones de @Component

Verdadero

11. Las consultas anotadas en el método de consulta tendrán prioridad sobre las consultas definidas mediante @NamedQuery

Verdadero

12. Los métodos CRUD en instancias de repositorio son transaccionales por defecto

Verdadero

13. Métodos de consulta que devuelven List's en lugar de Iterables's

JpaRepository

14. Hibernate es un provider que implementa Spring Data JPA

Falso

15. Estado de objeto utilizado cuando la entidad tiene un identificador asociado pero ya no está asociado con un contexto persistente

Detached (Separado)

16. Estado del objeto utilizado cuando la entidad tiene un identificador asociado y está asociada con un contexto de persistencia, pero puede o no existir físicamente en la base de datos.

Managed or persistent (Administrado o persistente)

17. Dada la definición de entidad

@Entity
public class Customer {
	@Id
	private Integer id;
	
	private String name;
	
	@Basic(fetch=FetchType.LAZY)
	private UUID personId;
	
	@Lob
	@Basic(fetch=FetchType.LAZY)
	@LazyGroup("lobs")
	private Blob image;
}

el acceso del atributo personId no forzará la carga del atributo imagen, y viceversa

Verdadero

18. Es la manipulación de código de bytes (bytecode manipulation of classes) de las clases para realizar un seguimiento de cuáles de sus atributos han cambiado

Dirty tracking (seguimiento sucio)

19. Dada la nueva instancia de entidad

Person person = new Person();
person.setId(1L);
person.setName("John Snow")

¿Cómo puede hacer que la entidad sea persistente con la API de Hibernate?

session.save(person);

20. Dada la siguiente definición de atributo de entidad

@ManyToMany(cascade=CascadeType.ALL, fetch=FetchType.LAZY, targetEntity=Employee.class)
@JoinTable(name="company_employee", joinColumns={@JoinColumn(name="company_id")}, inverseJoinColumns={@JoinColumn(name="employee_id")
})
private List<Employee> employees;

Usando la anotación @JoinTable, una tabla intermedia "company_employee" está lista para interactuar con

Verdadero

21. Dada la siguiente definición de entidad

@Entity(name="Product")
@DynamicUpdate
public static class Product {
	@Id
	private Long id;
	
	@Column
	private String name;
	
	@Column
	private Integer quantity;
}

If you modify only the quantity attribute after a first persisting, how many table columns Hibernate will consider update to generate a SQL Update statement?
Si modifica solo el atributo de cantidad después de una primera persistencia, ¿cuántas columnas de la tabla Hibernate considerará actualizar para generar una declaración de actualización de SQL?

1

22. ¿Estos son algunos de los principales módulos del proyecto en Spring Security?

Core, Web, Config, LDAP

23. ¿Qué es un contexto de seguridad?

Es una clase que incluye detalles del principal que actualmente usa la aplicación.

24. Dada la siguiente definición de entidades

@Entity(name="Position")
public static class Position {
	@Id
	private Long id;
}

@Entity(name="Employee")
public static class Employee {
	@Id
	private Long id;
	
	@NaturalId
	private String username;
	
	@ManyToMany(fetch=FetchType.EAGER)
	private Position position;
}

Si usa una consulta de entidad para encontrar un Employee como esta:

Employee employee = entityManager.createQuery("select e" + "from Employee e" + "where e.id = :id", Employee.class).setParameter("id",1L).getSingleResult();

the position attribute won't be fetched because the entity query fetch policy is overridden
el atributo de posición no se recuperará porque se anula la política de recuperación de consulta de entidad

Falso

25. JPA define la recuperación predeterminada (default fetch) para las colecciones como LAZY

Verdadero

26. La implementación predeterminada de esta interfaz crea instancias de beans con entusiasmo, pero se puede anular individualmente

ApplicationContext

27. After the bean definition with this scope, the container creates exactly one instance of the object, store it in a cache and all requests or references for that bean returns the cached object
Después de la definición del bean con este alcance, el contenedor crea exactamente una instancia del objeto, la almacena en un caché y todas las solicitudes o referencias para ese bean devuelven el objeto en caché.

Singleton

28. This scope is frequently used for all stateful beans because a new bean instance is created every time a request for that specific bean is made
Este alcance se usa con frecuencia para todos los beans con estado porque se crea una nueva instancia de bean cada vez que se realiza una solicitud para ese bean específico.

Prototype

29. Los usos comunes de Spring Cache son

Recuperar roles de usuario y parametros de configuración

30. Es un búfer de memoria utilizado para almacenar temporalmente datos a los que se accede con frecuencia

Cache

31. Si se configura un caché de segundo nivel, ¿dónde está el espacio de búsqueda inicial para buscar una entidad en caché?

Level 1

32. Son estrategias de concurrencia de caché utilizadas en la definición de entidades.

READ_ONLY, NONSTRICT_READ_WRITE, READ_WRITE

33. Son mapeos soportados por Hibernate

One-to-One, One-to-Many, Many-to-One, Many-to-Many

34. La inyección de dependencia mediante anotaciones se realiza después de la inyección de XML

Falso

35. Anotaciones utilizadas para eliminar la ambigüedad que especifica qué bean exacto debe conectarse

@Qualifier

36. Un Joinpoint es un punto durante la ejecución de un programa. En Spring AOP está representado por:

method execution

37. Estos son diferentes tipos de consejos (advice)

@Before, @AfterReturning, @Around

38. El @After advice se ejecuta después de la ejecución de un método coincidente solo si no se lanzó una excepción

Falso

39. Este objeto de sesión devuelto pertenece al hibernate context, por lo que no es necesario cerrarlo.

getCurrentSession()

40. Método recomendado de Hibernate para recuperar datos compatibles con la carga diferida

load()

41. Estos son algunos tipos de colecciones en Hibernate que se usan para asignaciones de relaciones de uno a muchos

List, Bag

42. Estas son formas de implementar Joins en Hibernate

A través de asociaciones como uno a muchos
Escribiendo una consulta sql nativa
Usando la consulta HQL

43. Es posible inyectar valores de cadena vacíos y nulos en Spring

Verdadero

44. Los métodos BeanPostProcessor se llaman cuando

Después de establecer valores y referencias a las propiedades del bean

45. Spring Framework proporciona una integración exitosa con la API de JDBC y proporciona una clase de utilidad ___ que podemos usar para evitar el código repetitivo

JdbcTemplate

46. Cuando se inicializa el contexto de Spring, el scope predeterminado de un bean de Spring es ___

@singleton

47. Con el uso de la anotación ___, se logra la Transaction Management en Spring

@transactional

48. ¿Las importantes anotaciones de Spring que has usado?

@Component, @Repository, @Controller, @Service, @RestController, @ResponseBody, @RequestMapping

Verdadero

49. ¿Cuál de los siguientes no es un objetivo maven?

goal no, install si, deploy si, run si

50. ¿Cuál de los siguientes comandos puede indicar la versión de maven?

mvn --version

51. ¿Cuál de las siguientes fases en el ciclo de vida de maven toma el código compilado y lo empaqueta en su formato distribuible, como un JAR?

package

52. ¿Cuál de los siguientes no es un método HTTP?

IN, ON

53. El verbo ___ se utiliza con mayor frecuencia para **crear** nuevos recursos. En particular, se utiliza para crear recursos subordinados. Es decir, subordinado a algún otro recurso (por ejemplo, principal). En otras palabras, al crear un nuevo recurso, ___ al padre y el servicio se encarga de asociar el nuevo recurso con el padre, asignando una ID (URI de nuevo recurso), etc.

POST

54. SOAP (anteriormente un acrónimo de Sample Access Protocol) es una especificación de protocolo de mensajería para el intercambio de información estructurada en la implementación de servicios web en redes informáticas. Utiliza el conjunto de información REST para su formato de mensaje y se basa en los protocolos de la capa de aplicación, con mayor frecuencia el Protocolo de transferencia de hipertexto (HTTP)

Falso

55. De las siguientes anotaciones cuáles son las mínimas que intervienen en la capa de persistencia

a. @Repository
b. @Service
c. @Controller
d. @Entity
e. @Override
f. @Table
g. @Column

Repository es la mínima
Entity, Table y Column solo aplican si usas code first
Controller y Service son de otras capas
Y Override es una anotación para cuando extiendes un metodo de una clase padre (no tiene nada que ver)