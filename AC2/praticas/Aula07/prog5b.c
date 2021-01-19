#include<detpic32.h>

volatile int voltage = 0; // Global variable

void _int_(4) isr_T1(void){
    // print character '1'
    printStr("1");
    // Reset T1IF flag
    IFS0bits.T1IF = 0;
}
void _int_(12) isr_T3(void){
    // print character '3'
    printStr("3");
    // Reset T3IF flag
    IFS0bits.T3IF = 0;
}


void configureAll(){

    // hexDisp configs
    LATB = LATB & 0x00FF;
    TRISB = TRISB & 0x00FF;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;

    // ADC
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;
    AD1CHSbits.CH0SA = 4;
    AD1CON2bits.SMPI = 7;
    AD1CON3bits.SAMC = 16;
    AD1CON1bits.ON = 1;
    IPC6bits.AD1IP = 2;
    IEC1bits.AD1IE = 1;
    IFS1bits.AD1IF = 0;

    // Timer 1 configs
    T1CONbits.TCKPS = 7;
    PR1 = 19530;
    TMR1 = 0;
    T1CONbits.TON = 1;
    IPC1bits.T1IP = 2;
    IEC0bits.T1IE = 1;
    IFS0bits.T1IF = 0;

    // Timer 3 configs
    T3CONbits.TCKPS = 2;
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;
    IPC3bits.T3IP = 2;
    IEC0bits.T3IE = 1;
    IFS0bits.T3IF = 0;

    EnableInterrupts();

}

int main(void){
    configureAll(); // Function to configure all (digital I/O, analog
                    // input, A/D module, timers T1 and T3, interrupts)
                    // Reset AD1IF, T1IF and T3IF flags
    /*IFS1bits.AD1IF = 0;
    IFS0bits.T1IF = 0;
    IFS0bits.T3IF = 0;*/
    //EnableInterrupts(); // Global Interrupt Enable
    while(1);

    return 0;
}