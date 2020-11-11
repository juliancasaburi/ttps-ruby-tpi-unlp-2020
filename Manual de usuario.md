# Manual de Usuario

# Instalación y configuración

Para ver los pasos a seguir para realizar la instalación y configuración, leer el archivo:

[Instalación y configuración](Instalacion%20y%20configuracion.md)

# Sobre la aplicación

La aplicación te permitirá gestionar cuadernos y notas.

## Operaciones disponibles

### Notas

–Creación de una nota  
–Listado de notas, que puede o no filtrarse por cuaderno.  
–Vista de una nota.  
–Modificación del título una nota.  
–Modificación del contenido una nota.  
–Borrado de una nota.  

### Cuadernos:

–Listado de los cuadernos de notas.  
–Renombrado de un cuaderno.  
–Borrado de un cuaderno.  

## Utilizando la aplicación

### Comandos disponibles

Podés consultar los comandos de la aplicación disponibles, con el comando:

```bash
ruby bin/rn
```

### Subcomandos

### Cuadernos

Podés consultar los subcomandos para los cuadernos, con el comando:

```bash
ruby bin/rn books
```

o utilizando el alias

```bash
ruby bin/rn b
```

### Notas

Podés consultar los subcomandos para las notas, con el comando:

```bash
ruby bin/rn notes
```

o utilizando el alias

```bash
ruby bin/rn n
```

### Ayuda de un subcomando

Podés consultar los argumentos esperados para un subcomando, utilizando el modificador -h o su alias --help.

Por ejemplo, para consultar la ayuda para la creación de una nota:

```bash
ruby bin/rn notes create --help
```



