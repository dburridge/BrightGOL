
_ADXL345_Write:

;AccelClick.c,55 :: 		void ADXL345_Write(unsigned short address, unsigned short data1) {
;AccelClick.c,56 :: 		I2C1_Start();              // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;AccelClick.c,57 :: 		I2C1_Wr(_ACCEL_ADDRESS);   // send byte via I2C  (device address + W)
	MOVLW       58
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,58 :: 		I2C1_Wr(address);          // send byte (address of the location)
	MOVF        FARG_ADXL345_Write_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,59 :: 		I2C1_Wr(data1);            // send data (data to be written)
	MOVF        FARG_ADXL345_Write_data1+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,60 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;AccelClick.c,61 :: 		}
L_end_ADXL345_Write:
	RETURN      0
; end of _ADXL345_Write

_ADXL345_Read:

;AccelClick.c,63 :: 		unsigned short ADXL345_Read(unsigned short address) {
;AccelClick.c,64 :: 		unsigned short tmp = 0;
	CLRF        ADXL345_Read_tmp_L0+0 
;AccelClick.c,66 :: 		I2C1_Start();              // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;AccelClick.c,67 :: 		I2C1_Wr(_ACCEL_ADDRESS);   // send byte via I2C (device address + W)
	MOVLW       58
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,68 :: 		I2C1_Wr(address);          // send byte (data address)
	MOVF        FARG_ADXL345_Read_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,70 :: 		I2C1_Start();              // issue I2C signal repeated start
	CALL        _I2C1_Start+0, 0
;AccelClick.c,71 :: 		I2C1_Wr(_ACCEL_ADDRESS+1); // send byte (device address + R)
	MOVLW       59
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;AccelClick.c,72 :: 		tmp = I2C1_Rd(0);          // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       ADXL345_Read_tmp_L0+0 
;AccelClick.c,73 :: 		I2C1_Stop();               // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;AccelClick.c,75 :: 		return tmp;
	MOVF        ADXL345_Read_tmp_L0+0, 0 
	MOVWF       R0 
;AccelClick.c,76 :: 		}
L_end_ADXL345_Read:
	RETURN      0
; end of _ADXL345_Read

_ADXL345_Init:

;AccelClick.c,77 :: 		char ADXL345_Init(void) {
;AccelClick.c,78 :: 		char id = 0x00;
;AccelClick.c,81 :: 		ADXL345_Write(0x2D, 0x00);
	MOVLW       45
	MOVWF       FARG_ADXL345_Write_address+0 
	CLRF        FARG_ADXL345_Write_data1+0 
	CALL        _ADXL345_Write+0, 0
;AccelClick.c,83 :: 		id = ADXL345_Read(0x00);
	CLRF        FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
;AccelClick.c,84 :: 		if (id != 0xE5) {
	MOVF        R0, 0 
	XORLW       229
	BTFSC       STATUS+0, 2 
	GOTO        L_ADXL345_Init0
;AccelClick.c,85 :: 		return _ACCEL_ERROR;
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end_ADXL345_Init
;AccelClick.c,86 :: 		}
L_ADXL345_Init0:
;AccelClick.c,88 :: 		ADXL345_Write(_DATA_FORMAT, 0x08);       // Full resolution, +/-2g, 4mg/LSB, right justified
	MOVLW       49
	MOVWF       FARG_ADXL345_Write_address+0 
	MOVLW       8
	MOVWF       FARG_ADXL345_Write_data1+0 
	CALL        _ADXL345_Write+0, 0
;AccelClick.c,89 :: 		ADXL345_Write(_BW_RATE, 0x0A);           // Set 100 Hz data rate
	MOVLW       44
	MOVWF       FARG_ADXL345_Write_address+0 
	MOVLW       10
	MOVWF       FARG_ADXL345_Write_data1+0 
	CALL        _ADXL345_Write+0, 0
;AccelClick.c,90 :: 		ADXL345_Write(_FIFO_CTL, 0x80);          // stream mode
	MOVLW       56
	MOVWF       FARG_ADXL345_Write_address+0 
	MOVLW       128
	MOVWF       FARG_ADXL345_Write_data1+0 
	CALL        _ADXL345_Write+0, 0
;AccelClick.c,91 :: 		ADXL345_Write(_POWER_CTL, 0x08);         // POWER_CTL reg: measurement mode
	MOVLW       45
	MOVWF       FARG_ADXL345_Write_address+0 
	MOVLW       8
	MOVWF       FARG_ADXL345_Write_data1+0 
	CALL        _ADXL345_Write+0, 0
;AccelClick.c,92 :: 		return 0x00;
	CLRF        R0 
;AccelClick.c,94 :: 		}
L_end_ADXL345_Init:
	RETURN      0
