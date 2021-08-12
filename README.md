Introducción
============

Un Drumpad es un dispositivo que permite la reproudcción de sonidos
previamente almacenados y asignados a algún controlador con posibilidad
de pulsación o interacción, como un teclado o algún sistema digital. El
drumpad interactúa con los toques dados externamente y reproduce el
sonido asignado a la casilla dada o botón. Este dispositivo es de amplio
uso en la industria de la música y el entretenimiento ya que permite el
control de sonidos almacenados y la reproducción de los mismos sin la
necesidad de generarlos nuevamente, algo conocido como *Sample*, y
permite hacer de ellos algo mas sencillo de controlar.

La idea del presente proyecto es la implementación de un drumpad que se
pueda controlar a través de un teclado matricial de 16 botones, y el
cual genere diferentes sonidos mediante el uso del sistema ”PWM” o Pulse
Width Modulation (Modulación de ancho de pulsos), y que permita la
visualización del botón pulsado del teclado mediante una pantalla VGA,
la cual alterna de color con cada que se pulsa el botón, extrayendo
dichos colores desde almacenamiento en memoria utilizando bancos de
registro. Adicionalmente, se genera la implementación utilizando los
conceptos de electrónica digital y el uso aplicado de tarjetas FPGA para
el desarrollo de proyectos programables con lógica.

Objetivos
=========

1.  Emplear los conocimientos de electrónica digital al desarrollo de
    proyectos que utilicen el control de señales digitales.

2.  Implementar proyectos con el uso de tarjetas tipo FPGA para el
    control programado de lógica y señales digitales.

3.  Aplicar los conceptos de lógica combinacional, lógica secuencial, y
    otros asociados a estos que permiten la facilidad del manejo de
    datos y señales, como bancos de registros y maquinas de estados.

4.  Entender y utilizar módulos de control para funcionalidades VGA y
    PWM para control de video y audio respectivamente.

Desarrollo
==========

Inicialmente para comenzar el desarrollo del Drumpad, es necesario
conocer los parámetros básicos de la FPGA, ya que con ellos se llevan a
cabo cálculos de memoria que permiten conocer las limitaciones de los
módulos a implementar, tanto la conexión a pantalla VGA y el sonido del
Drumpad.

La tarjeta a trabajar es desarrollada por Altera (Intel), perteneciente
a la familia de las *Cyclone IV* EPC4E10, específicamente la serie
E22C8N, la cual presenta una cantidad de 10 mil elementos lógicos, y
tiene una memoria integrada de 414 kB, además, cuenta con un reloj
interno ajustado por defecto a 50 MHz.

Como se van a realizar implementaciones utilizando el puerto VGA, se
requiere conocer la disponibilidad que trae la tarjeta para este tipo de
configuraciones, la cual se puede ver en la misma tarjeta o en cualquier
hoja de especificaciones.

![rgb FPGA](imagenes/RGB FPGA.jpg)

Conociendo que la tarjeta cuenta con un solo pin para cada color en el
chip madre, entonces se sabe que es posible trabajar los comandos de VGA
con un RGB 111, el cual permite 8 colores diferentes, ya que cada
parámetro de la configuración de color RGB puede asumir 1 o 0, lo cual
da espacio a 8 posibilidades de combinación, las cuales son 000 (negro),
001 (azul), 010 (verde), 100 (rojo), 011 (cian), 101 (magenta), 110
(amarillo) y 111 (blanco).

Otro dato que es requerido es el voltaje de salida de los pines
accesibles de la FPGA, ya que, varios de estos se usarán para las
conexiones del teclado y el PWM que genera el sonido. Este voltaje se
puede conocer con la hoja de especificaciones técnicas, o de una forma
más sencilla en el ”Pin Planner” de la programación de la tarjeta.

Dichos pines trabajan a un voltaje estándar de $2.5\ V$.

Cabe destacar que todo el trabajo de programación de la tarjeta se va a
realizar mediante el uso de la aplicación de Intel llamada ”Quartus
Prime”, la cual permite la creación de proyectos con archivos de código
en Verilog, lenguaje de programación ideal para el trabajo de tarjetas
FPGA, además que, permite configurar la referencia de la tarjeta con la
que se trabaja para programar sus pines e interactuar con los mismos y
el código.

Teclado matricial
-----------------

