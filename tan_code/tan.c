//https://people.sc.fsu.edu/~jburkardt/c_src/cordic/cordic.c

#include <stdlib.h>
# include <stdio.h>
# include <math.h>
# include <time.h>

# include "tan.h"

 /******************************************************************************/

double angle_shift ( double alpha, double beta )

/******************************************************************************/
/*
  Purpose:

    ANGLE_SHIFT shifts angle ALPHA to lie between BETA and BETA+2PI.

  Discussion:

    The input angle ALPHA is shifted by multiples of 2 * PI to lie
    between BETA and BETA+2*PI.

    The resulting angle GAMMA has all the same trigonometric function
    values as ALPHA.

  Licensing:

    This code is distributed under the GNU LGPL license. 

  Modified:

    19 January 2012

  Author:

    John Burkardt

  Parameters:

    Input, double ALPHA, the angle to be shifted.

    Input, double BETA, defines the lower endpoint of
    the angle range.

    Output, double ANGLE_SHIFT, the shifted angle.
*/
{
  double gamma;
  double pi = 3.141592653589793;

  if ( alpha < beta )
  {
    gamma = beta - fmod ( beta - alpha, 2.0 * pi ) + 2.0 * pi;
  }
  else
  {
    gamma = beta + fmod ( alpha - beta, 2.0 * pi );
  }

  return gamma;
}

/******************************************************************************/

double tan_cordic ( double beta, int n )

/******************************************************************************/
/*
  Purpose:

    TAN_CORDIC returns the tangent of an angle using the CORDIC method.

  Licensing:

    This code is distributed under the GNU LGPL license. 

  Modified:

    19 January 2012

  Author:

    Based on MATLAB code in a Wikipedia article.
    C++ version by John Burkardt

  Parameters:

    Input, double BETA, the angle (in radians).

    Input, int N, the number of iterations to take.
    A value of 10 is low.  Good accuracy is achieved with 20 or more
    iterations.

    Output, double TAN_CORDIC, the tangent of the angle.

  Local Parameters:

    Local, double ANGLES(60) = arctan ( (1/2)^(0:59) );
*/

{
# define ANGLES_LENGTH 60

  double angle;
  double angles[ANGLES_LENGTH] = {
    7.8539816339744830962E-01, 
    4.6364760900080611621E-01, 
    2.4497866312686415417E-01, 
    1.2435499454676143503E-01, 
    6.2418809995957348474E-02, 
    3.1239833430268276254E-02, 
    1.5623728620476830803E-02, 
    7.8123410601011112965E-03, 
    3.9062301319669718276E-03, 
    1.9531225164788186851E-03, 
    9.7656218955931943040E-04, 
    4.8828121119489827547E-04, 
    2.4414062014936176402E-04, 
    1.2207031189367020424E-04, 
    6.1035156174208775022E-05, 
    3.0517578115526096862E-05, 
    1.5258789061315762107E-05, 
    7.6293945311019702634E-06, 
    3.8146972656064962829E-06, 
    1.9073486328101870354E-06, 
    9.5367431640596087942E-07, 
    4.7683715820308885993E-07, 
    2.3841857910155798249E-07, 
    1.1920928955078068531E-07, 
    5.9604644775390554414E-08, 
    2.9802322387695303677E-08, 
    1.4901161193847655147E-08, 
    7.4505805969238279871E-09, 
    3.7252902984619140453E-09, 
    1.8626451492309570291E-09, 
    9.3132257461547851536E-10, 
    4.6566128730773925778E-10, 
    2.3283064365386962890E-10, 
    1.1641532182693481445E-10, 
    5.8207660913467407226E-11, 
    2.9103830456733703613E-11, 
    1.4551915228366851807E-11, 
    7.2759576141834259033E-12, 
    3.6379788070917129517E-12, 
    1.8189894035458564758E-12, 
    9.0949470177292823792E-13, 
    4.5474735088646411896E-13, 
    2.2737367544323205948E-13, 
    1.1368683772161602974E-13, 
    5.6843418860808014870E-14, 
    2.8421709430404007435E-14, 
    1.4210854715202003717E-14, 
    7.1054273576010018587E-15, 
    3.5527136788005009294E-15, 
    1.7763568394002504647E-15, 
    8.8817841970012523234E-16, 
    4.4408920985006261617E-16, 
    2.2204460492503130808E-16, 
    1.1102230246251565404E-16, 
    5.5511151231257827021E-17, 
    2.7755575615628913511E-17, 
    1.3877787807814456755E-17, 
    6.9388939039072283776E-18, 
    3.4694469519536141888E-18, 
    1.7347234759768070944E-18 };
  double c;
  double c2;
  double factor;
  int j;
  double pi = 3.141592653589793;
  double poweroftwo;
  double s;
  double s2;
  double sigma;
  double t;
  double theta;
/*
  Shift angle to interval [-pi,pi].
*/
  theta = angle_shift ( beta, -pi );
/*
  Shift angle to interval [-pi/2,pi/2].
*/
  if ( theta < - 0.5 * pi )
  {
    theta = theta + pi;
  }
  else if ( 0.5 * pi < theta )
  {
    theta = theta - pi;
  }

  c = 1.0;
  s = 0.0;

  poweroftwo = 1.0;
  angle = angles[0];

  for ( j = 1; j <= n; j++ )
  {
    if ( theta < 0.0 )
    {
      sigma = -1.0;
    }
    else
    {
      sigma = 1.0;
    }

    factor = sigma * poweroftwo;

    c2 =          c - factor * s;
    s2 = factor * c +          s;

    c = c2;
    s = s2;
/*
  Update the remaining angle.
*/
    theta = theta - sigma * angle;

    poweroftwo = poweroftwo / 2.0;
/*
  Update the angle from table, or eventually by just dividing by two.
*/
    if ( ANGLES_LENGTH < j + 1 )
    {
      angle = angle / 2.0;
    }
    else
    {
      angle = angles[j];
    }
  }

  t = s / c;

  return t;
# undef ANGLES_LENGTH
}