; end of _ADXL345_Init

_Accel_ReadX:

;AccelClick.c,97 :: 		int Accel_ReadX(void) {
;AccelClick.c,101 :: 		Out_x = ADXL345_Read(_DATAX1);
	MOVLW       51
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Accel_ReadX_Out_x_L0+0 
	MOVLW       0
	MOVWF       Accel_ReadX_Out_x_L0+1 
;AccelClick.c,102 :: 		low_byte = ADXL345_Read(_DATAX0);
	MOVLW       50
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
;AccelClick.c,104 :: 		Out_x = (Out_x << 8);
	MOVF        Accel_ReadX_Out_x_L0+0, 0 
	MOVWF       R3 
	CLRF        R2 
	MOVF        R2, 0 
	MOVWF       Accel_ReadX_Out_x_L0+0 
	MOVF        R3, 0 
	MOVWF       Accel_ReadX_Out_x_L0+1 
;AccelClick.c,105 :: 		Out_x = (Out_x | low_byte);
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
	IORWF       R0, 1 
	MOVF        R3, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       Accel_ReadX_Out_x_L0+0 
	MOVF        R1, 0 
	MOVWF       Accel_ReadX_Out_x_L0+1 
;AccelClick.c,107 :: 		return Out_x;
;AccelClick.c,108 :: 		}
L_end_Accel_ReadX:
	RETURN      0
; end of _Accel_ReadX

_Accel_ReadY:

;AccelClick.c,111 :: 		int Accel_ReadY(void) {
;AccelClick.c,115 :: 		Out_y = ADXL345_Read(_DATAY1);
	MOVLW       53
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Accel_ReadY_Out_y_L0+0 
	MOVLW       0
	MOVWF       Accel_ReadY_Out_y_L0+1 
;AccelClick.c,116 :: 		low_byte = ADXL345_Read(_DATAY0);
	MOVLW       52
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
;AccelClick.c,118 :: 		Out_y = (Out_y << 8);
	MOVF        Accel_ReadY_Out_y_L0+0, 0 
	MOVWF       R3 
	CLRF        R2 
	MOVF        R2, 0 
	MOVWF       Accel_ReadY_Out_y_L0+0 
	MOVF        R3, 0 
	MOVWF       Accel_ReadY_Out_y_L0+1 
;AccelClick.c,119 :: 		Out_y = (Out_y | low_byte);
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
	IORWF       R0, 1 
	MOVF        R3, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       Accel_ReadY_Out_y_L0+0 
	MOVF        R1, 0 
	MOVWF       Accel_ReadY_Out_y_L0+1 
;AccelClick.c,121 :: 		return Out_y;
;AccelClick.c,122 :: 		}
L_end_Accel_ReadY:
	RETURN      0
; end of _Accel_ReadY

_Accel_ReadZ:

;AccelClick.c,125 :: 		int Accel_ReadZ(void) {
;AccelClick.c,129 :: 		Out_z = ADXL345_Read(_DATAZ1);
	MOVLW       55
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
	MOVF        R0, 0 
	MOVWF       Accel_ReadZ_Out_z_L0+0 
	MOVLW       0
	MOVWF       Accel_ReadZ_Out_z_L0+1 
;AccelClick.c,130 :: 		low_byte = ADXL345_Read(_DATAZ0);
	MOVLW       54
	MOVWF       FARG_ADXL345_Read_address+0 
	CALL        _ADXL345_Read+0, 0
;AccelClick.c,132 :: 		Out_z = (Out_z << 8);
	MOVF        Accel_ReadZ_Out_z_L0+0, 0 
	MOVWF       R3 
	CLRF        R2 
	MOVF        R2, 0 
	MOVWF       Accel_ReadZ_Out_z_L0+0 
	MOVF        R3, 0 
	MOVWF       Accel_ReadZ_Out_z_L0+1 
;AccelClick.c,133 :: 		Out_z = (Out_z | low_byte);
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
	IORWF       R0, 1 
	MOVF        R3, 0 
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       Accel_ReadZ_Out_z_L0+0 
	MOVF        R1, 0 
	MOVWF       Accel_ReadZ_Out_z_L0+1 
;AccelClick.c,135 :: 		return Out_z;
;AccelClick.c,136 :: 		}
L_end_Accel_ReadZ:
	RETURN      0
