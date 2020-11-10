# Guía de Instalación y Configuración

# Instalación

## Instalación de Ruby

Para la ejecución del programa, será necesario contar con Ruby versión 2.5 o superior.  
Se recomienda la utilización de un manejador de versiones para Ruby (Ver sección Manejadores de la guía oficial)

Ver guía de instalación en la documentación del sitio oficial de Ruby

https://www.ruby-lang.org/es/documentation/installation/

## Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Bundler se encarga de instalar las dependencias ("gemas") declaradas en el archivo `Gemfile`.

Para instalarlas, podés utilizar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

# Configuración

## Configuración del entorno de ejecución

En el archivo `.env`, encontrarás variables de configuración del programa.

### Configuración default

Por defecto, las configuraciones son las siguientes:

```env
# RN working directory (Builds the directory path based on the current user home directory)
RN_DIRECTORY="$(Dir.home)/.my_rns"

# Note file extension
RN_NOTE_EXTENSION="rn"

# Global book name
RN_GLOBAL_BOOK_NAME="global"
```

### Variables

La variable `RN_DIRECTORY` configura el directorio del cajón de notas de la aplicación.

La variable `RN_NOTE_EXTENSION` configura la extensión de los archivos correspondientes a las notas *(Persistencia de las notas en archivos)*.

La variable `RN_GLOBAL_BOOK_NAME` configura el nombre del cuaderno *default* (notas que no fueron creadas dentro de un cuaderno).