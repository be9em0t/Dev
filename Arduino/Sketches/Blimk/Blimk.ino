void setup() {                
    // set pin 2 as an output
    pinMode(2, OUTPUT);     
}

void loop() {
    digitalWrite(2, HIGH);  // switch LED on 
    delay(3000);            // keep LED on for 1s
    digitalWrite(2, LOW);   // switch LED off
    delay(500);            // keeep LED off for 1s
}
