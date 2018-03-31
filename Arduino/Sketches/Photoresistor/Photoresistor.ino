int ledPin = 3;
int photocellInput = 0;
 
void setup()  {
  pinMode(ledPin, OUTPUT);
}
 
 
void loop()  {
 
  photocellInput = (analogRead(0)-128); // Divides input 0-1023 to resemble to 0-255
 
  analogWrite(ledPin, photocellInput);  
  // The delay can be change to get the desired dimming effect
  delay(20);                            
}
