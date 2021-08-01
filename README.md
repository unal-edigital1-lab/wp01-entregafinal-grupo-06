# Electrónica Digital 2021-1, Universidad Nacional de Colombia 
## Proyecto de Curso: Drumpad con visualización VGA
#### Nombres:
-Andrés Holguín Restrepo

-Julián Andrés Caipa Prieto

-Nicolás Velasquez

## Contenido
blablabla

## Introducción
Un Drumpad es un dispositivo que permite la reproudcción de sonidos previamente almacenados y asignados a algún controlador con posibilidad de pulsación o interacción, como un teclado o algún sistema digital. El drumpad interactúa con los toques dados externamente y reproduce el sonido asignado a la casilla dada o botón. Este dispositivo es de amplio uso en la industria de la música y el entretenimiento ya que permite el control de sonidos almacenados y la reproducción de los mismos sin la necesidad de generarlos nuevamente, algo conocido como _Sample_, y permite hacer de ellos algo mas sencillo de controlar. 

La idea del presente proyecto es la implementación de un drumpad que se pueda controlar a través de un teclado matricial de 16 botones, y el cual genere diferentes sonidos mediante el uso del sistema "PWM" o Pulse Width Modulation (Modulación de ancho de pulsos), y que permita la visualización del botón pulsado del teclado mediante una pantalla VGA, la cual alterna de color con cada que se pulsa el botón, extrayendo dichos colores desde almacenamiento en memoria utilizando bancos de registro. Adicionalmente, se genera la implementación utilizando los conceptos de electrónica digital y el uso aplicado de tarjetas FPGA para el desarrollo de proyectos programables con lógica. 

## Objetivos
1. Emplear los conocimientos de electrónica digital al desarrollo de proyectos que utilicen el control de señales digitales.
2. Implementar proyectos con el uso de tarjetas tipo FPGA para el control programado de lógica y señales digitales.
3. Aplicar los conceptos de lógica combinacional, lógica secuencial, y otros asociados a estos que permiten la facilidad del manejo de datos y señales, como bancos de registros y maquinas de estados.
4. Entender y utilizar módulos de control para funcionalidades VGA y PWM para control de video y audio respectivamente. 
![senoidal](imagenes/senoidal.png)
