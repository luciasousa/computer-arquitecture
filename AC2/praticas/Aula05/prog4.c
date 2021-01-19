#include<detpic32.h>

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

int main(void){

    // Configure the A/D module and port RB4 as analog input
    TRISBbits.TRISB4 = 1;       //rb4 digital output disconnected
    AD1PCFGbits.PCFG4 = 0;      //rb4 configured as analog input
    AD1CON1bits.SSRC = 7;       //Conversion trigger selection bits: in this mode an internal counter ends sampling and starts conversion
    AD1CON1bits.CLRASAM = 1;    //Stop conversions when the 1st A/D converter interrupt is generated. At the same time, hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      //Sample time is 16 TAD (TAD = 100 ns)
    AD1CHSbits.CH0SA = 4;       //Selects AN4 as input for the A/D converter
    AD1CON2bits.SMPI = 4;       //4 conversão 
    AD1CON1bits.ON = 1;         //Enable A/D converter

    while(1){
        // Start conversion
        AD1CON1bits.ASAM = 1;
        // Wait while conversion not done (AD1IF == 0)
        while(IFS1bits.AD1IF == 0);
        // Read conversion result (ADC1BUF0 value) and print it
        int *p = (int *)(&ADC1BUF0);
        int i;
        double media = 0.0;
        int soma = 0;
        for( i = 0; i < 4; i++ ){
            soma += p[i*4];
            delay(100);
        }
        media = soma / 4;
        printf("Media = %4.1f",media);
        printf("\n");
        // Reset AD1IF
        IFS1bits.AD1IF = 0;
        delay(100);
    }

    return 0;
}