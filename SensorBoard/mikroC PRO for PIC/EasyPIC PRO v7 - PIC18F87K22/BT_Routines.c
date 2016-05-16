//  Configure BlueTooth-Click module
// responses to parse
extern const BT_CMD;
extern const BT_AOK;
extern const BT_CONN;
extern const BT_END;
extern char BT_Get_Response();
extern void clearItsArray();

void  BT_Configure() {

  do {
    UART1_Write_Text("$$$");                  // Enter command mode
    Delay_ms(500);
  } while (BT_Get_Response() != BT_CMD);

  do {
    UART1_Write_Text("SN,BrightGOLSensor");   // Name of device
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

/*do {
    UART1_Write_Text("S-,BGSensor");   //
    UART1_Write(13);
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

     //F,1
  do {
    UART1_Write_Text("SI,0200");   // Inquiry Scan window
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);


  do {
    UART1_Write_Text("SJ,0200");   // Inquiry Scan window
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);*/



// R,1   ---- reboot
//  do {
//    UART1_Write_Text("SF,1 ");   // Factory Default
//    UART1_Write(13);                          // CR
//    Delay_ms(500);
//  } while (BT_Get_Response() != BT_AOK);

//  do {
//    UART1_Write_Text("SS,GoalDetector");   // Name of device
//    UART1_Write(13);                          // CR
//    Delay_ms(500);
//  } while (BT_Get_Response() != BT_AOK);

   do {
    UART1_Write_Text("SO,Slave");             // Extended status string
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

  do {
    UART1_Write_Text("SM,0");                 // Set mode (0 = slave, 1 = master, 2 = trigger, 3 = auto, 4 = DTR, 5 = ANY)
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

  do {
    UART1_Write_Text("SA,1");                 // Authentication (1 to enable, 0 to disable)
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

  do {
    UART1_Write_Text("SP,1234");              // Security pin code (mikroe)
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_AOK);

/*do {
    UART1_Write_Text("R,1");                  // Security pin code (mikroe)
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_END);*/

  do {
    UART1_Write_Text("---");                  // Security pin code (mikroe)
    UART1_Write(13);                          // CR
    Delay_ms(500);
  } while (BT_Get_Response() != BT_END);

}