; end of _Accel_ReadZ

_Accel_Average:

;AccelClick.c,139 :: 		void Accel_Average(void) {
;AccelClick.c,143 :: 		sx = sy = sz = 0;
	CLRF        Accel_Average_sz_L0+0 
	CLRF        Accel_Average_sz_L0+1 
	CLRF        Accel_Average_sy_L0+0 
	CLRF        Accel_Average_sy_L0+1 
	CLRF        Accel_Average_sx_L0+0 
	CLRF        Accel_Average_sx_L0+1 
;AccelClick.c,146 :: 		for (i=0; i<16; i++) {
	CLRF        Accel_Average_i_L0+0 
	CLRF        Accel_Average_i_L0+1 
L_Accel_Average2:
	MOVLW       128
	XORWF       Accel_Average_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Accel_Average22
	MOVLW       16
	SUBWF       Accel_Average_i_L0+0, 0 
L__Accel_Average22:
	BTFSC       STATUS+0, 0 
	GOTO        L_Accel_Average3
;AccelClick.c,147 :: 		sx += Accel_ReadX();
	CALL        _Accel_ReadX+0, 0
	MOVF        R0, 0 
	ADDWF       Accel_Average_sx_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      Accel_Average_sx_L0+1, 1 
;AccelClick.c,148 :: 		sy += Accel_ReadY();
	CALL        _Accel_ReadY+0, 0
	MOVF        R0, 0 
	ADDWF       Accel_Average_sy_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      Accel_Average_sy_L0+1, 1 
;AccelClick.c,149 :: 		sz += Accel_ReadZ();
	CALL        _Accel_ReadZ+0, 0
	MOVF        R0, 0 
	ADDWF       Accel_Average_sz_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      Accel_Average_sz_L0+1, 1 
;AccelClick.c,146 :: 		for (i=0; i<16; i++) {
	INFSNZ      Accel_Average_i_L0+0, 1 
	INCF        Accel_Average_i_L0+1, 1 
;AccelClick.c,150 :: 		}
	GOTO        L_Accel_Average2
L_Accel_Average3:
;AccelClick.c,152 :: 		readings[0] = sx >> 4;
	MOVLW       4
	MOVWF       R0 
	MOVF        Accel_Average_sx_L0+0, 0 
	MOVWF       _readings+0 
	MOVF        Accel_Average_sx_L0+1, 0 
	MOVWF       _readings+1 
	MOVF        R0, 0 
L__Accel_Average23:
	BZ          L__Accel_Average24
	RRCF        _readings+1, 1 
	RRCF        _readings+0, 1 
	BCF         _readings+1, 7 
	BTFSC       _readings+1, 6 
	BSF         _readings+1, 7 
	ADDLW       255
	GOTO        L__Accel_Average23
L__Accel_Average24:
;AccelClick.c,153 :: 		readings[1] = sy >> 4;
	MOVLW       4
	MOVWF       R0 
	MOVF        Accel_Average_sy_L0+0, 0 
	MOVWF       _readings+2 
	MOVF        Accel_Average_sy_L0+1, 0 
	MOVWF       _readings+3 
	MOVF        R0, 0 
L__Accel_Average25:
	BZ          L__Accel_Average26
	RRCF        _readings+3, 1 
	RRCF        _readings+2, 1 
	BCF         _readings+3, 7 
	BTFSC       _readings+3, 6 
	BSF         _readings+3, 7 
	ADDLW       255
	GOTO        L__Accel_Average25
L__Accel_Average26:
;AccelClick.c,154 :: 		readings[2] = sz >> 4;
	MOVLW       4
	MOVWF       R0 
	MOVF        Accel_Average_sz_L0+0, 0 
	MOVWF       _readings+4 
	MOVF        Accel_Average_sz_L0+1, 0 
	MOVWF       _readings+5 
	MOVF        R0, 0 
L__Accel_Average27:
	BZ          L__Accel_Average28
	RRCF        _readings+5, 1 
	RRCF        _readings+4, 1 
	BCF         _readings+5, 7 
	BTFSC       _readings+5, 6 
	BSF         _readings+5, 7 
	ADDLW       255
	GOTO        L__Accel_Average27
L__Accel_Average28:
;AccelClick.c,156 :: 		}
L_end_Accel_Average:
	RETURN      0
; end of _Accel_Average

_Display_X_Value:

;AccelClick.c,159 :: 		void Display_X_Value(void) {
;AccelClick.c,160 :: 		UART1_Write_Text("X:");
	MOVLW       ?lstr1_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,161 :: 		IntToStr(readings[0], out);
	MOVF        _readings+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _readings+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _out+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;AccelClick.c,162 :: 		UART1_Write_Text(out);
	MOVLW       _out+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,163 :: 		UART1_Write(0x09);
	MOVLW       9
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;AccelClick.c,164 :: 		Delay_ms(100);
	MOVLW       9
	MOVWF       R11, 0
	MOVLW       30
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_Display_X_Value5:
	DECFSZ      R13, 1, 1
	BRA         L_Display_X_Value5
	DECFSZ      R12, 1, 1
	BRA         L_Display_X_Value5
	DECFSZ      R11, 1, 1
	BRA         L_Display_X_Value5
	NOP
;AccelClick.c,165 :: 		}
L_end_Display_X_Value:
	RETURN      0
; end of _Display_X_Value

_Display_Y_Value:

;AccelClick.c,168 :: 		void Display_Y_Value(void) {
;AccelClick.c,169 :: 		UART1_Write_Text("Y:");
	MOVLW       ?lstr2_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,170 :: 		IntToStr(readings[1], out);
	MOVF        _readings+2, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _readings+3, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _out+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;AccelClick.c,171 :: 		UART1_Write_Text(out);
	MOVLW       _out+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,172 :: 		UART1_Write(0x09);
	MOVLW       9
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;AccelClick.c,173 :: 		Delay_ms(100);
	MOVLW       9
	MOVWF       R11, 0
	MOVLW       30
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_Display_Y_Value6:
	DECFSZ      R13, 1, 1
	BRA         L_Display_Y_Value6
	DECFSZ      R12, 1, 1
	BRA         L_Display_Y_Value6
	DECFSZ      R11, 1, 1
	BRA         L_Display_Y_Value6
	NOP
;AccelClick.c,174 :: 		}
L_end_Display_Y_Value:
	RETURN      0
; end of _Display_Y_Value

_Display_Z_Value:

;AccelClick.c,177 :: 		void Display_Z_Value(void) {
;AccelClick.c,178 :: 		UART1_Write_Text("Z:");
	MOVLW       ?lstr3_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,179 :: 		IntToStr(readings[2], out);
	MOVF        _readings+4, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _readings+5, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _out+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;AccelClick.c,180 :: 		UART1_Write_Text(out);
	MOVLW       _out+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_out+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,181 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;AccelClick.c,182 :: 		UART1_Write(0x0A);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;AccelClick.c,183 :: 		Delay_ms(100);
	MOVLW       9
	MOVWF       R11, 0
	MOVLW       30
	MOVWF       R12, 0
	MOVLW       228
	MOVWF       R13, 0
L_Display_Z_Value7:
	DECFSZ      R13, 1, 1
	BRA         L_Display_Z_Value7
	DECFSZ      R12, 1, 1
	BRA         L_Display_Z_Value7
	DECFSZ      R11, 1, 1
	BRA         L_Display_Z_Value7
	NOP
;AccelClick.c,184 :: 		}
L_end_Display_Z_Value:
	RETURN      0
; end of _Display_Z_Value

_AccelInit:

;AccelClick.c,185 :: 		void AccelInit(){
;AccelClick.c,187 :: 		if (ADXL345_Init() == 0) {
	CALL        _ADXL345_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_AccelInit8
;AccelClick.c,188 :: 		UART1_Write_Text("Accel module initialized.\r\n" );
	MOVLW       ?lstr4_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,189 :: 		Delay_ms(2000);
	MOVLW       163
	MOVWF       R11, 0
	MOVLW       87
	MOVWF       R12, 0
	MOVLW       2
	MOVWF       R13, 0
L_AccelInit9:
	DECFSZ      R13, 1, 1
	BRA         L_AccelInit9
	DECFSZ      R12, 1, 1
	BRA         L_AccelInit9
	DECFSZ      R11, 1, 1
	BRA         L_AccelInit9
	NOP
;AccelClick.c,190 :: 		}
	GOTO        L_AccelInit10
L_AccelInit8:
;AccelClick.c,193 :: 		UART1_Write_Text("Error during initialization.");
	MOVLW       ?lstr5_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,194 :: 		Delay_ms(2000);
	MOVLW       163
	MOVWF       R11, 0
	MOVLW       87
	MOVWF       R12, 0
	MOVLW       2
	MOVWF       R13, 0
L_AccelInit11:
	DECFSZ      R13, 1, 1
	BRA         L_AccelInit11
	DECFSZ      R12, 1, 1
	BRA         L_AccelInit11
	DECFSZ      R11, 1, 1
	BRA         L_AccelInit11
	NOP
;AccelClick.c,195 :: 		}
L_AccelInit10:
;AccelClick.c,196 :: 		}
L_end_AccelInit:
	RETURN      0
