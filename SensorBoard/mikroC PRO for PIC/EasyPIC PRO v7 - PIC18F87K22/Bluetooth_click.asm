
_clearItsArray:

;Bluetooth_click.c,71 :: 		void clearItsArray()
;Bluetooth_click.c,73 :: 		for ( iArray = 0; iArray < 200; iArray++ )
	CLRF        _iArray+0 
L_clearItsArray0:
	MOVLW       200
	SUBWF       _iArray+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_clearItsArray1
;Bluetooth_click.c,75 :: 		itsArray[iArray] = 0;
	MOVLW       _itsArray+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_itsArray+0)
	MOVWF       FSR1H 
	MOVF        _iArray+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Bluetooth_click.c,73 :: 		for ( iArray = 0; iArray < 200; iArray++ )
	INCF        _iArray+0, 1 
;Bluetooth_click.c,76 :: 		}
	GOTO        L_clearItsArray0
L_clearItsArray1:
;Bluetooth_click.c,77 :: 		iArray = 0;
	CLRF        _iArray+0 
;Bluetooth_click.c,78 :: 		}
L_end_clearItsArray:
	RETURN      0
; end of _clearItsArray

_interrupt:

;Bluetooth_click.c,81 :: 		void interrupt(){
;Bluetooth_click.c,82 :: 		if (RCIF_bit == 1) {                          // Do we have uart rx interrupt request?
	BTFSS       RCIF_bit+0, BitPos(RCIF_bit+0) 
	GOTO        L_interrupt3
;Bluetooth_click.c,83 :: 		tmp = UART1_Read();                         // Get received byte
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _tmp+0 
;Bluetooth_click.c,85 :: 		itsArray[iArray++] = tmp;
	MOVLW       _itsArray+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_itsArray+0)
	MOVWF       FSR1H 
	MOVF        _iArray+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        _iArray+0, 1 
;Bluetooth_click.c,87 :: 		if (CMD_mode){
	MOVF        _CMD_mode+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt4
;Bluetooth_click.c,105 :: 		switch (BT_state) {
	GOTO        L_interrupt5
;Bluetooth_click.c,106 :: 		case  0: {
L_interrupt7:
;Bluetooth_click.c,107 :: 		response = 0;                   // Clear response
	CLRF        _response+0 
;Bluetooth_click.c,108 :: 		if (tmp == 'C')                 // We have 'C', it could be CMD<cr><lf>  or CONN
	MOVF        _tmp+0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt8
;Bluetooth_click.c,109 :: 		BT_state = 1;                 // Expecting 'M' or 'N'
	MOVLW       1
	MOVWF       _BT_state+0 
L_interrupt8:
;Bluetooth_click.c,110 :: 		if (tmp == 'A')                 // We have 'A', it could be AOK<cr><lf>
	MOVF        _tmp+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt9
;Bluetooth_click.c,111 :: 		BT_state = 11;                // expecting 'O'
	MOVLW       11
	MOVWF       _BT_state+0 
L_interrupt9:
;Bluetooth_click.c,112 :: 		if (tmp == 'E')                 // We have 'E', it could be END<cr><lf>
	MOVF        _tmp+0, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
;Bluetooth_click.c,113 :: 		BT_state = 31;                // expecting 'N'
	MOVLW       31
	MOVWF       _BT_state+0 
L_interrupt10:
;Bluetooth_click.c,114 :: 		break;                          // ...
	GOTO        L_interrupt6
;Bluetooth_click.c,117 :: 		case  1: {
L_interrupt11:
;Bluetooth_click.c,118 :: 		if (tmp == 'M')
	MOVF        _tmp+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt12
;Bluetooth_click.c,119 :: 		BT_state = 2;
	MOVLW       2
	MOVWF       _BT_state+0 
	GOTO        L_interrupt13
L_interrupt12:
;Bluetooth_click.c,120 :: 		else if (tmp == 'O')
	MOVF        _tmp+0, 0 
	XORLW       79
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;Bluetooth_click.c,121 :: 		BT_state = 22;
	MOVLW       22
	MOVWF       _BT_state+0 
	GOTO        L_interrupt15
L_interrupt14:
;Bluetooth_click.c,123 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt15:
L_interrupt13:
;Bluetooth_click.c,124 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,127 :: 		case  2: {
L_interrupt16:
;Bluetooth_click.c,128 :: 		if (tmp == 'D') {
	MOVF        _tmp+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
;Bluetooth_click.c,129 :: 		response = BT_CMD;           // CMD
	MOVLW       1
	MOVWF       _response+0 
;Bluetooth_click.c,130 :: 		BT_state = 40;
	MOVLW       40
	MOVWF       _BT_state+0 
;Bluetooth_click.c,131 :: 		}
	GOTO        L_interrupt18
L_interrupt17:
;Bluetooth_click.c,133 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt18:
;Bluetooth_click.c,134 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,137 :: 		case 11: {
L_interrupt19:
;Bluetooth_click.c,138 :: 		if (tmp == 'O')
	MOVF        _tmp+0, 0 
	XORLW       79
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
;Bluetooth_click.c,139 :: 		BT_state = 12;
	MOVLW       12
	MOVWF       _BT_state+0 
	GOTO        L_interrupt21
L_interrupt20:
;Bluetooth_click.c,141 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt21:
;Bluetooth_click.c,142 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,145 :: 		case 12: {
L_interrupt22:
;Bluetooth_click.c,146 :: 		if (tmp == 'K'){
	MOVF        _tmp+0, 0 
	XORLW       75
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
;Bluetooth_click.c,147 :: 		response = BT_AOK;            // AOK
	MOVLW       2
	MOVWF       _response+0 
;Bluetooth_click.c,148 :: 		BT_state = 40;
	MOVLW       40
	MOVWF       _BT_state+0 
;Bluetooth_click.c,149 :: 		}
	GOTO        L_interrupt24
L_interrupt23:
;Bluetooth_click.c,151 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt24:
;Bluetooth_click.c,152 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,155 :: 		case 22: {
L_interrupt25:
;Bluetooth_click.c,156 :: 		if (tmp == 'N')
	MOVF        _tmp+0, 0 
	XORLW       78
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
;Bluetooth_click.c,157 :: 		BT_state = 23;
	MOVLW       23
	MOVWF       _BT_state+0 
	GOTO        L_interrupt27
L_interrupt26:
;Bluetooth_click.c,159 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt27:
;Bluetooth_click.c,160 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,163 :: 		case 23: {
L_interrupt28:
;Bluetooth_click.c,164 :: 		if (tmp == 'N') {
	MOVF        _tmp+0, 0 
	XORLW       78
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
;Bluetooth_click.c,165 :: 		response = BT_CONN;           // SlaveCONNECTmikroE
	MOVLW       3
	MOVWF       _response+0 
;Bluetooth_click.c,166 :: 		response_rcvd = 1;
	MOVLW       1
	MOVWF       _response_rcvd+0 
;Bluetooth_click.c,167 :: 		responseID = response;
	MOVLW       3
	MOVWF       _responseID+0 
;Bluetooth_click.c,168 :: 		}
L_interrupt29:
;Bluetooth_click.c,169 :: 		BT_state = 0;
	CLRF        _BT_state+0 
;Bluetooth_click.c,170 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,173 :: 		case 31: {
L_interrupt30:
;Bluetooth_click.c,174 :: 		if (tmp == 'N')
	MOVF        _tmp+0, 0 
	XORLW       78
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt31
;Bluetooth_click.c,175 :: 		BT_state = 32;
	MOVLW       32
	MOVWF       _BT_state+0 
	GOTO        L_interrupt32
L_interrupt31:
;Bluetooth_click.c,177 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt32:
;Bluetooth_click.c,178 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,181 :: 		case 32: {
L_interrupt33:
;Bluetooth_click.c,182 :: 		if (tmp == 'D') {
	MOVF        _tmp+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt34
;Bluetooth_click.c,183 :: 		response = BT_END;           // END
	MOVLW       4
	MOVWF       _response+0 
;Bluetooth_click.c,184 :: 		BT_state = 40;
	MOVLW       40
	MOVWF       _BT_state+0 
;Bluetooth_click.c,185 :: 		}
	GOTO        L_interrupt35
L_interrupt34:
;Bluetooth_click.c,187 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt35:
;Bluetooth_click.c,188 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,191 :: 		case 40: {
L_interrupt36:
;Bluetooth_click.c,192 :: 		if (tmp == 13)
	MOVF        _tmp+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt37
;Bluetooth_click.c,193 :: 		BT_state = 41;
	MOVLW       41
	MOVWF       _BT_state+0 
	GOTO        L_interrupt38
L_interrupt37:
;Bluetooth_click.c,195 :: 		BT_state = 0;
	CLRF        _BT_state+0 
L_interrupt38:
;Bluetooth_click.c,196 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,199 :: 		case 41: {
L_interrupt39:
;Bluetooth_click.c,200 :: 		if (tmp == 10){
	MOVF        _tmp+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt40
;Bluetooth_click.c,201 :: 		response_rcvd = 1;
	MOVLW       1
	MOVWF       _response_rcvd+0 
;Bluetooth_click.c,202 :: 		responseID = response;
	MOVF        _response+0, 0 
	MOVWF       _responseID+0 
;Bluetooth_click.c,203 :: 		}
L_interrupt40:
;Bluetooth_click.c,204 :: 		BT_state = 0;
	CLRF        _BT_state+0 
;Bluetooth_click.c,205 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,208 :: 		default: {
L_interrupt41:
;Bluetooth_click.c,209 :: 		BT_state = 0;
	CLRF        _BT_state+0 
;Bluetooth_click.c,210 :: 		break;
	GOTO        L_interrupt6
;Bluetooth_click.c,212 :: 		}
L_interrupt5:
	MOVF        _BT_state+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt7
	MOVF        _BT_state+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt11
	MOVF        _BT_state+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt16
	MOVF        _BT_state+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt19
	MOVF        _BT_state+0, 0 
	XORLW       12
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt22
	MOVF        _BT_state+0, 0 
	XORLW       22
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt25
	MOVF        _BT_state+0, 0 
	XORLW       23
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt28
	MOVF        _BT_state+0, 0 
	XORLW       31
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt30
	MOVF        _BT_state+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt33
	MOVF        _BT_state+0, 0 
	XORLW       40
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt36
	MOVF        _BT_state+0, 0 
	XORLW       41
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt39
	GOTO        L_interrupt41
L_interrupt6:
;Bluetooth_click.c,213 :: 		}
	GOTO        L_interrupt42
L_interrupt4:
;Bluetooth_click.c,215 :: 		if (tmp == 13) {
	MOVF        _tmp+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt43
;Bluetooth_click.c,216 :: 		txt[i] = 0;                            // Puting 0 at the end of the string
	MOVLW       _txt+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Bluetooth_click.c,217 :: 		DataReady = 1;                         // Data is received
	MOVLW       1
	MOVWF       _DataReady+0 
;Bluetooth_click.c,218 :: 		}
	GOTO        L_interrupt44
L_interrupt43:
;Bluetooth_click.c,220 :: 		txt[i] = tmp;                          // Moving the data received from UART to string txt[]
	MOVLW       _txt+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _tmp+0, 0 
	MOVWF       POSTINC1+0 
;Bluetooth_click.c,221 :: 		i++;                                   // Increment counter
	INCF        _i+0, 1 
;Bluetooth_click.c,222 :: 		}
L_interrupt44:
;Bluetooth_click.c,223 :: 		RCIF_bit = 0;                            // Clear UART RX interrupt flag
	BCF         RCIF_bit+0, BitPos(RCIF_bit+0) 
;Bluetooth_click.c,224 :: 		}
L_interrupt42:
;Bluetooth_click.c,225 :: 		}
L_interrupt3:
;Bluetooth_click.c,226 :: 		}
L_end_interrupt:
L__interrupt69:
	RETFIE      1
; end of _interrupt

_BT_Get_Response:

;Bluetooth_click.c,229 :: 		char BT_Get_Response() {
;Bluetooth_click.c,230 :: 		if (response_rcvd) {
	MOVF        _response_rcvd+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_BT_Get_Response45
;Bluetooth_click.c,231 :: 		response_rcvd = 0;
	CLRF        _response_rcvd+0 
;Bluetooth_click.c,232 :: 		return responseID;
	MOVF        _responseID+0, 0 
	MOVWF       R0 
	GOTO        L_end_BT_Get_Response
;Bluetooth_click.c,233 :: 		}
L_BT_Get_Response45:
;Bluetooth_click.c,235 :: 		return 0;
	CLRF        R0 
;Bluetooth_click.c,236 :: 		}
L_end_BT_Get_Response:
	RETURN      0
; end of _BT_Get_Response

_initBT:

;Bluetooth_click.c,239 :: 		void initBT()
;Bluetooth_click.c,242 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Bluetooth_click.c,243 :: 		Lcd_Out(1,1,"Connecting!");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,244 :: 		Lcd_Out(2,1,"Please, wait...");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,245 :: 		Delay_ms(1500);
	MOVLW       122
	MOVWF       R11, 0
	MOVLW       193
	MOVWF       R12, 0
	MOVLW       129
	MOVWF       R13, 0
L_initBT47:
	DECFSZ      R13, 1, 1
	BRA         L_initBT47
	DECFSZ      R12, 1, 1
	BRA         L_initBT47
	DECFSZ      R11, 1, 1
	BRA         L_initBT47
	NOP
	NOP
;Bluetooth_click.c,248 :: 		BT_Configure();
	CALL        _BT_Configure+0, 0
;Bluetooth_click.c,251 :: 		Lcd_Out(1,1,"BT_Configure OK");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,252 :: 		Lcd_Out(2,1,"Waiting4 BT_CONN");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,271 :: 		UART1_Write_Text("Bluetooth Click Connected!");         //  Send message on connection
	MOVLW       ?lstr5_Bluetooth_click+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_Bluetooth_click+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Bluetooth_click.c,272 :: 		UART1_Write(13);              // CR
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;Bluetooth_click.c,273 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Bluetooth_click.c,274 :: 		Lcd_Out(1,1,"Receiving...");  // Display message
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,277 :: 		}
L_end_initBT:
	RETURN      0
; end of _initBT

_main:

;Bluetooth_click.c,280 :: 		void main()
;Bluetooth_click.c,284 :: 		ANCON0 = 0;                                    // Configure PORTB pins as digital
	CLRF        ANCON0+0 
;Bluetooth_click.c,285 :: 		ANCON1 = 0;                                    // Configure PORTC pins as digital
	CLRF        ANCON1+0 
;Bluetooth_click.c,288 :: 		TRISA0_bit = 1;                                // set RB0 pin as input
	BSF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Bluetooth_click.c,290 :: 		TRISD = 0x00;                                  // Configure PORTD as output
	CLRF        TRISD+0 
;Bluetooth_click.c,291 :: 		LATD = 0xAA;                                   // Initial PORTD value
	MOVLW       170
	MOVWF       LATD+0 
;Bluetooth_click.c,293 :: 		oldstateBT = 0;
	CLRF        main_oldstateBT_L0+0 
	CLRF        main_oldstateBT_L0+1 
;Bluetooth_click.c,296 :: 		CMD_mode = 1;
	MOVLW       1
	MOVWF       _CMD_mode+0 
;Bluetooth_click.c,297 :: 		BT_state = 0;
	CLRF        _BT_state+0 
;Bluetooth_click.c,298 :: 		response_rcvd = 0;
	CLRF        _response_rcvd+0 
;Bluetooth_click.c,299 :: 		responseID = 0;
	CLRF        _responseID+0 
;Bluetooth_click.c,300 :: 		response = 0;
	CLRF        _response+0 
;Bluetooth_click.c,301 :: 		tmp = 0;
	CLRF        _tmp+0 
;Bluetooth_click.c,302 :: 		CMD_mode = 1;
	MOVLW       1
	MOVWF       _CMD_mode+0 
;Bluetooth_click.c,303 :: 		DataReady = 0;
	CLRF        _DataReady+0 
;Bluetooth_click.c,305 :: 		RCIE_bit = 1;                 // Enable UART RX interrupt
	BSF         RCIE_bit+0, BitPos(RCIE_bit+0) 
;Bluetooth_click.c,306 :: 		PEIE_bit = 1;                 // Enable Peripheral interrupt
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;Bluetooth_click.c,307 :: 		GIE_bit  = 1;                 // Enable Global interrupt
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Bluetooth_click.c,309 :: 		Lcd_Init();                   // Lcd Init
	CALL        _Lcd_Init+0, 0
;Bluetooth_click.c,310 :: 		UART1_init(115200);           // Initialize UART1 module
	MOVLW       34
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Bluetooth_click.c,311 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Bluetooth_click.c,312 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Turn cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Bluetooth_click.c,316 :: 		Lcd_Out(1,1,"BlueTooth-Click!");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,317 :: 		Lcd_Out(2,3,"Demo example");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,318 :: 		Delay_ms(1500);
	MOVLW       122
	MOVWF       R11, 0
	MOVLW       193
	MOVWF       R12, 0
	MOVLW       129
	MOVWF       R13, 0
L_main48:
	DECFSZ      R13, 1, 1
	BRA         L_main48
	DECFSZ      R12, 1, 1
	BRA         L_main48
	DECFSZ      R11, 1, 1
	BRA         L_main48
	NOP
	NOP
;Bluetooth_click.c,320 :: 		clearItsArray();
	CALL        _clearItsArray+0, 0
;Bluetooth_click.c,322 :: 		do {
L_main49:
;Bluetooth_click.c,323 :: 		if ( (oldstateBT == 0) && Button(&PORTA, 0, 1, 1)) {               // Detect logical one
	MOVLW       0
	XORWF       main_oldstateBT_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main73
	MOVLW       0
	XORWF       main_oldstateBT_L0+0, 0 
L__main73:
	BTFSS       STATUS+0, 2 
	GOTO        L_main54
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main54
L__main66:
;Bluetooth_click.c,324 :: 		oldstateBT = 1;                              // Update flag
	MOVLW       1
	MOVWF       main_oldstateBT_L0+0 
	MOVLW       0
	MOVWF       main_oldstateBT_L0+1 
;Bluetooth_click.c,325 :: 		}
L_main54:
;Bluetooth_click.c,326 :: 		if ( (oldstateBT == 1) && Button(&PORTA, 0, 1, 0)) {   // Detect one-to-zero transition
	MOVLW       0
	XORWF       main_oldstateBT_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main74
	MOVLW       1
	XORWF       main_oldstateBT_L0+0, 0 
L__main74:
	BTFSS       STATUS+0, 2 
	GOTO        L_main57
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main57
L__main65:
;Bluetooth_click.c,327 :: 		LATD = ~LATD;                              // Invert PORTD
	COMF        LATD+0, 1 
;Bluetooth_click.c,328 :: 		oldstateBT = 2;                              // Update flag
	MOVLW       2
	MOVWF       main_oldstateBT_L0+0 
	MOVLW       0
	MOVWF       main_oldstateBT_L0+1 
;Bluetooth_click.c,330 :: 		}
L_main57:
;Bluetooth_click.c,331 :: 		if (  Button(&PORTA, 1, 1, 1) || oldstateBT == 3 )
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	MOVLW       1
	MOVWF       FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__main64
	MOVLW       0
	XORWF       main_oldstateBT_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main75
	MOVLW       3
	XORWF       main_oldstateBT_L0+0, 0 
L__main75:
	BTFSC       STATUS+0, 2 
	GOTO        L__main64
	GOTO        L_main60
L__main64:
;Bluetooth_click.c,334 :: 		CMD_mode = 0;
	CLRF        _CMD_mode+0 
;Bluetooth_click.c,335 :: 		GIE_bit = 1;                  // Disable Global interrupt
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Bluetooth_click.c,337 :: 		if ( oldstateBT != 3 ) //display only the first time
	MOVLW       0
	XORWF       main_oldstateBT_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main76
	MOVLW       3
	XORWF       main_oldstateBT_L0+0, 0 
L__main76:
	BTFSC       STATUS+0, 2 
	GOTO        L_main61
;Bluetooth_click.c,339 :: 		UART1_Write_Text("Entering Data Mode");
	MOVLW       ?lstr9_Bluetooth_click+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_Bluetooth_click+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Bluetooth_click.c,340 :: 		Lcd_Out(1,1,"Entering Data Mode");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,341 :: 		Lcd_Out(2,3,"Hangs here...");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr11_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr11_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,342 :: 		oldstateBT = 3;
	MOVLW       3
	MOVWF       main_oldstateBT_L0+0 
	MOVLW       0
	MOVWF       main_oldstateBT_L0+1 
;Bluetooth_click.c,343 :: 		UART1_Write_Text("Stage0");
	MOVLW       ?lstr12_Bluetooth_click+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr12_Bluetooth_click+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Bluetooth_click.c,344 :: 		accelClickMainInit();
	CALL        _accelClickMainInit+0, 0
;Bluetooth_click.c,345 :: 		}
L_main61:
;Bluetooth_click.c,347 :: 		i = 0;                      // Initialize counter
	CLRF        _i+0 
;Bluetooth_click.c,349 :: 		memset(txt, 0, 16);         // Clear array of chars
	MOVLW       _txt+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       16
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;Bluetooth_click.c,350 :: 		GIE_bit = 1;                // Interrupts allowed
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Bluetooth_click.c,352 :: 		while (!DataReady)          // Wait while the data is received
L_main62:
	MOVF        _DataReady+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main63
;Bluetooth_click.c,353 :: 		;
	GOTO        L_main62
L_main63:
;Bluetooth_click.c,355 :: 		GIE_bit  = 0;               // Interrupts forbiden
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Bluetooth_click.c,356 :: 		DataReady = 0;              // Data not received
	CLRF        _DataReady+0 
;Bluetooth_click.c,358 :: 		LCD_Cmd(_LCD_CLEAR);        // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Bluetooth_click.c,359 :: 		Lcd_Out(1,1,"Received:");   // Display message
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_Bluetooth_click+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_Bluetooth_click+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,360 :: 		Lcd_Out(2,3,txt);   // Display message
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Bluetooth_click.c,362 :: 		UART1_Write_Text(txt);
	MOVLW       _txt+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;Bluetooth_click.c,364 :: 		accelClickMainLoopInteration();
	CALL        _accelClickMainLoopInteration+0, 0
;Bluetooth_click.c,372 :: 		}
L_main60:
;Bluetooth_click.c,374 :: 		} while(1);                                    // Endless loop
	GOTO        L_main49
;Bluetooth_click.c,376 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
