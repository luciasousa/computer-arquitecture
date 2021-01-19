#include<detpic32.h>

int main(void){
    TRISDbits.TRISD5 = 0;
    // Configure Timer T3 (2 Hz with interrupts disabled)
    T3CONbits.TCKPS = 5; // fout_presc = 625 KHz
    PR3 = 312499;   //Fout = 20MHz / (32 * (312499 + 1)) = 2 Hz
    TMR3 = 0;   //reste timer t3 count register
    T3CONbits.TON = 1;   //enable timer t3
    while(1){
        // Wait until T3IF = 1
        while(IFS0bits.T3IF == 0);
        putChar('.');
        // Reset T3IF
        IFS0bits.T3IF = 0;
    }

    return 0;
}