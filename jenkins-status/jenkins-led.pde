// LED PIN
#define LED_PIN_G 9
#define LED_PIN_B 10
#define LED_PIN_R 11

// ON OFF
#define ON  255
#define OFF 0

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

// color - green
void running() {
  analogWrite(LED_PIN_R, OFF);
  analogWrite(LED_PIN_G, ON);
  analogWrite(LED_PIN_B, OFF);
}

// off
void halt() {
  analogWrite(LED_PIN_R, OFF);
  analogWrite(LED_PIN_G, OFF);
  analogWrite(LED_PIN_B, OFF);
}

// initialize
void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN_R, OUTPUT);
  pinMode(LED_PIN_G, OUTPUT);
  pinMode(LED_PIN_B, OUTPUT);
}
 
// main
void loop() {
  if (Serial.available() > 0) {
    char c = Serial.read();
    switch (c) {
      case 'RUNNING':  running();  break;
      case 'UNSTABLE': unstable(); break;
      case 'SUCCESS':  success();  break;
      case 'FAIL':     fail();     break;
      default:         halt();     break;
    }
  }
}
