#include<detpic32.h>

volatile unsigned char voltage = 0; // Global variable

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

int main(void){
    // Configure Timers T1 and T3 with interrupts enabled)
    // TIMER 1 -- 2HZ
    T1CONbits.TCKPS = 3;
    PR1 = 39062;
    TMR1 = 0;
    T1CONbits.TON = 1;

    //TIMER 3 -- 10HZ
    T3CONbits.TCKPS = 5;
    PR3 = 62499;
    TMR3 = 0;
    T3CONbits.TON = 1;

    IPC1bits.T1IP = 2;
    IPC3bits.T3IP = 2;
    IEC0bits.T1IE = 1;
    IEC0bits.T3IE = 1;
    // Reset T1IF and T3IF flags
    IFS0bits.T1IF = 0;
    IFS0bits.T3IF = 0;
    EnableInterrupts();
    // Global Interrupt Enable
    while(1);

    return 0;
}
