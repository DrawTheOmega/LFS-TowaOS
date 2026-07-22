# Capítulo 5

## Recomendación

Si te interesa entender a profundidad el funcionamiento de compilación cruzada es buena idea leerlo desde la [Documentación Oficial](https://www.linuxfromscratch.org/lfs/view/stable-systemd/partintro/toolchaintechnotes.html).

Además hay que tener algunos puntos presentes:

- Cuando se apliquen algunos parches van a salir errores, es normal y están probados. Los parches se aplican aunque salgan mensajes de alerta
- Durante el compilado de la mayoría de paquetes van a salir demasiados mensajes de warning tan rápido que no darpa tiempo a verlos, no se preocupen que son normales. Son mensajes de obsolecencia en sintaxys de C y C++. Se va a avisar cuando realmente salgan alertas de las cuales si haya que revisar algo.
- Revisar las variables de entorno, en especial $LFS ya que va a ser la más usada
- Revisar que se use bash y los siguientes links simbólicos:

        - sh -> bash
        - /usr/bin/awk -> gawk
        - /usr/bin/yacc -> bison

### Procedimiento

Siempre estar parados en /mnt/lfs/sources/ ($LFS/sources/) y siempre hacer el mismo procedimiento:

- Descomprimir el paquete con "tar -xvf package.tar.xz".
- Cambiar al directorio del paquete con "cd package".
- Seguir las instrucciones de compilado de cada paquete.
- Volver al directorio de sources y eliminar el directorio del paquete (no el paquete en si) para evitar problemas el ruido entre paquetes que se compilan más de una vez.