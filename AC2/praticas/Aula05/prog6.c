#include<detpic32.h>

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

void send2displays(unsigned char value){
    static char flag = 0;
    static const char display7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    // send digit_high (dh) to display_high: 
    unsigned char dh = (value & 0xF0) >> 4;
    // send digit_low (dl) to display_low: 
    unsigned dl = value & 0x0F;
    char hexCode;
    if(flag){
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;    
        hexCode = display7Scodes[dl];
        LATB = (LATB & 0x00FF) | ((int)hexCode << 8);
    }
    else{
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        hexCode = display7Scodes[dh];
        LATB = (LATB & 0x00FF) | ((int)hexCode << 8);
    }
    
    flag = !flag;
}


int main(void){
    volatile int aux;
    // Configure A/D module; configure RE0 as a digital output port
    TRISBbits.TRISB4 = 1;       // RBx digital output disconnected
    AD1PCFGbits.PCFG4= 0;       // RBx configured as analog input (AN4)
    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 3;     // Interrupt is generated after XX samples
                                // (replace XX by the desired number of
                                // consecutive samples)
    AD1CHSbits.CH0SA = 4;       // replace x by the desired input
                                // analog channel (0 to 15)
    AD1CON1bits.ON = 1;         // Enable A/D converter
                                // This must the last command of the A/D
                                // configuration sequence
    
    LATEbits.LATE0 = 0;
    TRISEbits.TRISE0 = 0;
    while(1){
        // Set LATE0
        LATEbits.LATE0 = 1;
        // Start conversion
        AD1CON1bits.ASAM = 1;
        // Wait while conversion not done (AD1IF == 0)
        while(IFS1bits.AD1IF == 0);
        // Reset LATE0
        LATEbits.LATE0 = 0;
        // Read conversion result (ADC1BUF0) to "aux" variable
        aux = ADC1BUF0;
        // Reset AD1IF
        IFS1bits.AD1IF = 0;
    }
    return 0;
}