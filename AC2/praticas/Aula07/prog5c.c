#include<detpic32.h>

volatile int voltage = 0; // Global variable

void _int_(4) isr_T1(void){
    // start A/D conversion
    AD1CON1bits.ASAM = 1;
    // Reset T1IF flag
    IFS0bits.T1IF = 0;
}
void _int_(12) isr_T3(void){
    printStr("3");
    // Reset T3IF flag
    IFS0bits.T3IF = 0;
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
    while(1);

    return 0;
}