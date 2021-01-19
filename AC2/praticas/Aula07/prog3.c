#include<detpic32.h>

void _int_(12) isr_T3(void){
    putChar('.');
    //Reset T3 interrupt flag
    IFS0bits.T3IF = 0;
}

int main(void){

    // Configure Timer T3 (2 Hz with interrupts disabled)
    //T3CONbits.TCKPS = 5; // fout_presc = 625 KHz
    //PR3 = 624999;   //Fout = 20MHz / (32 * (624999 + 1)) = 1 Hz
    T3CONbits.TCKPS = 7;
    PR3 = 39062;
    TMR3 = 0;   //reste timer t3 count register
    T3CONbits.TON = 1;   //enable timer t3

    IPC3bits.T3IP = 2;  // Interrupt priority (must be in range [1..6])
    IEC0bits.T3IE = 1;  // Enable timer T3 interrupts
    IFS0bits.T3IF = 0;  // Reset timer T3 interrupt flag
    
    EnableInterrupts();
    while(1);

    return 0;
}