// downloaded (and modified by Kia) from
// www.execpc.com/~geezer/embed/cordic.c

#include <stdio.h>
#include <math.h>

#define AG_CONST 0.6072529350  //Ki

#define FXD(X) ((long int)((X) * 65536.0))

typedef long int fixed; /* 16.16 fixed-point */

static const fixed Alpha[] = { 2949120, 1740963,
919876, 466945, 234378, 117303,
58666, 29334, 14667, 7333,
3666, 1833};

static const fixed Alpha2[] = { 0, FXD(0.549306144), FXD(0.255412811883), FXD(0.12565721414045),
 FXD(0.062581571477003), FXD(0.031260178490667), FXD(0.015626271752052), FXD(0.0078126589515404),
  FXD(0.0039062698683968), FXD(0.0019531274835326) , FXD(0.00097656281044104), FXD(0.00048828128880511), FXD(0.00024414062485064), FXD(0.00012207031060633)};


/*
 FXD(45.0), FXD(26.565),
FXD(14.0362), FXD(7.12502), FXD(3.57633), FXD(1.78991),
FXD(0.895174), FXD(0.447614), FXD(0.223811), FXD(0.111906),
FXD(0.055953), FXD(0.027977) 


*/

//32 BIT NUMBERS

//declaration of ANGLES used (IN RADIANS)



int main(void)
{
  fixed X, Y, CurrAngle, TAN;
  fixed Xh, Yh, Zh, CurrAngleh, TANh;

  //32 bit values

  //x is the ultimate cosine value
  //y is the ultimate sine value
  //

  unsigned i;

  X = FXD(AG_CONST); /* Ki * 1 */

  Xh = FXD(0.82816 * 1.15470053819);


  Y = 0; /* AG_CONST * sin(0) */
  Yh = FXD(0.5773502);

  TAN = 0;


  //BIT SHIFT 16 //45
  CurrAngle= 2949120;
  CurrAngleh= FXD(0.549306144);

  for (i = 1; i < 14; i++)
  {
  	fixed NewXh;

  	if (CurrAngleh > 0)
  	{
  		NewXh = Xh - (Yh >> i);  // xi+1 = Ki*[xi + yi * 2^-i]

  		Yh += (Xh >> i);        // yi+1 = Ki*[yi + xi * 2^-i]
  		Zh = Zh - Alpha2[i];
        Xh = NewXh;

        //printf(" X: %d Y: %d\n",  X, Y);

        CurrAngleh -= Alpha2[i]; 

        if ( i == 4 || i == 13)
        {
        	NewXh = Xh - (Yh >> i);  // xi+1 = Ki*[xi + yi * 2^-i]

  			Yh += (Xh >> i);        // yi+1 = Ki*[yi + xi * 2^-i]
  			Zh = Zh - Alpha2[i];
     	    Xh = NewXh;

     	    //printf(" X: %d Y: %d\n",  X, Y);

      	    CurrAngleh -= Alpha2[i];

        }

  	}
  	else
  	{
		NewXh = Xh + (Yh >> i);  // xi+1 = Ki*[xi - yi * 2^-i]

  		Yh -= (Xh >> i);        // yi+1 = Ki*[yi - xi * 2^-i]
  		Zh = Zh + Alpha2[i];
        Xh = NewXh;

        //printf(" X: %d Y: %d\n",  X, Y);

        CurrAngleh += Alpha2[i]; 
        if ( i == 4 || i == 13)
        {
        	NewXh = Xh + (Yh >> i);  // xi+1 = Ki*[xi - yi * 2^-i]

  		Yh -= (Xh >> i);        // yi+1 = Ki*[yi - xi * 2^-i]
  		Zh = Zh + Alpha2[i];
        Xh = NewXh;

        //printf(" X: %d Y: %d\n",  X, Y);

        CurrAngleh += Alpha2[i]; 

        }
  	}



  }


  //CurrAngle= (28.027 << 16);


  for (i = 0; i < 12; i++)
  {
  	//printf("%d\n", Alpha[i]);

    fixed NewX;

    if (CurrAngle > 0)
    {
      TAN += (65536 >> i);  //tan = TAN + 1/2^i


      NewX = X - (Y >> i);  // xi+1 = Ki*[xi - yi * 2^-i]

      Y += (X >> i);        // yi+1 = Ki*[yi + xi * 2^-i]
      X = NewX;

      //printf(" X: %d Y: %d\n",  X, Y);

      CurrAngle -= Alpha[i]; 
    }
    else
    {
      TAN -= (65536 >> i);  //tan = TAN + 1/2^i

      NewX = X + (Y >> i);  // xi+1 = Ki*[xi + yi  * 2^-i]

      Y -= (X >> i);        // yi+1 = Ki*[yi - xi  * 2^-i]

      X = NewX;

     

      //printf(" X: %d Y: %d\n", X, Y);

      CurrAngle += Alpha[i];
    }

  }


  //BIT SHIFT 16
  //printf("cos()=%6.4f, sin()=%6.4f\n, tan()=%6.4f\n", X/65536.0, Y/65536.0, TAN/65536.0);
  printf("cosh()=%6.4f, sinh()=%6.4f\n", Xh/65536.0, Yh/65536.0);
} 
