/*
 * Project name:
       Accel click - Accelerometer Test
 * Copyright:
      (c) mikroElektronika, 2012.
 * Revision History:
      20120703:
      - Initial release (DO);
 * Description:
      This is a simple project which demonstrates the use of Accel click board.
      Measured coordinates (X,Y,Z) are being sent over the UART.
      You can track change of coordinates in USART Terminal tool.
 * Test configuration:
     MCU:             PIC18F45K22
                      http://ww1.microchip.com/downloads/en/DeviceDoc/41412F.pdf
     Dev. Board:      EasyPIC v7
                      http://www.mikroe.com/eng/products/view/757/easypic-v7-development-system/
     Oscillator:      HS-PLL, 8.000 MHz Crystal, 32.000 MHz MCU Clock
     Ext. Modules:    Accel click - ac:Accel_click
                      http://www.mikroe.com/eng/products/view/896/accel-click/
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/eng/products/view/7/mikroc-pro-for-pic/
 * NOTES:
      - Place Accel Click board in the mikroBUS socket 1.
      - Turn on UART RX and TX pins (SW1.1 and SW2.1).
      - Set jumpers J3 and J4 acording the UART connection (RS-232 or USB).
*/

// ADXL345 Register Definition
#define _POWER_CTL      0x2D
#define _DATA_FORMAT    0x31
#define _BW_RATE        0x2C
#define _DATAX0         0x32
#define _DATAX1         0x33
#define _DATAY0         0x34
#define _DATAY1         0x35
#define _DATAZ0         0x36
#define _DATAZ1         0x37
#define _FIFO_CTL       0x38
#define _SPEED          0x0F         // Buffer Speed - 3200Hz

#define _ACCEL_ERROR    0x02

#define _ACCEL_ADDRESS  0x3A         //alt A6  // 3A


sbit ACCEL_CS     at LATE0_bit;
sbit ACCEL_CS_Dir at TRISE0_bit;

unsigned short temp;
char out[16];
int readings[3] = {0, 0, 0}; // X, Y and Z
short address, buffer;

void ADXL345_Write(unsigned short address, unsigned short data1) {
  I2C1_Start();              // issue I2C start signal
  I2C1_Wr(_ACCEL_ADDRESS);   // send byte via I2C  (device address + W)
  I2C1_Wr(address);          // send byte (address of the location)
  I2C1_Wr(data1);            // send data (data to be written)
  I2C1_Stop();               // issue I2C stop signal
}

unsigned short ADXL345_Read(unsigned short address) {
  unsigned short tmp = 0;

  I2C1_Start();              // issue I2C start signal
  I2C1_Wr(_ACCEL_ADDRESS);   // send byte via I2C (device address + W)
  I2C1_Wr(address);          // send byte (data address)

  I2C1_Start();              // issue I2C signal repeated start
  I2C1_Wr(_ACCEL_ADDRESS+1); // send byte (device address + R)
  tmp = I2C1_Rd(0);          // Read the data (NO acknowledge)
  I2C1_Stop();               // issue I2C stop signal

  return tmp;
}
char ADXL345_Init(void) {
  char id = 0x00;

  // Go into standby mode to configure the device.
  ADXL345_Write(0x2D, 0x00);

  id = ADXL345_Read(0x00);
  if (id != 0xE5) {
    return _ACCEL_ERROR;
  }
  else {
    ADXL345_Write(_DATA_FORMAT, 0x08);       // Full resolution, +/-2g, 4mg/LSB, right justified
    ADXL345_Write(_BW_RATE, 0x0A);           // Set 100 Hz data rate
    ADXL345_Write(_FIFO_CTL, 0x80);          // stream mode
    ADXL345_Write(_POWER_CTL, 0x08);         // POWER_CTL reg: measurement mode
    return 0x00;
  }
}

// Read X Axis
int Accel_ReadX(void) {
  char low_byte;
  int Out_x;

  Out_x = ADXL345_Read(_DATAX1);
  low_byte = ADXL345_Read(_DATAX0);

  Out_x = (Out_x << 8);
  Out_x = (Out_x | low_byte);

  return Out_x;
}

