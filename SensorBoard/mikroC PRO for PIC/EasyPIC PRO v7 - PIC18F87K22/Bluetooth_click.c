/*
 * Project name:
     Bluetooth click board example;
 * Copyright:                                             it jumps to the wrong location
     (c) MikroElektronika, 2012.
  * Revision History:
     20120404:
       - initial release (FJ);
 * Description:
     This is a simple project which demonstrates the use of Bluetooth click board.
     After establishing the connection, Master sends messages to the Slave. 
     The Slave receives them and displays them at the 2x16 Lcd.
     As a Master any bluetooth device can be used: mobile phone, Bluetooth dongle, etc...
 * Test configuration:
     MCU:             PIC18F87K22
                      http://ww1.microchip.com/downloads/en/DeviceDoc/39960d.pdf
     Dev.Board:       EasyPIC PRO v7
                      http://www.mikroe.com/eng/products/view/815/easypic-pro-v7-development-system/
     Oscillator:      HS-PLL 64.0000 MHz, 16.0000 MHz Crystal
     Ext. Modules:    Bluetooth click Board - ac:BT_click
                      2x16 Lcd character display - ac:Lcd
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * NOTES:
     - Place Bluetooth click board in the mikroBUS socket 1 on the EasyPIC PRO v7 board.
     - Put power supply jumper (J1) on the EasyPIC PRO v7 board in 3.3V position.
     - Be sure to correctly establish connection between Bluetooth click board and Master.
     - After this, the EasyPIC PRO v7 must be powered off/on, due to the Bluetooth data mode entering.
     - At the Master side, connect to the appropriate virtual COM port using 
       Terminal and send message which will be displayed on the Lcd.
     - Passkey used in this example is "1234".
 */

#include "BT_Routines.h"

extern void accelClickMainInit();
extern void accelClickMainLoopInteration();

// responses to parse
const BT_CMD  = 1;
const BT_AOK  = 2;
const BT_CONN = 3;
const BT_END  = 4;

// Lcd module connections
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;
// End Lcd module connections

char txt[16];
unsigned short i, tmp, DataReady;
char CMD_mode;

char BT_state;
char response_rcvd;
char responseID, response = 0;
unsigned char itsArray[200];
unsigned short iArray = 0;

void clearItsArray()
{
     for ( iArray = 0; iArray < 200; iArray++ )
     {
         itsArray[iArray] = 0;
     }
     iArray = 0;
}

// Uart Rx interrupt handler
void interrupt(){
  if (RCIF_bit == 1) {                          // Do we have uart rx interrupt request?
    tmp = UART1_Read();                         // Get received byte

    itsArray[iArray++] = tmp;

  if (CMD_mode){

    /* The responses expected from the Bluetooth-Click module:
    CMD
    AOK
    AOK
    AOK
    AOK
    AOK
    END
    SlaveCONNECT1234
    Bluetooth-Click
    1234 ...
    Bluetooth-Click
    */

    // Process reception through state machine
    // We are parsing CMD<cr><lf>, AOK<cr><lf>, CONN<cr> and END<cr><lf> responses
    switch (BT_state) {
      case  0: {
                response = 0;                   // Clear response
                if (tmp == 'C')                 // We have 'C', it could be CMD<cr><lf>  or CONN
                  BT_state = 1;                 // Expecting 'M' or 'N'
                if (tmp == 'A')                 // We have 'A', it could be AOK<cr><lf>
                  BT_state = 11;                // expecting 'O'
                if (tmp == 'E')                 // We have 'E', it could be END<cr><lf>
                  BT_state = 31;                // expecting 'N'
                break;                          // ...
      }

      case  1: {
                if (tmp == 'M')
                  BT_state = 2;
                else if (tmp == 'O')
                  BT_state = 22;
                else
                  BT_state = 0;
                break;
      }

      case  2: {
                if (tmp == 'D') {
                  response = BT_CMD;           // CMD
                  BT_state = 40;
                }
                else
                  BT_state = 0;
                break;
      }

      case 11: {
                if (tmp == 'O')
                  BT_state = 12;
                else
                  BT_state = 0;
                break;
      }

      case 12: {
                if (tmp == 'K'){
                  response = BT_AOK;            // AOK
                  BT_state = 40;
                }
                else
                  BT_state = 0;
                break;
      }

      case 22: {
                if (tmp == 'N')
                  BT_state = 23;
                else
                  BT_state = 0;
                break;
      }

      case 23: {
                if (tmp == 'N') {
                  response = BT_CONN;           // SlaveCONNECTmikroE
                  response_rcvd = 1;
                  responseID = response;
                }
                BT_state = 0;
                break;
      }

      case 31: {
                if (tmp == 'N')
                  BT_state = 32;
                else
                  BT_state = 0;
                break;
      }

      case 32: {
                if (tmp == 'D') {
                  response = BT_END;           // END
                  BT_state = 40;
                }
                else
                  BT_state = 0;
                break;
      }

      case 40: {
                if (tmp == 13)
                  BT_state = 41;
                else
                  BT_state = 0;
                break;
      }

      case 41: {
                if (tmp == 10){
                  response_rcvd = 1;
                  responseID = response;
                }
                BT_state = 0;
                break;
      }

      default: {
                BT_state = 0;
                break;
      }
    }
  }
  else {
    if (tmp == 13) {
      txt[i] = 0;                            // Puting 0 at the end of the string
      DataReady = 1;                         // Data is received
    }
    else {
      txt[i] = tmp;                          // Moving the data received from UART to string txt[]
      i++;                                   // Increment counter
    }
    RCIF_bit = 0;                            // Clear UART RX interrupt flag
  }
  }
}

