#include<detpic32.h>
#include"i2c.h"

volatile unsigned int temper = 0;

void delay(int ms){
    for(; ms > 0; ms--){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

void send2displays(unsigned char value){
    static const char display7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    static char displayFlag = 0;
    unsigned char dh = display7Scodes[value >> 4];
    unsigned char dl = display7Scodes[value & 0x0F];

    if(displayFlag){
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;    
        LATB = (dh << 8) | (LATB & 0x00FF);
        if(value % 2 != 0){
            LATBbits.LATB15 = 1;
        }
    }

    else{
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        LATB = (dl << 8) | (LATB & 0x00FF);
        if(value % 2 == 0){
            LATBbits.LATB15 = 1;
        }
    }

    displayFlag = !displayFlag;  
}

int getTemperature(int *temperature){
    int ack;
    // Send Start event
    i2c1_start();
    // Send Address + WR (ADDR_WR) and copy return value to "ack" variable
    ack = i2c1_send(ADDR_WR);
    ack += i2c1_send(RTR);
    i2c1_start();
    ack += i2c1_send(ADDR_RD);
    if(ack != 0){
        i2c1_stop();
    }
    *temperature = (int)i2c1_receive(I2C_NACK);
    // Send Stop event
    i2c1_stop();

    return ack;
}

void _int_(12) isr_T3(){
    int q = temper / 10;
    int r = temper % 10;
    unsigned char temp = (q << 4 | r);
    send2displays(temp);

    IFS0bits.T3IF = 0;
}
 
int main(void){

    //configurar
    LATB = LATB & 0x00FF;
    TRISB = TRISB & 0x00FF;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;

    //Timer 3
    T3CONbits.TCKPS = 2;
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;
    IPC3bits.T3IP = 2;
    IEC0bits.T3IE = 1;
    IFS0bits.T3IF = 0;

    EnableInterrupts();

    while(1){
        int input = PORTB & 0x0003;
        if(input == 0x0003){
            printInt10(getTemperature(&temper));
            printStr("\n");
        }
    }
    return 0;
}