Para el control del Drumpad es necesario el uso de un teclado matricial
de 16 botones, para el cuál se debe implementar un módulo que permita su
manejo. Inicialmente se debe entender el funcionamiento de un teclado
matricial, y posteriormente si se genera el desarrollo del módulo que lo
controla. Un teclado matricial es un dispositivo que agrupa diferentes
pulsadores conectados a través de conductores entre filas y columnas,
uno para cada una de ellas, formando una matriz en la cuál para acceder
a cada botón se ubica su posición en la matriz y se utilizan los
conductores de su respectiva fila y columna.

Para el presente caso, se cuenta con un teclado matricial de 4x4, 4
filas y 4 columnas conectando un total de 16 botones.

El funcionamiento del teclado es simple, la idea es implementar el menor
número de conductores posibles, por esta razón se tienen solo 8, y se
trabaja mediante barridos. Se tiene la siguiente disposición inicial En
este caso, se realizará un barrido por columnas, lo cual a priori se
trata de conectar las columnas como salidas (a pines con voltaje dado) y
las filas a resistencias en conexión pull-up como entradas digitales. El
proceso es simple, se coloca una columna a 0V, se leen todas las
entradas de fila, se coloca nuevamente la columna al valor de voltaje de
entrada nominal, y se pasa a la siguiente columna, sucesivamente hasta
recorrer todas las posiciones de los botones y determinar cual de estos
está pulsado, teniendo en cuenta que bajo este tipo de control, es
pertinente pulsar una tecla a la vez porque se pueden presentar
inconvenientes al pulsar múltiples teclas.

Lo siguiente es la conexión a la FPGA, la cual se realiza como lo
descrito previamente, los pines de las columnas directamente a los de la
FPGA, y los pines de las filas se conectan a unas resistencias que van a
tierra, una por cada pin de $1\ k \Omega$, para posteriormente
conectarse a los pines de la FPGA. Las conexiones a la FPGA siempre se
realizan teniendo en cuenta que el siguiente ordenamiento para filas y
columnas de los conductores del teclado

Así pues, la primera fila asociada al primer conductor se conecta al pin
que se programa con el valor del bit más significativo del registro que
contiene los valores de filas, y de la misma forma con el quinto
conductor que representa el valor de la columna mas significativa.

Con lo previamente dicho, se pasa a la implementación mediante código,
para lo cual es requerido programar un módulo que genere el control del
teclado mediante la configuración definida, barrido por columnas.

El código tiene un funcionamiento simple, para cada cambio de flanco,
entra a un bloque de lógica que permite almacenar en un registro el
valor de fila, y si este valor es diferente de cero, se activa el
registro que almacena el valor de ”opr” que indica que hay un botón
siendo presionado. Dentro de este mismo bloque se genera un switch que
estudia el caso específico de la fila para entrar a asignar la columna,
y se concatena el valor de la fila con el de la columna para obtener un
número de 8 bits que representa la posición del botón, esto anterior con
el objetivo de generar un bloque de lógica adicional que contiene un
switch para los 16 números y el caso por defecto, y dependiendo esto, se
almacena un valor de 4 bits en el registro posición, que es un número
del 0 al 15 en binario que representa los 16 botones, comenzando (según
la disposición de la imagen mostrada del teclado) con el valor de 0 para
la tecla D, el valor de 1 para la tecla C, y así de forma ascendente
hasta llegar a la tecla A y luego pasar a la tecla \#, para terminar en
la tecla 1 con el valor posición de 15. Esto se realiza así porque el
valor con el que se va trabajar a través de los demás módulos es el de
posición.

Imagen
======

La primera sección del proyecto es la visualización en la VGA del botón
pulsado en el teclado matricial. Para esto, se trabaja la implementación
del controlador de la VGA y se aplica una memoria RAM para almacenar los
colores que se van a proyectar en cada posición (recordando que se
trabaja RGB 111).

VGA
---

