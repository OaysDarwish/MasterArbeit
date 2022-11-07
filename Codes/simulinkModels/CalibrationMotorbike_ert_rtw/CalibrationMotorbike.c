/*
 * BOSCH E-Bike Development
 * AE-EBI/ENG1
 * Project: VICTOR
 *
 * File: CalibrationMotorbike.c
 *
 * Real-Time Workshop code generated for Simulink model CalibrationMotorbike.
 *
 * Model version                        : 1.1438
 * Real-Time Workshop file version      : 9.1 (R2019a) 23-Nov-2018
 * Real-Time Workshop file generated on : Wed Jul  8 17:53:57 2020
 * TLC version                          : 9.1 (Feb 23 2019)
 * C/C++ source code generated on       : Wed Jul  8 17:53:59 2020
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Freescale->32-bit PowerPC
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. MISRA C:2012 guidelines
 *    3. ROM efficiency
 *    4. RAM efficiency
 * Validation result: Not run
 */

// Matlab Includes
#include "CalibrationMotorbike.h"
#include "Sensordata.h"

// Matlab Defines

/* Named constants for Chart: '<Root>/RSD_RidingStateDetection' */
#define CalibrationM_IN_NO_ACTIVE_CHILD ((uint8_T)0U)
#define CalibrationM_IN_RidingConstant1 ((uint8_T)4U)
#define CalibrationMo_IN_RidingConstant ((uint8_T)2U)
#define CalibrationMot_IN_BadSensorData ((uint8_T)1U)
#define CalibrationMoto_IN_waitState3_m ((uint8_T)5U)
#define CalibrationMotor_IN_WaitState_n ((uint8_T)5U)
#define CalibrationMotor_IN_waitState_k ((uint8_T)4U)
#define CalibrationMotorb_IN_Falling1_b ((uint8_T)1U)
#define CalibrationMotorb_IN_waitState1 ((uint8_T)7U)
#define CalibrationMotorb_IN_waitState2 ((uint8_T)8U)
#define CalibrationMotorb_IN_waitState3 ((uint8_T)9U)
#define CalibrationMotorbi_IN_WaitState ((uint8_T)3U)
#define CalibrationMotorbi_IN_waitState ((uint8_T)6U)
#define CalibrationMotorbik_IN_Falling1 ((uint8_T)2U)
#define CalibrationMotorbike_IN_Falling ((uint8_T)1U)
#define CalibrationMotorbike_IN_Idle   ((uint8_T)1U)
#define CalibrationMotorbike_IN_Idle2  ((uint8_T)4U)
#define CalibrationMotorbike_IN_Idle2_g ((uint8_T)3U)
#define CalibrationMotorbike_IN_Idle_d ((uint8_T)2U)
#define CalibrationMotorbike_IN_Idle_ds ((uint8_T)3U)
#define CalibrationMotorbike_IN_Rising ((uint8_T)5U)
#define Calibration_IN_RidingConstant_m ((uint8_T)3U)

/* Named constants for Chart: '<Root>/SlopeEstimation' */
#define CalibrationMotorbi_IN_NotRiding ((uint8_T)1U)
#define CalibrationMotorbike_IN_Riding ((uint8_T)2U)
#define CalibrationMotorbike_IN_Riding1 ((uint8_T)3U)
#define Calibration_IN_SpeedIntegration ((uint8_T)4U)
#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error Code was generated for compiler with different sized uchar/char. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error Code was generated for compiler with different sized ushort/short. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized uint/int. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

/*
#if ( ULONG_MAX != (0xFFFFFFFFU) ) || ( LONG_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized ulong/long. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif
*/

// Matlab Types

// Matlab Enums

// Matlab Definitions

real32_T calibrationModuleVersion = 1.1438F;


/* Exported data definition */

/* Definition for custom storage class: Struct */
MOCA_in_type MOCA_in;
MOCA_out_type MOCA_out;
MOCA_par_type MOCA_par =
{
  /* maxAngleChange_deg */
  10.0F,

  /* maxLongAccNorm_mg */
  600.0F,

  /* minLongAccNorm_mg */
  100.0F,

  /* minSpeedRSD_kmh */
  15.0F,

  /* samplePeriod_s */
  0.01F
};

/* Block signals and states (default storage) */
D_Work_CalibrationMotorbike CalibrationMotorbike_DWork;

// Matlab Declarations

/* Forward declaration for local functions */
static real32_T CalibrationMotorbike_sum(const real32_T x[300]);
static void Calibrat_CheckForConstantRiding(const real32_T *speedKmh, const
  real32_T *accFiltNorm, const real32_T *gyrIntegralNorm_deg, real32_T *Diff);
static void Calibratio_CheckForDeceleration(const real32_T *accFiltNorm, const
  real32_T *gyrIntegralNorm_deg, real32_T *Diff);
static real32_T CalibrationMotorbike_norm(const real32_T x[3]);

// Matlab Functions

/* Function for MATLAB Function: '<Root>/MATLAB Function2' */
static real32_T CalibrationMotorbike_sum(const real32_T x[300])
{
  real32_T y;
  int32_T k;
  y = x[0];
  for (k = 0; k < 299; k++)
  {
    y += x[k + 1];
  }

  return y;
}

/* Function for Chart: '<Root>/RSD_RidingStateDetection' */
static void Calibrat_CheckForConstantRiding(const real32_T *speedKmh, const
  real32_T *accFiltNorm, const real32_T *gyrIntegralNorm_deg, real32_T *Diff)
{
  uint8_T is_CheckForConstantRiding;
  uint16_T temporalCounter_i1;
  uint16_T RSD_constantRiding;
  RSD_constantRiding = CalibrationMotorbike_DWork.RSD_constantRiding;
  temporalCounter_i1 = CalibrationMotorbike_DWork.temporalCounter_i1;
  is_CheckForConstantRiding =
    CalibrationMotorbike_DWork.is_CheckForConstantRiding;

  /* During 'CheckForConstantRiding': '<S9>:19' */
  switch (is_CheckForConstantRiding)
  {
   case CalibrationMotorbike_IN_Idle:
    /* Constant: '<Root>/Constant3' incorporates:
     *  Constant: '<Root>/Constant2'
     */
    /* During 'Idle': '<S9>:1' */
    if ((*speedKmh >= MOCA_par.minSpeedRSD_kmh) && ((fabsf(*Diff) < 1.5F) &&
         (*gyrIntegralNorm_deg < MOCA_par.maxAngleChange_deg)))
    {
      /* Transition: '<S9>:4' */
      is_CheckForConstantRiding = CalibrationMotorbi_IN_WaitState;
      temporalCounter_i1 = 0U;

      /* Entry 'WaitState': '<S9>:3' */
      RSD_constantRiding = 0U;
    }
    break;

   case CalibrationMo_IN_RidingConstant:
    /* During 'RidingConstant': '<S9>:6' */
    /* Transition: '<S9>:8' */
    is_CheckForConstantRiding = CalibrationMotorbi_IN_WaitState;
    temporalCounter_i1 = 0U;

    /* Entry 'WaitState': '<S9>:3' */
    RSD_constantRiding = 0U;
    break;

   default:
    /* Constant: '<Root>/Constant3' incorporates:
     *  Constant: '<Root>/Constant2'
     */
    /* During 'WaitState': '<S9>:3' */
    if ((*speedKmh < MOCA_par.minSpeedRSD_kmh) || ((fabsf(*Diff) >= 1.5F) ||
         ((*gyrIntegralNorm_deg >= MOCA_par.maxAngleChange_deg) || (*accFiltNorm
           < 850.0F) || (*accFiltNorm > 1100.0F))))
    {
      /* Transition: '<S9>:5' */
      is_CheckForConstantRiding = CalibrationMotorbike_IN_Idle;

      /* Entry 'Idle': '<S9>:1' */
      RSD_constantRiding = 0U;
    }
    else
    {
      if ((uint32_T)temporalCounter_i1 >= 400U)
      {
        /* Transition: '<S9>:7' */
        is_CheckForConstantRiding = CalibrationMo_IN_RidingConstant;

        /* Entry 'RidingConstant': '<S9>:6' */
        RSD_constantRiding = 1U;
      }
    }
    break;
  }

  CalibrationMotorbike_DWork.is_CheckForConstantRiding =
    is_CheckForConstantRiding;
  CalibrationMotorbike_DWork.temporalCounter_i1 = temporalCounter_i1;
  CalibrationMotorbike_DWork.RSD_constantRiding = RSD_constantRiding;
}

/* Function for Chart: '<Root>/RSD_RidingStateDetection' */
static void Calibratio_CheckForDeceleration(const real32_T *accFiltNorm, const
  real32_T *gyrIntegralNorm_deg, real32_T *Diff)
{
  uint16_T RSD_accNormExtremaFlag;
  uint8_T is_CheckForDeceleration;
  uint16_T temporalCounter_i2;
  uint16_T RSD_decelerationFlag;
  RSD_decelerationFlag = CalibrationMotorbike_DWork.RSD_decelerationFlag;
  temporalCounter_i2 = CalibrationMotorbike_DWork.temporalCounter_i2;
  is_CheckForDeceleration = CalibrationMotorbike_DWork.is_CheckForDeceleration;
  RSD_accNormExtremaFlag = CalibrationMotorbike_DWork.RSD_accNormExtremaFlag;

  /* During 'CheckForDeceleration': '<S9>:45' */
  switch (is_CheckForDeceleration)
  {
   case CalibrationMot_IN_BadSensorData:
    /* During 'BadSensorData': '<S9>:176' */
    if (((uint32_T)temporalCounter_i2 >= 100U) && (*accFiltNorm > 400.0F) &&
        (*accFiltNorm < 1500.0F))
    {
      /* Transition: '<S9>:177' */
      is_CheckForDeceleration = CalibrationMotorbi_IN_waitState;
      temporalCounter_i2 = 0U;
    }
    break;

   case CalibrationMotorbike_IN_Idle_d:
    /* During 'Idle': '<S9>:51' */
    if ((*accFiltNorm < 400.0F) || (*accFiltNorm > 1500.0F))
    {
      /* Transition: '<S9>:174' */
      is_CheckForDeceleration = CalibrationMot_IN_BadSensorData;
      temporalCounter_i2 = 0U;
    }
    else
    {
      if (*Diff < -5.0F)
      {
        /* Transition: '<S9>:47' */
        is_CheckForDeceleration = CalibrationMotor_IN_WaitState_n;

        /* Entry 'WaitState': '<S9>:52' */
        RSD_decelerationFlag = 0U;
      }
    }
    break;

   case Calibration_IN_RidingConstant_m:
    /* During 'RidingConstant': '<S9>:53' */
    /* Transition: '<S9>:49' */
    is_CheckForDeceleration = CalibrationMotorb_IN_waitState1;
    temporalCounter_i2 = 0U;

    /* Entry 'waitState1': '<S9>:187' */
    RSD_decelerationFlag = 0U;
    break;

   case CalibrationM_IN_RidingConstant1:
    /* During 'RidingConstant1': '<S9>:115' */
    /* Transition: '<S9>:116' */
    is_CheckForDeceleration = CalibrationMotorb_IN_waitState1;
    temporalCounter_i2 = 0U;

    /* Entry 'waitState1': '<S9>:187' */
    RSD_decelerationFlag = 0U;
    break;

   case CalibrationMotor_IN_WaitState_n:
    /* During 'WaitState': '<S9>:52' */
    if ((int32_T)RSD_accNormExtremaFlag == 2)
    {
      /* Transition: '<S9>:114' */
      is_CheckForDeceleration = CalibrationM_IN_RidingConstant1;

      /* Entry 'RidingConstant1': '<S9>:115' */
      RSD_decelerationFlag = 2U;
    }
    else if ((*Diff >= -1.0F) || (*gyrIntegralNorm_deg >=
              MOCA_par.maxAngleChange_deg))
    {
      /* Transition: '<S9>:50' */
      is_CheckForDeceleration = CalibrationMotorbike_IN_Idle_d;

      /* Entry 'Idle': '<S9>:51' */
      RSD_decelerationFlag = 0U;
    }
    else
    {
      if ((int32_T)RSD_accNormExtremaFlag == 1)
      {
        /* Transition: '<S9>:48' */
        is_CheckForDeceleration = Calibration_IN_RidingConstant_m;

        /* Entry 'RidingConstant': '<S9>:53' */
        RSD_decelerationFlag = 1U;
      }
    }
    break;

   case CalibrationMotorbi_IN_waitState:
    /* During 'waitState': '<S9>:184' */
    if ((uint32_T)temporalCounter_i2 >= 1000U)
    {
      /* Transition: '<S9>:185' */
      is_CheckForDeceleration = CalibrationMotorbike_IN_Idle_d;

      /* Entry 'Idle': '<S9>:51' */
      RSD_decelerationFlag = 0U;
    }
    break;

   default:
    /* During 'waitState1': '<S9>:187' */
    if ((uint32_T)temporalCounter_i2 >= 1000U)
    {
      /* Transition: '<S9>:183' */
      is_CheckForDeceleration = CalibrationMotorbike_IN_Idle_d;

      /* Entry 'Idle': '<S9>:51' */
      RSD_decelerationFlag = 0U;
    }
    break;
  }

  CalibrationMotorbike_DWork.is_CheckForDeceleration = is_CheckForDeceleration;
  CalibrationMotorbike_DWork.temporalCounter_i2 = temporalCounter_i2;
  CalibrationMotorbike_DWork.RSD_decelerationFlag = RSD_decelerationFlag;
}

