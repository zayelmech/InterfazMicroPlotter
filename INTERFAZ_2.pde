import controlP5.*;
import processing.serial.*;

char cadena[]= {'x','y','z'};


PImage utm,denoba;

int[] corX=new int[100];
int[] corY=new int[100];

int realX[]=new int[100];
int realY[]=new int[100];
float delta;
int contador=0;
int servo1;

Serial port;
int manoX,manoY,dedoY;
int archivo;

ControlP5 cp5; 

Textfield ledr,ledg,ledb,intensidad;
Button boton,dibujar,nuevo;

int sizeX =800;
int sizeY =500;
void setup(){
cp5 = new ControlP5(this);

 denoba=loadImage("logo.png");
 utm=loadImage("utm.PNG");
 size(800,500);
     
   ledr = cp5.addTextfield("Z",width-350,height/10,50,20)
                   .setFont(createFont("arial",14))
                   .setAutoClear(false);
   ledg = cp5.addTextfield("HAND",width-280,height/10,50,20)
                   .setFont(createFont("arial",14))
                   .setAutoClear(false);
   ledb = cp5.addTextfield("ARM",width-210,height/10,50,20)
                   .setFont(createFont("arial",14))
                   .setAutoClear(false);
   /*intensidad = cp5.addTextfield("",width-255,height-205,50,20)
                   .setFont(createFont("arial",14))
                   .setAutoClear(false);
    */
    boton = cp5.addButton("Enviar")
        .setFont(createFont("arial",14))
        .setPosition(width-350,height-400)
        .setSize(80,30); 
    nuevo = cp5.addButton("Nuevo")
        .setFont(createFont("arial",14))
        .setPosition(width-259,height-250)
        .setSize(90,40); 
    
    dibujar = cp5.addButton("Dibujar")
        .setFont(createFont("arial",14))
        .setPosition(width-350,height-250)
        .setSize(90,40); 
        

    boton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): enviar(); break;
        case(ControlP5.ACTION_RELEASED): println("stop"); break;
      }
    }
  }
 );

   dibujar.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): fdraw(); break;
        case(ControlP5.ACTION_RELEASED): println("stop"); break;
      }
    }
  }
 );
 nuevo.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): fnuevo(); break;
        case(ControlP5.ACTION_RELEASED): println("stop"); break;
      }
    }
  }
 );
 
 fill(0);
// port = new Serial(this, Serial.list()[0], 9600); //Abre el puerto serie  
}
void draw(){
  
 background(53,131,120);
 textSize(15);
 fill(255);
 text("Dibuja en el área de abajo",40,25);
 text("Manual",450,38);
 
fill(70);
noStroke();
rect(445, 40, 210, 100,7);
rect(445, 230, 210, 100,7);

fill(255);
//text("VELOCIDAD",width-350,height-190);

fill(255);
stroke(126);
rect(40, 40, 400, 400);
//lines X
line(40,140, 440 , 140);
line(40,240, 440 , 240);
line(40,340, 440 , 340);
//lines Y
line(140,40, 140 , 440);
line(240,40, 240 , 440);
line(340,40, 340 , 440);

if(mousePressed && mouseX<441 && mouseY<441 && mouseX>39 && mouseY>39 &&contador<100){
//  delay(200);
if( contador>0)
   delta=sqrt(pow((abs(mouseX-corX[contador-1])),2) + pow(abs(mouseY -corY[contador-1]),2));
  
  if(delta>20 || contador==0){
    
  corX[contador]=mouseX;
  corY[contador]=mouseY;

 int posX=(corX[contador]-40)*115/399;
 int posY=(440 - corY[contador])*115/399;


float x=15+ posX;
float y=15+ posY;
float c =sqrt(x*x + y*y);
float thetaC=0; 
  thetaC=atan(y/x)*180/3.141592654;
 
float theta1=acos((2775.0 + c*c)/(200.0*c))*180/3.141592;
//theta1=acos((2775+c*c)/200*c)*180/3.141592;
int thetaBrazo=int( thetaC + theta1);
int thetaMano= int(acos((17225-c*c)/17000)*180/3.141592);
  
 realX[contador]=thetaBrazo;
 realY[contador]=180-thetaMano;
 
 println("thetaBrazo:" + thetaBrazo + " thetaMano: "+ thetaMano);
 println("posX: "+ x+"\t c: "+ c);
 println("posY: "+ y+"\t angulo: "+ thetaMano);
  
  contador++;
  }
}



fill(230);
noStroke();
rect(width-120,height-465,100, 455);
textSize(12);

if(contador>0){
  fill(0);
  noStroke();
 for(int i=0;i<contador;i++){
  ellipse(corX[i],corY[i],10,10);
  text("X:"+realX[i]+"  Y:" + realY[i],width -100,50+i*13);
 }//end for
}//end if
text(contador,width-120,height-450);

if(contador>1){
stroke(255,5,150);
 for(int i=0;i<(contador-1);i++){
line(corX[i],corY[i],corX[i+1],corY[i+1]);
 
 }//end for
}//end if


int red =int(ledr.getText());
 cadena[0]=char(red);
int green =int(ledg.getText());
 cadena[1]=char(green);
int blue =int(ledb.getText());
 cadena[2]=char(blue);

  


 image(denoba,width/5,height-55,179,50);

}//end main


void enviar(){
  
for(int i=0;i<3;i++){
 port.write(cadena[i]);
println("mensaje:"+ int(cadena[i]));
 }
}

void fdraw(){

 cadena[2]=char(realX[0]);
 cadena[1]=char(realY[0]);
 cadena[0]=120;
  for(int i=0;i<3;i++){
     port.write(cadena[i]);
     print( int(cadena[i])+ " <_> ");
  }
  delay(1000);
  
for(int j=0;j<contador;j++){
 cadena[2]=char(realX[j]);
 cadena[1]=char(realY[j]);
 cadena[0]=135;
 
  for(int i=0;i<3;i++){
     port.write(cadena[i]);
     print( int(cadena[i])+ " <_> ");
  }
  println("\n NEXT ");
  delay(500);
 }
 //stop condition
 cadena[2]=char(realX[contador-1]-10);//arm
 cadena[1]=char(realY[contador-1]+10); //hand
 cadena[0]=100;
  for(int i=0;i<3;i++){
     port.write(cadena[i]);
  }
  
}

void fnuevo(){
contador=0;
println("NUEVO DIBUJO");
}