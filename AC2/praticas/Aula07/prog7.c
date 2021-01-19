#include<detpic32.h>

void configureAll(){

    // Timer 3 configs
    T3CONbits.TCKPS = 2;
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;

    //PWM configs
    OC1CONbits.OCM = 6;         // PWM mode on OCx; fault pin disabled
    OC1CONbits.OCTSEL = 1;      // Use timer T3 as the time base for PWM generation
    OC1RS = 12500;              // Ton constant
    OC1CONbits.ON = 1;          //Enable OC1 module

}

int main(void){
    configureAll();
    while(1);
    return 0;
}