Para el manejo de la VGA es necesario configurar módulos que permitan
controlar la pantalla y las diferentes configuraciones que se van a
generar en la misma, en este caso, una división en 16 sectores
equivalentes asociados al teclado matricial y sus 16 botones, y cambios
de color entre los 8 posibles colores de RGB 111. Para ello, se
presentan 3 módulos brindados por el profesor, y se modifican para
adaptarlos a las necesidades previamente mencionadas. Dichos módulos son
”buffer\_ram\_dp” un buffer de memoria que almacena los posibles colores
a trabajar en la VGA y tiene como salida el valor de color específico,
”VGA\_Driver” un controlador con asignaciones y bloques de lógica que
permite sincronizar el color de pixel asignado por el buffer con el
valor de pixel de la VGA, y ”Test\_VGA” que combina los dos módulos
anteriores con una serie de asignaciones y condicionales que permiten la
división de la pantalla en 16 cuadros y la asignación de colores a cada
cuadro siguiendo el orden asignado en la memoria, y cambiando cada se
cambia la dirección asignada para el color dado.

Memoria RAM
-----------

El trabajo del banco de registro fue relativamente simple, debido a que
ya se había realizado previamente en un laboratorio anterior, por lo
cual solo debía adaptarse e implementarse para el presente caso.

En esencia, un banco de registros es una agrupación de un número dado de
registros que se pueden controlar mediante señales, con el fin de ser
leídos o escritos, sea de forma inicial o sea de sobre escritura, y
además, es posible tener múltiples entradas o salidas para controlar
simultáneamente varios registros.

Para el presente caso, el banco de registros se utiliza para almacenar
la dirección de color de los 16 cuadros de la VGA y a su vez, ir
modificando progresivamente el color que tiene cada cuadro, para así
saber qué color tiene asignado actualmente y qué color debería seguir
según lo definido en el buffer dp de la VGA. Inicialmente se genera una
precarga con todos los cuadros asignados a la dirección de color blanco.

Implementación en Verilog
-------------------------

A partir de lo mencionado anteriormente, es posible mostrar el código
utilizado para generar la imagen en la pantalla. En los comentarios del
mismo se explica su funcionamiento, sin embargo, en resumidas cuentas,
se hace coincidir dimensionalmente las posiciones del teclado matricial
con la pantalla, y así cambiar los colores de las posiciones
correspondientes. Cuando se llega a la última posición del color, vuelve
a su estado inicial, esto se logra mediante el uso del banco de registro
que ya se explicó.

Simulación
----------

Según la guía que se tenía para la VGA, lo ideal era generar el archivo
llamado test\_vga.txt que se creaba a partir del testbench para el
archivo de test\_VGA.v que venía con la guía. Lo que fue necesario
generar fue la memoria inicial, la cual se genera en el archivo en
matlab llamado crearMemoria.mlx, donde se genera un txt que contiene
todas las posiciones de memoria necesarias para poder generar
test\_vga.txt para utilizar en el simulador de VGA. Después de realizar
esto, y simularlo, se dio la siguiente imagen:

Viendo estos resultados, y consultando con el profesor, nos explicó que
es mucho más sencillo asignar los colores a las secciones de la pantalla
en vez de asignar un color a cada pixel, como se había generado en el
archivo mlx. De este modo, solo se necesita una memoria que almacene los
colores disponibles y que los píxeles de cada rectángulo accedan a su
valor correspondiente, lo cual permite utilizar toda la pantalla sin
generar un gasto grande de memoria, a diferencia de antes que se tenía
un dato para cada pixel y que era una memoria relativamente extensa para
la FPGA. Este cambio fue el que ya se explicó en la implementación de la
VGA y de la memoria RAM.

La contraindicación de generar este cambio en la implementación es que
en el código es necesario asignar condicionales correspondientes a las
posiciones en X y Y, donde se tendrían 16 conjuntos de 4 condicionales
para asegurarse de cubrir todas las regiones importantes. Esto se
evidencia en la siguiente subsección del código en verilog. Dicho esto,
al simular el VGA de este caso se obtuvo los siguientes resultados:

Con esto se completa esta sección de la imagen.

Sonido
======

La segunda sección de este proyecto es lograr emitir diferentes sonidos
con base al botón que se ha pulsado en el teclado matricial.

Para esto, con ayuda del profesor, se recomienda realizar mediante la
implementación de un PWM la señal digital que, mediante un filtro pasa
bajos, genere la señal sinusoidal deseada.

PWM
---

### Nivel DC

Para generar el PWM, lo ideal es tener los niveles DC correspondientes
para cierto intervalo de un periodo. Teniendo un periodo equivalente a
360 grados, se van a realizar intervalos cada 10 grados, dando un total
de 36 niveles DC a utilizar.