/* Function for MATLAB Function: '<Root>/MATLAB Function' */
static real32_T CalibrationMotorbike_norm(const real32_T x[3])
{
  real32_T y;
  real32_T scale;
  real32_T absxk;
  real32_T t;
  scale = 1.29246971E-26F;
  absxk = fabsf(x[0]);
  if (absxk > 1.29246971E-26F)
  {
    y = 1.0F;
    scale = absxk;
  }
  else
  {
    t = absxk / 1.29246971E-26F;
    y = t * t;
  }

  absxk = fabsf(x[1]);
  if (absxk > scale)
  {
    t = scale / absxk;
    y = y * t * t + 1.0F;
    scale = absxk;
  }
  else
  {
    t = absxk / scale;
    y += t * t;
  }

  absxk = fabsf(x[2]);
  if (absxk > scale)
  {
    t = scale / absxk;
    y = y * t * t + 1.0F;
    scale = absxk;
  }
  else
  {
    t = absxk / scale;
    y += t * t;
  }

  return scale * sqrtf(y);
}

/* Model step function */
void CalibrationMotorbike_step(void)
{
  real32_T gyrXIntegral_deg;
  real32_T gyrYIntegral_deg;
  real32_T gyrZIntegral_deg;
  real32_T accSfLongAccVec[3];
  real32_T longAccVecSfTmp[3];
  int32_T xpageoffset;
  int8_T b_I[9];
  real32_T SE_asinArg;
  real_T COCA_rtb_Product4;
  real_T COCA_rtb_Product8;
  real_T COCA_rtb_Divide;
  real_T COCA_rtb_Divide_p;
  real_T COCA_rtb_Divide_a;
  real32_T COCA_rtb_TSamp;
  boolean_T COCA_rtb_Compare;
  real_T COCA_rtb_Switch1;
  real_T COCA_rtb_Divide_h;
  real32_T accFiltNorm;
  int32_T i;
  real32_T a[3];
  real32_T Diff;
  real32_T accSfLongAccVec_0;
  real32_T rotMatSf2BfOut_3x3;
  real32_T accSfLongAccVec_1;
  real32_T longAccVecSfTmp_0;
  real32_T accSfLongAccVec_2;
  real32_T rotMatSf2BfOut_3x3_0;
  real32_T speedKmh_filt;
  real32_T UD_DSTATE_e;
  real_T UnitDelay4_DSTATE_e;
  real_T AtmPressureFilt;
  real32_T pressure_Pa;
  real32_T RSD_accSfZExtrema;
  real32_T RSD_accSfYExtrema;
  real32_T RSD_accSfXExtrema;
  real32_T UnitDelay_DSTATE_c;
  real32_T UnitDelay_DSTATE_e;
  real32_T UnitDelay_DSTATE_nf;
  real32_T UnitDelay_DSTATE_n;
  real32_T UnitDelay_DSTATE;
  real_T UnitDelay3_DSTATE_h;
  real32_T UD_DSTATE;
  real_T UnitDelay3_DSTATE_p;
  real_T UnitDelay3_DSTATE_j;
  real_T UnitDelay3_DSTATE;
  uint16_T calibFlag;
  real32_T SE_2EstFlag;
  uint16_T temporalCounter_i3;
  real32_T UnitDelay2_DSTATE;
  real_T SE_initPressure;
  real32_T curSlopePressure;
  real32_T SE_curDistance2M;
  real32_T SE_curDistanceM;
  uint8_T is_Slope2;
  uint8_T is_Slope1;
  uint8_T temporalCounter_i2_l;
  real32_T SE_timer;
  uint8_T temporalCounter_i1_i;
  real32_T accSFFiltNormRidingConstant;
  uint16_T RSD_accelerationFlag;
  boolean_T calibFlag_not_empty;
  uint16_T firstLongAccFlag;
  uint16_T UnitDelay2_DSTATE_n;
  real32_T UnitDelay_DSTATE_k;
  uint16_T firstRidindConstantFlag;
  uint16_T RSD_accExtremaFlag;
  uint8_T is_CheckForAccNormMaxAccelerati;
  uint8_T is_CheckForAccelerationPhase;
  uint8_T is_CheckForAccNormMax;
  real32_T UnitDelay1_DSTATE_i;
  real32_T RSD_curAccExtrema;
  real32_T RSD_curExtrema;
  int16_T i_0;
  int16_T rotMatUpdate;
  boolean_T guard1 = false;

  /* MATLAB Function: '<Root>/MATLAB Function2' */
  i_0 = CalibrationMotorbike_DWork.i;
  RSD_curExtrema = CalibrationMotorbike_DWork.RSD_curExtrema;
  RSD_curAccExtrema = CalibrationMotorbike_DWork.RSD_curAccExtrema;

  /* Chart: '<Root>/RSD_RidingStateDetection' incorporates:
   *  UnitDelay: '<Root>/Unit Delay1'
   */
  UnitDelay1_DSTATE_i = CalibrationMotorbike_DWork.UnitDelay1_DSTATE_i;
  is_CheckForAccNormMax = CalibrationMotorbike_DWork.is_CheckForAccNormMax;
  is_CheckForAccelerationPhase =
    CalibrationMotorbike_DWork.is_CheckForAccelerationPhase;
  is_CheckForAccNormMaxAccelerati =
    CalibrationMotorbike_DWork.is_CheckForAccNormMaxAccelerati;
  RSD_accExtremaFlag = CalibrationMotorbike_DWork.RSD_accExtremaFlag;
  firstRidindConstantFlag = CalibrationMotorbike_DWork.firstRidindConstantFlag;

  /* MATLAB Function: '<Root>/MATLAB Function' incorporates:
   *  UnitDelay: '<Root>/Unit Delay'
   *  UnitDelay: '<Root>/Unit Delay2'
   */
  UnitDelay_DSTATE_k = CalibrationMotorbike_DWork.UnitDelay_DSTATE_k;
  UnitDelay2_DSTATE_n = CalibrationMotorbike_DWork.UnitDelay2_DSTATE_n;
  firstLongAccFlag = CalibrationMotorbike_DWork.firstLongAccFlag;
  calibFlag_not_empty = CalibrationMotorbike_DWork.calibFlag_not_empty;
  RSD_accelerationFlag = CalibrationMotorbike_DWork.RSD_accelerationFlag;
  accSFFiltNormRidingConstant =
    CalibrationMotorbike_DWork.accSFFiltNormRidingConstant;
  temporalCounter_i1_i = CalibrationMotorbike_DWork.temporalCounter_i1_i;
  SE_timer = CalibrationMotorbike_DWork.SE_timer;
  temporalCounter_i2_l = CalibrationMotorbike_DWork.temporalCounter_i2_l;
  is_Slope1 = CalibrationMotorbike_DWork.is_Slope1;
  is_Slope2 = CalibrationMotorbike_DWork.is_Slope2;
  SE_curDistanceM = CalibrationMotorbike_DWork.SE_curDistanceM;
  SE_curDistance2M = CalibrationMotorbike_DWork.SE_curDistance2M;
  curSlopePressure = CalibrationMotorbike_DWork.curSlopePressure;
  SE_initPressure = CalibrationMotorbike_DWork.SE_initPressure;
  UnitDelay2_DSTATE = CalibrationMotorbike_DWork.UnitDelay2_DSTATE;
  temporalCounter_i3 = CalibrationMotorbike_DWork.temporalCounter_i3;
  SE_2EstFlag = CalibrationMotorbike_DWork.SE_2EstFlag;
  calibFlag = CalibrationMotorbike_DWork.calibFlag;

  /* UnitDelay: '<S1>/Unit Delay3' */
  UnitDelay3_DSTATE = CalibrationMotorbike_DWork.UnitDelay3_DSTATE;

  /* UnitDelay: '<S2>/Unit Delay3' */
  UnitDelay3_DSTATE_j = CalibrationMotorbike_DWork.UnitDelay3_DSTATE_j;

  /* UnitDelay: '<S3>/Unit Delay3' */
  UnitDelay3_DSTATE_p = CalibrationMotorbike_DWork.UnitDelay3_DSTATE_p;
  UD_DSTATE = CalibrationMotorbike_DWork.UD_DSTATE;

  /* UnitDelay: '<S5>/Unit Delay3' */
  UnitDelay3_DSTATE_h = CalibrationMotorbike_DWork.UnitDelay3_DSTATE_h;

  /* UnitDelay: '<S1>/Unit Delay' */
  UnitDelay_DSTATE = CalibrationMotorbike_DWork.UnitDelay_DSTATE;

  /* UnitDelay: '<S2>/Unit Delay' */
  UnitDelay_DSTATE_n = CalibrationMotorbike_DWork.UnitDelay_DSTATE_n;

  /* UnitDelay: '<S3>/Unit Delay' */
  UnitDelay_DSTATE_nf = CalibrationMotorbike_DWork.UnitDelay_DSTATE_nf;

  /* UnitDelay: '<S4>/Unit Delay' */
  UnitDelay_DSTATE_e = CalibrationMotorbike_DWork.UnitDelay_DSTATE_e;

  /* UnitDelay: '<S5>/Unit Delay' */
  UnitDelay_DSTATE_c = CalibrationMotorbike_DWork.UnitDelay_DSTATE_c;
  RSD_accSfXExtrema = CalibrationMotorbike_DWork.RSD_accSfXExtrema;
  RSD_accSfYExtrema = CalibrationMotorbike_DWork.RSD_accSfYExtrema;
  RSD_accSfZExtrema = CalibrationMotorbike_DWork.RSD_accSfZExtrema;

  /* Chart: '<Root>/SlopeEstimation' */
  AtmPressureFilt = CalibrationMotorbike_DWork.AtmPressureFilt;

  /* Update for Switch: '<S4>/Switch' incorporates:
   *  UnitDelay: '<S4>/Unit Delay4'
   */
  UnitDelay4_DSTATE_e = CalibrationMotorbike_DWork.UnitDelay4_DSTATE_e;

  /* Sum: '<S11>/Diff' incorporates:
   *  UnitDelay: '<S11>/UD'
   */
  UD_DSTATE_e = CalibrationMotorbike_DWork.UD_DSTATE_e;

  /* Sum: '<S12>/Diff' incorporates:
   *  UnitDelay: '<S12>/UD'
   */
  speedKmh_filt = CalibrationMotorbike_DWork.speedKmh_filt;

  /* Product: '<S1>/Divide1' incorporates:
   *  Constant: '<Root>/Constant'
   *  Constant: '<S1>/const3'
   *  Product: '<S2>/Divide1'
   *  Product: '<S3>/Divide1'
   *  Product: '<S4>/Divide1'
   *  Product: '<S5>/Divide1'
   */
  COCA_rtb_Divide_h = 2.0 / (real_T)MOCA_par.samplePeriod_s;

  /* Product: '<S1>/Product4' incorporates:
   *  Product: '<S1>/Divide1'
   */
  COCA_rtb_Product4 = COCA_rtb_Divide_h * COCA_rtb_Divide_h;

  /* Product: '<S1>/Product8' incorporates:
   *  Gain: '<S1>/Gain1'
   *  Product: '<S1>/Divide1'
   */
  COCA_rtb_Product8 = 1.4142135623730951 * COCA_rtb_Divide_h *
    1.5707963267948966;

  /* Product: '<S1>/Divide' incorporates:
   *  Gain: '<S1>/Gain2'
   *  Gain: '<S1>/Gain3'
   *  Inport: '<Root>/accSfX [mg]'
   *  Product: '<S1>/Product1'
   *  Product: '<S1>/Product2'
   *  Product: '<S1>/Product3'
   *  Product: '<S1>/Product7'
   *  Product: '<S1>/Product9'
   *  Sum: '<S1>/Add'
   *  Sum: '<S1>/Add1'
   *  Sum: '<S1>/Add2'
   *  Sum: '<S1>/Add3'
   *  Sum: '<S1>/Add4'
   *  Sum: '<S1>/Add5'
   *  UnitDelay: '<S1>/Unit Delay1'
   *  UnitDelay: '<S1>/Unit Delay4'
   */
  COCA_rtb_Divide = ((((real_T)(real32_T)(2.0F * UnitDelay_DSTATE) *
                       2.4674011002723395 + 2.4674011002723395 * (real_T)
                       ACC_getAccSfXmg()) + 2.4674011002723395 * (real_T)
                      CalibrationMotorbike_DWork.UnitDelay1_DSTATE) - ((-2.0 *
    COCA_rtb_Product4 + 4.934802200544679) * UnitDelay3_DSTATE +
    ((COCA_rtb_Product4 - COCA_rtb_Product8) + 2.4674011002723395) *
    CalibrationMotorbike_DWork.UnitDelay4_DSTATE)) / ((COCA_rtb_Product4 +
    COCA_rtb_Product8) + 2.4674011002723395);

  /* Product: '<S2>/Product4' */
  COCA_rtb_Divide_p = COCA_rtb_Divide_h * COCA_rtb_Divide_h;

  /* Product: '<S2>/Product8' incorporates:
   *  Gain: '<S2>/Gain1'
   */
  COCA_rtb_Divide_a = 1.4142135623730951 * COCA_rtb_Divide_h *
    1.5707963267948966;

  /* Product: '<S2>/Divide' incorporates:
   *  Gain: '<S2>/Gain2'
   *  Gain: '<S2>/Gain3'
   *  Inport: '<Root>/accSfY [mg]'
   *  Product: '<S2>/Product1'
   *  Product: '<S2>/Product2'
   *  Product: '<S2>/Product3'
   *  Product: '<S2>/Product4'
   *  Product: '<S2>/Product7'
   *  Product: '<S2>/Product8'
   *  Product: '<S2>/Product9'
   *  Sum: '<S2>/Add'
   *  Sum: '<S2>/Add1'
   *  Sum: '<S2>/Add2'
   *  Sum: '<S2>/Add3'
   *  Sum: '<S2>/Add4'
   *  Sum: '<S2>/Add5'
   *  UnitDelay: '<S2>/Unit Delay1'
   *  UnitDelay: '<S2>/Unit Delay4'
   */
  COCA_rtb_Divide_p = ((((real_T)(real32_T)(2.0F * UnitDelay_DSTATE_n) *
    2.4674011002723395 + 2.4674011002723395 * (real_T)ACC_getAccSfYmg()) +
                        2.4674011002723395 * (real_T)
                        CalibrationMotorbike_DWork.UnitDelay1_DSTATE_f) - ((-2.0
    * COCA_rtb_Divide_p + 4.934802200544679) * UnitDelay3_DSTATE_j +
    ((COCA_rtb_Divide_p - COCA_rtb_Divide_a) + 2.4674011002723395) *
    CalibrationMotorbike_DWork.UnitDelay4_DSTATE_f)) / ((COCA_rtb_Divide_p +
    COCA_rtb_Divide_a) + 2.4674011002723395);

  /* Product: '<S3>/Product4' */
  COCA_rtb_Product4 = COCA_rtb_Divide_h * COCA_rtb_Divide_h;

  /* Product: '<S3>/Product8' incorporates:
   *  Gain: '<S3>/Gain1'
   */
  COCA_rtb_Product8 = 1.4142135623730951 * COCA_rtb_Divide_h *
    1.5707963267948966;

  /* Product: '<S3>/Divide' incorporates:
   *  Gain: '<S3>/Gain2'
   *  Gain: '<S3>/Gain3'
   *  Inport: '<Root>/accSfZ [mg]'
   *  Product: '<S3>/Product1'
   *  Product: '<S3>/Product2'
   *  Product: '<S3>/Product3'
   *  Product: '<S3>/Product4'
   *  Product: '<S3>/Product7'
   *  Product: '<S3>/Product8'
   *  Product: '<S3>/Product9'
   *  Sum: '<S3>/Add'
   *  Sum: '<S3>/Add1'
   *  Sum: '<S3>/Add2'
   *  Sum: '<S3>/Add3'
   *  Sum: '<S3>/Add4'
   *  Sum: '<S3>/Add5'
   *  UnitDelay: '<S3>/Unit Delay1'
   *  UnitDelay: '<S3>/Unit Delay4'
   */
  COCA_rtb_Divide_a = ((((real_T)(real32_T)(2.0F * UnitDelay_DSTATE_nf) *
    2.4674011002723395 + 2.4674011002723395 * (real_T)ACC_getAccSfZmg()) +
                        2.4674011002723395 * (real_T)
                        CalibrationMotorbike_DWork.UnitDelay1_DSTATE_p) - ((-2.0
    * COCA_rtb_Product4 + 4.934802200544679) * UnitDelay3_DSTATE_p +
    ((COCA_rtb_Product4 - COCA_rtb_Product8) + 2.4674011002723395) *
    CalibrationMotorbike_DWork.UnitDelay4_DSTATE_n)) / ((COCA_rtb_Product4 +
    COCA_rtb_Product8) + 2.4674011002723395);

  /* DataTypeConversion: '<Root>/Data Type Conversion4' incorporates:
   *  Inport: '<Root>/speed [km//h*100]'
   */
  SE_asinArg = (real32_T)SPECO_getPresentSpeed() * 0.01F;

  /* Sum: '<S13>/Sum' incorporates:
   *  Gain: '<S13>/Gain'
   *  Sum: '<S13>/Diff'
   */
  UD_DSTATE = (UD_DSTATE - SE_asinArg) * 0.995F + SE_asinArg;

  /* SampleTimeMath: '<S6>/TSamp'
   *
   * About '<S6>/TSamp':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  COCA_rtb_TSamp = UD_DSTATE * 100.0F;

  /* Sum: '<S6>/Diff' incorporates:
   *  UnitDelay: '<S6>/UD'
   */
  Diff = COCA_rtb_TSamp - CalibrationMotorbike_DWork.UD_DSTATE_j;

  /* Sqrt: '<Root>/Sqrt' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion11'
   *  DataTypeConversion: '<Root>/Data Type Conversion5'
   *  DataTypeConversion: '<Root>/Data Type Conversion6'
   *  Math: '<Root>/Square'
   *  Math: '<Root>/Square1'
   *  Math: '<Root>/Square2'
   *  Sum: '<Root>/Add'
   */
  accFiltNorm = sqrtf(((real32_T)COCA_rtb_Divide * (real32_T)COCA_rtb_Divide +
                       (real32_T)COCA_rtb_Divide_p * (real32_T)COCA_rtb_Divide_p)
                      + (real32_T)COCA_rtb_Divide_a * (real32_T)
                      COCA_rtb_Divide_a);

  /* MATLAB Function: '<Root>/MATLAB Function2' incorporates:
   *  Constant: '<Root>/Constant'
   *  DataTypeConversion: '<Root>/Data Type Conversion7'
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  DataTypeConversion: '<Root>/Data Type Conversion9'
   *  Gain: '<Root>/Gain'
   *  Gain: '<Root>/Gain1'
   *  Gain: '<Root>/Gain2'
   *  Inport: '<Root>/gyrSfX [mdeg//s]'
   *  Inport: '<Root>/gyrSfY [mdeg//s]'
   *  Inport: '<Root>/gyrSfZ [mdeg//s]'
   */
  /* MATLAB Function 'MATLAB Function2': '<S8>:1' */
  /* '<S8>:1:6' */
  /* '<S8>:1:16' */
  i = (int32_T)i_0 - 1;
  CalibrationMotorbike_DWork.ringBufGyrX[i] = 0.001F * (real32_T)
    GYR_getGyrSfXmdegs();

  /* '<S8>:1:17' */
  CalibrationMotorbike_DWork.ringBufGyrY[i] = 0.001F * (real32_T)
    GYR_getGyrSfYmdegs();

  /* '<S8>:1:18' */
  CalibrationMotorbike_DWork.ringBufGyrZ[i] = 0.001F * (real32_T)
    GYR_getGyrSfZmdegs();

  /* '<S8>:1:21' */
  gyrXIntegral_deg = CalibrationMotorbike_sum
    (CalibrationMotorbike_DWork.ringBufGyrX) * MOCA_par.samplePeriod_s;

  /* '<S8>:1:22' */
  gyrYIntegral_deg = CalibrationMotorbike_sum
    (CalibrationMotorbike_DWork.ringBufGyrY) * MOCA_par.samplePeriod_s;

  /* '<S8>:1:23' */
  gyrZIntegral_deg = CalibrationMotorbike_sum
    (CalibrationMotorbike_DWork.ringBufGyrZ) * MOCA_par.samplePeriod_s;

  /* '<S8>:1:25' */
  gyrXIntegral_deg = sqrtf((gyrXIntegral_deg * gyrXIntegral_deg +
    gyrYIntegral_deg * gyrYIntegral_deg) + gyrZIntegral_deg * gyrZIntegral_deg);

  /* '<S8>:1:28' */
  i = (int32_T)i_0 + 1;
  if (i > 32767)
  {
    i = 32767;
  }

  i_0 = (int16_T)i;
  if ((int16_T)i > 300)
  {
    /* '<S8>:1:29' */
    /* '<S8>:1:30' */
    i_0 = 1;
  }

  /* Chart: '<Root>/RSD_RidingStateDetection' incorporates:
   *  Constant: '<Root>/Constant2'
   *  DataTypeConversion: '<Root>/Data Type Conversion11'
   *  DataTypeConversion: '<Root>/Data Type Conversion4'
   *  DataTypeConversion: '<Root>/Data Type Conversion5'
   *  DataTypeConversion: '<Root>/Data Type Conversion6'
   */
  if ((uint32_T)CalibrationMotorbike_DWork.temporalCounter_i1 < 511U)
  {
    CalibrationMotorbike_DWork.temporalCounter_i1 = (uint16_T)((uint32_T)
      CalibrationMotorbike_DWork.temporalCounter_i1 + 1U);
  }

  if ((uint32_T)CalibrationMotorbike_DWork.temporalCounter_i2 < 1023U)
  {
    CalibrationMotorbike_DWork.temporalCounter_i2 = (uint16_T)((uint32_T)
      CalibrationMotorbike_DWork.temporalCounter_i2 + 1U);
  }

  if ((uint32_T)temporalCounter_i3 < 1023U)
  {
    temporalCounter_i3 = (uint16_T)((uint32_T)temporalCounter_i3 + 1U);
  }

  /* Gateway: RSD_RidingStateDetection */
  /* During: RSD_RidingStateDetection */
  if ((uint32_T)CalibrationMotorbike_DWork.is_active_c3_CalibrationMotorbi == 0U)
  {
    /* Entry: RSD_RidingStateDetection */
    CalibrationMotorbike_DWork.is_active_c3_CalibrationMotorbi = 1U;

    /* Entry Internal: RSD_RidingStateDetection */
    /* Entry Internal 'CheckForConstantRiding': '<S9>:19' */
    /* Transition: '<S9>:2' */
    CalibrationMotorbike_DWork.is_CheckForConstantRiding =
      CalibrationMotorbike_IN_Idle;

    /* Entry 'Idle': '<S9>:1' */
    CalibrationMotorbike_DWork.RSD_constantRiding = 0U;

    /* Entry Internal 'CheckForDeceleration': '<S9>:45' */
    /* Transition: '<S9>:46' */
    CalibrationMotorbike_DWork.is_CheckForDeceleration =
      CalibrationMotorbike_IN_Idle_d;

    /* Entry 'Idle': '<S9>:51' */
    CalibrationMotorbike_DWork.RSD_decelerationFlag = 0U;

    /* Entry Internal 'CheckForAccNormMax': '<S9>:58' */
    /* Transition: '<S9>:59' */
    CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
    is_CheckForAccNormMax = CalibrationMotorbi_IN_waitState;

    /* Entry Internal 'CheckForAccelerationPhase': '<S9>:117' */
    /* Transition: '<S9>:119' */
    is_CheckForAccelerationPhase = CalibrationMotorbike_IN_Idle_d;

    /* Entry 'Idle': '<S9>:126' */
    RSD_accelerationFlag = 0U;

    /* Entry Internal 'CheckForAccNormMaxAccelerationPhase': '<S9>:130' */
    /* Transition: '<S9>:132' */
    RSD_accExtremaFlag = 0U;
    is_CheckForAccNormMaxAccelerati = CalibrationMotor_IN_waitState_k;
  }
  else
  {
    Calibrat_CheckForConstantRiding(&SE_asinArg, &accFiltNorm, &gyrXIntegral_deg,
      &Diff);
    Calibratio_CheckForDeceleration(&accFiltNorm, &gyrXIntegral_deg, &Diff);

    /* During 'CheckForAccNormMax': '<S9>:58' */
    switch (is_CheckForAccNormMax)
    {
     case CalibrationMotorbike_IN_Falling:
      /* During 'Falling': '<S9>:70' */
      if (accFiltNorm < RSD_curExtrema)
      {
        /* Transition: '<S9>:76' */
        RSD_curExtrema = accFiltNorm;
        RSD_accSfXExtrema = (real32_T)COCA_rtb_Divide;
        RSD_accSfYExtrema = (real32_T)COCA_rtb_Divide_p;
        RSD_accSfZExtrema = (real32_T)COCA_rtb_Divide_a;
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Falling;

        /* Entry 'Falling': '<S9>:70' */
      }
      else if (accFiltNorm > RSD_curExtrema + 4.0F)
      {
        /* Transition: '<S9>:77' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 1U;
        is_CheckForAccNormMax = CalibrationMotorb_IN_waitState2;
      }
      else
      {
        if ((int32_T)UnitDelay2_DSTATE_n >= 1)
        {
          /* Transition: '<S9>:110' */
          /* Transition: '<S9>:112' */
          is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle2;

          /* Entry 'Idle2': '<S9>:96' */
          CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
          RSD_curExtrema = UnitDelay1_DSTATE_i;
        }
      }
      break;

     case CalibrationMotorbik_IN_Falling1:
      /* During 'Falling1': '<S9>:97' */
      if (UnitDelay1_DSTATE_i > RSD_curExtrema + 15.0F)
      {
        /* Transition: '<S9>:100' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 2U;
        is_CheckForAccNormMax = CalibrationMotorb_IN_waitState3;
      }
      else
      {
        if (UnitDelay1_DSTATE_i < RSD_curExtrema)
        {
          /* Transition: '<S9>:99' */
          RSD_curExtrema = UnitDelay1_DSTATE_i;
          RSD_accSfXExtrema = (real32_T)COCA_rtb_Divide;
          RSD_accSfYExtrema = (real32_T)COCA_rtb_Divide_p;
          RSD_accSfZExtrema = (real32_T)COCA_rtb_Divide_a;
          is_CheckForAccNormMax = CalibrationMotorbik_IN_Falling1;

          /* Entry 'Falling1': '<S9>:97' */
        }
      }
      break;

     case CalibrationMotorbike_IN_Idle_ds:
      /* During 'Idle': '<S9>:65' */
      if ((int32_T)UnitDelay2_DSTATE_n >= 1)
      {
        /* Transition: '<S9>:108' */
        /* Transition: '<S9>:112' */
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle2;

        /* Entry 'Idle2': '<S9>:96' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
        RSD_curExtrema = UnitDelay1_DSTATE_i;
      }
      else if (accFiltNorm > UnitDelay_DSTATE_k + 25.0F)
      {
        /* Transition: '<S9>:68' */
        RSD_curExtrema = accFiltNorm;
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Rising;

        /* Entry 'Rising': '<S9>:69' */
      }
      else
      {
        if (accFiltNorm < UnitDelay_DSTATE_k - 25.0F)
        {
          /* Transition: '<S9>:71' */
          RSD_curExtrema = accFiltNorm;
          is_CheckForAccNormMax = CalibrationMotorbike_IN_Falling;

          /* Entry 'Falling': '<S9>:70' */
        }
      }
      break;

     case CalibrationMotorbike_IN_Idle2:
      /* During 'Idle2': '<S9>:96' */
      if (UnitDelay1_DSTATE_i > RSD_curExtrema)
      {
        /* Transition: '<S9>:101' */
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle2;

        /* Entry 'Idle2': '<S9>:96' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
        RSD_curExtrema = UnitDelay1_DSTATE_i;
      }
      else
      {
        if (UnitDelay1_DSTATE_i < RSD_curExtrema - 35.0F)
        {
          /* Transition: '<S9>:98' */
          is_CheckForAccNormMax = CalibrationMotorbik_IN_Falling1;

          /* Entry 'Falling1': '<S9>:97' */
        }
      }
      break;

     case CalibrationMotorbike_IN_Rising:
      /* During 'Rising': '<S9>:69' */
      if (accFiltNorm > RSD_curExtrema)
      {
        /* Transition: '<S9>:74' */
        RSD_curExtrema = accFiltNorm;
        RSD_accSfXExtrema = (real32_T)COCA_rtb_Divide;
        RSD_accSfYExtrema = (real32_T)COCA_rtb_Divide_p;
        RSD_accSfZExtrema = (real32_T)COCA_rtb_Divide_a;
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Rising;

        /* Entry 'Rising': '<S9>:69' */
      }
      else if (accFiltNorm < RSD_curExtrema - 4.0F)
      {
        /* Transition: '<S9>:75' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 1U;
        is_CheckForAccNormMax = CalibrationMotorb_IN_waitState1;
      }
      else
      {
        if ((int32_T)UnitDelay2_DSTATE_n >= 1)
        {
          /* Transition: '<S9>:111' */
          /* Transition: '<S9>:112' */
          is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle2;

          /* Entry 'Idle2': '<S9>:96' */
          CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
          RSD_curExtrema = UnitDelay1_DSTATE_i;
        }
      }
      break;

     case CalibrationMotorbi_IN_waitState:
      /* During 'waitState': '<S9>:78' */
      if ((int32_T)CalibrationMotorbike_DWork.RSD_constantRiding == 1)
      {
        /* Transition: '<S9>:80' */
        is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle_ds;

        /* Entry 'Idle': '<S9>:65' */
        CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
      }
      break;

     case CalibrationMotorb_IN_waitState1:
      /* During 'waitState1': '<S9>:85' */
      /* Transition: '<S9>:86' */
      is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle_ds;

      /* Entry 'Idle': '<S9>:65' */
      CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
      break;

     case CalibrationMotorb_IN_waitState2:
      /* During 'waitState2': '<S9>:87' */
      /* Transition: '<S9>:88' */
      is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle_ds;

      /* Entry 'Idle': '<S9>:65' */
      CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
      break;

     default:
      /* During 'waitState3': '<S9>:106' */
      /* Transition: '<S9>:107' */
      is_CheckForAccNormMax = CalibrationMotorbike_IN_Idle2;

      /* Entry 'Idle2': '<S9>:96' */
      CalibrationMotorbike_DWork.RSD_accNormExtremaFlag = 0U;
      RSD_curExtrema = UnitDelay1_DSTATE_i;
      break;
    }

    /* During 'CheckForAccelerationPhase': '<S9>:117' */
    switch (is_CheckForAccelerationPhase)
    {
     case CalibrationMot_IN_BadSensorData:
      /* During 'BadSensorData': '<S9>:178' */
      if (((uint32_T)temporalCounter_i3 >= 100U) && (accFiltNorm > 400.0F) &&
          (accFiltNorm < 1500.0F))
      {
        /* Transition: '<S9>:180' */
        is_CheckForAccelerationPhase = CalibrationMotorbi_IN_waitState;
        temporalCounter_i3 = 0U;
      }
      break;

     case CalibrationMotorbike_IN_Idle_d:
      /* During 'Idle': '<S9>:126' */
      if ((accFiltNorm < 400.0F) || (accFiltNorm > 1500.0F))
      {
        /* Transition: '<S9>:179' */
        is_CheckForAccelerationPhase = CalibrationMot_IN_BadSensorData;
        temporalCounter_i3 = 0U;
      }
      else
      {
        if (Diff > 5.0F)
        {
          /* Transition: '<S9>:121' */
          is_CheckForAccelerationPhase = CalibrationMotor_IN_WaitState_n;

          /* Entry 'WaitState': '<S9>:127' */
          RSD_accelerationFlag = 0U;
        }
      }
      break;

     case Calibration_IN_RidingConstant_m:
      /* During 'RidingConstant': '<S9>:125' */
      /* Transition: '<S9>:118' */
      is_CheckForAccelerationPhase = CalibrationMotorb_IN_waitState1;
      temporalCounter_i3 = 0U;

      /* Entry 'waitState1': '<S9>:188' */
      RSD_accelerationFlag = 0U;
      break;

     case CalibrationM_IN_RidingConstant1:
      /* During 'RidingConstant1': '<S9>:128' */
      /* Transition: '<S9>:124' */
      is_CheckForAccelerationPhase = CalibrationMotorb_IN_waitState1;
      temporalCounter_i3 = 0U;

      /* Entry 'waitState1': '<S9>:188' */
      RSD_accelerationFlag = 0U;
      break;

     case CalibrationMotor_IN_WaitState_n:
      /* During 'WaitState': '<S9>:127' */
      if ((int32_T)RSD_accExtremaFlag == 2)
      {
        /* Transition: '<S9>:123' */
        is_CheckForAccelerationPhase = CalibrationM_IN_RidingConstant1;

        /* Entry 'RidingConstant1': '<S9>:128' */
        RSD_accelerationFlag = 2U;
      }
      else if ((Diff <= 1.0F) || (gyrXIntegral_deg >=
                MOCA_par.maxAngleChange_deg))
      {
        /* Transition: '<S9>:122' */
        is_CheckForAccelerationPhase = CalibrationMotorbike_IN_Idle_d;

        /* Entry 'Idle': '<S9>:126' */
        RSD_accelerationFlag = 0U;
      }
      else
      {
        if ((int32_T)CalibrationMotorbike_DWork.RSD_accNormExtremaFlag == 1)
        {
          /* Transition: '<S9>:120' */
          is_CheckForAccelerationPhase = Calibration_IN_RidingConstant_m;

          /* Entry 'RidingConstant': '<S9>:125' */
          RSD_accelerationFlag = 1U;
        }
      }
      break;

     case CalibrationMotorbi_IN_waitState:
      /* During 'waitState': '<S9>:191' */
      if ((uint32_T)temporalCounter_i3 >= 1000U)
      {
        /* Transition: '<S9>:190' */
        is_CheckForAccelerationPhase = CalibrationMotorbike_IN_Idle_d;

        /* Entry 'Idle': '<S9>:126' */
        RSD_accelerationFlag = 0U;
      }
      break;

     default:
      /* During 'waitState1': '<S9>:188' */
      if ((uint32_T)temporalCounter_i3 >= 1000U)
      {
        /* Transition: '<S9>:189' */
        is_CheckForAccelerationPhase = CalibrationMotorbike_IN_Idle_d;

        /* Entry 'Idle': '<S9>:126' */
        RSD_accelerationFlag = 0U;
      }
      break;
    }

    /* During 'CheckForAccNormMaxAccelerationPhase': '<S9>:130' */
    switch (is_CheckForAccNormMaxAccelerati)
    {
     case CalibrationMotorb_IN_Falling1_b:
      /* During 'Falling1': '<S9>:159' */
      if (UnitDelay1_DSTATE_i < RSD_curAccExtrema - 15.0F)
      {
        /* Transition: '<S9>:149' */
        RSD_accExtremaFlag = 2U;
        is_CheckForAccNormMaxAccelerati = CalibrationMoto_IN_waitState3_m;
      }
      else
      {
        if (UnitDelay1_DSTATE_i > RSD_curAccExtrema)
        {
          /* Transition: '<S9>:150' */
          RSD_curAccExtrema = UnitDelay1_DSTATE_i;
          RSD_accSfXExtrema = (real32_T)COCA_rtb_Divide;
          RSD_accSfYExtrema = (real32_T)COCA_rtb_Divide_p;
          RSD_accSfZExtrema = (real32_T)COCA_rtb_Divide_a;
          is_CheckForAccNormMaxAccelerati = CalibrationMotorb_IN_Falling1_b;

          /* Entry 'Falling1': '<S9>:159' */
        }
      }
      break;

     case CalibrationMotorbike_IN_Idle_d:
      /* During 'Idle': '<S9>:152' */
      if ((int32_T)UnitDelay2_DSTATE_n >= 1)
      {
        /* Transition: '<S9>:138' */
        is_CheckForAccNormMaxAccelerati = CalibrationMotorbike_IN_Idle2_g;

        /* Entry 'Idle2': '<S9>:157' */
        RSD_accExtremaFlag = 0U;
        RSD_curAccExtrema = UnitDelay1_DSTATE_i;
      }
      break;

     case CalibrationMotorbike_IN_Idle2_g:
      /* During 'Idle2': '<S9>:157' */
      if (UnitDelay1_DSTATE_i < RSD_curAccExtrema)
      {
        /* Transition: '<S9>:147' */
        is_CheckForAccNormMaxAccelerati = CalibrationMotorbike_IN_Idle2_g;

        /* Entry 'Idle2': '<S9>:157' */
        RSD_accExtremaFlag = 0U;
        RSD_curAccExtrema = UnitDelay1_DSTATE_i;
      }
      else
      {
        if (UnitDelay1_DSTATE_i > RSD_curAccExtrema + 35.0F)
        {
          /* Transition: '<S9>:146' */
          is_CheckForAccNormMaxAccelerati = CalibrationMotorb_IN_Falling1_b;

          /* Entry 'Falling1': '<S9>:159' */
        }
      }
      break;

     case CalibrationMotor_IN_waitState_k:
      /* During 'waitState': '<S9>:151' */
      if ((int32_T)CalibrationMotorbike_DWork.RSD_constantRiding == 1)
      {
        /* Transition: '<S9>:133' */
        is_CheckForAccNormMaxAccelerati = CalibrationMotorbike_IN_Idle_d;

        /* Entry 'Idle': '<S9>:152' */
        RSD_accExtremaFlag = 0U;
      }
      break;

     default:
      /* During 'waitState3': '<S9>:158' */
      /* Transition: '<S9>:148' */
      is_CheckForAccNormMaxAccelerati = CalibrationMotorbike_IN_Idle2_g;

      /* Entry 'Idle2': '<S9>:157' */
      RSD_accExtremaFlag = 0U;
      RSD_curAccExtrema = UnitDelay1_DSTATE_i;
      break;
    }
  }

  /* MATLAB Function: '<Root>/MATLAB Function' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion11'
   *  DataTypeConversion: '<Root>/Data Type Conversion5'
   *  DataTypeConversion: '<Root>/Data Type Conversion6'
   *  Inport: '<Root>/initRotMatSf2Bf [3x3]'
   */
  /* MATLAB Function 'MATLAB Function': '<S7>:1' */
  /* '<S7>:1:29' */
  if (!calibFlag_not_empty)
  {
    /* '<S7>:1:13' */
    guard1 = false;
    if ((MOCA_in.initRotMatSf2Bf_3x3[0] + MOCA_in.initRotMatSf2Bf_3x3[4]) +
        MOCA_in.initRotMatSf2Bf_3x3[8] == 3.0F)
    {
      /* '<S7>:1:15' */
      guard1 = true;
    }
    else
    {
      for (i = 0; i < 3; i++)
      {
        xpageoffset = i * 3;
        accSfLongAccVec[i] = MOCA_in.initRotMatSf2Bf_3x3[xpageoffset + 2] +
          (MOCA_in.initRotMatSf2Bf_3x3[xpageoffset + 1] +
           MOCA_in.initRotMatSf2Bf_3x3[xpageoffset]);
      }

      if ((accSfLongAccVec[0] + accSfLongAccVec[1]) + accSfLongAccVec[2] == 0.0F)
      {
        /* '<S7>:1:15' */
        guard1 = true;
      }
      else
      {
        /* '<S7>:1:24' */
        for (i = 0; i < 9; i++)
        {
          CalibrationMotorbike_DWork.rotMatSf2Bf[i] =
            MOCA_in.initRotMatSf2Bf_3x3[i];
        }

        /* '<S7>:1:25' */
        calibFlag = 1U;
        calibFlag_not_empty = true;

        /* '<S7>:1:26' */
        firstRidindConstantFlag = 1U;

        /* '<S7>:1:27' */
        firstLongAccFlag = 2U;

        /* '<S7>:1:28' */
        accSFFiltNormRidingConstant = 1000.0F;

        /* '<S7>:1:29' */
        /* '<S7>:1:30' */
        CalibrationMotorbike_DWork.accSfVecRidingConstant[0] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[2] * 1000.0F;
        CalibrationMotorbike_DWork.longAccVecSf[0] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[0];
        CalibrationMotorbike_DWork.accSfVecRidingConstant[1] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[5] * 1000.0F;
        CalibrationMotorbike_DWork.longAccVecSf[1] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[3];
        CalibrationMotorbike_DWork.accSfVecRidingConstant[2] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[8] * 1000.0F;
        CalibrationMotorbike_DWork.longAccVecSf[2] =
          CalibrationMotorbike_DWork.rotMatSf2Bf[6];
      }
    }

    if (guard1)
    {
      /* '<S7>:1:16' */
      for (i = 0; i < 9; i++)
      {
        b_I[i] = 0;
      }

      b_I[0] = 1;
      b_I[4] = 1;
      b_I[8] = 1;
      for (i = 0; i < 9; i++)
      {
        CalibrationMotorbike_DWork.rotMatSf2Bf[i] = (real32_T)b_I[i];
      }

      /* '<S7>:1:17' */
      calibFlag = 0U;
      calibFlag_not_empty = true;

      /* '<S7>:1:18' */
      firstRidindConstantFlag = 0U;

      /* '<S7>:1:19' */
      firstLongAccFlag = 0U;

      /* '<S7>:1:20' */
      accSFFiltNormRidingConstant = 1000.0F;

      /* '<S7>:1:21' */
      /* '<S7>:1:22' */
      CalibrationMotorbike_DWork.accSfVecRidingConstant[0] = 0.0F;
      CalibrationMotorbike_DWork.longAccVecSf[0] = 0.0F;
      CalibrationMotorbike_DWork.accSfVecRidingConstant[1] = 0.0F;
      CalibrationMotorbike_DWork.longAccVecSf[1] = 0.0F;
      CalibrationMotorbike_DWork.accSfVecRidingConstant[2] = 0.0F;
      CalibrationMotorbike_DWork.longAccVecSf[2] = 0.0F;
    }
  }

  if (((int32_T)CalibrationMotorbike_DWork.RSD_constantRiding == 1) && ((int32_T)
       firstRidindConstantFlag == 0))
  {
    /* '<S7>:1:35' */
    /* '<S7>:1:36' */
    accSFFiltNormRidingConstant = accFiltNorm;

    /* '<S7>:1:37' */
    firstRidindConstantFlag = 1U;

    /* '<S7>:1:38' */
    CalibrationMotorbike_DWork.accSfVecRidingConstant[0] = (real32_T)
      COCA_rtb_Divide;
    CalibrationMotorbike_DWork.accSfVecRidingConstant[1] = (real32_T)
      COCA_rtb_Divide_p;
    CalibrationMotorbike_DWork.accSfVecRidingConstant[2] = (real32_T)
      COCA_rtb_Divide_a;
  }
  else
  {
    if (((int32_T)CalibrationMotorbike_DWork.RSD_constantRiding == 1) &&
        ((int32_T)firstRidindConstantFlag == 1))
    {
      /* '<S7>:1:39' */
      /* '<S7>:1:40' */
      accSFFiltNormRidingConstant = 0.9F * accSFFiltNormRidingConstant + 0.1F *
        accFiltNorm;

      /* '<S7>:1:41' */
      CalibrationMotorbike_DWork.accSfVecRidingConstant[0] = 0.9F *
        CalibrationMotorbike_DWork.accSfVecRidingConstant[0] + 0.1F * (real32_T)
        COCA_rtb_Divide;
      CalibrationMotorbike_DWork.accSfVecRidingConstant[1] = 0.9F *
        CalibrationMotorbike_DWork.accSfVecRidingConstant[1] + 0.1F * (real32_T)
        COCA_rtb_Divide_p;
      CalibrationMotorbike_DWork.accSfVecRidingConstant[2] = 0.9F *
        CalibrationMotorbike_DWork.accSfVecRidingConstant[2] + 0.1F * (real32_T)
        COCA_rtb_Divide_a;
    }
  }

  /* '<S7>:1:44' */
  accSfLongAccVec[0] = CalibrationMotorbike_DWork.accSfVecRidingConstant[0] -
    RSD_accSfXExtrema;
  accSfLongAccVec[1] = CalibrationMotorbike_DWork.accSfVecRidingConstant[1] -
    RSD_accSfYExtrema;
  accSfLongAccVec[2] = CalibrationMotorbike_DWork.accSfVecRidingConstant[2] -
    RSD_accSfZExtrema;

  /* '<S7>:1:45' */
  Diff = CalibrationMotorbike_norm(accSfLongAccVec);

  /* '<S7>:1:46' */
  accSfLongAccVec_0 = accSfLongAccVec[0];
  accSfLongAccVec_0 /= Diff;
  accSfLongAccVec[0] = accSfLongAccVec_0;
  accSfLongAccVec_0 = accSfLongAccVec[1];
  accSfLongAccVec_0 /= Diff;
  accSfLongAccVec[1] = accSfLongAccVec_0;
  accSfLongAccVec_0 = accSfLongAccVec[2];
  accSfLongAccVec_0 /= Diff;

  /* DataTypeConversion: '<Root>/Data Type Conversion27' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  /* '<S7>:1:49' */
  /* '<S7>:1:50' */
  /* '<S7>:1:92' */
  rotMatUpdate = 0;

  /* MATLAB Function: '<Root>/MATLAB Function' incorporates:
   *  Constant: '<Root>/Constant4'
   *  Constant: '<Root>/Constant5'
   *  DataTypeConversion: '<Root>/Data Type Conversion7'
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  DataTypeConversion: '<Root>/Data Type Conversion9'
   *  Inport: '<Root>/accSfX [mg]'
   *  Inport: '<Root>/accSfY [mg]'
   *  Inport: '<Root>/accSfZ [mg]'
   *  Inport: '<Root>/gyrSfX [mdeg//s]'
   *  Inport: '<Root>/gyrSfY [mdeg//s]'
   *  Inport: '<Root>/gyrSfZ [mdeg//s]'
   */
  /* '<S7>:1:93' */
  if ((((int32_T)CalibrationMotorbike_DWork.RSD_decelerationFlag >= 1) ||
       ((int32_T)RSD_accelerationFlag >= 1)) && (Diff >=
       MOCA_par.minLongAccNorm_mg) && (Diff <= MOCA_par.maxLongAccNorm_mg))
  {
    /* '<S7>:1:95' */
    /* '<S7>:1:96' */
    if ((int32_T)CalibrationMotorbike_DWork.RSD_decelerationFlag >= 1)
    {
      /* '<S7>:1:97' */
      /* '<S7>:1:98' */
      longAccVecSfTmp[0] = accSfLongAccVec[0];
      longAccVecSfTmp[1] = accSfLongAccVec[1];
      longAccVecSfTmp[2] = accSfLongAccVec_0;
    }
    else
    {
      /* '<S7>:1:100' */
      longAccVecSfTmp[0] = -accSfLongAccVec[0];
      longAccVecSfTmp[1] = -accSfLongAccVec[1];
      longAccVecSfTmp[2] = -accSfLongAccVec_0;
    }

    /* '<S7>:1:104' */
    accSfLongAccVec_1 = accSfLongAccVec[0];
    accFiltNorm = -accSfLongAccVec_1;
    gyrXIntegral_deg = -accSfLongAccVec_1 *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[0];
    accSfLongAccVec_1 = accSfLongAccVec[1];
    gyrYIntegral_deg = -accSfLongAccVec_1;
    gyrXIntegral_deg += -accSfLongAccVec_1 *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[1];
    accSfLongAccVec_1 = accSfLongAccVec_0;
    gyrXIntegral_deg += -accSfLongAccVec_1 *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[2];
    a[0] = gyrYIntegral_deg * CalibrationMotorbike_DWork.accSfVecRidingConstant
      [2] - -accSfLongAccVec_1 *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[1];
    a[1] = -accSfLongAccVec_1 *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[0] - accFiltNorm *
      CalibrationMotorbike_DWork.accSfVecRidingConstant[2];
    a[2] = accFiltNorm * CalibrationMotorbike_DWork.accSfVecRidingConstant[1] -
      gyrYIntegral_deg * CalibrationMotorbike_DWork.accSfVecRidingConstant[0];
    accFiltNorm = 57.2957802F * atan2f(CalibrationMotorbike_norm(a),
      gyrXIntegral_deg);
    if (((int32_T)firstLongAccFlag == 0) && (fabsf(accFiltNorm - 90.0F) < 25.0F))
    {
      /* '<S7>:1:109' */
      /* '<S7>:1:110' */
      CalibrationMotorbike_DWork.longAccVecSf[0] = longAccVecSfTmp[0];
      CalibrationMotorbike_DWork.longAccVecSf[1] = longAccVecSfTmp[1];
      CalibrationMotorbike_DWork.longAccVecSf[2] = longAccVecSfTmp[2];

      /* '<S7>:1:111' */
      firstLongAccFlag = 1U;

      /* DataTypeConversion: '<Root>/Data Type Conversion27' */
      /* '<S7>:1:112' */
      rotMatUpdate = 1;
    }
    else if (((int32_T)firstLongAccFlag == 1) && (fabsf(accFiltNorm - 90.0F) <
              12.0F))
    {
      /* '<S7>:1:113' */
      /* '<S7>:1:114' */
      CalibrationMotorbike_DWork.longAccVecSf[0] = longAccVecSfTmp[0];
      CalibrationMotorbike_DWork.longAccVecSf[1] = longAccVecSfTmp[1];
      CalibrationMotorbike_DWork.longAccVecSf[2] = longAccVecSfTmp[2];

      /* '<S7>:1:115' */
      firstLongAccFlag = 2U;

      /* '<S7>:1:116' */
      calibFlag = 1U;

      /* DataTypeConversion: '<Root>/Data Type Conversion27' */
      /* '<S7>:1:117' */
      rotMatUpdate = 1;
    }
    else
    {
      if (((int32_T)firstLongAccFlag == 2) && (fabsf(accFiltNorm - 90.0F) <
           12.0F))
      {
        /* '<S7>:1:118' */
        /* '<S7>:1:120' */
        Diff = (Diff - 100.0F) * 0.1F / 150.0F + 0.05F;
        if ((real_T)Diff > 0.15)
        {
          /* '<S7>:1:121' */
          /* '<S7>:1:122' */
          Diff = 0.15F;
        }

        /* '<S7>:1:124' */
        CalibrationMotorbike_DWork.longAccVecSf[0] = (1.0F - Diff) *
          CalibrationMotorbike_DWork.longAccVecSf[0] + Diff * longAccVecSfTmp[0];
        CalibrationMotorbike_DWork.longAccVecSf[1] = (1.0F - Diff) *
          CalibrationMotorbike_DWork.longAccVecSf[1] + Diff * longAccVecSfTmp[1];
        CalibrationMotorbike_DWork.longAccVecSf[2] = (1.0F - Diff) *
          CalibrationMotorbike_DWork.longAccVecSf[2] + Diff * longAccVecSfTmp[2];

        /* DataTypeConversion: '<Root>/Data Type Conversion27' */
        /* '<S7>:1:125' */
        rotMatUpdate = 1;
      }
    }

    /* '<S7>:1:129' */
    /* '<S7>:1:131' */
    Diff = CalibrationMotorbike_norm
      (CalibrationMotorbike_DWork.accSfVecRidingConstant);

    /* '<S7>:1:132' */
    /* '<S7>:1:135' */
    accFiltNorm = CalibrationMotorbike_DWork.accSfVecRidingConstant[0] / Diff;
    CalibrationMotorbike_DWork.rotMatSf2Bf[0] =
      CalibrationMotorbike_DWork.longAccVecSf[0];
    CalibrationMotorbike_DWork.rotMatSf2Bf[2] = accFiltNorm;
    accSfLongAccVec[0] = accFiltNorm;
    accFiltNorm = CalibrationMotorbike_DWork.accSfVecRidingConstant[1] / Diff;
    CalibrationMotorbike_DWork.rotMatSf2Bf[3] =
      CalibrationMotorbike_DWork.longAccVecSf[1];
    CalibrationMotorbike_DWork.rotMatSf2Bf[5] = accFiltNorm;
    accSfLongAccVec[1] = accFiltNorm;
    accFiltNorm = CalibrationMotorbike_DWork.accSfVecRidingConstant[2] / Diff;
    CalibrationMotorbike_DWork.rotMatSf2Bf[6] =
      CalibrationMotorbike_DWork.longAccVecSf[2];
    CalibrationMotorbike_DWork.rotMatSf2Bf[8] = accFiltNorm;
    CalibrationMotorbike_DWork.rotMatSf2Bf[1] = accSfLongAccVec[1] *
      CalibrationMotorbike_DWork.longAccVecSf[2] - accFiltNorm *
      CalibrationMotorbike_DWork.longAccVecSf[1];
    CalibrationMotorbike_DWork.rotMatSf2Bf[4] = accFiltNorm *
      CalibrationMotorbike_DWork.longAccVecSf[0] - accSfLongAccVec[0] *
      CalibrationMotorbike_DWork.longAccVecSf[2];
    CalibrationMotorbike_DWork.rotMatSf2Bf[7] = accSfLongAccVec[0] *
      CalibrationMotorbike_DWork.longAccVecSf[1] - accSfLongAccVec[1] *
      CalibrationMotorbike_DWork.longAccVecSf[0];
  }

  /* '<S7>:1:140' */
  for (i = 0; i < 9; i++)
  {
    rotMatSf2BfOut_3x3 = CalibrationMotorbike_DWork.rotMatSf2Bf[i] * 1.0E+6F;
    rotMatSf2BfOut_3x3 = truncf(rotMatSf2BfOut_3x3);
    rotMatSf2BfOut_3x3 *= 1.0E-6F;
    MOCA_out.rotMatSf2BfOut_3x3[i] = rotMatSf2BfOut_3x3;
  }

  /* '<S7>:1:144' */
  /* '<S7>:1:145' */
  for (i = 0; i < 3; i++)
  {
    rotMatSf2BfOut_3x3_0 = MOCA_out.rotMatSf2BfOut_3x3[i];
    accSfLongAccVec_2 = rotMatSf2BfOut_3x3_0 * (real32_T)ACC_getAccSfXmg();
    longAccVecSfTmp_0 = rotMatSf2BfOut_3x3_0 * (real32_T)GYR_getGyrSfXmdegs();
    rotMatSf2BfOut_3x3_0 = MOCA_out.rotMatSf2BfOut_3x3[i + 3];
    accSfLongAccVec_2 += rotMatSf2BfOut_3x3_0 * (real32_T)ACC_getAccSfYmg();
    longAccVecSfTmp_0 += rotMatSf2BfOut_3x3_0 * (real32_T)GYR_getGyrSfYmdegs();
    rotMatSf2BfOut_3x3_0 = MOCA_out.rotMatSf2BfOut_3x3[i + 6];
    accSfLongAccVec_2 += rotMatSf2BfOut_3x3_0 * (real32_T)ACC_getAccSfZmg();
    longAccVecSfTmp_0 += rotMatSf2BfOut_3x3_0 * (real32_T)GYR_getGyrSfZmdegs();
    accSfLongAccVec[i] = accSfLongAccVec_2;
    longAccVecSfTmp[i] = longAccVecSfTmp_0;
  }

  /* DataTypeConversion: '<Root>/Data Type Conversion10' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  /* '<S7>:1:147' */
  /* '<S7>:1:148' */
  /* '<S7>:1:149' */
  /* '<S7>:1:150' */
  /* '<S7>:1:152' */
  /* '<S7>:1:154' */
  /* '<S7>:1:156' */
  /* '<S7>:1:158' */
  /* '<S7>:1:159' */
  /* '<S7>:1:160' */
  /* '<S7>:1:162' */
  /* '<S7>:1:163' */
  /* '<S7>:1:164' */
  COCA_accBfXmg = (int16_T)accSfLongAccVec[0];

  /* DataTypeConversion: '<Root>/Data Type Conversion13' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  COCA_accBfYmg = (int16_T)accSfLongAccVec[1];

  /* DataTypeConversion: '<Root>/Data Type Conversion15' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  COCA_accBfZmg = (int16_T)accSfLongAccVec[2];

  /* DataTypeConversion: '<Root>/Data Type Conversion16' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  COCA_gyrBfXmdegs = (int32_T)longAccVecSfTmp[0];

  /* DataTypeConversion: '<Root>/Data Type Conversion17' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  COCA_gyrBfYmdegs = (int32_T)longAccVecSfTmp[1];

  /* DataTypeConversion: '<Root>/Data Type Conversion18' incorporates:
   *  MATLAB Function: '<Root>/MATLAB Function'
   */
  COCA_gyrBfZmdegs = (int32_T)longAccVecSfTmp[2];

  /* DataTypeConversion: '<Root>/Data Type Conversion19' */
  COCA_calibrationFlag = (int16_T)calibFlag;

  /* DataTypeConversion: '<Root>/Data Type Conversion12' incorporates:
   *  Inport: '<Root>/pressure [Pa] '
   */
  pressure_Pa = (real32_T)ENV_getPressurePa();

  /* Saturate: '<Root>/Saturation1' */
  if (pressure_Pa > 120000.0F)
  {
    Diff = 120000.0F;
  }
  else if (pressure_Pa < 80000.0F)
  {
    Diff = 80000.0F;
  }
  else
  {
    Diff = pressure_Pa;
  }

  /* End of Saturate: '<Root>/Saturation1' */

  /* Product: '<S4>/Product4' */
  COCA_rtb_Product4 = COCA_rtb_Divide_h * COCA_rtb_Divide_h;

  /* Sum: '<S4>/Add6' incorporates:
   *  Constant: '<Root>/Constant'
   */
  UnitDelay2_DSTATE += MOCA_par.samplePeriod_s;

  /* RelationalOperator: '<S15>/Compare' incorporates:
   *  Constant: '<S15>/Constant'
   */
  COCA_rtb_Compare = (UnitDelay2_DSTATE >= 3.0F);

  /* Sum: '<S11>/Sum' incorporates:
   *  Gain: '<S11>/Gain'
   *  Sum: '<S11>/Diff'
   */
  UD_DSTATE_e = (UD_DSTATE_e - Diff) * 0.95F + Diff;

  /* Switch: '<S4>/Switch1' incorporates:
   *  Switch: '<S4>/Switch'
   */
  if (COCA_rtb_Compare)
  {
    COCA_rtb_Switch1 = AtmPressureFilt;
  }
  else
  {
    COCA_rtb_Switch1 = (real_T)UD_DSTATE_e;
    UnitDelay4_DSTATE_e = (real_T)UD_DSTATE_e;
  }

  /* End of Switch: '<S4>/Switch1' */

  /* Product: '<S4>/Product8' incorporates:
   *  Gain: '<S4>/Gain1'
   */
  COCA_rtb_Product8 = 1.4142135623730951 * COCA_rtb_Divide_h *
    0.31415926535897931;

  /* Product: '<S4>/Divide' incorporates:
   *  Gain: '<S4>/Gain2'
   *  Gain: '<S4>/Gain3'
   *  Product: '<S4>/Product1'
   *  Product: '<S4>/Product2'
   *  Product: '<S4>/Product3'
   *  Product: '<S4>/Product4'
   *  Product: '<S4>/Product7'
   *  Product: '<S4>/Product9'
   *  Sum: '<S4>/Add'
   *  Sum: '<S4>/Add1'
   *  Sum: '<S4>/Add2'
   *  Sum: '<S4>/Add3'
   *  Sum: '<S4>/Add4'
   *  Sum: '<S4>/Add5'
   *  UnitDelay: '<S4>/Unit Delay1'
   */
  AtmPressureFilt = ((((real_T)(real32_T)(2.0F * UnitDelay_DSTATE_e) *
                       0.098696044010893574 + 0.098696044010893574 * (real_T)
                       Diff) + 0.098696044010893574 * (real_T)
                      CalibrationMotorbike_DWork.UnitDelay1_DSTATE_h) - ((-2.0 *
    COCA_rtb_Product4 + 0.19739208802178715) * COCA_rtb_Switch1 +
    ((COCA_rtb_Product4 - COCA_rtb_Product8) + 0.098696044010893574) *
    UnitDelay4_DSTATE_e)) / ((COCA_rtb_Product4 + COCA_rtb_Product8) +
    0.098696044010893574);

  /* Product: '<S5>/Product4' */
  COCA_rtb_Product4 = COCA_rtb_Divide_h * COCA_rtb_Divide_h;

  /* Product: '<S5>/Product8' incorporates:
   *  Gain: '<S5>/Gain1'
   */
  COCA_rtb_Product8 = 1.4142135623730951 * COCA_rtb_Divide_h *
    1.5707963267948966;

  /* Product: '<S5>/Divide' incorporates:
   *  Gain: '<S5>/Gain2'
   *  Gain: '<S5>/Gain3'
   *  MATLAB Function: '<Root>/MATLAB Function'
   *  Product: '<S5>/Product1'
   *  Product: '<S5>/Product2'
   *  Product: '<S5>/Product3'
   *  Product: '<S5>/Product4'
   *  Product: '<S5>/Product7'
   *  Product: '<S5>/Product8'
   *  Product: '<S5>/Product9'
   *  Sum: '<S5>/Add'
   *  Sum: '<S5>/Add1'
   *  Sum: '<S5>/Add2'
   *  Sum: '<S5>/Add3'
   *  Sum: '<S5>/Add4'
   *  Sum: '<S5>/Add5'
   *  UnitDelay: '<S5>/Unit Delay1'
   *  UnitDelay: '<S5>/Unit Delay4'
   */
  COCA_rtb_Divide_h = ((((real_T)(real32_T)(2.0F * UnitDelay_DSTATE_c) *
    2.4674011002723395 + 2.4674011002723395 * (real_T)accSfLongAccVec[0]) +
                        2.4674011002723395 * (real_T)
                        CalibrationMotorbike_DWork.UnitDelay1_DSTATE_a) - ((-2.0
    * COCA_rtb_Product4 + 4.934802200544679) * UnitDelay3_DSTATE_h +
    ((COCA_rtb_Product4 - COCA_rtb_Product8) + 2.4674011002723395) *
    CalibrationMotorbike_DWork.UnitDelay4_DSTATE_nq)) / ((COCA_rtb_Product4 +
    COCA_rtb_Product8) + 2.4674011002723395);

  /* Sum: '<S12>/Sum' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion4'
   *  Gain: '<S12>/Gain'
   *  Sum: '<S12>/Diff'
   */
  speedKmh_filt = (speedKmh_filt - SE_asinArg) * 0.995F + SE_asinArg;

  /* Chart: '<Root>/SlopeEstimation' incorporates:
   *  Constant: '<Root>/Constant'
   */
  if ((uint32_T)temporalCounter_i1_i < 255U)
  {
    temporalCounter_i1_i = (uint8_T)((uint32_T)temporalCounter_i1_i + 1U);
  }

  if ((uint32_T)temporalCounter_i2_l < 255U)
  {
    temporalCounter_i2_l = (uint8_T)((uint32_T)temporalCounter_i2_l + 1U);
  }

  /* Gateway: SlopeEstimation */
  /* During: SlopeEstimation */
  if ((uint32_T)CalibrationMotorbike_DWork.is_active_c1_CalibrationMotorbi == 0U)
  {
    /* Entry: SlopeEstimation */
    CalibrationMotorbike_DWork.is_active_c1_CalibrationMotorbi = 1U;

    /* Entry Internal: SlopeEstimation */
    /* Entry Internal 'Slope1': '<S10>:24' */
    /* Transition: '<S10>:5' */
    is_Slope1 = CalibrationMotorbi_IN_NotRiding;

    /* Entry 'NotRiding': '<S10>:4' */
    /* Entry Internal 'Slope2': '<S10>:25' */
    /* Transition: '<S10>:26' */
    curSlopePressure = 0.0F;
    SE_2EstFlag = 0.0F;
    is_Slope2 = CalibrationMotorbi_IN_NotRiding;

    /* Entry 'NotRiding': '<S10>:33' */
  }
  else
  {
    /* During 'Slope1': '<S10>:24' */
    switch (is_Slope1)
    {
     case CalibrationMotorbi_IN_NotRiding:
      /* During 'NotRiding': '<S10>:4' */
      if (speedKmh_filt >= 3.0F)
      {
        /* Transition: '<S10>:1' */
        is_Slope1 = CalibrationMotorbike_IN_Riding;

        /* Entry 'Riding': '<S10>:3' */
        SE_2EstFlag = 0.0F;
        SE_initPressure = AtmPressureFilt;
        SE_curDistanceM = speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
      }
      break;

     case CalibrationMotorbike_IN_Riding:
      /* During 'Riding': '<S10>:3' */
      if (speedKmh_filt < 3.0F)
      {
        /* Transition: '<S10>:2' */
        is_Slope1 = CalibrationMotorbi_IN_NotRiding;

        /* Entry 'NotRiding': '<S10>:4' */
        SE_2EstFlag = 0.0F;
      }
      else
      {
        /* Transition: '<S10>:14' */
        is_Slope1 = Calibration_IN_SpeedIntegration;
        temporalCounter_i1_i = 0U;

        /* Entry 'SpeedIntegration': '<S10>:12' */
        SE_curDistanceM += speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
        SE_timer = MOCA_par.samplePeriod_s;
      }
      break;

     case CalibrationMotorbike_IN_Riding1:
      /* During 'Riding1': '<S10>:13' */
      /* Transition: '<S10>:21' */
      is_Slope1 = CalibrationMotorbike_IN_Riding;

      /* Entry 'Riding': '<S10>:3' */
      SE_2EstFlag = 0.0F;
      SE_initPressure = AtmPressureFilt;
      SE_curDistanceM = speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
      break;

     default:
      /* During 'SpeedIntegration': '<S10>:12' */
      if ((uint32_T)temporalCounter_i1_i >= 200U)
      {
        /* Transition: '<S10>:20' */
        is_Slope1 = CalibrationMotorbike_IN_Riding1;

        /* Entry 'Riding1': '<S10>:13' */
        SE_asinArg = (real32_T)(real_T)(log(AtmPressureFilt / SE_initPressure) *
          8434.7) / SE_curDistanceM;
        if (SE_asinArg > 1.0F)
        {
          SE_asinArg = 1.0F;
        }
        else
        {
          if (SE_asinArg < -1.0F)
          {
            SE_asinArg = -1.0F;
          }
        }

        curSlopePressure = 57.2957802F * asinf(SE_asinArg);
      }
      else if (speedKmh_filt < 3.0F)
      {
        /* Transition: '<S10>:22' */
        is_Slope1 = CalibrationMotorbi_IN_NotRiding;

        /* Entry 'NotRiding': '<S10>:4' */
        SE_2EstFlag = 0.0F;
      }
      else
      {
        SE_curDistanceM += speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
        SE_timer += MOCA_par.samplePeriod_s;
        if (SE_timer >= 1.0F)
        {
          SE_2EstFlag = 1.0F;
        }
      }
      break;
    }

    /* During 'Slope2': '<S10>:25' */
    switch (is_Slope2)
    {
     case CalibrationMotorbi_IN_NotRiding:
      /* During 'NotRiding': '<S10>:33' */
      if ((speedKmh_filt >= 3.0F) && (SE_2EstFlag == 1.0F))
      {
        /* Transition: '<S10>:29' */
        is_Slope2 = CalibrationMotorbike_IN_Riding;

        /* Entry 'Riding': '<S10>:34' */
        CalibrationMotorbike_DWork.SE_initPressure2 = AtmPressureFilt;
        SE_curDistance2M = speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
        SE_2EstFlag = 0.0F;
      }
      break;

     case CalibrationMotorbike_IN_Riding:
      /* During 'Riding': '<S10>:34' */
      if (speedKmh_filt < 3.0F)
      {
        /* Transition: '<S10>:28' */
        is_Slope2 = CalibrationMotorbi_IN_NotRiding;

        /* Entry 'NotRiding': '<S10>:33' */
      }
      else
      {
        /* Transition: '<S10>:30' */
        is_Slope2 = Calibration_IN_SpeedIntegration;
        temporalCounter_i2_l = 0U;

        /* Entry 'SpeedIntegration': '<S10>:36' */
        SE_curDistance2M += speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
      }
      break;

     case CalibrationMotorbike_IN_Riding1:
      /* During 'Riding1': '<S10>:35' */
      /* Transition: '<S10>:32' */
      is_Slope2 = CalibrationMotorbi_IN_NotRiding;

      /* Entry 'NotRiding': '<S10>:33' */
      break;

     default:
      /* During 'SpeedIntegration': '<S10>:36' */
      if ((uint32_T)temporalCounter_i2_l >= 200U)
      {
        /* Transition: '<S10>:31' */
        is_Slope2 = CalibrationMotorbike_IN_Riding1;

        /* Entry 'Riding1': '<S10>:35' */
        SE_asinArg = (real32_T)(real_T)(log(AtmPressureFilt /
          CalibrationMotorbike_DWork.SE_initPressure2) * 8434.7) /
          SE_curDistance2M;
        if (SE_asinArg > 1.0F)
        {
          SE_asinArg = 1.0F;
        }
        else
        {
          if (SE_asinArg < -1.0F)
          {
            SE_asinArg = -1.0F;
          }
        }

        curSlopePressure = 57.2957802F * asinf(SE_asinArg);
      }
      else if (speedKmh_filt < 3.0F)
      {
        /* Transition: '<S10>:27' */
        is_Slope2 = CalibrationMotorbi_IN_NotRiding;

        /* Entry 'NotRiding': '<S10>:33' */
      }
      else
      {
        SE_curDistance2M += speedKmh_filt / 3.6F * MOCA_par.samplePeriod_s;
      }
      break;
    }
  }

  /* Saturate: '<Root>/Saturation' */
  if (curSlopePressure > 20.0F)
  {
    SE_asinArg = 20.0F;
  }
  else if (curSlopePressure < -20.0F)
  {
    SE_asinArg = -20.0F;
  }
  else
  {
    SE_asinArg = curSlopePressure;
  }

  /* End of Saturate: '<Root>/Saturation' */

  /* Sum: '<S14>/Sum' incorporates:
   *  Gain: '<S14>/Gain'
   *  Sum: '<S14>/Diff'
   *  UnitDelay: '<S14>/UD'
   */
  CalibrationMotorbike_DWork.curSlopePressureFilt =
    (CalibrationMotorbike_DWork.curSlopePressureFilt - SE_asinArg) * 0.99F +
    SE_asinArg;

  /* Update for UnitDelay: '<S1>/Unit Delay1' */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE = UnitDelay_DSTATE;

  /* Update for UnitDelay: '<S1>/Unit Delay4' */
  CalibrationMotorbike_DWork.UnitDelay4_DSTATE = UnitDelay3_DSTATE;

  /* Update for UnitDelay: '<S2>/Unit Delay1' */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE_f = UnitDelay_DSTATE_n;

  /* Update for UnitDelay: '<S2>/Unit Delay4' */
  CalibrationMotorbike_DWork.UnitDelay4_DSTATE_f = UnitDelay3_DSTATE_j;

  /* Update for UnitDelay: '<S3>/Unit Delay1' */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE_p = UnitDelay_DSTATE_nf;

  /* Update for UnitDelay: '<S3>/Unit Delay4' */
  CalibrationMotorbike_DWork.UnitDelay4_DSTATE_n = UnitDelay3_DSTATE_p;

  /* Update for UnitDelay: '<S6>/UD' */
  CalibrationMotorbike_DWork.UD_DSTATE_j = COCA_rtb_TSamp;

  /* Update for UnitDelay: '<S4>/Unit Delay1' */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE_h = UnitDelay_DSTATE_e;

  /* Update for Switch: '<S4>/Switch' incorporates:
   *  UnitDelay: '<S4>/Unit Delay4'
   */
  UnitDelay4_DSTATE_e = COCA_rtb_Switch1;

  /* Update for UnitDelay: '<S5>/Unit Delay1' */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE_a = UnitDelay_DSTATE_c;

  /* Update for UnitDelay: '<S5>/Unit Delay4' */
  CalibrationMotorbike_DWork.UnitDelay4_DSTATE_nq = UnitDelay3_DSTATE_h;

  /* MATLAB Function: '<Root>/MATLAB Function' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion7'
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  DataTypeConversion: '<Root>/Data Type Conversion9'
   *  Inport: '<Root>/gyrSfX [mdeg//s]'
   *  Inport: '<Root>/gyrSfY [mdeg//s]'
   *  Inport: '<Root>/gyrSfZ [mdeg//s]'
   */
  CalibrationMotorbike_DWork.gyrSfZ_mdegs = (real32_T)GYR_getGyrSfZmdegs();
  CalibrationMotorbike_DWork.gyrSfY_mdegs = (real32_T)GYR_getGyrSfYmdegs();
  CalibrationMotorbike_DWork.gyrSfX_mdegs = (real32_T)GYR_getGyrSfXmdegs();
  UnitDelay_DSTATE_c = accSfLongAccVec[0];

  /* Switch: '<S4>/Switch' */
  CalibrationMotorbike_DWork.AtmPressureFiltTransFer = UD_DSTATE_e;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  UnitDelay_DSTATE_e = Diff;

  /* DataTypeConversion: '<Root>/Data Type Conversion1' incorporates:
   *  Inport: '<Root>/accSfZ [mg]'
   */
  UnitDelay_DSTATE_nf = (real32_T)ACC_getAccSfZmg();

  /* DataTypeConversion: '<Root>/Data Type Conversion3' incorporates:
   *  Inport: '<Root>/accSfY [mg]'
   */
  UnitDelay_DSTATE_n = (real32_T)ACC_getAccSfYmg();

  /* DataTypeConversion: '<Root>/Data Type Conversion2' incorporates:
   *  Inport: '<Root>/accSfX [mg]'
   */
  UnitDelay_DSTATE = (real32_T)ACC_getAccSfXmg();

  /* Update for UnitDelay: '<S5>/Unit Delay3' */
  UnitDelay3_DSTATE_h = COCA_rtb_Divide_h;

  /* Update for UnitDelay: '<S3>/Unit Delay3' */
  UnitDelay3_DSTATE_p = COCA_rtb_Divide_a;

  /* Update for UnitDelay: '<S2>/Unit Delay3' */
  UnitDelay3_DSTATE_j = COCA_rtb_Divide_p;

  /* Update for UnitDelay: '<S1>/Unit Delay3' */
  UnitDelay3_DSTATE = COCA_rtb_Divide;
  UnitDelay2_DSTATE_n = firstLongAccFlag;
  UnitDelay_DSTATE_k = accSFFiltNormRidingConstant;

  /* DataTypeConversion: '<Root>/Data Type Conversion14' */
  UnitDelay1_DSTATE_i = (real32_T)COCA_rtb_Divide_h;

  /* Sum: '<S12>/Diff' incorporates:
   *  UnitDelay: '<S12>/UD'
   */
  CalibrationMotorbike_DWork.speedKmh_filt = speedKmh_filt;

  /* Sum: '<S11>/Diff' incorporates:
   *  UnitDelay: '<S11>/UD'
   */
  CalibrationMotorbike_DWork.UD_DSTATE_e = UD_DSTATE_e;

  /* Update for Switch: '<S4>/Switch' incorporates:
   *  UnitDelay: '<S4>/Unit Delay4'
   */
  CalibrationMotorbike_DWork.UnitDelay4_DSTATE_e = UnitDelay4_DSTATE_e;

  /* Chart: '<Root>/SlopeEstimation' */
  CalibrationMotorbike_DWork.AtmPressureFilt = AtmPressureFilt;

  /* DataTypeConversion: '<Root>/Data Type Conversion12' */
  CalibrationMotorbike_DWork.pressure_Pa = pressure_Pa;
  CalibrationMotorbike_DWork.RSD_accSfZExtrema = RSD_accSfZExtrema;
  CalibrationMotorbike_DWork.RSD_accSfYExtrema = RSD_accSfYExtrema;
  CalibrationMotorbike_DWork.RSD_accSfXExtrema = RSD_accSfXExtrema;

  /* UnitDelay: '<S5>/Unit Delay' */
  CalibrationMotorbike_DWork.UnitDelay_DSTATE_c = UnitDelay_DSTATE_c;

  /* UnitDelay: '<S4>/Unit Delay' */
  CalibrationMotorbike_DWork.UnitDelay_DSTATE_e = UnitDelay_DSTATE_e;

  /* UnitDelay: '<S3>/Unit Delay' */
  CalibrationMotorbike_DWork.UnitDelay_DSTATE_nf = UnitDelay_DSTATE_nf;

  /* UnitDelay: '<S2>/Unit Delay' */
  CalibrationMotorbike_DWork.UnitDelay_DSTATE_n = UnitDelay_DSTATE_n;

  /* UnitDelay: '<S1>/Unit Delay' */
  CalibrationMotorbike_DWork.UnitDelay_DSTATE = UnitDelay_DSTATE;

  /* UnitDelay: '<S5>/Unit Delay3' */
  CalibrationMotorbike_DWork.UnitDelay3_DSTATE_h = UnitDelay3_DSTATE_h;
  CalibrationMotorbike_DWork.UD_DSTATE = UD_DSTATE;

  /* UnitDelay: '<S3>/Unit Delay3' */
  CalibrationMotorbike_DWork.UnitDelay3_DSTATE_p = UnitDelay3_DSTATE_p;

  /* UnitDelay: '<S2>/Unit Delay3' */
  CalibrationMotorbike_DWork.UnitDelay3_DSTATE_j = UnitDelay3_DSTATE_j;

  /* UnitDelay: '<S1>/Unit Delay3' */
  CalibrationMotorbike_DWork.UnitDelay3_DSTATE = UnitDelay3_DSTATE;
  CalibrationMotorbike_DWork.calibFlag = calibFlag;
  CalibrationMotorbike_DWork.SE_2EstFlag = SE_2EstFlag;
  CalibrationMotorbike_DWork.temporalCounter_i3 = temporalCounter_i3;
  CalibrationMotorbike_DWork.UnitDelay2_DSTATE = UnitDelay2_DSTATE;
  CalibrationMotorbike_DWork.SE_initPressure = SE_initPressure;
  CalibrationMotorbike_DWork.curSlopePressure = curSlopePressure;
  CalibrationMotorbike_DWork.SE_curDistance2M = SE_curDistance2M;
  CalibrationMotorbike_DWork.SE_curDistanceM = SE_curDistanceM;
  CalibrationMotorbike_DWork.is_Slope2 = is_Slope2;
  CalibrationMotorbike_DWork.is_Slope1 = is_Slope1;
  CalibrationMotorbike_DWork.temporalCounter_i2_l = temporalCounter_i2_l;
  CalibrationMotorbike_DWork.SE_timer = SE_timer;
  CalibrationMotorbike_DWork.temporalCounter_i1_i = temporalCounter_i1_i;
  CalibrationMotorbike_DWork.accSFFiltNormRidingConstant =
    accSFFiltNormRidingConstant;
  CalibrationMotorbike_DWork.RSD_accelerationFlag = RSD_accelerationFlag;
  CalibrationMotorbike_DWork.calibFlag_not_empty = calibFlag_not_empty;
  CalibrationMotorbike_DWork.firstLongAccFlag = firstLongAccFlag;

  /* MATLAB Function: '<Root>/MATLAB Function' incorporates:
   *  UnitDelay: '<Root>/Unit Delay'
   *  UnitDelay: '<Root>/Unit Delay2'
   */
  CalibrationMotorbike_DWork.UnitDelay2_DSTATE_n = UnitDelay2_DSTATE_n;
  CalibrationMotorbike_DWork.UnitDelay_DSTATE_k = UnitDelay_DSTATE_k;
  CalibrationMotorbike_DWork.firstRidindConstantFlag = firstRidindConstantFlag;
  CalibrationMotorbike_DWork.RSD_accExtremaFlag = RSD_accExtremaFlag;
  CalibrationMotorbike_DWork.is_CheckForAccNormMaxAccelerati =
    is_CheckForAccNormMaxAccelerati;
  CalibrationMotorbike_DWork.is_CheckForAccelerationPhase =
    is_CheckForAccelerationPhase;
  CalibrationMotorbike_DWork.is_CheckForAccNormMax = is_CheckForAccNormMax;

  /* Chart: '<Root>/RSD_RidingStateDetection' incorporates:
   *  UnitDelay: '<Root>/Unit Delay1'
   */
  CalibrationMotorbike_DWork.UnitDelay1_DSTATE_i = UnitDelay1_DSTATE_i;
  CalibrationMotorbike_DWork.RSD_curAccExtrema = RSD_curAccExtrema;
  CalibrationMotorbike_DWork.RSD_curExtrema = RSD_curExtrema;

  /* MATLAB Function: '<Root>/MATLAB Function2' */
  CalibrationMotorbike_DWork.i = i_0;

  /* DataTypeConversion: '<Root>/Data Type Conversion27' */
  MOCA_out.rotMatUpdate = rotMatUpdate;
}

