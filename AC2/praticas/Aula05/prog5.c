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
    TRISBbits.TRISB4 = 1;       // RBx digital output disconnected
    AD1PCFGbits.PCFG4= 0;       // RBx configured as analog input (AN4)
    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 4-1;     // Interrupt is generated after XX samples
                                // (replace XX by the desired number of
                                // consecutive samples)
    AD1CHSbits.CH0SA = 4;       // replace x by the desired input
                                // analog channel (0 to 15)
    AD1CON1bits.ON = 1;         // Enable A/D converter
                                // This must the last command of the A/D
                                // configuration sequence
    
    TRISD = TRISD & 0xFF9F;
    LATD = LATD & 0xF9FF;

    TRISB = TRISB & 0x80FF;
    LATB = LATB & 0x80FF;

    int i = 0;
    int amp = 0;
    int q = 0;
    int r = 0;
    while(1){
        if(i++ % 25 == 0) {     // 0, 250ms, 500ms, 750ms, ...
            // Convert analog input (4 samples)
            AD1CON1bits.ASAM = 1;
            // Wait while conversion not done (AD1IF == 0)
            while(IFS1bits.AD1IF == 0);

            // Calculate buffer average
            int *p = (int *)(&ADC1BUF0);
            int i;
            int media = 0;
            int soma = 0;
            for( i = 0; i < 4; i++ ){
                soma += p[i*4];
            }
            media = soma / 4;
            // Reset AD1IF
            IFS1bits.AD1IF = 0;
            
            // Calculate voltage amplitude
            amp = (media * 33)/1023;
            // Convert voltage amplitude to decimal
            q = amp / 10;
            r = amp % 10;
            
        }
        char out = (q << 4 | r);
        // Send voltage value to displays
        send2displays(out);
        printInt(out,2);
        // Wait 10 ms (using the core timer)
        delay(10);
    }
    return 0;
}