De esta señal se separa en 36 intervalos y se determina el nivel DC.
Para poder utilizarlo, se determina en un intervalo de 0 a 1,
calculándolo a partir del valor se la señal senoidal respecto a su
máximo de 2.5V. A continuación se muestran los resultados de forma
gráfica:

Frecuencia de salida
--------------------

Para generar la frecuencia de salida deseada, es necesario realizar el
cálculo de la frecuencia del PWM con base al reloj de la FPGA.

Teniendo un reloj de 50MHz, es necesario determinar la precisión del
PWM. Esta se define como el número de flancos positivos de reloj
necesarios para completar el periodo del PWM. Este número se determina
como $2^R$, donde R es la precisión que se quiera tener. Lo ideal es
usar un R=6, dando una precisión de 64 puntos para el PWM.

Para la frecuencia del PWM, se divide la frecuencia del reloj por esta
precisión del PWM. De este modo, se tiene que:

Además, cabe resaltar que para cada intervalo de 10 grados, se necesita
que transcurran mínimo N=10 periodos del PWM para poder definir
adecuadamente este intervalo. De este modo, dividiendo esta frecuencia
de PWM por un mínimo de N=10 por intervalo, y de 36 intervalos totales,
se tiene que la frecuencia máxima de la onda senoidal de salida puede
tener un máximo de:

Para poder disminuir esta frecuencia, basta con aumentar el número de
periodos del PWM dentro de los intervalos de 10 grados, aumentando este
N=10 a cualquier valor más alto, se disminuye a la frecuencia que se
desee tener de salida.

Para este caso se van a realizar 16 frecuencias diferentes,
correspondientes a cada posición del teclado. En el botón 1 del teclado,
se tendrá esta frecuencia máxima, y se disminuirá en sentido izquierda
derecha arriba abajo con los siguientes valores.

N=10, f=2170.1 N=11, f=1972.9 N=12, f=1808.4 N=13, f=1669.3 N=14,
f=1550.1 N=15, f=1446.8 N=16, f=1356.3 N=17, f=1276.6 N=18, f=1205.6
N=19, f=1142.2 N=20, f=1085.1 N=21, f=1033.4 N=22, f=986.43 N=24,
f=904.22 N=26, f=834.67 N=28, f=775.05

Memoria ROM
-----------

Como se ve en esta tabla anterior, se generan diferentes valores de N
para emitir distintas frecuencias de audio. Ahora, para poder facilitar
el uso de estos datos con respecto a la posición de los botones de
teclado, es ideal implementar una memoria ROM para hacer la lectura de
estos datos. Es importante hacer esto debido a que la posición 0 que se
obtiene en la FPGA no va a corresponder al primer botón, debido a que la
enumeración de 0 a 15 del teclado es de abajo a arriba de derecha a
izquierda. Por esto, en la memoria ROM se ajustan los valores de N para
que coincidan con la posición real de los botones a partir de su
asignación de lectura. La memoria ROM entonces se precarga con el
archivo freq.men, donde se colocan los valores de N en binario de la
siguiente manera:

Implementación en Verilog
-------------------------

De los datos obtenidos anteriormente, es posible realizar la
implementación del pwm en Verilog. A continuación se muestra el código.

Como se puede ver, en cada flanco positivo del reloj, Q\_reg aumenta en
1. Además, cuando Q\_reg es igual a 2R-1 (en este caso 63), n=n+1. Esto
se genera porque n es el número de veces que el pwm ha transcurrido en
el ciclo de 10 grados del pwm. De este modo, si se tiene un N=10 para
los intervalos de la señal, cuando n=10, y se cumpla que n=N,
caso=caso+1, lo que indica que se avanza en el intervalo de la señal. Si
caso estaba en 35 (el último), su cambio siguiente es a 0, lo que genera
que se repita la señal indefinidamente.

Por último, dependiendo del valor de caso, cambia el valor de la
variable ciclo, el cual es un número entre 0 y 2R-1, que refleja el
porcentaje del periodo del pwm que este se mantiene en alto. De este
modo, se multiplica por el nivel DC ya calculado para determinar este
valor esperado, generando los cambios ya calculados anteriormente.

Simulación en verilog
---------------------

