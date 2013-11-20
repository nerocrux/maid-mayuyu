// LED PIN
#define LED_PIN_G 9
#define LED_PIN_B 10
#define LED_PIN_R 11

// ON OFF
#define ON  255
#define OFF 0

// BLINK ELAPSE
#define ELAPSE 600

// color - red
void fail() {
  analogWrite(LED_PIN_R, ON);
  analogWrite(LED_PIN_G, OFF);
  analogWrite(LED_PIN_B, OFF);
}

// color - blue
void success() {
  analogWrite(LED_PIN_R, OFF);
  analogWrite(LED_PIN_G, OFF);
  analogWrite(LED_PIN_B, ON);
}

// color - yellow
void unstable() {
  analogWrite(LED_PIN_R, ON);
  analogWrite(LED_PIN_G, ON);
  analogWrite(LED_PIN_B, OFF);
}

// blue blink
void running() {
  analogWrite(LED_PIN_B, ON);
  delay(ELAPSE);
  analogWrite(LED_PIN_B, OFF);
  delay(ELAPSE);
}

// initialize
void setup(){
  pinMode(LED_PIN_R, OUTPUT);
  pinMode(LED_PIN_G, OUTPUT);
  pinMode(LED_PIN_B, OUTPUT);
}
 
// main
void loop() {
  if (Serial.available() > 0) {
    char c = Serial.read();
    if (c == 'running') {
      running();
    } else if (c == 'unstable') {
      unstable();
    } else if (c == 'success')  {
      success();
    } else if (c == 'fail')     {
      fail();
    }
  }
}
