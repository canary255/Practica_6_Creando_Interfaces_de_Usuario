# Practica_6_Creando-Interfaces-de-Usuario
## Procesamiento de imagen y vídeo - Ismael Aarab Umpiérrez

### Introducción
Para esta práctica de Creando Interfaces de Usuario, se va a trabajar en el uso de la webcam y proponer un concepto y su prototipo de combinación de salida gráfica en respuesta a una captura de vídeo.

![](ejercito.gif)

### Desarrollo
- Ya que teniamos herramientas como detección de cara y ojos, se decidió hacer un filtro donde en **Instagram** se hizo bastante popular a finales de 2019, que era poner una imagen en la frente y adivinar el personaje que eres, basado en el juego de mesa ***"¿Quién soy?"***. Pues en base a ello, se decidió hacer uno similar, pero adivinando que tipo de personaje de **Super Mario** eres, usando varias imagenes con varias caras diferentes e implementandolo en la cam.
- Cogiendo el detector de caras, se movió las coordenadas hacia la frente de la persona, y en ello se implantó las imágenes. Se creó un timer para que ponga primero la frase de ***"Qué tipo de Mario eres?*** y 3 segundos más tarde ponga imagenes aleatorias de los Marios, durando 6 segundos. Una vez pasado esto, se coloca la imagen final del Mario que te salió.

```
Nota: No tiene se puesto el nombre de cada tipo de Mario, solo se
puede apreciar e intuir con la imagen (Como por ejemplo, el del gif, que se intuye como un Mario golpeador).
```

- Tras hacer esto, no parecía suficiente, asi que se decidió crear también un filtro al estilo ejercito, donde hay montones de caras en frente a la cámara, haciendo una ilusión de ejercito.
- Para ello, se captura la cara de la persona, y se crea una nueva cam enfocandose a la cara que tiene cierto ancho y cierto alto, y con un bucle *while*, se va creando esa cara varias veces, incrementando la posicion de la cam hasta que ocupe toda la pantalla, acompañado de la canción **Moskau 1979** de **Dschinghis Khan**, reproduciendose a partir del min *1:05* (Se ha recortado la canción para llegar hasta allí). Para la implementación de la canción, se ha usado la biblioteca **Minim**.
- Esta multiplicación de cara tiene varias fases:
  - Fase 1 (0-500 ms): Muestra la imagen completa
  - Fase 2 (500-3300 ms): Se muestra las caras multiplicadas, pero no son suficientes.
  - Fase 3 (3300-6200 ms): Aquí ya hay aproximadamente unas 8x4 caras creadas en la cámara.
  - Fase 4 (>6200 ms): El ejercito ha sido creado, aproximadamente hay unas 32x20 caras creadas en la cámara, añadiendo también que se creó en este preciso instante para que se sincronizara con la canción al romper (cosa que en el GIF no se aprecia :( ).
 - Si esperas 15 segundos más, creará más caras, pero no se apreciará mucho porque es demasiado pequeño.
```
Nota: No siempre detecta la cara y cuando detecta otra cosa,
muestra solo esa parte y puede que se distorsione un poco el efecto de ejército.
```

### Instrucciones
  - **E** - Cambia al filtro "¿Qué tipo de Mario eres?".
  - **R** - Cambia al filtro ejercito.
  - **N** - Pone la cámara a modo normal.
  
  
### Herramientas y Referencias
  
  - [Conversión video a GIF](https://imagen.online-convert.com/es/convertir-a-gif)
  
  - [Dschinghis Khan - Moskau 1979 (Min 1:05)](https://www.youtube.com/watch?v=NvS351QKFV4)
  
  - [Minim](http://code.compartmental.net/tools/minim/)
  
