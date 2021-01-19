#include<detpic32.h>

// Interrupt Handler
//Replace VECTOR by the A/D vector number - see "PIC32 family data sheet" (pages 74-76)
void _int_(27) isr_adc(void){
    //Reset RB6     LATB6 = 0
    LATBbits.LATB6 = 0;
    // Print ADC1BUF0 value
    int *p = (int *)(&ADC1BUF0);
    // Hexadecimal (3 digits format)
    printInt(*p,16 | 3 << 16);
    printStr("\n");

    // Set RB6
    LATBbits.LATB6 = 1;

    // Start A/D conversion
    AD1CON1bits.ASAM = 1;
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0;  
}




void main(void){
    // Configure all (digital I/O, analog input, A/D module)

    TRISBbits.TRISB0 = 1; // RBx digital output disconnected
    AD1PCFGbits.PCFG0 = 0; // RBx configured as analog input (AN4)
    AD1CON1bits.SSRC = 7; // Conversion trigger selection bits: in this mode an internal counter ends sampling and starts conversion
    AD1CON1bits.CLRASAM = 1; // Stop conversions when the 1st A/D converter interrupt is generated. At the same time, hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16; // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 0; // 1 conversão
    AD1CHSbits.CH0SA = 4; // input analog channel (0 to 15)
    AD1CON1bits.ON = 1; // Enable A/D converter

    // Configure interrupt system
    IPC6bits.AD1IP = 2; // A/D interrupts priority
    IEC1bits.AD1IE = 1; // a/d interrupts enabled
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0; // clear A/D flag

    
    EnableInterrupts();
    // Global Interrupt Enable
    // Start A/D conversion
    AD1CON1bits.ASAM = 1;
    while(1) { 
        
    }
    // all activity is done by the ISR
}