/* Model initialize function */
void CalibrationMotorbike_initialize(void)
{
  /* Registration code */

  /* block I/O */

  /* custom signals */
  MOCA_out.rotMatSf2BfOut_3x3[0] = 1.0F;
  MOCA_out.rotMatSf2BfOut_3x3[1] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[2] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[3] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[4] = 1.0F;
  MOCA_out.rotMatSf2BfOut_3x3[5] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[6] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[7] = 0.0F;
  MOCA_out.rotMatSf2BfOut_3x3[8] = 1.0F;
  MOCA_out.rotMatUpdate = 0;

  /* states (dwork) */
  (void) memset((void *)&CalibrationMotorbike_DWork, 0,
                sizeof(D_Work_CalibrationMotorbike));

  /* external inputs */
  MOCA_in.initRotMatSf2Bf_3x3[0] = 1.0F;
  MOCA_in.initRotMatSf2Bf_3x3[1] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[2] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[3] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[4] = 1.0F;
  MOCA_in.initRotMatSf2Bf_3x3[5] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[6] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[7] = 0.0F;
  MOCA_in.initRotMatSf2Bf_3x3[8] = 1.0F;

  /* InitializeConditions for UnitDelay: '<S11>/UD' */
  CalibrationMotorbike_DWork.UD_DSTATE_e = 90000.0F;

  /* SystemInitialize for MATLAB Function: '<Root>/MATLAB Function2' */
  memset(&CalibrationMotorbike_DWork.ringBufGyrX[0], 0, 300U * sizeof(real32_T));
  memset(&CalibrationMotorbike_DWork.ringBufGyrY[0], 0, 300U * sizeof(real32_T));
  memset(&CalibrationMotorbike_DWork.ringBufGyrZ[0], 0, 300U * sizeof(real32_T));
  CalibrationMotorbike_DWork.i = 1;

  /* SystemInitialize for Chart: '<Root>/RSD_RidingStateDetection' */
  CalibrationMotorbike_DWork.is_CheckForAccNormMax =
    CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.is_CheckForAccNormMaxAccelerati =
    CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.is_CheckForAccelerationPhase =
    CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.temporalCounter_i3 = 0U;
  CalibrationMotorbike_DWork.is_CheckForConstantRiding =
    CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.temporalCounter_i1 = 0U;
  CalibrationMotorbike_DWork.is_CheckForDeceleration =
    CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.temporalCounter_i2 = 0U;
  CalibrationMotorbike_DWork.is_active_c3_CalibrationMotorbi = 0U;

  /* SystemInitialize for MATLAB Function: '<Root>/MATLAB Function' */
  CalibrationMotorbike_DWork.calibFlag_not_empty = false;

  /* SystemInitialize for Chart: '<Root>/SlopeEstimation' */
  CalibrationMotorbike_DWork.is_Slope1 = CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.temporalCounter_i1_i = 0U;
  CalibrationMotorbike_DWork.is_Slope2 = CalibrationM_IN_NO_ACTIVE_CHILD;
  CalibrationMotorbike_DWork.temporalCounter_i2_l = 0U;
  CalibrationMotorbike_DWork.is_active_c1_CalibrationMotorbi = 0U;
}

/*
 * File trailer for Real-Time Workshop generated code.
 *
 * [EOF]
 */
