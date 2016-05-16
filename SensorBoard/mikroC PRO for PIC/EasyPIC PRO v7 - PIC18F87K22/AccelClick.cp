#line 1 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/AccelClick.c"
#line 47 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/AccelClick.c"
sbit ACCEL_CS at LATE0_bit;
sbit ACCEL_CS_Dir at TRISE0_bit;

unsigned short temp;
char out[16];
int readings[3] = {0, 0, 0};
short address, buffer;

void ADXL345_Write(unsigned short address, unsigned short data1) {
 I2C1_Start();
 I2C1_Wr( 0x3A );
 I2C1_Wr(address);
 I2C1_Wr(data1);
 I2C1_Stop();
}

unsigned short ADXL345_Read(unsigned short address) {
 unsigned short tmp = 0;

 I2C1_Start();
 I2C1_Wr( 0x3A );
 I2C1_Wr(address);

 I2C1_Start();
 I2C1_Wr( 0x3A +1);
 tmp = I2C1_Rd(0);
 I2C1_Stop();

 return tmp;
}
char ADXL345_Init(void) {
 char id = 0x00;


 ADXL345_Write(0x2D, 0x00);

 id = ADXL345_Read(0x00);
 if (id != 0xE5) {
 return  0x02 ;
 }
 else {
 ADXL345_Write( 0x31 , 0x08);
 ADXL345_Write( 0x2C , 0x0A);
 ADXL345_Write( 0x38 , 0x80);
 ADXL345_Write( 0x2D , 0x08);
 return 0x00;
 }
}


int Accel_ReadX(void) {
 char low_byte;
 int Out_x;

 Out_x = ADXL345_Read( 0x33 );
 low_byte = ADXL345_Read( 0x32 );

 Out_x = (Out_x << 8);
 Out_x = (Out_x | low_byte);

 return Out_x;
}


int Accel_ReadY(void) {
 char low_byte;
 int Out_y;

 Out_y = ADXL345_Read( 0x35 );
 low_byte = ADXL345_Read( 0x34 );

 Out_y = (Out_y << 8);
 Out_y = (Out_y | low_byte);

 return Out_y;
}


int Accel_ReadZ(void) {
 char low_byte;
 int Out_z;

 Out_z = ADXL345_Read( 0x37 );
 low_byte = ADXL345_Read( 0x36 );

 Out_z = (Out_z << 8);
 Out_z = (Out_z | low_byte);

 return Out_z;
}


void Accel_Average(void) {
 int i, sx, sy, sz;


 sx = sy = sz = 0;


 for (i=0; i<16; i++) {
 sx += Accel_ReadX();
 sy += Accel_ReadY();
 sz += Accel_ReadZ();
 }

 readings[0] = sx >> 4;
 readings[1] = sy >> 4;
 readings[2] = sz >> 4;

}


void Display_X_Value(void) {
 UART1_Write_Text("X:");
 IntToStr(readings[0], out);
 UART1_Write_Text(out);
 UART1_Write(0x09);
 Delay_ms(100);
}


void Display_Y_Value(void) {
 UART1_Write_Text("Y:");
 IntToStr(readings[1], out);
 UART1_Write_Text(out);
 UART1_Write(0x09);
 Delay_ms(100);
}


void Display_Z_Value(void) {
 UART1_Write_Text("Z:");
 IntToStr(readings[2], out);
 UART1_Write_Text(out);
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 Delay_ms(100);
}
void AccelInit(){

 if (ADXL345_Init() == 0) {
 UART1_Write_Text("Accel module initialized.\r\n" );
 Delay_ms(2000);
 }
 else {

 UART1_Write_Text("Error during initialization.");
 Delay_ms(2000);
 }
}


void accelClickMainInit()
{



 CM1CON = 0;
 CM2CON = 0;





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
 Accel_Average();
 Display_X_Value();
 Display_Y_Value();
 Display_Z_Value();
}