Con el código anterior, se muestra el código del testbench.

A partir de este código, es posible generar la simulación para cualquier
PWM cambiando los parámetros R y N. En este caso R=6 y N es variable con
el fin de cambiar la frecuencia de salida. Para realizar la simulación,
se utilizará un N=1 para que pueda verse fácilmente los cambios de
estados del PWM. A continuación se muestran los resultados:

Aplicación
----------

Este PWM se piensa utilizar para procesar sonidos a diferentes
frecuencias, por lo que se va a implementar un parlante externo, esto
debido a que la chicharra de la FPGA no la consideramos adecuada para
esta aplicación. Se consigue un parlante 8 ohmios de 0.5W y se conecta
mediante un pin externo de la FPGA. De este modo logramos tener nuestra
salida de audio.

Conjunto final
==============

Para acoplar todos los elementos mencionados anteriormente, es necesario
describir cómo van a funcionar en conjunto, de este modo, se muestra un
diagrama de bloques que ejemplifica la estructura de la implementación
en la FPGA extraída directamente de Quartus de su módulo RTL viewer.

Como se evidencia, el wire de columna del bloque teclado es una salida
de la FPGA para realizar el barrido en el teclado matricial, mientras
que fila es un input a la tarjeta dirigida a este mismo bloque. Con esto
se realiza el cálculo de la posición del último botón presionado y el
opr que indica si sí se está presionando.

Sumado a esto, la salida del teclado: “posicion” es de 4 bits,
refiriéndose a la posición entre 0 y 15 del teclado matricial. Este es
una entrada tanto para la RAM como la ROM. En la ROM es la dirección de
lectura, mientras que en la RAM es la posición de escritura. Para la
lectura de la RAM, se tiene también un wire de 4 bits llamado posicion
del bloque de VGA, donde se conecta a la dirección de lectura de la RAM,
y este dato datOutR sale de la RAM y se conecta a la dirección de color
de la VGA para acceder al color correspondiente del rectángulo de la
pantalla.

Por último, salidaPWM corresponde a un and entre el pwm\_out y el opr,
con el fin de que solo suene el parlante cuando se esté presionando
algún botón del teclado.

Errores y limitaciones
======================

A lo largo del desarrollo del proyecto se tuvieron muchos errores,
dificultades e inconvenientes, por lo que se va a realizar un resumen de
estos.

Implementación del VGA
----------------------

Para la VGA no se tuvo demasiados problemas a comparación del resto, sin
embargo si hubo unos que no se lograron arreglar hasta el final del
desarrollo.

Una limitación que se tuvo es la implementación de la VGA es que la FPGA
solo soportaba el RGB111, por lo que no podíamos aumentar los colores
disponibles aunque quisiéramos, esto debido a que el espacio ocupado en
memoria fue relativamente bajo.

Otra limitación que tuvimos fue la comprensión del VGA\_DRIVER640X480 y
del BUFFER\_ram\_dp, que eran bloques de código que nos dieron desde el
inicio del proyecto. A pesar de que a grandes rasgos entendimos el cómo
funcionaba, una duda que nos generó es el cómo pasa un driver de 640x480
a funcionar en toda la pantalla del televisor que es de dimensiones
mucho más grandes, teniendo en cuenta que las proporciones definidas
para los rectángulos se mantuviera como se tenía establecido de dividir
en 4 secciones iguales horizontal y verticalmente.

El error más significativo que teníamos era que cuando implementábamos
el teclado con el VGA, se generaban cambios aleatorios en rectángulos
que no se estaban seleccionando, y que los cambios en los rectángulos
seleccionados no eran lineales, es decir, el valor del banco de registro
asociado a ese rectángulo no estaba aumentando de a una unidad en cada
pulso del teclado.

No supimos por qué nos pasaba esto, sin embargo después de analizar el
código del teclado nos dimos cuenta que fue un error de esta sección que
se explica después.

Para implementar el banco de registro para los cambios de color de
imagen ya se tenía el código de un banco de registro de laboratorios
pasados, por lo que facilitó su configuración. Adaptarlo a solo un caso
de lectura y otro de escritura fue sencillo. Un detalle que sí se
cambió, es que ahora el valor de la posición puntual cambia cuando se da
un flanco positivo de RegWrite, lo cual generó que no implementáramos el
clk para el bloque de lógica secuencial como se había estado trabajando.

