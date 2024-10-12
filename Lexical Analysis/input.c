#include <stdio.h>

void main()
{
    int x = 0, y = 5, z = 10;

    for (x = 0; x < 5; x++)
    {
        printf("For loop");
    }

    while (y > 0)
    {
        printf("While loop");
        y--;
    }

    do
    {
        printf("Do-While Loop");
        z--;
    } while (z > 0);
}
