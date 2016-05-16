#line 1 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/BT_Routines.c"


extern const BT_CMD;
extern const BT_AOK;
extern const BT_CONN;
extern const BT_END;
extern char BT_Get_Response();
extern void clearItsArray();

void BT_Configure() {

 do {
 UART1_Write_Text("$$$");
 Delay_ms(500);
 } while (BT_Get_Response() != BT_CMD);

 do {
 UART1_Write_Text("SN,BrightGOLSensor");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_AOK);
#line 58 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/BT_Routines.c"
 do {
 UART1_Write_Text("SO,Slave");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_AOK);

 do {
 UART1_Write_Text("SM,0");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_AOK);

 do {
 UART1_Write_Text("SA,1");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_AOK);

 do {
 UART1_Write_Text("SP,1234");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_AOK);
#line 88 "C:/Users/Darren/Desktop/samples/newMessageTypesFail/mikroC PRO for PIC/EasyPIC PRO v7 - PIC18F87K22/BT_Routines.c"
 do {
 UART1_Write_Text("---");
 UART1_Write(13);
 Delay_ms(500);
 } while (BT_Get_Response() != BT_END);

}
