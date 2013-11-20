// LED PIN
#define LED_PIN_G 2
#define LED_PIN_B 3
#define LED_PIN_R 4

// LED STATUS
#define ON            255
#define OFF           0

// Job Status Code
#define SUCCESS_CODE  101
#define FAIL_CODE     102
#define UNSTABLE_CODE 103

// LED Bar
int ANODEPIN[10] = { 18, 13, 12, 11, 10, 9, 8, 7, 6, 5 };
int CATHODEPIN[3] = { 14, 16, 15 }; // R, G, B

// dummy status code list for LED Bar
int statuses[10] = {FAIL_CODE, SUCCESS_CODE, FAIL_CODE, UNSTABLE_CODE, FAIL_CODE, FAIL_CODE, SUCCESS_CODE, UNSTABLE_CODE, SUCCESS_CODE, FAIL_CODE};

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
  // LED Ball
  Serial.begin(9600);
  pinMode(LED_PIN_R, OUTPUT);
  pinMode(LED_PIN_G, OUTPUT);
  pinMode(LED_PIN_B, OUTPUT);
  
  // LED Bar
  for(int ano = 0; ano < 10; ano++) {
    pinMode(ANODEPIN[ano], OUTPUT);
    digitalWrite(ANODEPIN[ano], LOW);
  }
  for(int cat = 0; cat < 3; cat++) {
    pinMode(CATHODEPIN[cat], OUTPUT);
    digitalWrite(CATHODEPIN[cat], HIGH);
  }
}

// LED Bar light up
int lighton(int anodepin, int r, int g, int b, int status_code) {
    double c[3];
    if (status_code == SUCCESS_CODE) {
      c[0] = 0.0;
      c[1] = 0.0;
      c[2] = 1.0;  // blue
    } else if (status_code == FAIL_CODE) {
      c[0] = 1.0;
      c[1] = 0.0;
      c[2] = 0.0;  // red
    } else if (status_code == UNSTABLE_CODE) {
      c[0] = 1.0;
      c[1] = 1.0;
      c[2] = 0.0;  // yellow
    } else {
      c[0] = 0.0;
      c[1] = 0.0;
      c[2] = 0.0;  // no color
    }
  
    int iR4 = (int)(c[0] * 4.0 + 0.5);
    int iG4 = (int)(c[1] * 4.0 + 0.5);
    int iB4 = (int)(c[2] * 4.0 + 0.5);
    digitalWrite( anodepin, HIGH );
    
    for( int i = 0; i < 10; i++ ) {
        for( int j = 0; j < 4; j++ ) {
            digitalWrite( r, !(j < iR4) );
            digitalWrite( g, !(j < iG4) );
            digitalWrite( b, !(j < iB4) );
        }
    }
    digitalWrite( r, HIGH );
    digitalWrite( g, HIGH );
    digitalWrite( b, HIGH );
    digitalWrite( anodepin, LOW );
}
 
// main
void loop() {
  // LED Ball
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

  // LED Bar
  for (int i = 0; i < 10; i++) {
    lighton(ANODEPIN[i], CATHODEPIN[0], CATHODEPIN[1], CATHODEPIN[2], statuses[i]);
  }
}
