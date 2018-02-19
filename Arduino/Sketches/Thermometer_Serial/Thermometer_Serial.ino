/*--------------------------------------------------------------
  Program:     serial_temperature

  Description:  Reads the voltage from a MCP9700 temperature
                sensor on pin A0 of the Arduino. Converts the
                voltage to a temperature and sends it out of
                the serial port for display on the serial
                monitor.

  Date:         15 April 2012
 
  Author:       W.A. Smith, http://startingelectronics.org
--------------------------------------------------------------*/

void setup() {
    // initialize the serial port
    Serial.begin(9600);
}

void loop() {
    float temperature = 0.0;   // stores the calculated temperature
    int sample;                // counts through ADC samples
    float ten_samples = 0.0;   // stores sum of 10 samples
  
    // take 10 samples from the MCP9700
    for (sample = 0; sample < 10; sample++) {
        // convert A0 value to temperature
        temperature = ((float)analogRead(A0) * 5.0 / 1024.0) - 0.5;
        temperature = temperature / 0.01;
        // sample every 0.1 seconds
        delay(100);
        // sum of all samples
        ten_samples = ten_samples + temperature;
    }
    // get the average value of 10 temperatures
    temperature = ten_samples / 10.0;
    // send temperature out of serial port
    Serial.print(temperature);
    Serial.println(" deg. C");
    ten_samples = 0.0;
}


