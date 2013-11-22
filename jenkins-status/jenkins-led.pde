#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// LED PIN
#define LED_PIN_G 2
#define LED_PIN_B 3
#define LED_PIN_R 4

// LED STATUS
#define ON            255
#define OFF           0

// Job Status Code
#define SUCCESS_CODE  1
#define FAIL_CODE     2
#define UNSTABLE_CODE 3

// LED Bar
int ANODEPIN[10] = { 18, 13, 12, 11, 10, 9, 8, 7, 6, 5 };
int CATHODEPIN[3] = { 14, 16, 15 }; // R, G, B

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

int status_code[10];
int cnt = 0;
boolean is_lighton = false;
void loop() {
    if (Serial.available() > 0) {
        char in_c = Serial.read();
        
        if (in_c == 'r') {
            running();
        } else {
            if (in_c == 'c') {
                //clear status_code
                cnt = 0;
                for (int i=0; i<10; i++) {
                    status_code[i] = 0;
                }
            } else {
                //enqueue -> status_code
                if (cnt < 10) {
                    status_code[cnt] = (int)in_c % 48;
                    cnt++;
                }
            }
                        
            // LED Ball
            switch (status_code[0]) {
                case UNSTABLE_CODE: unstable(); break;
                case SUCCESS_CODE:  success();  break;
                case FAIL_CODE:     fail();     break;
                default:            halt();     break;
            }
        }
    }
    
    // LED Bar
    for (int i = 0; i < cnt; i++) {
        lighton(ANODEPIN[i], CATHODEPIN[0], CATHODEPIN[1], CATHODEPIN[2], status_code[i]);
    }
}
