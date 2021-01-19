#include <detpic32.h>

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

int main(void){

    LATE = (LATE & 0xFFF0);
    TRISE = (TRISE & 0xFFF0);       //outputs

    int count = 0;

    while(1){
        delay(500);
        LATE = count & 0x000F;
        count ++;
        if(count == 16){
            count = 0;
        }
    }
}