#include<detpic32.h>
volatile unsigned char voltage = 0; // Global variable

void send2displays(unsigned char value) {
    static const char display7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    static char displayFlag = 1;
    unsigned char dh = display7Scodes[value >> 4];
    unsigned char dl = display7Scodes[value & 0x0F];

    if(displayFlag) {
        // send digit_high (dh) to display_high: dh = value >> 4
        LATDbits.LATD6 = 1;
        LATDbits.LATD5 = 0;
        LATB = (dh << 8) | (LATB & 0x00FF);
    }

    else {
        // send digit_low (dl) to display_low: dl = value & 0x0F
        LATDbits.LATD6 = 0;
        LATDbits.LATD5 = 1;
        LATB = (dl << 8) | (LATB & 0x00FF);
    }

    displayFlag = !displayFlag;
}

void _int_(27) isr_adc(void){
    int soma = 0;
    int average = 0;
    int volt = 0;
    int q = 0;
    int r = 0;
    // Calculate buffer average (8 samples)
    int *p = (int *) (&ADC1BUF0);
    int i = 0;
    for (i = 0; i < 8; i++){
        soma += p[i*4];
    }

    average = soma / 8;
    
    // Calculate voltage amplitude
    volt = (average*33)/1023;
    // Convert voltage amplitude to decimal. Assign it to "voltage"
    q = volt / 10;
    r = volt % 10;

    voltage = (q << 4 | r);
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0;
}

void _int_(4) isr_T1(void) {
    AD1CON1bits.ASAM = 1;       // Start conversion
    IFS0bits.T1IF = 0;
} 

void _int_(12) isr_T3(void) {
    send2displays(voltage);
    IFS0bits.T3IF = 0;          // Reset timer T3 interrupt flag
} 

void configureAll(){

   TRISBbits.TRISB4 = 1;       // RBx digital output disconnected
    AD1PCFGbits.PCFG4= 0;       // RBx configured as analog input (AN4)
    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 8-1;     // Interrupt is generated after XX samples
                                // (replace XX by the desired number of
                                // consecutive samples)
    AD1CHSbits.CH0SA = 4;       // replace x by the desired input
                                // analog channel (0 to 15)
    AD1CON1bits.ON = 1;         // Enable A/D converter
                                // This must the last command of the A/D
                                // configuration sequence

    IPC6bits.AD1IP = 2;         // configure priority of A/D interrupts
    IFS1bits.AD1IF = 0;         // clear A/D interrupt flag
    IEC1bits.AD1IE = 1;         // enable A/D interrupts 
    

    T1CONbits.TCKPS = 3; 
    PR1 = 19530; 
    TMR1 = 0;                   // Reset timer T1 count register

    IPC1bits.T1IP = 2;          // Interrupt priority (must be in range [1..6])
    IEC0bits.T1IE = 1;          // Enable timer T1 interrupts
    IFS0bits.T1IF = 0;          // Reset timer T1 interrupt flag

    T3CONbits.TCKPS = 2; 
    PR3 = 49999; 
    TMR3 = 0;                   // Reset timer T3 count register

    IPC3bits.T3IP = 2;          // Interrupt priority (must be in range [1..6])
    IEC0bits.T3IE = 1;          // Enable timer T3 interrupts
    IFS0bits.T3IF = 0;          // Reset timer T3 interrupt flag

    EnableInterrupts();         // Global Interrupt Enable

    T1CONbits.TON = 1;          // Enable timer T1 (must be the last command of the timer configuration sequence)
    T3CONbits.TON = 1;          // Enable timer T3 (must be the last command of the timer configuration sequence)
}


int main(void){
    configureAll();

    LATD = LATD & 0xF9FF;
    TRISD = TRISD & 0xFF9F;

    LATB = LATB & 0x80FF;
    TRISB = TRISB & 0x80FF;
    TRISB = TRISB | 0x03;

     while(1){
        if(PORTBbits.RB0 == 1 && PORTBbits.RB1 == 0){
            IEC0bits.T1IE = 0;
        }           
        // Disable timer T1 interrupts
        else{ 
            IEC0bits.T1IE = 1; 
        }                                                 
        // Enable timer T1 interrupts
    }
    return 0;
}