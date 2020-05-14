//https://www.quinapalus.com/efunc.html

#include <stdio.h>
#include <math.h>



#define FXD(X) ((long int)((X) * 65536.0))

typedef long int fixed; /* 16.16 fixed-point */

static const fixed a[] = { FXD(5.5452), FXD(2.7726), FXD(1.3863), FXD(0.6931), FXD(0.4055), FXD(0.2231), FXD(0.1178),
FXD(0.0606), FXD(0.0308), FXD(0.0155), FXD(0.0078)};




int main(void)
{


  
  fixed t,y,x;

  x = FXD(0.5);

  y= FXD(1);


  t= x-a[0];

  printf("X= %6.4f Y= %6.4f T= %6.4f\n", x/65536.0, y/65536.0, t/65536.0);

 
  if(t>=0) x=t,y<<=8;

  t=x-a[1]; 
  if(t>=0) x=t,y<<=4;

  t=x-a[2]; 
  if(t>=0) x=t,y<<=2;

  t=x-a[3]; 
  if(t>=0) x=t,y<<=1;




  t=x-0x067cd; 
  if(t>=0) x=t,y+=y>>1;

  t=x-0x03920; 
  if(t>=0) x=t,y+=y>>2;

  t=x-0x01e27; 
  if(t>=0) x=t,y+=y>>3;

  t=x-0x00f85; 
  if(t>=0) x=t,y+=y>>4;

  t=x-0x007e1; 
  if(t>=0) x=t,y+=y>>5;

  t=x-0x003f8; 
  if(t>=0) x=t,y+=y>>6;

  t=x-0x001fe; 
  if(t>=0) x=t,y+=y>>7;




  if(x&0x100)               y+=y>>8;
  if(x&0x080)               y+=y>>9;
  if(x&0x040)               y+=y>>10;
  if(x&0x020)               y+=y>>11;
  if(x&0x010)               y+=y>>12;
  if(x&0x008)               y+=y>>13;
  if(x&0x004)               y+=y>>14;
  if(x&0x002)               y+=y>>15;
  if(x&0x001)               y+=y>>16;

  printf("%6.4f\n",y/65536.0);


  return y;
  

  
} 