// Read Y Axis
int Accel_ReadY(void) {
  char low_byte;
  int Out_y;

  Out_y = ADXL345_Read(_DATAY1);
  low_byte = ADXL345_Read(_DATAY0);

  Out_y = (Out_y << 8);
  Out_y = (Out_y | low_byte);

  return Out_y;
}

// Read Z Axis
int Accel_ReadZ(void) {
  char low_byte;
  int Out_z;

  Out_z = ADXL345_Read(_DATAZ1);
  low_byte = ADXL345_Read(_DATAZ0);

  Out_z = (Out_z << 8);
  Out_z = (Out_z | low_byte);

  return Out_z;
}

// Calculate the average values of the X, Y and Z axis reads
void Accel_Average(void) {
  int i, sx, sy, sz;

  // sum
  sx = sy = sz = 0;

  // average accelerometer reading over last 16 samples
  for (i=0; i<16; i++) {
    sx += Accel_ReadX();
    sy += Accel_ReadY();
    sz += Accel_ReadZ();
  }
  // average
  readings[0] = sx >> 4;
  readings[1] = sy >> 4;
  readings[2] = sz >> 4;

}

// Display average X-axis read value on UART
void Display_X_Value(void) {
  UART1_Write_Text("X:");
  IntToStr(readings[0], out);
  UART1_Write_Text(out);
  UART1_Write(0x09);
  Delay_ms(100);
}

// Display average Y-axis read value on UART
void Display_Y_Value(void) {
  UART1_Write_Text("Y:");
  IntToStr(readings[1], out);
  UART1_Write_Text(out);
  UART1_Write(0x09);
  Delay_ms(100);
}

// Display average z-axis read value on UART
void Display_Z_Value(void) {
  UART1_Write_Text("Z:");
  IntToStr(readings[2], out);
  UART1_Write_Text(out);
  UART1_Write(0x0D);
  UART1_Write(0x0A);
  Delay_ms(100);
}
void AccelInit(){
  // Initialize ADXL345 accelerometer
  if (ADXL345_Init() == 0) {
    UART1_Write_Text("Accel module initialized.\r\n" );
    Delay_ms(2000);
  }
  else {
    //  UART_Write_Text("Error during Accel module initialization.", 70, 100);
    UART1_Write_Text("Error during initialization.");
    Delay_ms(2000);
  }
}


void accelClickMainInit() 
{
//  PLLEN_bit = 1;                   // Enable PLL
//  Delay_ms(150);

  CM1CON  = 0;                     // Turn off comparators
  CM2CON  = 0;
//  ANSELB  = 0;                     // Configure PORTB pins as digital
//  ANSELC  = 0;                     // Configure PORTC pins as digital

//?????dnbdnbdnb todo: check this out!
//  TRISC = 0x10;
UART1_Write_Text("Stage1");

  ACCEL_CS_Dir = 0;
  ACCEL_CS = 1;
UART1_Write_Text("Stage5");


  UART1_Write_Text("Accel test starting...\r\n");
  Delay_ms(2000);

  I2C1_Init(100000);

  AccelInit();
  Delay_ms(150);

  UART1_Write_Text("Reading axis values...\r\n\r\n");
  Delay_ms(2000);

}

void accelClickMainLoopInteration()
{
    Accel_Average();               // Calculate average X, Y and Z reads
    Display_X_Value();
    Display_Y_Value();
    Display_Z_Value();
}

/*
void main() {
  PLLEN_bit = 1;                   // Enable PLL
  Delay_ms(150);

  CM1CON  = 0;                     // Turn off comparators
  CM2CON  = 0;
  ANSELB  = 0;                     // Configure PORTB pins as digital
  ANSELC  = 0;                     // Configure PORTC pins as digital

  TRISC = 0x10;

  ACCEL_CS_Dir = 0;
  ACCEL_CS = 1;

  UART1_Init(9600);
  Delay_ms(100);                   // Wait for UART module to stabilize

  UART1_Write_Text("Accel test starting...\r\n");
  Delay_ms(2000);

  I2C1_Init(100000);

  AccelInit();
  Delay_ms(150);

  UART1_Write_Text("Reading axis values...\r\n\r\n");
  Delay_ms(2000);

  while(1) {
    Accel_Average();               // Calculate average X, Y and Z reads
    Display_X_Value();
    Display_Y_Value();
    Display_Z_Value();
  }
}
*/