Implementación del teclado
--------------------------

Con lo dicho en la sección anterior, se tuvo un error en la generación
del opr en el teclado. El código con el problema se muestra a
continuación.

Lo que pasa con este ploque es que opr está cambiando entre 0 y 1 en
todos los cambios de count, debido a que si se está espichando un boton,
solo funciona para una configuración de count, y como este está
cambiando, opr pasa a ser 0 3/4 veces. Esto generaba los saltos
inexplicables aplicados en la VGA. Para arreglar esto, era necesario
redefinir el opr:

Como se puede ver, se tienen 4 sub opr, los cuales indican si para los 4
casos de columnas, el valor de la fila es diferente de 0, si esto
sucede, su opr es 1, de resto es 0. Ahora, como se tiene esto para los 4
casos de columnas, basta con usar un “or” entre estos y así se conoce si
en cualquier caso se está espichando o no un botón.

Este fue la principal preocupación en la implementación del teclado. De
resto, la comprensión de lectura fue relativamente sencilla debido a los
diferentes foros en internet y al profesor que nos ayudaron a entender
cómo funciona y cómo se debe recorrer el teclado matricial.

Otro inconveniente fue que mientras estábamos realizando el código del
teclado e implementándolo en la VGA, se empezó a dañar bastante la
aplicación. Después de analizar el teclado, fisicamente el teclado
matricial se habia dañado y estaba generando cortos entre caminos,
generando conexiones no deseadas. Esto se debe a que en este teclado se
estaba usando al aire y no en una superficie plana. Cuando compramos el
segundo teclado nos aseguramos de utilizarlo adecuadamente y este error
se corrigió.

Implementación del PWM
----------------------

Por último, se tiene la implementación del PWM que sí tuvo demasiados
problemas.

Empezando con que se planteó generar señales de audio pero que no se
lograron crear fue un cambio bastante drástico. Nunca pudimos determinar
exactamente la señal que estábamos implementado debido a que no teníamos
acceso a un osciloscopio, por lo que los errores asociados a esta señal
simulada no se pudieron arreglar adecuadamente.

Por esto, lo que realizamos fue implementar un LED que se prendiera o
apagara a las frecuencias generadas en el PWM. Este LED estaba conectado
en paralelo con el condensador del filtro, para poder garantizar el
filtrado de las señales.

En esta configuración se tiene que el LED debe funcionar bajo
frecuencias muy bajas, cercanos o menores a 12Hz para que el ojo humano
pueda determinar adecuadamente los periodos. De este modo, se tiene que
N\>=1000(f\<=) para poder tener cambios apreciables en el LED. Cabe
mencionar que visualmente no se tiene una atenuación de intensidad del
LED durante el periodo, sino que se tiene unos momentos donde este está
encendido y otros donde no, y entre menor sea la frecuencia, estos
periodos de tiempo son mayores pero con las mismas proporciones entre
ellos.

Debido a los problemas de equipo, es que, a pesar de que logramos
implementar un LED como receptor de la señal, y que se logró evidenciar
los cambios de la frecuencia de señal del LED, no pudimos describirla
cuantitativamente, ya que solo teníamos los datos cualitativos que
generaba en la implementación. Dicho esto, a pesar de que se cumple que
en un N más grande se demora más en titilar el LED, la frecuencia a la
cual completa un ciclo y lo repite es desconocida, y no consideramos que
es la que se presupuestó en los cálculos del PWM. Sobre esto aún se
tenían muchas incógnitas que se hubieran podido resolver de mejor forma
contando con los instrumentos adecuados.

Otra limitación que se tuvo es que queríamos que el PWM solo estuviera
en alto cuando se mantuviera presionado un botón, sin embargo no se pudo
realizar inmediatamente. Lo más probable sea que opr no se mantenga todo
el tiempo en 1 cuando se oprime el boton, por lo que no se pudo usar la
función “and” entre opr y el salidaPWM. La solución a esto es asegurarse
que opr se mantenga constante en 1. Nosotros lo intentamos mediante el
uso del código de un antirrebote, sin embargo este no está diseñado para
el error que estamos teniendo en este caso particular.