; end of _AccelInit

_accelClickMainInit:

;AccelClick.c,199 :: 		void accelClickMainInit()
;AccelClick.c,204 :: 		CM1CON  = 0;                     // Turn off comparators
	CLRF        CM1CON+0 
;AccelClick.c,205 :: 		CM2CON  = 0;
	CLRF        CM2CON+0 
;AccelClick.c,211 :: 		UART1_Write_Text("Stage1");
	MOVLW       ?lstr6_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,213 :: 		ACCEL_CS_Dir = 0;
	BCF         TRISE0_bit+0, BitPos(TRISE0_bit+0) 
;AccelClick.c,214 :: 		ACCEL_CS = 1;
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;AccelClick.c,215 :: 		UART1_Write_Text("Stage5");
	MOVLW       ?lstr7_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,218 :: 		UART1_Write_Text("Accel test starting...\r\n");
	MOVLW       ?lstr8_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,219 :: 		Delay_ms(2000);
	MOVLW       163
	MOVWF       R11, 0
	MOVLW       87
	MOVWF       R12, 0
	MOVLW       2
	MOVWF       R13, 0
L_accelClickMainInit12:
	DECFSZ      R13, 1, 1
	BRA         L_accelClickMainInit12
	DECFSZ      R12, 1, 1
	BRA         L_accelClickMainInit12
	DECFSZ      R11, 1, 1
	BRA         L_accelClickMainInit12
	NOP
