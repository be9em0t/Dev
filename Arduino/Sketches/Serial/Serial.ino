/*--------------------------------------------------------------
  Program:     serial_tx_msg
               (serial transmit message)

  Description:  Sends a text message out of the serial (USB)
                port of the Arduino every second.
                
                Use the Arduino Serial Monitor to receive the
                message.
               
  Date:         3 March 2012
 
  Author:       W.A. Smith, http://startingelectronics.org
--------------------------------------------------------------*/

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println("Hello, world!");
  delay(1000);
  Serial.println("======");
  delay(2000);
  }
