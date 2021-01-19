#include<detpic32.h>

// Global variable
volatile unsigned char voltage = 0;

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
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
int soma = 0;
void _int_(27) isr_adc(void){
    
    // Calculate buffer average (8 samples)
    int *p = (int *) (&ADC1BUF0);
    int j;
    for (j = 0; j < 8; j++){
        soma += p[j*4];
    }

    int average = soma / 8;
    
    // Calculate voltage amplitude
    int volt = (average*33)/1023;
    // Convert voltage amplitude to decimal. Assign it to "voltage"
    int q = volt / 10;
    int r = volt % 10;
    printf("%d \t %d\n",q,r);

    voltage = (q << 4 | r);
   
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0;
}



int main(void){
    TRISB = TRISB | 0x000F;
    TRISB = TRISB & 0x00FF;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;
    AD1CON1bits.SSRC = 7; // Conversion trigger selection bits: in this mode an internal counter ends sampling and starts conversion
    AD1CON1bits.CLRASAM = 1; // Stop conversions when the 1st A/D converter interrupt is generated. At the same time, hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16; // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 7; // 8 conversoes
    AD1CHSbits.CH0SA = 4; // input analog channel (0 to 15)
    AD1CON1bits.ON = 1; // Enable A/D converter
    AD1CON3bits.ADCS = 15;
    // Configure interrupt system
    IPC6bits.AD1IP = 2; // A/D interrupts priority
    IEC1bits.AD1IE = 1; // a/d interrupts enabled
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0; // clear A/D flag

    EnableInterrupts();
    // Global Interrupt Enable
    int i = 0;
    while(1){
        // Wait 10 ms using the core timer
        delay(10);
      
        if(i++ == 25){ // 250 ms (4 samples/second)
            // Start A/D conversion
            AD1CON1bits.ASAM = 1;
            i = 0;
        }
        // Send "voltage" variable to displays
        send2displays(voltage);
        //printf("%d\n",voltage);
    }

    return 0;
}