En la búsqueda de soluciones para dichos inconvenientes lo primero que
se realizó fue colocar el código de forma independiente del opr, así, a
pesar de que se mantuviera prendido constantemente, por lo menos era
posible contar con el PWM. Después de realizar esto, se denotaron otra
serie de problemas, y es que, a pesar de no poder conocer
cuantitativamente la señal de forma exacta, era evidente que las
frecuencias que se estaban introduciendo a cada botón no iban acorde a
la forma en como titilaba el LED, por lo que se abordaron dos
soluciones, visualizar en los Display de la FPGA y forzar en el código
del PWM diferentes frecuencias. Con la primera solución se descubrió que
la frecuencia que se tenía era la correcta pero que al momento de salir
de la tarjeta no era la correcta, y por las limitaciones de equipos
mencionadas anteriormente, fue complicado encontrar la causa de dicho
fallo. Por otro lado, en cuanto a forzar dentro del código del PWM se
realizó de diferentes maneras, de forma escalonada, para tratar de
encontrar en qué punto comenzaba a fallar, partiendo de forzar la
frecuencia en la sección del condicional que ajustaba el caso para el
proceso de generación del PWM

Con esto, se vió en el LED cuanto demoraba en titilar, obteniendo unos
resultados mas acordes, considerando que forzar la frecuencia allí
funcionaba de forma correcta, y se decidió comenzar a ascender en el
código, creando un registro y ajustándolo al valor de frecuencia
querido, obteniendo nuevamente resultados acordes. Finalmente se decidió
implementar con un registro conectado a una entrada, que sería una
frecuencia ajustada desde el top, es decir, externamente del PWM, en
donde se obtuvo una demora en las titiladas del LED, por lo que se
evidencio que el error se generaba al tratar de asignar un valor por
fuera del código del PWM, error que no fue posible encontrarle una
solución hasta realizar un análisis del código a manera profunda con
ayuda del profe, en dónde se encontró el error que representaba todas
las fallas del PWM, y es que, el condicional previamente mencionado,
sobre el cual se asignaban de forma forzadas las frecuencias, estaba en
un bloque de lógica que estaba asociado a cambios en cualquier señal del
sistema, cuando dicho bloque debía pertenecer al bloque de lógica que
dependía de los cambios del clk de la tarjeta, bloque en el cual se
generaba la asignación de ’Q\_reg’. Con dicho cambio, el PWM no solo
comenzó a funcionar de manera adecuada, sino que funcionaron múltiples
cosas asociadas al mismo que no había sido posible alcanzar su correcto
funcionamiento, las cuales son la atenuación de la señal, el
funcionamiento del PWM únicamente al estar activo ’opr’, es decir, al
presionar algún botón del teclado, y que se pudieran ingresar los
valores de frecuencias de forma externa al código del PWM, o ajustarlos
mediante un case (que luego posteriormente se dimitió y se implementó la
memoria ROM).

Finalmente y al funcionar de forma correcta en el LED, se llevó todo el
proceso al parlante, disminuyendo las valores de N hasta N=10, y
generando señales de audio limpias sobre cada botón del teclado,
arreglando así la limitación de sonido que se consideraba inicialmente
de no poder crearlas de manera adecuada.

Conclusiones
============

Se pudo completar el desarrollo del proyecto en lo que respecta a los
códigos en Verilog y a sus resultados de simulación, y también se logró
llevar a cabo su implementación física.

Es necesario realizar las simulaciones en Verilog para verificar si se
está teniendo errores en el código. Sin embargo, puede suceder que el
simulador funcione correctamente y en su implementación no funcione. Por
ello se debe detallar muy bien los códigos, ya que lo más probable es
que sea un error del código que pasa por alto en la simulación pero que
si genera problemas en la implementación.

Es necesario la creación de un PWM con el fin de simular una señal
senoidal de cierta frecuencia que genere un audio deseado, sin embargo,
es importante acotar correctamente los intervalos de la señal, el número
de periodos del PWM por ciclo, y la precisión del PWM, ya que todos
estos son factores claves en la implementación y el reloj utilizado
podría quedarse corto ante tantas divisiones de frecuencia.

En la implementación de la VGA se puede reducir la memoria utilizada en
la FPGA al tener un banco de registros de pequeña magnitud que
representa el color para secciones grandes de la pantalla, ya que esto
evita el uso de una memoria que contenga los colores correspondientes
para cada posición en X y Y.