// Get BlueTooth response, if there is any
char BT_Get_Response() {
  if (response_rcvd) {
    response_rcvd = 0;
    return responseID;
  }
  else
    return 0;
}


void initBT()
{

  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(1,1,"Connecting!");
  Lcd_Out(2,1,"Please, wait...");
  Delay_ms(1500);

  // Configure BlueTooth-Click module
  BT_Configure();


  Lcd_Out(1,1,"BT_Configure OK");
  Lcd_Out(2,1,"Waiting4 BT_CONN");


  //  Wait until connected
//  while (BT_Get_Response() != BT_CONN);
//
//  Lcd_Out(1,1,"BT_CONN OK");
//  Lcd_Out(2,1,"Waiting4 Commands");
//
//  Lcd_Cmd(_LCD_CLEAR);          //  Clear display
//  CMD_mode = 0;
//  GIE_bit = 0;                  // Disable Global interrupt
//  DataReady = 0;                // Data not received
//
//  LCD_Cmd(_LCD_CLEAR);          // Clear display
//  Lcd_Out(1,1,"Connected!");    // Display message
//  Delay_ms(1000);
//

  UART1_Write_Text("Bluetooth Click Connected!");         //  Send message on connection
  UART1_Write(13);              // CR
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Out(1,1,"Receiving...");  // Display message


}


void main() 
{

  int oldstateBT;
  ANCON0 = 0;                                    // Configure PORTB pins as digital
  ANCON1 = 0;                                    // Configure PORTC pins as digital
  //ANCON2 = 0;

  TRISA0_bit = 1;                                // set RB0 pin as input

  TRISD = 0x00;                                  // Configure PORTD as output
  LATD = 0xAA;                                   // Initial PORTD value

  oldstateBT = 0;
  
    // Initialize variables
  CMD_mode = 1;
  BT_state = 0;
  response_rcvd = 0;
  responseID = 0;
  response = 0;
  tmp = 0;
  CMD_mode = 1;
  DataReady = 0;

  RCIE_bit = 1;                 // Enable UART RX interrupt
  PEIE_bit = 1;                 // Enable Peripheral interrupt
  GIE_bit  = 1;                 // Enable Global interrupt

  Lcd_Init();                   // Lcd Init
  UART1_init(115200);           // Initialize UART1 module
  Lcd_Cmd(_LCD_CLEAR);          // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);     // Turn cursor off


  // Display starting messages
  Lcd_Out(1,1,"BlueTooth-Click!");
  Lcd_Out(2,3,"Demo example");
  Delay_ms(1500);

  clearItsArray();

  do {
    if ( (oldstateBT == 0) && Button(&PORTA, 0, 1, 1)) {               // Detect logical one
      oldstateBT = 1;                              // Update flag
    }
    if ( (oldstateBT == 1) && Button(&PORTA, 0, 1, 0)) {   // Detect one-to-zero transition
      LATD = ~LATD;                              // Invert PORTD
      oldstateBT = 2;                              // Update flag
//      initBT();
    }
    if (  Button(&PORTA, 1, 1, 1) || oldstateBT == 3 )
    {
    
  CMD_mode = 0;
  GIE_bit = 1;                  // Disable Global interrupt

        if ( oldstateBT != 3 ) //display only the first time
        {
            UART1_Write_Text("Entering Data Mode");
            Lcd_Out(1,1,"Entering Data Mode");
            Lcd_Out(2,3,"Hangs here...");
            oldstateBT = 3;
            UART1_Write_Text("Stage0");
            accelClickMainInit();
        }

        i = 0;                      // Initialize counter

        memset(txt, 0, 16);         // Clear array of chars
        GIE_bit = 1;                // Interrupts allowed

        while (!DataReady)          // Wait while the data is received
          ;

        GIE_bit  = 0;               // Interrupts forbiden
        DataReady = 0;              // Data not received

        LCD_Cmd(_LCD_CLEAR);        // Clear display
        Lcd_Out(1,1,"Received:");   // Display message
        Lcd_Out(2,3,txt);   // Display message
        
        UART1_Write_Text(txt);

        accelClickMainLoopInteration();
//        Lcd_Cmd(_LCD_SECOND_ROW);   // Write in second row

//        i = 0;                      // Reset counter
//        while (txt[i] != 0) {
//          Lcd_Chr_CP(txt[i]);       // Displaying the received text on the LCD
//          i++;                      // Increment counter
//        }
    }

  } while(1);                                    // Endless loop

}