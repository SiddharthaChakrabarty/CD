#include <stdio.h>
void main()
{
    int x = 0, y = 0, z = 0;
    for(x = 0; x < 10; x++){
        printf("For loop");
    }

    while(y < 0){
        printf("While loop");
        y++;
    }

    do{
        printf("Do-while loop");
        z++;
    }while(z < 0);
}