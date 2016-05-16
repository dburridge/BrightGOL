#line 1 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/Bluetooth_click.c"
#line 1 "c:/users/darren/desktop/samples/newmessagetypesfail/mikroc pro for pic/easypic pro v7 - pic18f87k22/bt_routines.h"
char BT_Get_Response();
void BT_Configure();
#line 36 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/Bluetooth_click.c"
extern void accelClickMainInit();
extern void accelClickMainLoopInteration();


const BT_CMD = 1;
const BT_AOK = 2;
const BT_CONN = 3;
const BT_END = 4;


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


void interrupt(){
 if (RCIF_bit == 1) {
 tmp = UART1_Read();

 itsArray[iArray++] = tmp;

 if (CMD_mode){
#line 105 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/Bluetooth_click.c"
 switch (BT_state) {
 case 0: {
 response = 0;
 if (tmp == 'C')
 BT_state = 1;
 if (tmp == 'A')
 BT_state = 11;
 if (tmp == 'E')
 BT_state = 31;
 break;
 }

 case 1: {
 if (tmp == 'M')
 BT_state = 2;
 else if (tmp == 'O')
 BT_state = 22;
 else
 BT_state = 0;
 break;
 }

 case 2: {
 if (tmp == 'D') {
 response = BT_CMD;
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
 response = BT_AOK;
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
 response = BT_CONN;
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
 response = BT_END;
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
 txt[i] = 0;
 DataReady = 1;
 }
 else {
 txt[i] = tmp;
 i++;
 }
 RCIF_bit = 0;
 }
 }
}


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


 BT_Configure();


 Lcd_Out(1,1,"BT_Configure OK");
 Lcd_Out(2,1,"Waiting4 BT_CONN");
#line 271 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/Bluetooth_click.c"
 UART1_Write_Text("Bluetooth Click Connected!");
 UART1_Write(13);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Receiving...");


}


void main()
{

 int oldstateBT;
 ANCON0 = 0;
 ANCON1 = 0;


 TRISA0_bit = 1;

 TRISD = 0x00;
 LATD = 0xAA;

 oldstateBT = 0;


 CMD_mode = 1;
 BT_state = 0;
 response_rcvd = 0;
 responseID = 0;
 response = 0;
 tmp = 0;
 CMD_mode = 1;
 DataReady = 0;

 RCIE_bit = 1;
 PEIE_bit = 1;
 GIE_bit = 1;

 Lcd_Init();
 UART1_init(115200);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);



 Lcd_Out(1,1,"BlueTooth-Click!");
 Lcd_Out(2,3,"Demo example");
 Delay_ms(1500);

 clearItsArray();

 do {
 if ( (oldstateBT == 0) && Button(&PORTA, 0, 1, 1)) {
 oldstateBT = 1;
 }
 if ( (oldstateBT == 1) && Button(&PORTA, 0, 1, 0)) {
 LATD = ~LATD;
 oldstateBT = 2;

 }
 if ( Button(&PORTA, 1, 1, 1) || oldstateBT == 3 )
 {

 CMD_mode = 0;
 GIE_bit = 1;

 if ( oldstateBT != 3 )
 {
 UART1_Write_Text("Entering Data Mode");
 Lcd_Out(1,1,"Entering Data Mode");
 Lcd_Out(2,3,"Hangs here...");
 oldstateBT = 3;
 UART1_Write_Text("Stage0");
 accelClickMainInit();
 }

 i = 0;

 memset(txt, 0, 16);
 GIE_bit = 1;

 while (!DataReady)
 ;

 GIE_bit = 0;
 DataReady = 0;

 LCD_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Received:");
 Lcd_Out(2,3,txt);

 UART1_Write_Text(txt);

 accelClickMainLoopInteration();







 }

 } while(1);

}
