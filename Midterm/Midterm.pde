import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String otherComputer;

PVector p1Pos;
PVector p2Pos;

float paddleSpeed;

PVector ballPos;

float ballSpeedX;
float ballSpeedY;

boolean movingRight;
boolean movingLeft;

float p1Distance;
float p2Distance;

int p1Score;
int p2Score;

float firstValue;
int secondValue;
int thirdValue;
float fourthValue;
float fifthValue;

void setup(){
  size(500, 500);
  //frameRate(25);
  
  otherComputer = "192.168.0.8";
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress(otherComputer, 12000);
  
  ballPos = new PVector(width/2, height/2);
  ballSpeedX = 3;
  ballSpeedY = 3;
  
  paddleSpeed = 5;
  
  p1Score = 0;
  p2Score = 0;
  
  p1Pos = new PVector(width*0.1, height*0.4);
  
  p2Pos = new PVector(width*0.9, height*0.4);
}

void draw(){
  
  background(0);
  
  fill(255);
  
  OscMessage myMessage = new OscMessage("/PongGame");
  
  ellipse(ballPos.x, ballPos.y, 20, 20);
  
  ballPos.x += ballSpeedX;
  ballPos.y += ballSpeedY;
  
  rect(p1Pos.x, p1Pos.y, 10, 100);
  
  rect(p2Pos.x, p2Pos.y, 10, 100);
  
  p1Distance = PVector.dist(p1Pos, ballPos);
  p2Distance = PVector.dist(p2Pos, ballPos);
  
 //player 1 collision
 if(p1Distance <= 60 && movingLeft == true){
    ballSpeedX = -ballSpeedX;
  }
  
  //player 2 collision
  if(p2Distance <= 60 && movingRight == true){
   ballSpeedX = -ballSpeedX;
  }
  
  //println("Moving Right: " + movingRight);
  //println("Moving Left: " + movingLeft);
  
  if(ballPos.y < 20 || ballPos.y > height-20){
    ballSpeedY = - ballSpeedY;
  }
  
  if(ballSpeedX > 0){
    movingRight = true;
    movingLeft = false;
  }
  
  if(ballSpeedX < 0){
    movingRight = false;
    movingLeft = true;
  }
  
  if(ballPos.x < -20){
  p2Score++;
  ballPos.x = width-20;
  }
  
  if(ballPos.x > width+20){
   p1Score++; 
   ballPos.x = 20;
  }
  
  text("Player 1: " + p1Score, width*0.3, 50);
  text("Player 2: " + p2Score, width*0.6, 50);
  
  if(keyPressed){
    if (key == CODED) {
      if (keyCode == UP && p1Pos.y > 0) {
        p1Pos.y -= paddleSpeed;
        //p2Pos.y -= paddleSpeed;
      }
      if(keyCode == DOWN && p1Pos.y < height*0.79){
        p1Pos.y += paddleSpeed;
        //p2Pos.y += paddleSpeed;
      }
    }
  }
  
  myMessage.add(p1Pos.y);
  myMessage.add(p1Score);
  myMessage.add(p2Score);
  myMessage.add(ballPos.x);
  myMessage.add(ballPos.y);
  
  oscP5.send(myMessage, myRemoteLocation);
  
  p2Pos.y = firstValue;
  //p1Score = secondValue;
  //p2Score = thirdValue;
  //ballPos.x = forthValue;
  //ballPos.y = fifthValue;
  
}

void oscEvent(OscMessage theOscMessage) {
  
  if(theOscMessage.checkAddrPattern("/PongGame")==true){
    
    if(theOscMessage.checkTypetag("fiiff")){
      firstValue = theOscMessage.get(0).floatValue();
      secondValue = theOscMessage.get(1).intValue();
      thirdValue = theOscMessage.get(2).intValue();
      fourthValue = theOscMessage.get(3).floatValue();
      fifthValue = theOscMessage.get(4).floatValue();
      print("### received an osc message /PongGame with typetag ifs.");
      println(" values: "+firstValue+", "+secondValue+", "+thirdValue+", "+fourthValue+", "+fifthValue);
      return;
    }
  }
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}