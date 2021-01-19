#include<detpic32.h>
#include"i2c.h"

void delay(int ms){
    for(; ms > 0; ms--){
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

int getTemperature(int *temperature){
    int ack;
    // Send Start event
    i2c1_start();
    // Send Address + WR (ADDR_WR) and copy return value to "ack" variable
    ack = i2c1_send(ADDR_WR);
    ack += i2c1_send(RTR);
    i2c1_start();
    ack += i2c1_send(ADDR_RD);
    if(ack != 0){
        i2c1_stop();
    }
    *temperature = (int)i2c1_receive(I2C_NACK);
    // Send Stop event
    i2c1_stop();

    return ack;
}
 
int main(void){
    int temperature;
    i2c1_init(TC74_CLK_FREQ);
    while(1){
        printInt10(getTemperature(&temperature));
        printStr("\n");
        delay(250);
    }
    return 0;
}
