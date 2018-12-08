#include <Arduino.h>
#include <stdint.h>
#include "Linduino.h"
#include "LT_SPI.h"
#include <SPI.h>
#include "UserInterface.h"
#include "LT_I2C.h"
#include "QuikEval_EEPROM.h"
#include "LTC24XX_general.h"
#include "LTC2497.h"
#include <XBee.h>

//static uint8_t i2c_address;
static uint8_t i2c_address = LTC2497_I2C_ADDRESS;
uint8_t ack = 0;
static float LTC2497_vref = 5.0;                    //!< The ideal reference voltage
static uint16_t timeout = 300;                      //!< 300 ms timeout      



void menu_3_set_address();


//! Lookup table to build the command for single-ended mode
const uint8_t BUILD_COMMAND_SINGLE_ENDED[16] = {LTC24XX_MULTI_CH_CH0, LTC24XX_MULTI_CH_CH1, LTC24XX_MULTI_CH_CH2, LTC24XX_MULTI_CH_CH3,
    LTC24XX_MULTI_CH_CH4, LTC24XX_MULTI_CH_CH5, LTC24XX_MULTI_CH_CH6, LTC24XX_MULTI_CH_CH7,
    LTC24XX_MULTI_CH_CH8, LTC24XX_MULTI_CH_CH9, LTC24XX_MULTI_CH_CH10, LTC24XX_MULTI_CH_CH11,
    LTC24XX_MULTI_CH_CH12, LTC24XX_MULTI_CH_CH13, LTC24XX_MULTI_CH_CH14, LTC24XX_MULTI_CH_CH15
                                                };    //!< Builds the command for single-ended mode

//! Lookup table to build the command for differential mode
const uint8_t BUILD_COMMAND_DIFF[16] = {LTC24XX_MULTI_CH_P0_N1, LTC24XX_MULTI_CH_P2_N3, LTC24XX_MULTI_CH_P4_N5, LTC24XX_MULTI_CH_P6_N7,
                                        LTC24XX_MULTI_CH_P8_N9, LTC24XX_MULTI_CH_P10_N11, LTC24XX_MULTI_CH_P12_N13, LTC24XX_MULTI_CH_P14_N15,
                                        LTC24XX_MULTI_CH_P1_N0, LTC24XX_MULTI_CH_P3_N2, LTC24XX_MULTI_CH_P5_N4, LTC24XX_MULTI_CH_P7_N6,
                                       LTC24XX_MULTI_CH_P9_N8, LTC24XX_MULTI_CH_P11_N10, LTC24XX_MULTI_CH_P13_N12, LTC24XX_MULTI_CH_P15_N14
                                        };      //!< Build the command for differential mode
XBee xb;
void setup() {
    int16_t user_command = 20;
  // put your setup code here, to run once:
    char demo_name[]="DC1012";    // Demo Board Name stored in QuikEval EEPROM
    quikeval_I2C_init();          // Configure the EEPROM I2C port for 100kHz
    quikeval_I2C_connect();       // Connect I2C to main data port
    Serial.begin(115200);
    xb = XBee();
    xb.setSerial(Serial); 
 
    i2c_address = user_command&0x7F;
          
}

byte* floatTobyte(float f[], int size) {
  int counter = 0;
  byte b[12];

  for(int i =0; i<size; i++) {
    byte *t = (byte*)&f[i];
    b[counter++] = t[0];
    b[counter++] = t[1];
    b[counter++] = t[2];
    b[counter++] = t[3];
  }
  return b;
}


void sendFloat(float f)
{
  byte *b = (byte*)&f;
  
//
//  Serial.write(b[0]);
//  Serial.write(b[1]);
//  Serial.write(b[2]);
//  Serial.write(b[3]);
    Serial.write(b ,4);
    Serial.flush();
}

void loop() { 
// put your main code here, to run repeatedly:

uint8_t acknowledge = 0;
uint8_t adc_command;     // The LTC2497 command word
int16_t user_command;    // The user input command
int32_t adc_code = 0;    // The LTC2497 code
float adc_voltage=0;     // The LTC2497 voltage


adc_command = BUILD_COMMAND_SINGLE_ENDED[0];                  // Build ADC command for channel 0     
ack |= LTC2497_read(i2c_address, adc_command, &adc_code, timeout);    // Throws out last reading
//float x[] = {2.4,1.1,3.2};
float f[17]; 
for (int8_t x = 0; x <= 15; x++)                              // Read all channels in single-ended mode
      {
        adc_command = BUILD_COMMAND_SINGLE_ENDED[(x + 1) % 16];

        ack |= LTC2497_read(i2c_address, adc_command, &adc_code, timeout);
        adc_voltage = LTC2497_code_to_voltage(adc_code, LTC2497_vref);
        if(!ack)
        {

          f[x] = adc_voltage;
          //Serial.println(adc_voltage);

        }
        else
        {
         // Serial.print(F("  ****"));
         // Serial.print(F("CH"));
         // Serial.print(x);
         // Serial.print(F(": "));
          Serial.println(F("Error in read"));
      
        }
      }
        f[16] = (float)analogRead(1);
      // byte * b = floatTobyte(f,16);      
        Serial.write((byte *)f, 68);
        Serial.flush();

}


