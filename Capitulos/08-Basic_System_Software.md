# Capitulo 8

## Introduccion

Ahora empieza la construcción del sistema real- El principio es el mismo que los pasos anteriores, se descomprime, se compila y se elimina el directorio. Son cerca de 80 paquetes así que va a tardar, por eso antes declaramos "MAKEFLAGS=-j$(nproc)" para dividir las tareas en todos los cores del procesador. En mi caso lo hice con 4 cores y estuve un dia completo.

## Gestor de Paquetes

En LFS no se habla de ningún gestor de paquetes específico ya que el objetivo es aprender a compilar todo nosotros pero si nos da recomendaciones para actualizar algunos paquetes específicos

## Paquetes

Esto se ejecuta dentro de chroot, si usan el script deben copiarlo en un path que tenga acceso.