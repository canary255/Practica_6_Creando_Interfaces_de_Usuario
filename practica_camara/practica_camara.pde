import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

Capture cam;
CVImage img;
CVImage caras;

Minim sound;
AudioSample ejercito;

int ancho,alto;
int anchoImg,altoImg;
int auxAltoImg, auxAnchoImg;
int caraDetectada=0;
int x=0,y=0;

int ejercitoTimer, auxEjercitoTimer;

int timer,auxTimer,numRandom,modo=0;

PImage[] imagenes = new PImage[10];

//Cascadas para detección
CascadeClassifier face,leye,reye;
//Nombres de modelos
String faceFile, leyeFile,reyeFile;

void setup() {
  size(640, 480);
  //Cámara
  cam = new Capture(this, width , height);
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  caras = new CVImage(cam.width, cam.height);
  
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  leyeFile = "haarcascade_mcs_lefteye.xml";
  reyeFile = "haarcascade_mcs_righteye.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  leye = new CascadeClassifier(dataPath(leyeFile));
  reye = new CascadeClassifier(dataPath(reyeFile));
  
  //IMAGE
  imagenes[0] = loadImage("texto.png");
  imagenes[1] = loadImage("mario_normal.jpg");
  imagenes[2] = loadImage("mario_corrupto.png");
  imagenes[3] = loadImage("mario_90.jpg");
  imagenes[4] = loadImage("mario_comunista.jpg");
  imagenes[5] = loadImage("mario_64.png");
  imagenes[6] = loadImage("mario_toon.jpg");
  imagenes[7] = loadImage("mario_fair.jpg");
  imagenes[8] = loadImage("mario_pelado.jpg");
  imagenes[9] = loadImage("mario_verde.png");
  
  ancho = cam.width;
  alto = cam.height;
  anchoImg=img.width;
  altoImg=img.height;
  
  sound = new Minim(this);
  ejercito = sound.loadSample("ejercito.mp3",1024);
}

void draw() {  
  if (cam.available()) {
    background(0);
    noStroke();
    
    cam.read();
    
    if(modo==0){    //Modo normal
      auxTimer=0;
      numRandom = (int) (random(0,9))+1;
      ancho = cam.width;
      alto = cam.height;
      auxAnchoImg=anchoImg;
      auxAltoImg=altoImg;
      x=0;y=0;
      caraDetectada=0;
      auxEjercitoTimer=0;
      ejercito.stop();
    } else if(modo==1){  //Modo filtro: "Que mario eres?"
      ancho = cam.width;
      alto = cam.height;
      auxAnchoImg=anchoImg;
      auxAltoImg=altoImg;
      x=0;y=0;
      caraDetectada=0;
      auxEjercitoTimer=0;
      ejercito.stop();
    } else if(modo==2){  //Modo filtro: Ejercito
      auxTimer=0;
      numRandom = (int) random(9)+1;
    }
    
    //Obtiene la imagen de la cámara
    if(modo==2 && caraDetectada==1){
        caras.copy(cam, x, y, ancho, alto, 
        0, 0, auxAnchoImg, auxAltoImg);
        caras.copyTo();
    } else {
      img.copy(cam, x, y, ancho, alto, 
      0, 0, auxAnchoImg, auxAltoImg);
      img.copyTo();
    }
    //Imagen de grises
    Mat gris = img.getGrey();
    
    //Imagen de entrada
    if(modo == 2 && caraDetectada==1){
      x=0;
      y=0;
      if(auxEjercitoTimer==0){
        ejercitoTimer=millis();
        auxEjercitoTimer=-1;  //Desactivamos timer
        ejercito.trigger();
      }
      if (millis() - ejercitoTimer < 500){
        image(img,0,0);
      } else if (millis() - ejercitoTimer > 500 && millis() - ejercitoTimer < 3300){
        while(x < width && y < height){
          image(caras,x,y);
          x = x+ancho;
          if(x >= width){
            x = 0;
            y = y+alto;
          }
        } 
      } else if (millis() - ejercitoTimer > 3300 && millis() - ejercitoTimer < 6200){
         while(x < width && y < height){
          image(caras,x,y,300,225);
          x = x+80;
          if(x >= width){
            x = 0;
            y = y+110;
          }
        } 
      } else if (millis() - ejercitoTimer > 6200 && millis() - ejercitoTimer < 20000){
         while(x < width && y < height){
          image(caras,x,y,150,80);
          x = x+40;
          if(x >= width){
            x = 0;
            y = y+40;
          }
        } 
      } else {
         while(x < width && y < height){
          image(caras,x,y,75,40);
          x = x+20;
          if(x >= width){
            x = 0;
            y = y+20;
          }
        } 
      }
    } else {
      image(img,0,0);
    }
    
    fill(0,255,0);
    textSize(19);
    text("Modo normal: N",0,16);
    text("¿Qué tipo de mario eres?: E",0,40);
    text("Modo ejercito: R",0,64);
    
    //Detección y pintado de contenedores
    FaceDetect(gris);
    
    gris.release();
  }
}

void keyPressed(){

  if(key=='E' || key=='e'){
    modo=1;
  } else if (key == 'N' || key=='n'){modo = 0;
  } else if (key == 'r' || key =='R'){
    modo=2;
  }

}


void FaceDetect(Mat grey)
{
  
  //Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
   
   if(modo==1){
     //Dibuja contenedores
     if(facesArr.length>0){
         dibujaMario();  //activamos timer
         if(millis()-timer < 3000){
           image(imagenes[0],facesArr[0].x, facesArr[0].y-80,200,100);
         } else if(millis()-timer > 3000 && millis()-timer < 9000) {
           image(imagenes[(int)random(9)+1],facesArr[0].x+50, facesArr[0].y-80,100,100);
         } else if(millis()-timer > 9000){
           image(imagenes[numRandom],facesArr[0].x+50, facesArr[0].y-80,100,100);
         }
     }
   }
   
   if(modo==2){
      if(facesArr.length>0){
        caraDetectada=1;
        
        
        ancho=facesArr[0].width;
        alto = facesArr[0].height+60;
        x= facesArr[0].x;
        y = facesArr[0].y-60;
        auxAnchoImg=ancho;
        auxAltoImg=alto;
      }
   }
   
   
   
  faces.release();
}


void dibujaMario(){
    if(auxTimer==0){
      timer = millis(); 
      auxTimer=-1;  //desactivamos timer
    }
}
