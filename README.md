# Ruby Notes

Ruby Notes es una aplicación desarrollada con [Ruby on Rails 6.1.1](https://github.com/rails/rails/releases/tag/v6.1.1) como trabajo integrador de la cursada 2020 de la materia Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática perteneciente a la Universidad Nacional de La Plata.

# Frontend

El frontend, desarrollado utilizando [Vue.js](https://vuejs.org/) y el framework [Vuetify](https://vuetifyjs.com/en/) se encuentra en el repositorio:

https://github.com/juliancasaburi/ttps-ruby-tpi-frontend-unlp-2020

# Backend

API [Ruby on Rails 6.1.1](https://github.com/rails/rails/releases/tag/v6.1.1), con MySQL/MariaDB como gestor de bases de datos.

# Instalación

## Instalación con Docker

Copiar db-variables.example.env a db-variables.env

```bash
$ cp db-variables.example.env db-variables.env
```

Configurar el usuario y password de MariaDB

```
MYSQL_ROOT_PASSWORD=
MYSQL_USER=
MYSQL_PASSWORD=
```

```bash
$ sudo docker-compose up -d
```

## Instalación sin Docker

## Requerimientos

* Ruby >= 2.5.0

  ### Instalación de ruby 2.7.2 utilizando [rbenv](https://github.com/rbenv/rbenv)
  ```bash
  $ apt update -qq
  $ apt install -y git \
        build-essential \
        autoconf \
        bison \
        curl \
        lib{ssl,yaml,sqlite3}-dev \
        libreadline{8,-dev} \
        zlib1g{,-dev}


  $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  $ cd ~/.rbenv && src/configure && make -C src
  $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  $ exec $SHELL -l
  $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins /ruby-build
  $ rbenv install 2.7.2
  $ rbenv global 2.7.2
  ```
  Puede comprobar la versión de Ruby instalada:
  ```bash
  $ ruby --version
  ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
  ```

* RubyGems >= 3.2.8

  ### [Actualizar rubygems](https://rubygems.org/pages/download)

  ```bash
  $ gem update --system
  ```
  
* MySQL/MariaDB

  ### Instalación

  ```bash
  $ sudo apt install mysql-server
  ```

  ### Configuración

  ```bash
  $ sudo mysql_secure_installation
  ```

* Bundler (Instrucciones a continuación)
* Rails 6.1.1 (Instrucciones a continuación)

## Instalación de RubyNotes
Una vez instalados Ruby y MySQL/MariaDB
### Descargar código fuente:
* [Repositorio Github](https://github.com/juliancasaburi/ttps-ruby-tpi-unlp-2020.git)
* O desde la consola, clonar el repositorio:

  ```bash
  $ git clone https://github.com/juliancasaburi/ttps-ruby-tpi-unlp-2020.git
  ```
  * En caso de no contar con git instalado, instalar con:
  ```bash
  $ sudo apt-get install git
  ```
  
### Gemas:
* Bundler:
  ```bash
  $ gem install bundler
  ```
* Rails y otras gemas requeridas por Ruby Notes

  Ubicarse sobre el directorio donde se clonó/descargó el repositorio.

  ```bash
  $ cd ttps-ruby-tpi-unlp-2020
  ```

  ```bash
  $ bundle install
  ```

# Configuración

Crear archivo .env a partir de .env.example

```bash
$ cp .env.example .env
```

Configurar con el usuario y password de MySQL

```
RAILS_DB_USR=
RAILS_DB_PWD=
```

Configurar `DEVISE_JWT_SECRET_KEY`

Este valor se genera con el siguiente comando:

```bash
$ rails secret
```
  
### Preparar base de datos:
Ruby Notes provee datos pre-cargados (seeds) para poder probar el software.

Si desea crear la base de datos y cargar las seeds:

```bash
$ rails db:setup
```

Si solamente quiere crear la base de datos, sin los datos de prueba

```bash
$ rails db:create db:migrate
```

### Con docker:

```bash
$ sudo docker-compose run app rails db:setup   
```

```bash
$ sudo docker-compose run app rails db:create db:migrate 
```

# Iniciar web server

Para iniciar el web server:
```bash
$ rails s
```

### ¡Listo!
El servidor se encontrará funcionando en [http://localhost:3000](http://localhost:3000)

# API Endpoints

```http
Prefix            Verb   URI Pattern                                                                            Controller#Action
signup            POST   /signup                                                                                users/registrations#create
login             POST   /login                                                                                 users/sessions#create
logout            DELETE /logout                                                                                users/sessions#destroy
v1_books          GET    /api/v1/books                                                                          api/v1/books#index {:format=>"json"}
                  POST   /api/v1/books                                                                          api/v1/books#create {:format=>"json"}
v1_book           GET    /api/v1/books/:id                                                                      api/v1/books#show  {:format=>"json"}
                  PATCH  /api/v1/books/:id                                                                      api/v1/books#update {:format=>"json"}
                  PUT    /api/v1/books/:id                                                                      api/v1/books#update {:format=>"json"}
                  DELETE /api/v1/books/:id                                                                      api/v1/books#destroy {:format=>"json"}
v1_exportBooks    GET    /api/v1/exportBooks                                                                    api/v1/books#export {:format=>"json"}
v1                GET    /api/v1/books/:id/notes                                                                api/v1/books#book_notes {:format=>"json", :id=>/[0-9]+/}
                  GET    /api/v1/books/:id/export                                                               api/v1/books#export_book {:format=>"json", :id=>/[0-9]+/}
v1_notes          GET    /api/v1/notes                                                                          api/v1/notes#index {:format=>"json"}
                  POST   /api/v1/notes                                                                          api/v1/notes#create {:format=>"json"}
v1_note           GET    /api/v1/notes/:id                                                                      api/v1/notes#show {:format=>"json"}
                  PATCH  /api/v1/notes/:id                                                                      api/v1/notes#update {:format=>"json"}
                  PUT    /api/v1/notes/:id                                                                      api/v1/notes#update {:format=>"json"}
                  DELETE /api/v1/notes/:id                                                                      api/v1/notes#destroy {:format=>"json"}
                  GET    /api/v1/notes/:id/export                                                               api/v1/notes#export{:format=>"json":id=>/[0-9]+/}
```

# Decisiones de diseño

## API

La app fue creada en modo api-only

https://guides.rubyonrails.org/api_app.html

```bash
$ rails new ttps-ruby-tpi-unlp-2020 --api
```

## Gestión de sesiones
Para las sesiones se utiliza JWT (JSON Web Token), usando la gema [devise-jwt](https://github.com/waiting-for-dev/devise-jwt)

## Control de acceso
- Existen endpoints privados (que requieren autenticación), y endpoints que no requieren autenticación. Los únicos endpoints que no requieren autenticación son el endpoint para autenticarse y el endpoint para crear un usuario. Para acceder a los demás endpoints se requiere estar autenticado.

- Los usuarios autenticados solo pueden acceder a sus propias Notes y Books.

## Global Book

Todos los usuarios poseen un Book con name *Global*, el cual no puede ser eliminado ni editado.

Luego de la creación del usuario, se crea el libro *Global* para el mismo. Para este fin se utiliza el callback after_save en el modelo User.

[Active record callbacks](https://guides.rubyonrails.org/active_record_callbacks.html)

## Formato de texto rico en notas

Las notes soportan el formato de texto rico MarkDown.

Se utilizan las gemas

[kramdown](https://github.com/gettalong/kramdown) y [kramdown-converter-pdf](https://github.com/kramdown/converter-pdf)

## Exportación de una nota

La nota puede ser exportada en formato pdf.

## Exportación de un libro

Se exportan todas las notas de un libro. Se exporta cada Note como pdf y se empaquetan las mismas en un archivo .zip

Para lograr esta funcionalidad, se utiliza la gema [rubyzip](https://github.com/rubyzip/rubyzip)

## Exportación de todos los libros de un usuario

Se exportan todas las notas de todos los libros del usuario. Se crea una carpeta por Book, se exporta cada nota como pdf y se empaquetan las mismas en un archivo .zip

Para lograr esta funcionalidad, se utiliza la gema [rubyzip](https://github.com/rubyzip/rubyzip)