;AccelClick.c,221 :: 		I2C1_Init(100000);
	MOVLW       160
	MOVWF       SSP1ADD+0 
	CALL        _I2C1_Init+0, 0
;AccelClick.c,223 :: 		AccelInit();
	CALL        _AccelInit+0, 0
;AccelClick.c,224 :: 		Delay_ms(150);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       45
	MOVWF       R12, 0
	MOVLW       215
	MOVWF       R13, 0
L_accelClickMainInit13:
	DECFSZ      R13, 1, 1
	BRA         L_accelClickMainInit13
	DECFSZ      R12, 1, 1
	BRA         L_accelClickMainInit13
	DECFSZ      R11, 1, 1
	BRA         L_accelClickMainInit13
	NOP
	NOP
;AccelClick.c,226 :: 		UART1_Write_Text("Reading axis values...\r\n\r\n");
	MOVLW       ?lstr9_AccelClick+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_AccelClick+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;AccelClick.c,227 :: 		Delay_ms(2000);
	MOVLW       163
	MOVWF       R11, 0
	MOVLW       87
	MOVWF       R12, 0
	MOVLW       2
	MOVWF       R13, 0
L_accelClickMainInit14:
	DECFSZ      R13, 1, 1
	BRA         L_accelClickMainInit14
	DECFSZ      R12, 1, 1
	BRA         L_accelClickMainInit14
	DECFSZ      R11, 1, 1
	BRA         L_accelClickMainInit14
	NOP
;AccelClick.c,229 :: 		}
L_end_accelClickMainInit:
	RETURN      0
; end of _accelClickMainInit

_accelClickMainLoopInteration:

;AccelClick.c,231 :: 		void accelClickMainLoopInteration()
;AccelClick.c,233 :: 		Accel_Average();               // Calculate average X, Y and Z reads
	CALL        _Accel_Average+0, 0
;AccelClick.c,234 :: 		Display_X_Value();
	CALL        _Display_X_Value+0, 0
;AccelClick.c,235 :: 		Display_Y_Value();
	CALL        _Display_Y_Value+0, 0
;AccelClick.c,236 :: 		Display_Z_Value();
	CALL        _Display_Z_Value+0, 0
;AccelClick.c,237 :: 		}
L_end_accelClickMainLoopInteration:
	RETURN      0
; end of _accelClickMainLoopInteration
