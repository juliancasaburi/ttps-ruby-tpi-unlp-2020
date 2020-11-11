# Decisiones de diseño

# Estructura

* `lib/`: directorio que contiene todas las clases del modelo y de soporte para la ejecución
  del programa `bin/rn`.
  * `lib/rn.rb` es la declaración del namespace `RN`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).
  * `lib/rn/` es el directorio que representa el namespace `RN`. El uso de un módulo como namespace se refleja en la estructura de archivos del proyecto como un directorio con el mismo nombre que el archivo `.rb` que define el módulo, pero  sin la terminación `.rb`.
  * `lib/rn/commands.rb` y `lib/rn/commands/*.rb` son las definiciones de comandos de `dry-cli`. `lib/rn/commands/books.rb` y `lib/rn/commands/notes.rb` son disparadores de operaciones de los helpers. `lib/rn/commands/version.rb` define un comando simple que muestra la versión de la aplicación.
  * `lib/rn/exceptions.rb` y `lib/rn/exceptions/*.rb` son las definiciones de excepciones, para los distintos errores que pueden producirse durante la ejecución del programa. Estas excepciones son lanzadas por `BookHelper` y `NoteHelper`
  * `lib/rn/helpers.rb` y `lib/rn/helpers/*.rb` son las definiciones de helpers. Estos son clases intermediaras que permiten, desde los comandos realizar las operaciones de los modelos `Book` y `Note`.
  * `lib/rn/models.rb` y `lib/rn/models/*.rb` son las definiciones de modelos.
  * `lib/rn/persistence_layer.rb` y `lib/rn/persistence_layer/file_persistence_layer.rb` definen la clase FilePersistenceLayer, la cual se encarga de lectura/escritura de archivos y directorios.
  * `lib/rn/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).
* `bin/`: directorio donde reside cualquier archivo ejecutable, siendo el más notorio `rn`, que se utiliza como punto de entrada para el uso de la herramienta.

# Configuración

Para la configuacíon, la aplicación utiliza la gema [dotenv](https://rubygems.org/gems/dotenv).

En el archivo `.env`, se encuentran las variables de configuración del programa.

Permite configurar:

- El directorio del cajón de notas
- La extensión de los archivos correspondientes a las notas
- El nombre del "cuaderno global" (cuaderno de notas que fueron creadas sin el cuaderno por parámetro)

### Archivo .env

```env
# RN working directory (Builds the directory path based on the current user home directory)
RN_DIRECTORY="$(Dir.home)/.my_rns"

# Note file extension
RN_NOTE_EXTENSION="rn"

# Global book name
RN_GLOBAL_BOOK_NAME="global"
```

### Configuración default

En caso de no poder leer alguna variable desde el archivo .env, se utilizará su valor default.

Estos valores se establecen en `bin/rn`

```ruby
ENV['RN_DIRECTORY'] = ENV['RN_DIRECTORY'] || "#{Dir.home}/.my_rns"
ENV['RN_NOTE_EXTENSION'] = ENV['RN_NOTE_EXTENSION'] || "rn"
ENV['RN_GLOBAL_BOOK_NAME'] = ENV['RN_GLOBAL_BOOK_NAME'] || "global"
```

### Variables

La variable `RN_DIRECTORY` configura el directorio del cajón de notas de la aplicación.

La variable `RN_NOTE_EXTENSION` configura la extensión de los archivos correspondientes a las notas *(Persistencia de las notas en archivos)*.

La variable `RN_GLOBAL_BOOK_NAME` configura el nombre del cuaderno *default* (notas que no fueron creadas dentro de un cuaderno).

# Modelo de datos

La lógica del programa requirió la definición de 2 clases para el modelo de datos:

`Book`
`Note`

# Títulos de notas y nombres de cuadernos

Existen caracteres que no pueden ser parte del título de una nota o el nombre de un cuaderno, porque no está permitido incluirlos en el nombre de un archivo.

Para esto, al instanciarse y al modificar sus atributos, los modelos saben como *sanitizar* sus valores.

```ruby
def sanitize_title(title)
  title.gsub(/[^0-9A-Za-z.\-]/, '_')
end
```

### Ejemplo

Al ejecutar el comando

```bash
ruby bin/rn n create "titulo/no<permitido?"
```

Obtenemos como respuesta en stdout

> La nota con título titulo_no_permitido_ fue creada exitosamente en el cuaderno global


# Contenido de una nota

Existen 2 variantes para el contenido durante la creación de una nota:

## Contenido como named argument opcional

El contenido de una nota puede pasarse como parámetro durante la creación, haciendo uso de las [opciones de dry-cli](https://dry-rb.org/gems/dry-cli/0.6/options/)

```ruby
option :content, type: :string, desc: 'Content of the note'
```

### Ejemplo con named argument opcional

```bash
ruby bin/rn n create usando-named-argument --content "Este es un contenido de prueba.
multilinea"
```


## Contenido usando editor de texto predeterminado

El contenido de una nota puede editarse durante la creación. Se abre el editor de texto predeterminado y el usuario puede escribir el contenido.  
Para este fin, se hace uso de la gema [tty-editor](https://rubygems.org/gems/tty-editor)

### Ejemplo con editor de texto predeterminado

```bash
ruby bin/rn n create "usando editor de texto"
```

> NOTA: el título de la nota será reemplazado por **usando_editor_de_texto**

