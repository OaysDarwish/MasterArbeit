/*
 * BOSCH E-Bike Development
 * AE-EBI/ENG1
 * Project: VICTOR
 *
 * File: CalibrationMotorbike_v2.c
 *
 * Real-Time Workshop code generated for Simulink model CalibrationMotorbike_v2.
 *
 * Model version                        : 4.9
 * Real-Time Workshop file version      : 9.4 (R2020b) 29-Jul-2020
 * Real-Time Workshop file generated on : Sat Jul 30 14:27:25 2022
 * TLC version                          : 9.4 (Aug 20 2020)
 * C/C++ source code generated on       : Sat Jul 30 14:27:26 2022
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
#include "CalibrationMotorbike_v2.h"
#include "Sensordata.h"

// Matlab Defines

/* Named constants for Chart: '<Root>/CalibrationState' */
#define C_IN_DRIVING_IN_DIRECTION_BREAK ((uint8_T)1U)
#define Ca_IN_RIDING_ACCELERATION_check ((uint8_T)2U)
#define Ca_IN_RIDING_DECELERATION_check ((uint8_T)6U)
#define Calibr_IN_ACCELERATION_NEGATIVE ((uint8_T)1U)
#define Calibr_IN_ACCELERATION_POSITIVE ((uint8_T)2U)
#define Calibr_IN_DIRECTION_FOUND_ACCEL ((uint8_T)3U)
#define Calibr_IN_DIRECTION_FOUND_BREAK ((uint8_T)4U)
#define Calibrat_IN_RIDING_ACCELERATION ((uint8_T)1U)
#define Calibrat_IN_RIDING_DECELERATION ((uint8_T)5U)
#define Calibrat_IN_TRUSTABLE_DIRECTION ((uint8_T)3U)
#define Calibrati_IN_RIDING_CONST_check ((uint8_T)4U)
#define Calibratio_IN_UNKNOWN_DIRECTION ((uint8_T)4U)
#define CalibrationM_IN_KNOWN_DIRECTION ((uint8_T)1U)
#define CalibrationM_IN_NO_ACTIVE_CHILD ((uint8_T)0U)
#define CalibrationM_IN_UNKNOWN_DRIVING ((uint8_T)5U)
#define CalibrationMo_IN_INIT_DIRECTION ((uint8_T)5U)
#define CalibrationMo_IN_STANDING_STILL ((uint8_T)3U)
#define CalibrationMoto_IN_RIDING_CONST ((uint8_T)3U)
#define CalibrationMotor_IN_ENGINE_ON_h ((uint8_T)1U)
#define CalibrationMotor_IN_RIDING_SLOW ((uint8_T)2U)
#define CalibrationMotorb_IN_ENGINE_OFF ((uint8_T)1U)
#define CalibrationMotorb_IN_STATIONARY ((uint8_T)6U)
#define CalibrationMotorbi_IN_ENGINE_ON ((uint8_T)2U)
#define CalibrationMotorbik_IN_STANDING ((uint8_T)3U)
#define CalibrationMotorbik_IN_STRAIGHT ((uint8_T)2U)
#define CalibrationMotorbike__IN_RIDING ((uint8_T)1U)
#define CalibrationMotorbike_v_IN_CURVE ((uint8_T)1U)
#define CalibrationMotorbike_v_IN_IDLE1 ((uint8_T)2U)
#define Calibration_IN_STABLE_DIRECTION ((uint8_T)2U)
#define Calibration_IN_STRAIGHT_DRIVING ((uint8_T)4U)
#define IN_DRIVING_OUT_DIRECTION_ACCEL ((uint8_T)2U)
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

real32_T calibrationModuleVersion = 4.0009F;


/* Exported data definition */

/* Definition for custom storage class: Struct */
MOCA_in_type MOCA_in;
MOCA_out_type MOCA_out;

/* Block signals and states (default storage) */
D_Work_CalibrationMotorbike_v2 CalibrationMotorbike_v2_DWork;

// Matlab Declarations
static void Calibration_MovingAverage1_Init(rtDW_MovingAverage1_Calibration
  *localDW);
static void CalibrationMotor_MovingAverage1(real_T COCA_rtu_0,
  rtDW_MovingAverage1_Calibration *localDW);
static void Calibration_MovingAverage2_Init(rtDW_MovingAverage2_Calibration
  *localDW);
static void CalibrationMotor_MovingAverage2(real32_T COCA_rtu_0,
  rtDW_MovingAverage2_Calibration *localDW);
static void C_MovingStandardDeviation2_Init(rtDW_MovingStandardDeviation2_C
  *localDW);
static void Calibr_MovingStandardDeviation2(real32_T COCA_rtu_0,
  rtDW_MovingStandardDeviation2_C *localDW);
static void CalibrationMo_SmartFilter2_Init(rtDW_SmartFilter2_CalibrationMo
  *localDW);
static void CalibrationMotorbi_SmartFilter2(real32_T COCA_rtu_x_mean, real32_T
  COCA_rtu_x_std, rtDW_SmartFilter2_CalibrationMo *localDW);

/* Forward declaration for local functions */
static void CalibrationMot_SystemCore_setup(dsp_simulink_MovingStandardDevi *obj);

/* Forward declaration for local functions */
static real_T CalibrationMotorbike_angle_diff(real_T alpha, real_T beta);
static void Calibra_RIDING_STATE_ESTIMATION(void);
static void CalibrationM_update_Calibration(real_T state_now);
static void CalibrationMo_update_GravVector(const real_T acc[5], real_T acc_out
  [5]);
static void CalibrationMoto_UNKNOWN_DRIVING(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve);
static void CalibrationMot_STRAIGHT_DRIVING(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve);
static void Cal_CALIBRATION_STATE_ESTIMATOR(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve);

// Matlab Functions

/*
 * System initialize for atomic system:
 *    synthesized block
 *    synthesized block
 */
static void Calibration_MovingAverage1_Init(rtDW_MovingAverage1_Calibration
  *localDW)
{
  dsp_simulink_MovingAverage_Cali *obj;
  g_dsp_private_SlidingWindowAver *obj_0;
  int32_T i;

  /* Start for MATLABSystem: '<Root>/Moving Average1' */
  localDW->obj.matlabCodegenIsDeleted = true;
  localDW->obj.isInitialized = 0;
  localDW->obj.NumChannels = -1;
  localDW->obj.matlabCodegenIsDeleted = false;
  localDW->objisempty = true;
  obj = &localDW->obj;
  localDW->obj.isSetupComplete = false;
  localDW->obj.isInitialized = 1;
  localDW->obj.NumChannels = 1;
  obj->_pobj0.isInitialized = 0;
  localDW->obj.pStatistic = &obj->_pobj0;
  localDW->obj.isSetupComplete = true;
  localDW->obj.TunablePropsChanged = false;

  /* InitializeConditions for MATLABSystem: '<Root>/Moving Average1' */
  obj_0 = localDW->obj.pStatistic;
  if (obj_0->isInitialized == 1)
  {
    obj_0->pCumSum = 0.0;
    for (i = 0; i < 49; i++)
    {
      obj_0->pCumSumRev[i] = 0.0;
    }

    obj_0->pCumRevIndex = 1.0;
  }

  /* End of InitializeConditions for MATLABSystem: '<Root>/Moving Average1' */
}

/*
 * Output and update for atomic system:
 *    synthesized block
 *    synthesized block
 */
static void CalibrationMotor_MovingAverage1(real_T COCA_rtu_0,
  rtDW_MovingAverage1_Calibration *localDW)
{
  g_dsp_private_SlidingWindowAver *obj;
  real_T csumrev[49];
  real_T csum;
  real_T cumRevIndex;
  real_T z;
  int32_T i;

  /* MATLABSystem: '<Root>/Moving Average1' */
  if (localDW->obj.TunablePropsChanged)
  {
    localDW->obj.TunablePropsChanged = false;
  }

  obj = localDW->obj.pStatistic;
  if (obj->isInitialized != 1)
  {
    obj->isSetupComplete = false;
    obj->isInitialized = 1;
    obj->pCumSum = 0.0;
    for (i = 0; i < 49; i++)
    {
      obj->pCumSumRev[i] = 0.0;
    }

    obj->pCumRevIndex = 1.0;
    obj->isSetupComplete = true;
    obj->pCumSum = 0.0;
    for (i = 0; i < 49; i++)
    {
      obj->pCumSumRev[i] = 0.0;
    }

    obj->pCumRevIndex = 1.0;
  }

  cumRevIndex = obj->pCumRevIndex;
  csum = obj->pCumSum;
  for (i = 0; i < 49; i++)
  {
    csumrev[i] = obj->pCumSumRev[i];
  }

  csum += COCA_rtu_0;
  z = csumrev[(int32_T)cumRevIndex - 1] + csum;
  csumrev[(int32_T)cumRevIndex - 1] = COCA_rtu_0;
  if (cumRevIndex != 49.0)
  {
    cumRevIndex++;
  }
  else
  {
    cumRevIndex = 1.0;
    csum = 0.0;
    for (i = 47; i >= 0; i--)
    {
      csumrev[i] += csumrev[i + 1];
    }
  }

  obj->pCumSum = csum;
  for (i = 0; i < 49; i++)
  {
    obj->pCumSumRev[i] = csumrev[i];
  }

  obj->pCumRevIndex = cumRevIndex;

  /* MATLABSystem: '<Root>/Moving Average1' */
  localDW->Direction_absAverage = z / 50.0;
}

/*
 * System initialize for atomic system:
 *    synthesized block
 *    synthesized block
 *    synthesized block
 */
static void Calibration_MovingAverage2_Init(rtDW_MovingAverage2_Calibration
  *localDW)
{
  dsp_simulink_MovingAverage_Ca_e *obj;
  g_dsp_private_SlidingWindowAv_h *obj_0;
  int32_T i;

  /* Start for MATLABSystem: '<S19>/Moving Average2' */
  localDW->obj.matlabCodegenIsDeleted = true;
  localDW->obj.isInitialized = 0;
  localDW->obj.NumChannels = -1;
  localDW->obj.matlabCodegenIsDeleted = false;
  localDW->objisempty = true;
  obj = &localDW->obj;
  localDW->obj.isSetupComplete = false;
  localDW->obj.isInitialized = 1;
  localDW->obj.NumChannels = 1;
  obj->_pobj0.isInitialized = 0;
  localDW->obj.pStatistic = &obj->_pobj0;
  localDW->obj.isSetupComplete = true;
  localDW->obj.TunablePropsChanged = false;

  /* InitializeConditions for MATLABSystem: '<S19>/Moving Average2' */
  obj_0 = localDW->obj.pStatistic;
  if (obj_0->isInitialized == 1)
  {
    obj_0->pCumSum = 0.0F;
    for (i = 0; i < 39; i++)
    {
      obj_0->pCumSumRev[i] = 0.0F;
    }

    obj_0->pCumRevIndex = 1.0F;
  }

  /* End of InitializeConditions for MATLABSystem: '<S19>/Moving Average2' */
}

/*
 * Output and update for atomic system:
 *    synthesized block
 *    synthesized block
 *    synthesized block
 */
static void CalibrationMotor_MovingAverage2(real32_T COCA_rtu_0,
  rtDW_MovingAverage2_Calibration *localDW)
{
  g_dsp_private_SlidingWindowAv_h *obj;
  int32_T i;
  real32_T csumrev[39];
  real32_T csum;
  real32_T cumRevIndex;
  real32_T z;

  /* MATLABSystem: '<S19>/Moving Average2' */
  if (localDW->obj.TunablePropsChanged)
  {
    localDW->obj.TunablePropsChanged = false;
  }

  obj = localDW->obj.pStatistic;
  if (obj->isInitialized != 1)
  {
    obj->isSetupComplete = false;
    obj->isInitialized = 1;
    obj->pCumSum = 0.0F;
    for (i = 0; i < 39; i++)
    {
      obj->pCumSumRev[i] = 0.0F;
    }

    obj->pCumRevIndex = 1.0F;
    obj->isSetupComplete = true;
    obj->pCumSum = 0.0F;
    for (i = 0; i < 39; i++)
    {
      obj->pCumSumRev[i] = 0.0F;
    }

    obj->pCumRevIndex = 1.0F;
  }

  cumRevIndex = obj->pCumRevIndex;
  csum = obj->pCumSum;
  for (i = 0; i < 39; i++)
  {
    csumrev[i] = obj->pCumSumRev[i];
  }

  csum += COCA_rtu_0;
  z = csumrev[(int32_T)cumRevIndex - 1] + csum;
  csumrev[(int32_T)cumRevIndex - 1] = COCA_rtu_0;
  if (cumRevIndex != 39.0F)
  {
    cumRevIndex++;
  }
  else
  {
    cumRevIndex = 1.0F;
    csum = 0.0F;
    for (i = 37; i >= 0; i--)
    {
      csumrev[i] += csumrev[i + 1];
    }
  }

  obj->pCumSum = csum;
  for (i = 0; i < 39; i++)
  {
    obj->pCumSumRev[i] = csumrev[i];
  }

  obj->pCumRevIndex = cumRevIndex;

  /* MATLABSystem: '<S19>/Moving Average2' */
  localDW->accSfXmg_Average20 = z / 40.0F;
}

static void CalibrationMot_SystemCore_setup(dsp_simulink_MovingStandardDevi *obj)
{
  obj->isSetupComplete = false;
  obj->isInitialized = 1;
  obj->NumChannels = 1;
  obj->_pobj0.isInitialized = 0;
  obj->pStatistic = &obj->_pobj0;
  obj->isSetupComplete = true;
  obj->TunablePropsChanged = false;
}

/*
 * System initialize for atomic system:
 *    synthesized block
 *    synthesized block
 *    synthesized block
 */
static void C_MovingStandardDeviation2_Init(rtDW_MovingStandardDeviation2_C
  *localDW)
{
  g_dsp_private_SlidingWindowVari *obj;
  int32_T i;

  /* Start for MATLABSystem: '<S19>/Moving Standard Deviation2' */
  localDW->obj.matlabCodegenIsDeleted = true;
  localDW->obj.isInitialized = 0;
  localDW->obj.NumChannels = -1;
  localDW->obj.matlabCodegenIsDeleted = false;
  localDW->objisempty = true;
  CalibrationMot_SystemCore_setup(&localDW->obj);

  /* InitializeConditions for MATLABSystem: '<S19>/Moving Standard Deviation2' */
  obj = localDW->obj.pStatistic;
  if (obj->isInitialized == 1)
  {
    for (i = 0; i < 40; i++)
    {
      obj->pReverseSamples[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseT[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseS[i] = 0.0F;
    }

    obj->pT = 0.0F;
    obj->pS = 0.0F;
    obj->pM = 0.0F;
    obj->pCounter = 1.0F;
  }

  /* End of InitializeConditions for MATLABSystem: '<S19>/Moving Standard Deviation2' */
}

/*
 * Output and update for atomic system:
 *    synthesized block
 *    synthesized block
 *    synthesized block
 */
static void Calibr_MovingStandardDeviation2(real32_T COCA_rtu_0,
  rtDW_MovingStandardDeviation2_C *localDW)
{
  g_dsp_private_SlidingWindowVari *obj;
  int32_T i;
  real32_T reverseS[40];
  real32_T reverseSamples[40];
  real32_T reverseT[40];
  real32_T M;
  real32_T Mprev;
  real32_T S;
  real32_T T;
  real32_T counter;
  real32_T reverseMPrev;

  /* MATLABSystem: '<S19>/Moving Standard Deviation2' */
  if (localDW->obj.TunablePropsChanged)
  {
    localDW->obj.TunablePropsChanged = false;
  }

  obj = localDW->obj.pStatistic;
  if (obj->isInitialized != 1)
  {
    obj->isSetupComplete = false;
    obj->isInitialized = 1;
    for (i = 0; i < 40; i++)
    {
      obj->pReverseSamples[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseT[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseS[i] = 0.0F;
    }

    obj->pT = 0.0F;
    obj->pS = 0.0F;
    obj->pM = 0.0F;
    obj->pCounter = 0.0F;
    obj->isSetupComplete = true;
    for (i = 0; i < 40; i++)
    {
      obj->pReverseSamples[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseT[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseS[i] = 0.0F;
    }

    obj->pT = 0.0F;
    obj->pS = 0.0F;
    obj->pM = 0.0F;
    obj->pCounter = 1.0F;
  }

  for (i = 0; i < 40; i++)
  {
    reverseSamples[i] = obj->pReverseSamples[i];
  }

  for (i = 0; i < 40; i++)
  {
    reverseT[i] = obj->pReverseT[i];
  }

  for (i = 0; i < 40; i++)
  {
    reverseS[i] = obj->pReverseS[i];
  }

  T = obj->pT;
  S = obj->pS;
  M = obj->pM;
  counter = obj->pCounter;
  T += COCA_rtu_0;
  Mprev = M;
  M += 1.0F / counter * (COCA_rtu_0 - M);
  Mprev = COCA_rtu_0 - Mprev;
  S += (counter - 1.0F) * Mprev * Mprev / counter;
  Mprev = (40.0F - counter) / counter * T - reverseT[(int32_T)(real32_T)(40.0F -
    counter) - 1];
  Mprev = counter / (((40.0F - counter) + counter) * (40.0F - counter)) * (Mprev
    * Mprev) + (reverseS[(int32_T)(real32_T)(40.0F - counter) - 1] + S);
  reverseSamples[(int32_T)(real32_T)(40.0F - counter) - 1] = COCA_rtu_0;
  if (counter < 39.0F)
  {
    counter++;
  }
  else
  {
    counter = 1.0F;
    memcpy(&reverseT[0], &reverseSamples[0], 40U * sizeof(real32_T));
    T = 0.0F;
    S = 0.0F;
    for (i = 0; i < 39; i++)
    {
      M = reverseSamples[i];
      reverseT[i + 1] += reverseT[i];
      reverseMPrev = T;
      T += 1.0F / ((real32_T)i + 1.0F) * (M - T);
      M -= reverseMPrev;
      S += (((real32_T)i + 1.0F) - 1.0F) * M * M / ((real32_T)i + 1.0F);
      reverseS[i] = S;
    }

    T = 0.0F;
    S = 0.0F;
    M = 0.0F;
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseSamples[i] = reverseSamples[i];
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseT[i] = reverseT[i];
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseS[i] = reverseS[i];
  }

  obj->pT = T;
  obj->pS = S;
  obj->pM = M;
  obj->pCounter = counter;

  /* MATLABSystem: '<S19>/Moving Standard Deviation2' */
  localDW->MovingStandardDeviation2 = sqrtf(Mprev / 39.0F);
}

/*
 * System initialize for atomic system:
 *    '<S19>/SmartFilter2'
 *    '<S20>/SmartFilter2'
 *    '<S21>/SmartFilter2'
 */
static void CalibrationMo_SmartFilter2_Init(rtDW_SmartFilter2_CalibrationMo
  *localDW)
{
  localDW->y_not_empty = false;
  localDW->k = 5.0;
}

/*
 * Output and update for atomic system:
 *    '<S19>/SmartFilter2'
 *    '<S20>/SmartFilter2'
 *    '<S21>/SmartFilter2'
 */
static void CalibrationMotorbi_SmartFilter2(real32_T COCA_rtu_x_mean, real32_T
  COCA_rtu_x_std, rtDW_SmartFilter2_CalibrationMo *localDW)
{
  real_T k;
  real_T k_in;
  real_T y;
  k = localDW->k;
  y = localDW->y;

  /* MATLAB Function 'SmartACCFilter1/SmartFilter2': '<S25>:1' */
  /* '<S25>:1:5' */
  /* '<S25>:1:6' */
  /* '<S25>:1:7' */
  /* '<S25>:1:8' */
  /* '<S25>:1:9' */
  if (!localDW->y_not_empty)
  {
    /* '<S25>:1:12' */
    /* '<S25>:1:13' */
    y = (real_T)COCA_rtu_x_mean;
    localDW->y_not_empty = true;
  }

  if (COCA_rtu_x_std < 1000.0F)
  {
    /* '<S25>:1:20' */
    /* '<S25>:1:21' */
    k_in = 5.0;
  }
  else if (COCA_rtu_x_std < 2000.0F)
  {
    /* '<S25>:1:22' */
    /* '<S25>:1:23' */
    k_in = (real_T)(real32_T)((COCA_rtu_x_std - 1000.0F) * -0.004999F + 5.0F);
  }
  else
  {
    /* '<S25>:1:25' */
    k_in = 0.001;
  }

  if (k_in > k)
  {
    /* '<S25>:1:31' */
    /* '<S25>:1:32' */
    k_in = 0.001 * k_in + 0.999 * k;
  }
  else
  {
    /* '<S25>:1:34' */
  }

  /* '<S25>:1:38' */
  y = (real_T)(real32_T)(((real32_T)(real_T)((1000.0 - k_in) * y) + (real32_T)
    k_in * COCA_rtu_x_mean) / 1000.0F);

  /* '<S25>:1:40' */
  /* '<S25>:1:41' */
  localDW->y_out = y;
  k = k_in;
  localDW->y = y;
  localDW->k = k;
}

/* Output and update for Simulink Function: '<Root>/Simulink Function' */
void CalibrationMotorbike_v2_Gravity_2_RotMatrix(const real32_T
  COCA_rtu_gravity[4], real32_T COCA_rty_rot_Matrix[9])
{
  int32_T i;
  real32_T A_temp[9];
  real32_T a;
  real32_T n1;
  real32_T n2;
  real32_T n3;
  int8_T b_I[9];

  /* MATLAB Function: '<S18>/Gravity_2_RotMatrixMat' incorporates:
   *  SignalConversion generated from: '<S18>/gravity'
   */
  /* MATLAB Function 'Simulink Function/Gravity_2_RotMatrixMat': '<S24>:1' */
  /* '<S24>:1:112' */
  for (i = 0; i < 9; i++)
  {
    b_I[i] = 0;
  }

  b_I[0] = 1;
  b_I[4] = 1;
  b_I[8] = 1;
  for (i = 0; i < 9; i++)
  {
    COCA_rty_rot_Matrix[i] = (real32_T)b_I[i];
  }

  /* '<S24>:1:123' */
  a = sqrtf((COCA_rtu_gravity[0] * COCA_rtu_gravity[0] + COCA_rtu_gravity[1] *
             COCA_rtu_gravity[1]) + COCA_rtu_gravity[2] * COCA_rtu_gravity[2]);
  if (a > 10.0F)
  {
    /* '<S24>:1:125' */
    /* '<S24>:1:126' */
    n1 = COCA_rtu_gravity[0] / a;

    /* '<S24>:1:127' */
    n2 = COCA_rtu_gravity[1] / a;

    /* '<S24>:1:128' */
    n3 = COCA_rtu_gravity[2] / a;

    /* '<S24>:1:130' */
    a = sqrtf(((n1 + 1.0F) * (n1 + 1.0F) + n2 * n2) + n3 * n3);

    /* '<S24>:1:131' */
    n1 = (n1 + 1.0F) / a;

    /* '<S24>:1:132' */
    n2 /= a;

    /* '<S24>:1:133' */
    n3 /= a;

    /* '<S24>:1:141' */
    COCA_rty_rot_Matrix[2] = n1 * n1 * 2.0F - 1.0F;

    /* '<S24>:1:142' */
    a = n1 * n2 * 2.0F;
    COCA_rty_rot_Matrix[5] = a;

    /* '<S24>:1:143' */
    n1 = n1 * n3 * 2.0F;
    COCA_rty_rot_Matrix[8] = n1;

    /* '<S24>:1:145' */
    COCA_rty_rot_Matrix[1] = a;

    /* '<S24>:1:146' */
    COCA_rty_rot_Matrix[4] = n2 * n2 * 2.0F - 1.0F;

    /* '<S24>:1:147' */
    a = n2 * n3 * 2.0F;
    COCA_rty_rot_Matrix[7] = a;

    /* '<S24>:1:149' */
    COCA_rty_rot_Matrix[0] = n1;

    /* '<S24>:1:150' */
    COCA_rty_rot_Matrix[3] = a;

    /* '<S24>:1:151' */
    COCA_rty_rot_Matrix[6] = n3 * n3 * 2.0F - 1.0F;

    /* '<S24>:1:155' */
    if (COCA_rtu_gravity[3] != 0.0F)
    {
      /* '<S24>:1:157' */
      /* '<S24>:1:158' */
      n2 = COCA_rtu_gravity[3] * 3.14159274F / 180.0F;

      /* '<S24>:1:161' */
      for (i = 0; i < 9; i++)
      {
        A_temp[i] = COCA_rty_rot_Matrix[i];
      }

      /* '<S24>:1:163' */
      a = sinf(n2);
      n1 = cosf(n2);
      COCA_rty_rot_Matrix[1] = -n1 * COCA_rty_rot_Matrix[1] + a *
        COCA_rty_rot_Matrix[0];

      /* '<S24>:1:164' */
      COCA_rty_rot_Matrix[4] = -cosf(n2) * A_temp[4] + a * A_temp[3];

      /* '<S24>:1:165' */
      COCA_rty_rot_Matrix[7] = -cosf(n2) * A_temp[7] + a * A_temp[6];

      /* '<S24>:1:167' */
      COCA_rty_rot_Matrix[0] = a * A_temp[1] + n1 * A_temp[0];

      /* '<S24>:1:168' */
      COCA_rty_rot_Matrix[3] = a * A_temp[4] + n1 * A_temp[3];

      /* '<S24>:1:169' */
      COCA_rty_rot_Matrix[6] = a * A_temp[7] + n1 * A_temp[6];
    }
  }

  /* End of MATLAB Function: '<S18>/Gravity_2_RotMatrixMat' */
}

/* Function for Chart: '<Root>/CalibrationState' */
static real_T CalibrationMotorbike_angle_diff(real_T alpha, real_T beta)
{
  real_T diff;

  /* MATLAB Function 'angle_diff': '<S13>:247' */
  /* '<S13>:247:3' */
  diff = alpha - beta;
  if (diff > 180.0)
  {
    /* '<S13>:247:4' */
    /* '<S13>:247:5' */
    diff -= 360.0;
  }

  if (diff < -180.0)
  {
    /* '<S13>:247:8' */
    /* '<S13>:247:9' */
    diff += 360.0;
  }

  return diff;
}

/* Function for Chart: '<Root>/CalibrationState' */
static void Calibra_RIDING_STATE_ESTIMATION(void)
{
  real_T state_Riding;
  real32_T speedKmh;
  real32_T speed_kmh_prev;
  real32_T speed_kmh_prev_n2;
  uint8_T is_RIDING;
  uint8_T is_RIDING_STATE_ESTIMATION;
  uint8_T temporalCounter_i2;
  state_Riding = CalibrationMotorbike_v2_DWork.state_Riding;
  speed_kmh_prev_n2 = CalibrationMotorbike_v2_DWork.speed_kmh_prev_n2;
  speed_kmh_prev = CalibrationMotorbike_v2_DWork.speed_kmh_prev;
  temporalCounter_i2 = CalibrationMotorbike_v2_DWork.temporalCounter_i2;
  is_RIDING = CalibrationMotorbike_v2_DWork.is_RIDING;
  is_RIDING_STATE_ESTIMATION =
    CalibrationMotorbike_v2_DWork.is_RIDING_STATE_ESTIMATION;
  speedKmh = CalibrationMotorbike_v2_DWork.speedKmh;

  /* During 'RIDING_STATE_ESTIMATION': '<S13>:161' */
  switch (is_RIDING_STATE_ESTIMATION)
  {
   case CalibrationMotorbike__IN_RIDING:
    /* During 'RIDING': '<S13>:52' */
    if (speedKmh < 7.0F)
    {
      /* Transition: '<S13>:48' */
      /* Exit Internal 'RIDING': '<S13>:52' */
      is_RIDING = CalibrationM_IN_NO_ACTIVE_CHILD;
      is_RIDING_STATE_ESTIMATION = CalibrationMotor_IN_RIDING_SLOW;

      /* Entry 'RIDING_SLOW': '<S13>:51' */
      state_Riding = 1.0;
    }
    else
    {
      switch (is_RIDING)
      {
       case Calibrat_IN_RIDING_ACCELERATION:
        /* During 'RIDING_ACCELERATION': '<S13>:63' */
        if (((uint32_T)temporalCounter_i2 >= 200U) || (speedKmh !=
             speed_kmh_prev))
        {
          /* Transition: '<S13>:60' */
          is_RIDING = Ca_IN_RIDING_ACCELERATION_check;

          /* Entry 'RIDING_ACCELERATION_check': '<S13>:65' */
        }
        break;

       case Ca_IN_RIDING_ACCELERATION_check:
        /* During 'RIDING_ACCELERATION_check': '<S13>:65' */
        if (speedKmh <= speed_kmh_prev + 0.25F)
        {
          /* Transition: '<S13>:56' */
          is_RIDING = CalibrationMoto_IN_RIDING_CONST;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_CONST': '<S13>:62' */
          state_Riding = 4.0;
          speed_kmh_prev = speedKmh;
        }
        else
        {
          /* Transition: '<S13>:58' */
          state_Riding = 5.0;
          is_RIDING = Calibrat_IN_RIDING_ACCELERATION;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_ACCELERATION': '<S13>:63' */
          speed_kmh_prev = speedKmh;
        }
        break;

       case CalibrationMoto_IN_RIDING_CONST:
        /* During 'RIDING_CONST': '<S13>:62' */
        if (((uint32_T)temporalCounter_i2 >= 200U) || (speedKmh !=
             speed_kmh_prev))
        {
          /* Transition: '<S13>:224' */
          is_RIDING = Calibrati_IN_RIDING_CONST_check;

          /* Entry 'RIDING_CONST_check': '<S13>:221' */
          speed_kmh_prev_n2 = speed_kmh_prev;
        }
        else
        {
          state_Riding = 4.0;
          speed_kmh_prev = speedKmh;
        }
        break;

       case Calibrati_IN_RIDING_CONST_check:
        /* During 'RIDING_CONST_check': '<S13>:221' */
        if (speedKmh < fmaxf(speed_kmh_prev, speed_kmh_prev_n2) - 2.0F)
        {
          /* Transition: '<S13>:54' */
          is_RIDING = Calibrat_IN_RIDING_DECELERATION;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_DECELERATION': '<S13>:64' */
          speed_kmh_prev = speedKmh;
        }
        else if (speedKmh > fminf(speed_kmh_prev, speed_kmh_prev_n2) + 2.0F)
        {
          /* Transition: '<S13>:55' */
          is_RIDING = Calibrat_IN_RIDING_ACCELERATION;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_ACCELERATION': '<S13>:63' */
          speed_kmh_prev = speedKmh;
        }
        else
        {
          /* Transition: '<S13>:228' */
          is_RIDING = CalibrationMoto_IN_RIDING_CONST;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_CONST': '<S13>:62' */
          state_Riding = 4.0;
          speed_kmh_prev = speedKmh;
        }
        break;

       case Calibrat_IN_RIDING_DECELERATION:
        /* During 'RIDING_DECELERATION': '<S13>:64' */
        if (((uint32_T)temporalCounter_i2 >= 200U) || (speedKmh !=
             speed_kmh_prev))
        {
          /* Transition: '<S13>:61' */
          is_RIDING = Ca_IN_RIDING_DECELERATION_check;

          /* Entry 'RIDING_DECELERATION_check': '<S13>:66' */
        }
        break;

       default:
        /* During 'RIDING_DECELERATION_check': '<S13>:66' */
        if (speedKmh >= speed_kmh_prev - 0.25F)
        {
          /* Transition: '<S13>:57' */
          is_RIDING = CalibrationMoto_IN_RIDING_CONST;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_CONST': '<S13>:62' */
          state_Riding = 4.0;
          speed_kmh_prev = speedKmh;
        }
        else
        {
          /* Transition: '<S13>:59' */
          state_Riding = 3.0;
          is_RIDING = Calibrat_IN_RIDING_DECELERATION;
          temporalCounter_i2 = 0U;

          /* Entry 'RIDING_DECELERATION': '<S13>:64' */
          speed_kmh_prev = speedKmh;
        }
        break;
      }
    }
    break;

   case CalibrationMotor_IN_RIDING_SLOW:
    /* During 'RIDING_SLOW': '<S13>:51' */
    if (speedKmh > 15.0F)
    {
      /* Transition: '<S13>:46' */
      is_RIDING_STATE_ESTIMATION = CalibrationMotorbike__IN_RIDING;

      /* Entry 'RIDING': '<S13>:52' */
      /* Entry Internal 'RIDING': '<S13>:52' */
      /* Transition: '<S13>:53' */
      is_RIDING = CalibrationMoto_IN_RIDING_CONST;
      temporalCounter_i2 = 0U;

      /* Entry 'RIDING_CONST': '<S13>:62' */
      state_Riding = 4.0;
      speed_kmh_prev = speedKmh;
    }
    else if (speedKmh < 3.0F)
    {
      /* Transition: '<S13>:49' */
      is_RIDING_STATE_ESTIMATION = CalibrationMotorbik_IN_STANDING;

      /* Entry 'STANDING': '<S13>:50' */
      state_Riding = 0.0;
    }
    else
    {
      state_Riding = 1.0;
    }
    break;

   default:
    /* During 'STANDING': '<S13>:50' */
    if (speedKmh > 5.0F)
    {
      /* Transition: '<S13>:47' */
      is_RIDING_STATE_ESTIMATION = CalibrationMotor_IN_RIDING_SLOW;

      /* Entry 'RIDING_SLOW': '<S13>:51' */
      state_Riding = 1.0;
    }
    else
    {
      state_Riding = 0.0;
    }
    break;
  }

  CalibrationMotorbike_v2_DWork.is_RIDING_STATE_ESTIMATION =
    is_RIDING_STATE_ESTIMATION;
  CalibrationMotorbike_v2_DWork.is_RIDING = is_RIDING;
  CalibrationMotorbike_v2_DWork.temporalCounter_i2 = temporalCounter_i2;
  CalibrationMotorbike_v2_DWork.speed_kmh_prev = speed_kmh_prev;
  CalibrationMotorbike_v2_DWork.speed_kmh_prev_n2 = speed_kmh_prev_n2;
  CalibrationMotorbike_v2_DWork.state_Riding = state_Riding;
}

/* Function for Chart: '<Root>/CalibrationState' */
static void CalibrationM_update_Calibration(real_T state_now)
{
  real_T k;
  real_T k2;

  /* MATLAB Function 'update_Calibration': '<S13>:188' */
  if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
  {
    /* '<S13>:188:26' */
    /* '<S13>:188:27' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[0] =
      CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[0];

    /* '<S13>:188:28' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[1] =
      CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[1];

    /* '<S13>:188:29' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[2] =
      CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[2];

    /* '<S13>:188:30' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[3] = 0.0;
  }

  if (CalibrationMotorbike_v2_DWork.calibration.last_state != state_now)
  {
    /* '<S13>:188:34' */
    /* '<S13>:188:35' */
    CalibrationMotorbike_v2_DWork.calibration.n_block = 0.0;
  }

  if (state_now == 10.0)
  {
    /* '<S13>:188:45' */
    if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
    {
      /* '<S13>:188:48' */
      /* '<S13>:188:49' */
      k = 1.0;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 1.0)
    {
      /* '<S13>:188:50' */
      /* '<S13>:188:51' */
      k = 0.1;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 2.0)
    {
      /* '<S13>:188:52' */
      /* '<S13>:188:53' */
      k = 0.01;
    }
    else
    {
      /* '<S13>:188:55' */
      k = 0.0;
    }

    /* '<S13>:188:58' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[0] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[0] + k *
      CalibrationMotorbike_v2_DWork.GravityStanding[0];

    /* '<S13>:188:59' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[1] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[1] + k *
      CalibrationMotorbike_v2_DWork.GravityStanding[1];

    /* '<S13>:188:60' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[2] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[2] + k *
      CalibrationMotorbike_v2_DWork.GravityStanding[2];

    /* '<S13>:188:61' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[3] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[3] + k *
      CalibrationMotorbike_v2_DWork.GravityBreaking[3];
    if (CalibrationMotorbike_v2_DWork.calibration.n_standing < 1.0E+6)
    {
      /* '<S13>:188:62' */
      /* '<S13>:188:63' */
      CalibrationMotorbike_v2_DWork.calibration.n_standing++;
    }

    if ((k > 0.0) && (CalibrationMotorbike_v2_DWork.calibration.n < 1000.0))
    {
      /* '<S13>:188:65' */
      /* '<S13>:188:66' */
      CalibrationMotorbike_v2_DWork.calibration.n++;
    }

    if ((CalibrationMotorbike_v2_DWork.calibration.n_block == 0.0) &&
        (CalibrationMotorbike_v2_DWork.calibration.blockCnt_standing < 1.0E+6))
    {
      /* '<S13>:188:68' */
      /* '<S13>:188:69' */
      CalibrationMotorbike_v2_DWork.calibration.blockCnt_standing++;
    }
  }
  else if (state_now == 40.0)
  {
    /* '<S13>:188:73' */
    if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
    {
      /* '<S13>:188:76' */
      /* '<S13>:188:77' */
      k = 1.0;

      /* '<S13>:188:78' */
      k2 = 1.0;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 1.0)
    {
      /* '<S13>:188:79' */
      /* '<S13>:188:80' */
      k = 0.1;

      /* '<S13>:188:81' */
      k2 = 0.1;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 2.0)
    {
      /* '<S13>:188:82' */
      /* '<S13>:188:83' */
      k = 0.05;

      /* '<S13>:188:84' */
      k2 = 0.05;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 3.0)
    {
      /* '<S13>:188:85' */
      /* '<S13>:188:86' */
      k = 0.01;
      if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking < 3.0)
      {
        /* '<S13>:188:87' */
        /* '<S13>:188:88' */
        k2 = 0.01;
      }
      else
      {
        /* '<S13>:188:90' */
        k2 = 0.0;
      }
    }
    else
    {
      /* '<S13>:188:94' */
      k = 0.0;

      /* '<S13>:188:95' */
      k2 = 0.0;
    }

    /* '<S13>:188:99' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[0] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[0] + k *
      CalibrationMotorbike_v2_DWork.GravityRiding[0];

    /* '<S13>:188:100' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[1] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[1] + k *
      CalibrationMotorbike_v2_DWork.GravityRiding[1];

    /* '<S13>:188:101' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[2] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[2] + k *
      CalibrationMotorbike_v2_DWork.GravityRiding[2];

    /* '<S13>:188:102' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[3] = (1.0 - k2) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[3] + k2 *
      CalibrationMotorbike_v2_DWork.GravityRiding[3];

    /* '<S13>:188:103' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[4]++;
    if (CalibrationMotorbike_v2_DWork.calibration.n_riding < 1.0E+6)
    {
      /* '<S13>:188:105' */
      /* '<S13>:188:106' */
      CalibrationMotorbike_v2_DWork.calibration.n_riding++;
    }

    if ((k > 0.0) && (CalibrationMotorbike_v2_DWork.calibration.n < 2000.0))
    {
      /* '<S13>:188:108' */
      /* '<S13>:188:109' */
      CalibrationMotorbike_v2_DWork.calibration.n++;
    }

    if ((CalibrationMotorbike_v2_DWork.calibration.n_block == 0.0) &&
        (CalibrationMotorbike_v2_DWork.calibration.blockCnt_riding < 1.0E+6))
    {
      /* '<S13>:188:111' */
      /* '<S13>:188:112' */
      CalibrationMotorbike_v2_DWork.calibration.blockCnt_riding++;
    }
  }
  else if (state_now == 30.0)
  {
    /* '<S13>:188:116' */
    if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
    {
      /* '<S13>:188:120' */
      /* '<S13>:188:121' */
      k = 1.0;

      /* '<S13>:188:122' */
      k2 = 1.0;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 1.0)
    {
      /* '<S13>:188:123' */
      /* '<S13>:188:124' */
      k = 0.1;

      /* '<S13>:188:125' */
      k2 = 0.1;
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 2.0)
    {
      /* '<S13>:188:129' */
      /* '<S13>:188:130' */
      k = 0.05;

      /* '<S13>:188:131' */
      k2 = 0.05;
      if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking < 2.0)
      {
        /* '<S13>:188:132' */
        /* '<S13>:188:133' */
        k2 = 0.1;
      }
    }
    else if (CalibrationMotorbike_v2_DWork.calibration.state == 3.0)
    {
      /* '<S13>:188:135' */
      /* '<S13>:188:136' */
      k = 0.01;

      /* '<S13>:188:137' */
      k2 = 0.01;
      if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking < 2.0)
      {
        /* '<S13>:188:138' */
        /* '<S13>:188:139' */
        k2 = 0.1;
      }
    }
    else
    {
      /* '<S13>:188:143' */
      k = 0.01;

      /* '<S13>:188:144' */
      k2 = 0.01;
      if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking < 2.0)
      {
        /* '<S13>:188:145' */
        /* '<S13>:188:146' */
        k2 = 0.1;
      }
    }

    /* '<S13>:188:151' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[0] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[0] + k *
      CalibrationMotorbike_v2_DWork.GravityBreaking[0];

    /* '<S13>:188:152' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[1] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[1] + k *
      CalibrationMotorbike_v2_DWork.GravityBreaking[1];

    /* '<S13>:188:153' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[2] = (1.0 - k) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[2] + k *
      CalibrationMotorbike_v2_DWork.GravityBreaking[2];

    /* '<S13>:188:154' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[3] = (1.0 - k2) *
      CalibrationMotorbike_v2_DWork.Calibration_Vector[3] + k2 *
      CalibrationMotorbike_v2_DWork.GravityBreaking[3];

    /* '<S13>:188:155' */
    CalibrationMotorbike_v2_DWork.Calibration_Vector[4]++;
    if (CalibrationMotorbike_v2_DWork.calibration.n_breaking < 1.0E+6)
    {
      /* '<S13>:188:156' */
      /* '<S13>:188:157' */
      CalibrationMotorbike_v2_DWork.calibration.n_breaking++;
    }

    /* '<S13>:188:159' */
    if (CalibrationMotorbike_v2_DWork.calibration.n < 1.0E+6)
    {
      /* '<S13>:188:159' */
      /* '<S13>:188:160' */
      CalibrationMotorbike_v2_DWork.calibration.n++;
    }

    if ((CalibrationMotorbike_v2_DWork.calibration.n_block == 0.0) &&
        (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking < 1.0E+6))
    {
      /* '<S13>:188:162' */
      /* '<S13>:188:163' */
      CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking++;
    }
  }
  else
  {
    if (state_now == 50.0)
    {
      /* '<S13>:188:167' */
      if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
      {
        /* '<S13>:188:171' */
        /* '<S13>:188:172' */
        k = 1.0;

        /* '<S13>:188:173' */
        k2 = 1.0;
      }
      else if (CalibrationMotorbike_v2_DWork.calibration.state == 1.0)
      {
        /* '<S13>:188:174' */
        /* '<S13>:188:175' */
        k = 0.1;

        /* '<S13>:188:176' */
        k2 = 0.1;
      }
      else if (CalibrationMotorbike_v2_DWork.calibration.state == 2.0)
      {
        /* '<S13>:188:180' */
        /* '<S13>:188:181' */
        k = 0.05;

        /* '<S13>:188:182' */
        k2 = 0.05;
        if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating < 2.0)
        {
          /* '<S13>:188:183' */
          /* '<S13>:188:184' */
          k2 = 0.1;
        }
      }
      else if (CalibrationMotorbike_v2_DWork.calibration.state == 3.0)
      {
        /* '<S13>:188:186' */
        /* '<S13>:188:187' */
        k = 0.01;

        /* '<S13>:188:188' */
        k2 = 0.01;
        if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating < 2.0)
        {
          /* '<S13>:188:189' */
          /* '<S13>:188:190' */
          k2 = 0.1;
        }
      }
      else
      {
        /* '<S13>:188:194' */
        k = 0.01;

        /* '<S13>:188:195' */
        k2 = 0.01;
        if (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating < 2.0)
        {
          /* '<S13>:188:196' */
          /* '<S13>:188:197' */
          k2 = 0.1;
        }
      }

      /* '<S13>:188:201' */
      CalibrationMotorbike_v2_DWork.Calibration_Vector[0] = (1.0 - k) *
        CalibrationMotorbike_v2_DWork.Calibration_Vector[0] + k *
        CalibrationMotorbike_v2_DWork.GravityBreaking[0];

      /* '<S13>:188:202' */
      CalibrationMotorbike_v2_DWork.Calibration_Vector[1] = (1.0 - k) *
        CalibrationMotorbike_v2_DWork.Calibration_Vector[1] + k *
        CalibrationMotorbike_v2_DWork.GravityBreaking[1];

      /* '<S13>:188:203' */
      CalibrationMotorbike_v2_DWork.Calibration_Vector[2] = (1.0 - k) *
        CalibrationMotorbike_v2_DWork.Calibration_Vector[2] + k *
        CalibrationMotorbike_v2_DWork.GravityBreaking[2];

      /* '<S13>:188:204' */
      CalibrationMotorbike_v2_DWork.Calibration_Vector[3] = (1.0 - k2) *
        CalibrationMotorbike_v2_DWork.Calibration_Vector[3] + k2 *
        CalibrationMotorbike_v2_DWork.GravityBreaking[3];

      /* '<S13>:188:205' */
      CalibrationMotorbike_v2_DWork.Calibration_Vector[4]++;
      if (CalibrationMotorbike_v2_DWork.calibration.n_acclerating < 1.0E+6)
      {
        /* '<S13>:188:206' */
        /* '<S13>:188:207' */
        CalibrationMotorbike_v2_DWork.calibration.n_acclerating++;
      }

      /* '<S13>:188:209' */
      if (CalibrationMotorbike_v2_DWork.calibration.n < 1.0E+6)
      {
        /* '<S13>:188:209' */
        /* '<S13>:188:210' */
        CalibrationMotorbike_v2_DWork.calibration.n++;
      }

      if ((CalibrationMotorbike_v2_DWork.calibration.n_block == 0.0) &&
          (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating <
           1.0E+6))
      {
        /* '<S13>:188:212' */
        /* '<S13>:188:213' */
        CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating++;
      }
    }
  }

  if (CalibrationMotorbike_v2_DWork.calibration.state == 0.0)
  {
    /* '<S13>:188:224' */
    if (CalibrationMotorbike_v2_DWork.calibration.n > 100.0)
    {
      /* '<S13>:188:225' */
      /* '<S13>:188:226' */
      CalibrationMotorbike_v2_DWork.calibration.state = 1.0;
    }
  }
  else if (CalibrationMotorbike_v2_DWork.calibration.state == 1.0)
  {
    /* '<S13>:188:228' */
    if ((CalibrationMotorbike_v2_DWork.calibration.n > 150.0) &&
        (CalibrationMotorbike_v2_DWork.speedKmh > 3.0F))
    {
      /* '<S13>:188:229' */
      /* '<S13>:188:230' */
      CalibrationMotorbike_v2_DWork.calibration.state = 2.0;
    }
  }
  else if (CalibrationMotorbike_v2_DWork.calibration.state == 2.0)
  {
    /* '<S13>:188:232' */
    if (((CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking >= 1.0) ||
         (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating >= 1.0))
        && (CalibrationMotorbike_v2_DWork.calibration.blockCnt_riding >= 1.0))
    {
      /* '<S13>:188:233' */
      /* '<S13>:188:234' */
      CalibrationMotorbike_v2_DWork.calibration.state = 3.0;
    }
  }
  else
  {
    if ((CalibrationMotorbike_v2_DWork.calibration.state == 3.0) &&
        (CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking >= 1.0) &&
        (CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating >= 1.0))
    {
      /* '<S13>:188:236' */
      /* '<S13>:188:237' */
      /* '<S13>:188:238' */
      CalibrationMotorbike_v2_DWork.calibration.state = 4.0;
    }
  }

  /* '<S13>:188:247' */
  CalibrationMotorbike_v2_DWork.calibration.last_state = state_now;
  if (CalibrationMotorbike_v2_DWork.calibration.n_block < 1.0E+6)
  {
    /* '<S13>:188:248' */
    /* '<S13>:188:249' */
    CalibrationMotorbike_v2_DWork.calibration.n_block++;
  }

  /* '<S13>:188:253' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[0] =
    CalibrationMotorbike_v2_DWork.calibration.state;

  /* '<S13>:188:254' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[1] =
    CalibrationMotorbike_v2_DWork.calibration.n;

  /* '<S13>:188:255' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[2] =
    CalibrationMotorbike_v2_DWork.calibration.n_standing;

  /* '<S13>:188:256' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[3] =
    CalibrationMotorbike_v2_DWork.calibration.n_riding;

  /* '<S13>:188:257' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[4] =
    CalibrationMotorbike_v2_DWork.calibration.n_breaking;

  /* '<S13>:188:258' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[5] =
    CalibrationMotorbike_v2_DWork.calibration.n_acclerating;

  /* '<S13>:188:259' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[6] =
    CalibrationMotorbike_v2_DWork.calibration.n_block;

  /* '<S13>:188:260' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[7] =
    CalibrationMotorbike_v2_DWork.calibration.last_state;

  /* '<S13>:188:261' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[8] =
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_standing;

  /* '<S13>:188:262' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[9] =
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_riding;

  /* '<S13>:188:263' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[10] =
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking;

  /* '<S13>:188:264' */
  CalibrationMotorbike_v2_DWork.calibrationOUT[11] =
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating;
}

/* Function for Chart: '<Root>/CalibrationState' */
static void CalibrationMo_update_GravVector(const real_T acc[5], real_T acc_out
  [5])
{
  real_T alpha;
  real_T diff;
  int32_T i;

  /* MATLAB Function 'update_GravVector': '<S13>:180' */
  /* '<S13>:180:3' */
  for (i = 0; i < 5; i++)
  {
    acc_out[i] = acc[i];
  }

  /* '<S13>:180:4' */
  /* '<S13>:180:6' */
  alpha = CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage;

  /* '<S13>:180:30' */
  diff = CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage -
    CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd;
  if (diff > 180.0)
  {
    /* '<S13>:180:31' */
    /* '<S13>:180:32' */
    diff -= 360.0;
  }

  if (diff < -180.0)
  {
    /* '<S13>:180:35' */
    /* '<S13>:180:36' */
    diff += 360.0;
  }

  if (fabs(diff) > 90.0)
  {
    /* '<S13>:180:39' */
    /* '<S13>:180:40' */
    alpha = CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage +
      180.0;
    if (CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage +
        180.0 > 180.0)
    {
      /* '<S13>:180:41' */
      /* '<S13>:180:42' */
      alpha = (CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage
               + 180.0) - 360.0;
    }
  }

  if (acc[4] <= 0.0)
  {
    /* '<S13>:180:50' */
    /* '<S13>:180:51' */
    diff = 1.0;
  }
  else if (acc[4] < 10.0)
  {
    /* '<S13>:180:52' */
    /* '<S13>:180:53' */
    diff = 0.1;
  }
  else if (acc[4] < 30.0)
  {
    /* '<S13>:180:54' */
    /* '<S13>:180:55' */
    diff = 0.05;
  }
  else if (acc[4] < 100.0)
  {
    /* '<S13>:180:56' */
    /* '<S13>:180:57' */
    diff = 0.02;
  }
  else
  {
    /* '<S13>:180:59' */
    diff = 0.01;
  }

  /* '<S13>:180:67' */
  acc_out[0] = (1.0 - diff) * acc[0] + diff *
    CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[0];

  /* '<S13>:180:68' */
  acc_out[1] = (1.0 - diff) * acc[1] + diff *
    CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[1];

  /* '<S13>:180:69' */
  acc_out[2] = (1.0 - diff) * acc[2] + diff *
    CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[2];
  if (CalibrationMotorbike_v2_DWork.state_Direction > 1.0)
  {
    /* '<S13>:180:70' */
    /* '<S13>:180:71' */
    acc_out[3] = (1.0 - diff) * acc[3] + diff * alpha;
  }

  if (acc[4] < 100000.0)
  {
    /* '<S13>:180:76' */
    /* '<S13>:180:77' */
    acc_out[4] = acc[4] + 1.0;
  }
}

/* Function for Chart: '<Root>/CalibrationState' */
static void CalibrationMoto_UNKNOWN_DRIVING(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve)
{
  real_T tmp[5];
  real_T state_Acceleration;
  real_T state_Riding;
  int32_T i;
  uint8_T is_ENGINE_ON;
  state_Acceleration = CalibrationMotorbike_v2_DWork.state_Acceleration;
  state_Riding = CalibrationMotorbike_v2_DWork.state_Riding;

  /* During 'UNKNOWN_DRIVING': '<S13>:112' */
  /* Transition: '<S13>:134' */
  if ((state_Riding == 0.0) && (*Divide < 200000.0) && (*state_Curve == 0.0))
  {
    /* Transition: '<S13>:118' */
    is_ENGINE_ON = CalibrationMo_IN_STANDING_STILL;

    /* Entry 'STANDING_STILL': '<S13>:117' */
    *state_Calibration = 10.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityStanding[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityStanding);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 4.0) && (*state_Curve == 0.0))
  {
    /* Transition: '<S13>:125' */
    is_ENGINE_ON = Calibration_IN_STRAIGHT_DRIVING;

    /* Entry 'STRAIGHT_DRIVING': '<S13>:121' */
    *state_Calibration = 40.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityRiding[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityRiding);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 3.0) && ((state_Acceleration == 3.0) ||
            (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
           (*state_Curve == 0.0) &&
           (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
  {
    /* Transition: '<S13>:131' */
    is_ENGINE_ON = C_IN_DRIVING_IN_DIRECTION_BREAK;

    /* Entry 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
    *state_Calibration = 30.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityBreaking[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityBreaking);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 5.0) && ((state_Acceleration == 5.0) ||
            (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
           (*state_Curve == 0.0) &&
           (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
  {
    /* Transition: '<S13>:214' */
    is_ENGINE_ON = IN_DRIVING_OUT_DIRECTION_ACCEL;

    /* Entry 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
    *state_Calibration = 50.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityAccel[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityAccel);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else
  {
    /* Transition: '<S13>:136' */
    is_ENGINE_ON = CalibrationM_IN_UNKNOWN_DRIVING;

    /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
    if (*state_Curve == 0.0)
    {
      *state_Calibration = 0.0;
    }
    else
    {
      *state_Calibration = -1.0;
    }

    CalibrationM_update_Calibration(0.0);
  }

  CalibrationMotorbike_v2_DWork.is_ENGINE_ON = is_ENGINE_ON;
}

/* Function for Chart: '<Root>/CalibrationState' */
static void CalibrationMot_STRAIGHT_DRIVING(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve)
{
  real_T tmp[5];
  real_T state_Acceleration;
  real_T state_Riding;
  int32_T i;
  uint8_T is_ENGINE_ON;
  state_Acceleration = CalibrationMotorbike_v2_DWork.state_Acceleration;
  state_Riding = CalibrationMotorbike_v2_DWork.state_Riding;

  /* During 'STRAIGHT_DRIVING': '<S13>:121' */
  /* Transition: '<S13>:127' */
  /* Transition: '<S13>:217' */
  if ((state_Riding == 0.0) && (*Divide < 200000.0) && (*state_Curve == 0.0))
  {
    /* Transition: '<S13>:118' */
    is_ENGINE_ON = CalibrationMo_IN_STANDING_STILL;

    /* Entry 'STANDING_STILL': '<S13>:117' */
    *state_Calibration = 10.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityStanding[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityStanding);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 4.0) && (*state_Curve == 0.0))
  {
    /* Transition: '<S13>:125' */
    is_ENGINE_ON = Calibration_IN_STRAIGHT_DRIVING;

    /* Entry 'STRAIGHT_DRIVING': '<S13>:121' */
    *state_Calibration = 40.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityRiding[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityRiding);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 3.0) && ((state_Acceleration == 3.0) ||
            (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
           (*state_Curve == 0.0) &&
           (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
  {
    /* Transition: '<S13>:131' */
    is_ENGINE_ON = C_IN_DRIVING_IN_DIRECTION_BREAK;

    /* Entry 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
    *state_Calibration = 30.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityBreaking[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityBreaking);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else if ((state_Riding == 5.0) && ((state_Acceleration == 5.0) ||
            (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
           (*state_Curve == 0.0) &&
           (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
  {
    /* Transition: '<S13>:214' */
    is_ENGINE_ON = IN_DRIVING_OUT_DIRECTION_ACCEL;

    /* Entry 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
    *state_Calibration = 50.0;
    for (i = 0; i < 5; i++)
    {
      tmp[i] = CalibrationMotorbike_v2_DWork.GravityAccel[i];
    }

    CalibrationMo_update_GravVector(tmp,
      CalibrationMotorbike_v2_DWork.GravityAccel);
    CalibrationM_update_Calibration(*state_Calibration);
  }
  else
  {
    /* Transition: '<S13>:136' */
    is_ENGINE_ON = CalibrationM_IN_UNKNOWN_DRIVING;

    /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
    if (*state_Curve == 0.0)
    {
      *state_Calibration = 0.0;
    }
    else
    {
      *state_Calibration = -1.0;
    }

    CalibrationM_update_Calibration(0.0);
  }

  CalibrationMotorbike_v2_DWork.is_ENGINE_ON = is_ENGINE_ON;
}

/* Function for Chart: '<Root>/CalibrationState' */
static void Cal_CALIBRATION_STATE_ESTIMATOR(const real_T *Divide, real_T
  *state_Calibration, const real_T *state_Curve)
{
  real_T tmp[5];
  real_T state_Ignition;
  int32_T i;
  uint8_T is_CALIBRATION_STATE_ESTIMATOR;
  is_CALIBRATION_STATE_ESTIMATOR =
    CalibrationMotorbike_v2_DWork.is_CALIBRATION_STATE_ESTIMATOR;
  state_Ignition = CalibrationMotorbike_v2_DWork.state_Ignition;

  /* During 'CALIBRATION_STATE_ESTIMATOR': '<S13>:166' */
  if ((uint32_T)is_CALIBRATION_STATE_ESTIMATOR ==
      CalibrationMotor_IN_ENGINE_ON_h)
  {
    /* During 'ENGINE_ON': '<S13>:106' */
    if (state_Ignition == 0.0)
    {
      /* Transition: '<S13>:109' */
      /* Exit Internal 'ENGINE_ON': '<S13>:106' */
      CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
        CalibrationM_IN_NO_ACTIVE_CHILD;
      is_CALIBRATION_STATE_ESTIMATOR = CalibrationMotorbike_v_IN_IDLE1;

      /* Entry 'IDLE1': '<S13>:107' */
      *state_Calibration = 0.0;
      CalibrationM_update_Calibration(0.0);
    }
    else
    {
      switch (CalibrationMotorbike_v2_DWork.is_ENGINE_ON)
      {
       case C_IN_DRIVING_IN_DIRECTION_BREAK:
        /* During 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
        /* Transition: '<S13>:132' */
        /* Transition: '<S13>:217' */
        if ((CalibrationMotorbike_v2_DWork.state_Riding == 0.0) && (*Divide <
             200000.0) && (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:118' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationMo_IN_STANDING_STILL;

          /* Entry 'STANDING_STILL': '<S13>:117' */
          *state_Calibration = 10.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityStanding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityStanding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 4.0) &&
                 (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:125' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            Calibration_IN_STRAIGHT_DRIVING;

          /* Entry 'STRAIGHT_DRIVING': '<S13>:121' */
          *state_Calibration = 40.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityRiding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityRiding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 3.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 3.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:131' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            C_IN_DRIVING_IN_DIRECTION_BREAK;

          /* Entry 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
          *state_Calibration = 30.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityBreaking[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityBreaking);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 5.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 5.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:214' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            IN_DRIVING_OUT_DIRECTION_ACCEL;

          /* Entry 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
          *state_Calibration = 50.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityAccel[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityAccel);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else
        {
          /* Transition: '<S13>:136' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationM_IN_UNKNOWN_DRIVING;

          /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
          if (*state_Curve == 0.0)
          {
            *state_Calibration = 0.0;
          }
          else
          {
            *state_Calibration = -1.0;
          }

          CalibrationM_update_Calibration(0.0);
        }
        break;

       case IN_DRIVING_OUT_DIRECTION_ACCEL:
        /* During 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
        /* Transition: '<S13>:215' */
        /* Transition: '<S13>:217' */
        if ((CalibrationMotorbike_v2_DWork.state_Riding == 0.0) && (*Divide <
             200000.0) && (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:118' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationMo_IN_STANDING_STILL;

          /* Entry 'STANDING_STILL': '<S13>:117' */
          *state_Calibration = 10.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityStanding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityStanding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 4.0) &&
                 (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:125' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            Calibration_IN_STRAIGHT_DRIVING;

          /* Entry 'STRAIGHT_DRIVING': '<S13>:121' */
          *state_Calibration = 40.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityRiding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityRiding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 3.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 3.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:131' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            C_IN_DRIVING_IN_DIRECTION_BREAK;

          /* Entry 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
          *state_Calibration = 30.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityBreaking[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityBreaking);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 5.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 5.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:214' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            IN_DRIVING_OUT_DIRECTION_ACCEL;

          /* Entry 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
          *state_Calibration = 50.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityAccel[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityAccel);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else
        {
          /* Transition: '<S13>:136' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationM_IN_UNKNOWN_DRIVING;

          /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
          if (*state_Curve == 0.0)
          {
            *state_Calibration = 0.0;
          }
          else
          {
            *state_Calibration = -1.0;
          }

          CalibrationM_update_Calibration(0.0);
        }
        break;

       case CalibrationMo_IN_STANDING_STILL:
        /* During 'STANDING_STILL': '<S13>:117' */
        /* Transition: '<S13>:120' */
        /* Transition: '<S13>:217' */
        if ((CalibrationMotorbike_v2_DWork.state_Riding == 0.0) && (*Divide <
             200000.0) && (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:118' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationMo_IN_STANDING_STILL;

          /* Entry 'STANDING_STILL': '<S13>:117' */
          *state_Calibration = 10.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityStanding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityStanding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 4.0) &&
                 (*state_Curve == 0.0))
        {
          /* Transition: '<S13>:125' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            Calibration_IN_STRAIGHT_DRIVING;

          /* Entry 'STRAIGHT_DRIVING': '<S13>:121' */
          *state_Calibration = 40.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityRiding[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityRiding);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 3.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 3.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:131' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            C_IN_DRIVING_IN_DIRECTION_BREAK;

          /* Entry 'DRIVING_IN_DIRECTION_BREAK': '<S13>:130' */
          *state_Calibration = 30.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityBreaking[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityBreaking);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else if ((CalibrationMotorbike_v2_DWork.state_Riding == 5.0) &&
                 ((CalibrationMotorbike_v2_DWork.state_Acceleration == 5.0) ||
                  (CalibrationMotorbike_v2_DWork.state_Direction == 3.0)) &&
                 (*state_Curve == 0.0) &&
                 (CalibrationMotorbike_v2_DWork.state_Direction > 1.0))
        {
          /* Transition: '<S13>:214' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            IN_DRIVING_OUT_DIRECTION_ACCEL;

          /* Entry 'DRIVING_OUT_DIRECTION_ACCEL': '<S13>:211' */
          *state_Calibration = 50.0;
          for (i = 0; i < 5; i++)
          {
            tmp[i] = CalibrationMotorbike_v2_DWork.GravityAccel[i];
          }

          CalibrationMo_update_GravVector(tmp,
            CalibrationMotorbike_v2_DWork.GravityAccel);
          CalibrationM_update_Calibration(*state_Calibration);
        }
        else
        {
          /* Transition: '<S13>:136' */
          CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
            CalibrationM_IN_UNKNOWN_DRIVING;

          /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
          if (*state_Curve == 0.0)
          {
            *state_Calibration = 0.0;
          }
          else
          {
            *state_Calibration = -1.0;
          }

          CalibrationM_update_Calibration(0.0);
        }
        break;

       case Calibration_IN_STRAIGHT_DRIVING:
        CalibrationMot_STRAIGHT_DRIVING(Divide, state_Calibration, state_Curve);
        break;

       default:
        CalibrationMoto_UNKNOWN_DRIVING(Divide, state_Calibration, state_Curve);
        break;
      }
    }
  }
  else
  {
    /* During 'IDLE1': '<S13>:107' */
    if (state_Ignition > 0.0)
    {
      /* Transition: '<S13>:108' */
      is_CALIBRATION_STATE_ESTIMATOR = CalibrationMotor_IN_ENGINE_ON_h;

      /* Entry Internal 'ENGINE_ON': '<S13>:106' */
      /* Transition: '<S13>:116' */
      CalibrationMotorbike_v2_DWork.is_ENGINE_ON =
        CalibrationM_IN_UNKNOWN_DRIVING;

      /* Entry 'UNKNOWN_DRIVING': '<S13>:112' */
      if (*state_Curve == 0.0)
      {
        *state_Calibration = 0.0;
      }
      else
      {
        *state_Calibration = -1.0;
      }

      CalibrationM_update_Calibration(0.0);
    }
    else
    {
      *state_Calibration = 0.0;
      CalibrationM_update_Calibration(0.0);
    }
  }

  CalibrationMotorbike_v2_DWork.is_CALIBRATION_STATE_ESTIMATOR =
    is_CALIBRATION_STATE_ESTIMATOR;
}

/* Model step function */
void CalibrationMotorbike_v2_step(void)
{
  /* local block i/o variables */
  real_T COCA_rtb_abs;
  real_T COCA_rtb_alpha;
  real32_T COCA_rtb_accSfX_mg;
  real32_T COCA_rtb_accSfY_mg;
  real32_T COCA_rtb_accSfZ_mg;
  g_dsp_private_SlidingWindowA_hd *obj_0;
  g_dsp_private_SlidingWindowVa_h *obj_1;
  g_dsp_private_SlidingWindowVari *obj;
  real_T reverseS_0[50];
  real_T reverseSamples_0[50];
  real_T reverseT_0[50];
  real_T csumrev[9];
  real_T COCA_rtb_Divide_jd[5];
  real_T COCA_rtb_UnitDelay3_p[5];
  real_T COCA_rtb_UnitDelay_c[5];
  real_T COCA_rtb_Divide_idx_0;
  real_T COCA_rtb_Divide_idx_1;
  real_T COCA_rtb_Divide_idx_2;
  real_T COCA_rtb_Divide_iu;
  real_T COCA_rtb_Divide_k;
  real_T COCA_rtb_Divide_n;
  real_T COCA_rtb_Min1;
  real_T COCA_rtb_Sqrt2;
  real_T COCA_rtb_UnitDelay;
  real_T COCA_rtb_UnitDelay3;
  real_T COCA_rtb_UnitDelay3_c;
  real_T COCA_rtb_UnitDelay3_f;
  real_T COCA_rtb_UnitDelay3_o_idx_0;
  real_T COCA_rtb_UnitDelay3_o_idx_1;
  real_T COCA_rtb_UnitDelay3_o_idx_2;
  real_T COCA_rtb_UnitDelay_m;
  real_T Divide;
  real_T M_0;
  real_T S_0;
  real_T T_0;
  real_T a;
  real_T counter_0;
  real_T csum;
  real_T cumRevIndex;
  real_T gyrSfmdegs_FiltAverage;
  real_T n1;
  real_T n2;
  real_T n3;
  real_T reverseMPrev;
  real_T z;
  int32_T i;
  int32_T xpageoffset;
  real32_T reverseS[40];
  real32_T reverseSamples[40];
  real32_T reverseT[40];
  real32_T COCA_rtb_rot_Matrix[9];
  real32_T COCA_rtb_CastToSingle[5];
  real32_T COCA_rtb_gyrBfmdegs[3];
  real32_T COCA_rtb_UnitDelay_d_idx_2;
  real32_T COCA_rtb_UnitDelay_gd;
  real32_T COCA_rtb_UnitDelay_kh;
  real32_T COCA_rtb_accSfNorm_Raw;
  real32_T COCA_rtb_gyrBfmdegs_f0;
  real32_T COCA_rtb_gyrBfmdegs_jk;
  real32_T COCA_rtb_gyrBfmdegs_n;
  real32_T COCA_rtb_rot_Matrix_b;
  real32_T COCA_rtb_rot_Matrix_g;
  real32_T COCA_rtb_y_rot;
  real32_T COCA_rtb_z_rot;
  real32_T M;
  real32_T Mprev;
  real32_T S;
  real32_T T;
  real32_T counter;
  boolean_T COCA_rtb_GreaterThanOrEqual;
  boolean_T COCA_rtb_init_valid_0;

  /* DataTypeConversion: '<Root>/Data Type Conversion14' incorporates:
   *  Inport: '<Root>/speed [km//h*100]1'
   */
  CalibrationMotorbike_v2_DWork.speedKmh = (real32_T)SPECO_getPresentSpeed() *
    0.01F;

  /* DataTypeConversion: '<Root>/Data Type Conversion2' incorporates:
   *  Inport: '<Root>/accSfX [mg]'
   */
  COCA_rtb_accSfX_mg = (real32_T)ACC_getAccSfXmg();

  /* DataTypeConversion: '<Root>/Data Type Conversion3' incorporates:
   *  Inport: '<Root>/accSfY [mg]'
   */
  COCA_rtb_accSfY_mg = (real32_T)ACC_getAccSfYmg();

  /* DataTypeConversion: '<Root>/Data Type Conversion1' incorporates:
   *  Inport: '<Root>/accSfZ [mg]'
   */
  COCA_rtb_accSfZ_mg = (real32_T)ACC_getAccSfZmg();

  /* Sqrt: '<Root>/Sqrt1' incorporates:
   *  Math: '<Root>/Square3'
   *  Math: '<Root>/Square4'
   *  Math: '<Root>/Square5'
   *  Sum: '<Root>/Add1'
   */
  COCA_rtb_accSfNorm_Raw = sqrtf((COCA_rtb_accSfX_mg * COCA_rtb_accSfX_mg +
    COCA_rtb_accSfY_mg * COCA_rtb_accSfY_mg) + COCA_rtb_accSfZ_mg *
    COCA_rtb_accSfZ_mg);

  /* MATLABSystem: '<Root>/Moving Variance2' */
  if (CalibrationMotorbike_v2_DWork.obj_l.TunablePropsChanged)
  {
    CalibrationMotorbike_v2_DWork.obj_l.TunablePropsChanged = false;
  }

  obj = CalibrationMotorbike_v2_DWork.obj_l.pStatistic;
  if (obj->isInitialized != 1)
  {
    obj->isSetupComplete = false;
    obj->isInitialized = 1;
    for (i = 0; i < 40; i++)
    {
      obj->pReverseSamples[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseT[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseS[i] = 0.0F;
    }

    obj->pT = 0.0F;
    obj->pS = 0.0F;
    obj->pM = 0.0F;
    obj->pCounter = 0.0F;
    obj->isSetupComplete = true;
    for (i = 0; i < 40; i++)
    {
      obj->pReverseSamples[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseT[i] = 0.0F;
    }

    for (i = 0; i < 40; i++)
    {
      obj->pReverseS[i] = 0.0F;
    }

    obj->pT = 0.0F;
    obj->pS = 0.0F;
    obj->pM = 0.0F;
    obj->pCounter = 1.0F;
  }

  for (i = 0; i < 40; i++)
  {
    reverseSamples[i] = obj->pReverseSamples[i];
  }

  for (i = 0; i < 40; i++)
  {
    reverseT[i] = obj->pReverseT[i];
  }

  for (i = 0; i < 40; i++)
  {
    reverseS[i] = obj->pReverseS[i];
  }

  T = obj->pT;
  S = obj->pS;
  M = obj->pM;
  counter = obj->pCounter;
  T += COCA_rtb_accSfNorm_Raw;
  Mprev = M;
  M += 1.0F / counter * (COCA_rtb_accSfNorm_Raw - M);
  Mprev = COCA_rtb_accSfNorm_Raw - Mprev;
  S += (counter - 1.0F) * Mprev * Mprev / counter;
  Mprev = (40.0F - counter) / counter * T - reverseT[(int32_T)(real32_T)(40.0F -
    counter) - 1];
  Mprev = counter / (((40.0F - counter) + counter) * (40.0F - counter)) * (Mprev
    * Mprev) + (reverseS[(int32_T)(real32_T)(40.0F - counter) - 1] + S);
  reverseSamples[(int32_T)(real32_T)(40.0F - counter) - 1] =
    COCA_rtb_accSfNorm_Raw;
  if (counter < 39.0F)
  {
    counter++;
  }
  else
  {
    counter = 1.0F;
    memcpy(&reverseT[0], &reverseSamples[0], 40U * sizeof(real32_T));
    COCA_rtb_accSfNorm_Raw = 0.0F;
    T = 0.0F;
    for (i = 0; i < 39; i++)
    {
      S = reverseSamples[i];
      reverseT[i + 1] += reverseT[i];
      M = COCA_rtb_accSfNorm_Raw;
      COCA_rtb_accSfNorm_Raw += 1.0F / ((real32_T)i + 1.0F) * (S -
        COCA_rtb_accSfNorm_Raw);
      S -= M;
      T += (((real32_T)i + 1.0F) - 1.0F) * S * S / ((real32_T)i + 1.0F);
      reverseS[i] = T;
    }

    T = 0.0F;
    S = 0.0F;
    M = 0.0F;
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseSamples[i] = reverseSamples[i];
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseT[i] = reverseT[i];
  }

  for (i = 0; i < 40; i++)
  {
    obj->pReverseS[i] = reverseS[i];
  }

  obj->pT = T;
  obj->pS = S;
  obj->pM = M;
  obj->pCounter = counter;

  /* MinMax: '<Root>/Min1' incorporates:
   *  Constant: '<Root>/Constant2'
   *  MATLABSystem: '<Root>/Moving Variance2'
   */
  COCA_rtb_Min1 = fmin((real_T)(real32_T)(Mprev / 39.0F), 1.0E+6);

  /* UnitDelay: '<S10>/Unit Delay' */
  COCA_rtb_UnitDelay = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE;

  /* UnitDelay: '<S10>/Unit Delay3' */
  COCA_rtb_UnitDelay3 = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE;

  /* Product: '<S10>/Divide' incorporates:
   *  Gain: '<S10>/Gain2'
   *  Product: '<S10>/Product1'
   *  Product: '<S10>/Product2'
   *  Product: '<S10>/Product3'
   *  Product: '<S10>/Product7'
   *  Product: '<S10>/Product9'
   *  Sum: '<S10>/Add'
   *  Sum: '<S10>/Add1'
   *  Sum: '<S10>/Add4'
   *  UnitDelay: '<S10>/Unit Delay'
   *  UnitDelay: '<S10>/Unit Delay1'
   *  UnitDelay: '<S10>/Unit Delay4'
   */
  Divide = (((2.0 * CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE *
              0.098696044010893574 + 0.098696044010893574 * COCA_rtb_Min1) +
             0.098696044010893574 *
             CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE) -
            (-79999.802607911974 * COCA_rtb_UnitDelay3 + 39911.241037280844 *
             CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE)) /
    40088.956354807182;

  /* S-Function (sdspbiquad): '<S1>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (3.21383339E-7F * COCA_rtb_accSfX_mg - -1.99938118F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[0]) -
    0.999381483F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[1];
  T = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[1];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[1] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[0];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[0] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S2>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (3.21383339E-7F * COCA_rtb_accSfY_mg - -1.99938118F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[0]) -
    0.999381483F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[1];
  Mprev = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[1];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[1] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[0];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[0] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S3>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (3.21383339E-7F * COCA_rtb_accSfZ_mg - -1.99938118F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[0]) -
    0.999381483F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[1];
  counter = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[1];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[1] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[0];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[0] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S1>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (T - -1.95207202F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[2]) -
    0.95412153F * CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE
    [3];
  T = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[3];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[3] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[2];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STATE[2] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S2>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (Mprev - -1.95207202F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[2]) -
    0.95412153F * CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n
    [3];
  Mprev = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[3];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[3] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[2];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_n[2] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S3>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = (counter - -1.95207202F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[2]) -
    0.95412153F * CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p
    [3];
  counter = 2.0F * COCA_rtb_accSfNorm_Raw + -2.0F *
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[3];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[3] =
    CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[2];
  CalibrationMotorbike_v2_DWork.GeneratedFilterBlock_FILT_STA_p[2] =
    COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S1>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = 350.750824F * T;

  /* Math: '<Root>/Square' */
  T = COCA_rtb_accSfNorm_Raw * COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S2>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = 350.750824F * Mprev;

  /* Math: '<Root>/Square1' */
  Mprev = COCA_rtb_accSfNorm_Raw * COCA_rtb_accSfNorm_Raw;

  /* S-Function (sdspbiquad): '<S3>/Generated Filter Block' */
  COCA_rtb_accSfNorm_Raw = 350.750824F * counter;

  /* Sqrt: '<Root>/Sqrt' incorporates:
   *  Math: '<Root>/Square2'
   *  Sum: '<Root>/Add'
   */
  counter = sqrtf((T + Mprev) + COCA_rtb_accSfNorm_Raw * COCA_rtb_accSfNorm_Raw);

  /* SignalConversion generated from: '<Root>/Matrix Multiply1' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion7'
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  DataTypeConversion: '<Root>/Data Type Conversion9'
   *  Inport: '<Root>/gyrSfX [mdeg//s]'
   *  Inport: '<Root>/gyrSfY [mdeg//s]'
   *  Inport: '<Root>/gyrSfZ [mdeg//s]'
   */
  Mprev = (real32_T)GYR_getGyrSfXmdegs();
  COCA_rtb_accSfNorm_Raw = (real32_T)GYR_getGyrSfYmdegs();
  T = (real32_T)GYR_getGyrSfZmdegs();

  /* UnitDelay: '<S8>/Unit Delay' */
  S = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[0];

  /* UnitDelay: '<S8>/Unit Delay3' */
  COCA_rtb_UnitDelay3_o_idx_0 =
    CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[0];

  /* Product: '<S8>/Divide' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion8'
   *  Gain: '<S8>/Gain2'
   *  Inport: '<Root>/gyrSfX [mdeg//s]'
   *  Product: '<S8>/Product1'
   *  Product: '<S8>/Product2'
   *  Product: '<S8>/Product3'
   *  Product: '<S8>/Product7'
   *  Product: '<S8>/Product9'
   *  Sum: '<S8>/Add'
   *  Sum: '<S8>/Add1'
   *  Sum: '<S8>/Add4'
   *  UnitDelay: '<S8>/Unit Delay'
   *  UnitDelay: '<S8>/Unit Delay1'
   *  UnitDelay: '<S8>/Unit Delay3'
   *  UnitDelay: '<S8>/Unit Delay4'
   */
  COCA_rtb_Divide_idx_0 = ((((real_T)(real32_T)(2.0F *
    CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[0]) * 2.4674011002723395 +
    2.4674011002723395 * (real_T)(real32_T)GYR_getGyrSfXmdegs()) +
    2.4674011002723395 * (real_T)
    CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[0]) -
    (-79995.065197799457 * CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[0]
     + 39558.179107284435 * CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[0]))
    / 40446.755694916108;

  /* UnitDelay: '<S8>/Unit Delay' */
  M = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[1];

  /* UnitDelay: '<S8>/Unit Delay3' */
  COCA_rtb_UnitDelay3_o_idx_1 =
    CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[1];

  /* Product: '<S8>/Divide' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion9'
   *  Gain: '<S8>/Gain2'
   *  Inport: '<Root>/gyrSfY [mdeg//s]'
   *  Product: '<S8>/Product1'
   *  Product: '<S8>/Product2'
   *  Product: '<S8>/Product3'
   *  Product: '<S8>/Product7'
   *  Product: '<S8>/Product9'
   *  Sum: '<S8>/Add'
   *  Sum: '<S8>/Add1'
   *  Sum: '<S8>/Add4'
   *  UnitDelay: '<S8>/Unit Delay'
   *  UnitDelay: '<S8>/Unit Delay1'
   *  UnitDelay: '<S8>/Unit Delay3'
   *  UnitDelay: '<S8>/Unit Delay4'
   */
  COCA_rtb_Divide_idx_1 = ((((real_T)(real32_T)(2.0F *
    CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[1]) * 2.4674011002723395 +
    2.4674011002723395 * (real_T)(real32_T)GYR_getGyrSfYmdegs()) +
    2.4674011002723395 * (real_T)
    CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[1]) -
    (-79995.065197799457 * CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[1]
     + 39558.179107284435 * CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[1]))
    / 40446.755694916108;

  /* UnitDelay: '<S8>/Unit Delay' */
  COCA_rtb_UnitDelay_d_idx_2 = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c
    [2];

  /* UnitDelay: '<S8>/Unit Delay3' */
  COCA_rtb_UnitDelay3_o_idx_2 =
    CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[2];

  /* Product: '<S8>/Divide' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion7'
   *  Gain: '<S8>/Gain2'
   *  Inport: '<Root>/gyrSfZ [mdeg//s]'
   *  Product: '<S8>/Product1'
   *  Product: '<S8>/Product2'
   *  Product: '<S8>/Product3'
   *  Product: '<S8>/Product7'
   *  Product: '<S8>/Product9'
   *  Sum: '<S8>/Add'
   *  Sum: '<S8>/Add1'
   *  Sum: '<S8>/Add4'
   *  UnitDelay: '<S8>/Unit Delay'
   *  UnitDelay: '<S8>/Unit Delay1'
   *  UnitDelay: '<S8>/Unit Delay3'
   *  UnitDelay: '<S8>/Unit Delay4'
   */
  COCA_rtb_Divide_idx_2 = ((((real_T)(real32_T)(2.0F *
    CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[2]) * 2.4674011002723395 +
    2.4674011002723395 * (real_T)(real32_T)GYR_getGyrSfZmdegs()) +
    2.4674011002723395 * (real_T)
    CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[2]) -
    (-79995.065197799457 * CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[2]
     + 39558.179107284435 * CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[2]))
    / 40446.755694916108;

  /* Sqrt: '<Root>/Sqrt2' incorporates:
   *  Math: '<Root>/Square6'
   *  Math: '<Root>/Square7'
   *  Math: '<Root>/Square8'
   *  Sum: '<Root>/Add2'
   */
  COCA_rtb_Sqrt2 = sqrt((COCA_rtb_Divide_idx_0 * COCA_rtb_Divide_idx_0 +
    COCA_rtb_Divide_idx_1 * COCA_rtb_Divide_idx_1) + COCA_rtb_Divide_idx_2 *
                        COCA_rtb_Divide_idx_2);

  /* MATLABSystem: '<Root>/Moving Average' */
  if (CalibrationMotorbike_v2_DWork.obj_d.TunablePropsChanged)
  {
    CalibrationMotorbike_v2_DWork.obj_d.TunablePropsChanged = false;
  }

  obj_0 = CalibrationMotorbike_v2_DWork.obj_d.pStatistic;
  if (obj_0->isInitialized != 1)
  {
    obj_0->isSetupComplete = false;
    obj_0->isInitialized = 1;
    obj_0->pCumSum = 0.0;
    for (i = 0; i < 9; i++)
    {
      obj_0->pCumSumRev[i] = 0.0;
    }

    obj_0->pCumRevIndex = 1.0;
    obj_0->isSetupComplete = true;
    obj_0->pCumSum = 0.0;
    for (i = 0; i < 9; i++)
    {
      obj_0->pCumSumRev[i] = 0.0;
    }

    obj_0->pCumRevIndex = 1.0;
  }

  cumRevIndex = obj_0->pCumRevIndex;
  csum = obj_0->pCumSum;
  for (i = 0; i < 9; i++)
  {
    csumrev[i] = obj_0->pCumSumRev[i];
  }

  csum += COCA_rtb_Sqrt2;
  z = csumrev[(int32_T)cumRevIndex - 1] + csum;
  csumrev[(int32_T)cumRevIndex - 1] = COCA_rtb_Sqrt2;
  if (cumRevIndex != 9.0)
  {
    cumRevIndex++;
  }
  else
  {
    cumRevIndex = 1.0;
    csum = 0.0;
    for (i = 7; i >= 0; i--)
    {
      csumrev[i] += csumrev[i + 1];
    }
  }

  obj_0->pCumSum = csum;
  for (i = 0; i < 9; i++)
  {
    obj_0->pCumSumRev[i] = csumrev[i];
  }

  obj_0->pCumRevIndex = cumRevIndex;

  /* MATLABSystem: '<Root>/Moving Average' */
  gyrSfmdegs_FiltAverage = z / 10.0;
  CalibrationMotor_MovingAverage2(COCA_rtb_accSfX_mg,
    &CalibrationMotorbike_v2_DWork.MovingAverage2_pn);
  Calibr_MovingStandardDeviation2(COCA_rtb_accSfX_mg,
    &CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_p);

  /* MATLAB Function: '<S20>/SmartFilter2' */
  CalibrationMotorbi_SmartFilter2
    (CalibrationMotorbike_v2_DWork.MovingAverage2_pn.accSfXmg_Average20,
     CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_p.MovingStandardDeviation2,
     &CalibrationMotorbike_v2_DWork.sf_SmartFilter2_b);

  /* UnitDelay: '<S5>/Unit Delay' */
  COCA_rtb_Sqrt2 = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_o;

  /* UnitDelay: '<S5>/Unit Delay3' */
  cumRevIndex = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_j;

  /* Product: '<S5>/Divide' incorporates:
   *  Gain: '<S5>/Gain2'
   *  Product: '<S5>/Product1'
   *  Product: '<S5>/Product2'
   *  Product: '<S5>/Product3'
   *  Product: '<S5>/Product7'
   *  Product: '<S5>/Product9'
   *  Sum: '<S5>/Add'
   *  Sum: '<S5>/Add1'
   *  Sum: '<S5>/Add4'
   *  UnitDelay: '<S5>/Unit Delay1'
   *  UnitDelay: '<S5>/Unit Delay3'
   *  UnitDelay: '<S5>/Unit Delay4'
   */
  csum = (((2.0 * COCA_rtb_Sqrt2 * 0.00098696044010893589 +
            0.00098696044010893589 *
            CalibrationMotorbike_v2_DWork.sf_SmartFilter2_b.y_out) +
           0.00098696044010893589 *
           CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_l) -
          (-79999.99802607912 *
           CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_j +
           39991.115221084125 *
           CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_e)) /
    40008.886752836755;
  CalibrationMotor_MovingAverage2(COCA_rtb_accSfY_mg,
    &CalibrationMotorbike_v2_DWork.MovingAverage2_p);
  Calibr_MovingStandardDeviation2(COCA_rtb_accSfY_mg,
    &CalibrationMotorbike_v2_DWork.MovingStandardDeviation2);

  /* MATLAB Function: '<S19>/SmartFilter2' */
  CalibrationMotorbi_SmartFilter2
    (CalibrationMotorbike_v2_DWork.MovingAverage2_p.accSfXmg_Average20,
     CalibrationMotorbike_v2_DWork.MovingStandardDeviation2.MovingStandardDeviation2,
     &CalibrationMotorbike_v2_DWork.sf_SmartFilter2);

  /* UnitDelay: '<S6>/Unit Delay' */
  z = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_m;

  /* UnitDelay: '<S6>/Unit Delay3' */
  COCA_rtb_UnitDelay3_c = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_c;

  /* Product: '<S6>/Divide' incorporates:
   *  Gain: '<S6>/Gain2'
   *  Product: '<S6>/Product1'
   *  Product: '<S6>/Product2'
   *  Product: '<S6>/Product3'
   *  Product: '<S6>/Product7'
   *  Product: '<S6>/Product9'
   *  Sum: '<S6>/Add'
   *  Sum: '<S6>/Add1'
   *  Sum: '<S6>/Add4'
   *  UnitDelay: '<S6>/Unit Delay1'
   *  UnitDelay: '<S6>/Unit Delay3'
   *  UnitDelay: '<S6>/Unit Delay4'
   */
  COCA_rtb_Divide_iu = (((2.0 * z * 0.00098696044010893589 +
    0.00098696044010893589 * CalibrationMotorbike_v2_DWork.sf_SmartFilter2.y_out)
    + 0.00098696044010893589 * CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_j)
                        - (-79999.99802607912 *
    CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_c + 39991.115221084125 *
    CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_c)) / 40008.886752836755;
  CalibrationMotor_MovingAverage2(COCA_rtb_accSfZ_mg,
    &CalibrationMotorbike_v2_DWork.MovingAverage2_pna);
  Calibr_MovingStandardDeviation2(COCA_rtb_accSfZ_mg,
    &CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_pn);

  /* MATLAB Function: '<S21>/SmartFilter2' */
  CalibrationMotorbi_SmartFilter2
    (CalibrationMotorbike_v2_DWork.MovingAverage2_pna.accSfXmg_Average20,
     CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_pn.MovingStandardDeviation2,
     &CalibrationMotorbike_v2_DWork.sf_SmartFilter2_j);

  /* UnitDelay: '<S7>/Unit Delay' */
  COCA_rtb_UnitDelay_m = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_e;

  /* UnitDelay: '<S7>/Unit Delay3' */
  COCA_rtb_UnitDelay3_f = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_cs;

  /* Product: '<S7>/Divide' incorporates:
   *  Gain: '<S7>/Gain2'
   *  Product: '<S7>/Product1'
   *  Product: '<S7>/Product2'
   *  Product: '<S7>/Product3'
   *  Product: '<S7>/Product7'
   *  Product: '<S7>/Product9'
   *  Sum: '<S7>/Add'
   *  Sum: '<S7>/Add1'
   *  Sum: '<S7>/Add4'
   *  UnitDelay: '<S7>/Unit Delay1'
   *  UnitDelay: '<S7>/Unit Delay3'
   *  UnitDelay: '<S7>/Unit Delay4'
   */
  COCA_rtb_Divide_k = (((2.0 * COCA_rtb_UnitDelay_m * 0.00098696044010893589 +
    0.00098696044010893589 *
    CalibrationMotorbike_v2_DWork.sf_SmartFilter2_j.y_out) +
                        0.00098696044010893589 *
                        CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_d) -
                       (-79999.99802607912 *
                        CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_cs +
                        39991.115221084125 *
                        CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_b)) /
    40008.886752836755;

  /* MATLAB Function: '<Root>/Rotate_to_Gravity' */
  /* MATLAB Function 'Rotate_to_Gravity': '<S17>:1' */
  /* '<S17>:1:10' */
  /* '<S17>:1:11' */
  COCA_rtb_y_rot = COCA_rtb_accSfY_mg;

  /* '<S17>:1:12' */
  COCA_rtb_z_rot = COCA_rtb_accSfZ_mg;

  /* '<S17>:1:14' */
  a = sqrt((csum * csum + COCA_rtb_Divide_iu * COCA_rtb_Divide_iu) +
           COCA_rtb_Divide_k * COCA_rtb_Divide_k);
  if (a != 0.0)
  {
    /* '<S17>:1:16' */
    /* '<S17>:1:17' */
    n1 = csum / a + 1.0;

    /* '<S17>:1:18' */
    n2 = COCA_rtb_Divide_iu / a;

    /* '<S17>:1:19' */
    n3 = COCA_rtb_Divide_k / a;

    /* '<S17>:1:21' */
    a = sqrt((n1 * n1 + n2 * n2) + n3 * n3);

    /* '<S17>:1:22' */
    n1 /= a;

    /* '<S17>:1:23' */
    n2 /= a;

    /* '<S17>:1:24' */
    n3 /= a;

    /* '<S17>:1:27' */
    /* '<S17>:1:28' */
    COCA_rtb_z_rot = (real32_T)(real_T)(n2 * n3 * 2.0);
    COCA_rtb_y_rot = ((real32_T)(real_T)(n2 * n2 * 2.0 - 1.0) *
                      COCA_rtb_accSfY_mg + (real32_T)(real_T)(n2 * n1 * 2.0) *
                      COCA_rtb_accSfX_mg) + COCA_rtb_z_rot * COCA_rtb_accSfZ_mg;

    /* '<S17>:1:29' */
    COCA_rtb_z_rot = ((real32_T)(real_T)(n3 * n1 * 2.0) * COCA_rtb_accSfX_mg +
                      COCA_rtb_z_rot * COCA_rtb_accSfY_mg) + (real32_T)(real_T)
      (n3 * n3 * 2.0 - 1.0) * COCA_rtb_accSfZ_mg;
  }

  /* End of MATLAB Function: '<Root>/Rotate_to_Gravity' */

  /* UnitDelay: '<S12>/Unit Delay' */
  COCA_rtb_UnitDelay_gd = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_ob;

  /* UnitDelay: '<S12>/Unit Delay3' */
  n1 = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_g;

  /* Product: '<S12>/Divide' incorporates:
   *  Gain: '<S12>/Gain2'
   *  Product: '<S12>/Product1'
   *  Product: '<S12>/Product2'
   *  Product: '<S12>/Product3'
   *  Product: '<S12>/Product7'
   *  Product: '<S12>/Product9'
   *  Sum: '<S12>/Add'
   *  Sum: '<S12>/Add1'
   *  Sum: '<S12>/Add4'
   *  UnitDelay: '<S12>/Unit Delay'
   *  UnitDelay: '<S12>/Unit Delay1'
   *  UnitDelay: '<S12>/Unit Delay3'
   *  UnitDelay: '<S12>/Unit Delay4'
   */
  n2 = ((((real_T)(real32_T)(2.0F *
           CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_ob) *
          2.4674011002723395 + 2.4674011002723395 * (real_T)COCA_rtb_y_rot) +
         2.4674011002723395 * (real_T)
         CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_k) -
        (-79995.065197799457 * CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_g
         + 39558.179107284435 *
         CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_o)) /
    40446.755694916108;

  /* UnitDelay: '<S4>/Unit Delay' */
  COCA_rtb_UnitDelay_kh = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_n;

  /* UnitDelay: '<S4>/Unit Delay3' */
  n3 = CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_pt;

  /* Product: '<S4>/Divide' incorporates:
   *  Gain: '<S4>/Gain2'
   *  Product: '<S4>/Product1'
   *  Product: '<S4>/Product2'
   *  Product: '<S4>/Product3'
   *  Product: '<S4>/Product7'
   *  Product: '<S4>/Product9'
   *  Sum: '<S4>/Add'
   *  Sum: '<S4>/Add1'
   *  Sum: '<S4>/Add4'
   *  UnitDelay: '<S4>/Unit Delay'
   *  UnitDelay: '<S4>/Unit Delay1'
   *  UnitDelay: '<S4>/Unit Delay3'
   *  UnitDelay: '<S4>/Unit Delay4'
   */
  COCA_rtb_Divide_n = ((((real_T)(real32_T)(2.0F *
    CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_n) * 2.4674011002723395 +
    2.4674011002723395 * (real_T)COCA_rtb_z_rot) + 2.4674011002723395 * (real_T)
                        CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_n) -
                       (-79995.065197799457 *
                        CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_pt +
                        39558.179107284435 *
                        CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_j)) /
    40446.755694916108;

  /* MATLAB Function: '<Root>/Direction_Vector' */
  /* MATLAB Function 'Direction_Vector': '<S14>:1' */
  /* '<S14>:1:14' */
  COCA_rtb_abs = sqrt(n2 * n2 + COCA_rtb_Divide_n * COCA_rtb_Divide_n);
  if (COCA_rtb_abs > 0.0)
  {
    /* '<S14>:1:16' */
    /* '<S14>:1:17' */
    COCA_rtb_alpha = atan2(n2, COCA_rtb_Divide_n) * 57.295779513082323;
  }
  else
  {
    /* '<S14>:1:19' */
    COCA_rtb_alpha = 0.0;
  }

  if (COCA_rtb_alpha < -180.0)
  {
    /* '<S14>:1:30' */
    /* '<S14>:1:31' */
    COCA_rtb_alpha += 360.0;
  }

  if (COCA_rtb_alpha > 180.0)
  {
    /* '<S14>:1:34' */
    /* '<S14>:1:35' */
    COCA_rtb_alpha -= 360.0;
  }

  if (COCA_rtb_abs > CalibrationMotorbike_v2_DWork.abs_max)
  {
    /* '<S14>:1:41' */
    /* '<S14>:1:42' */
    CalibrationMotorbike_v2_DWork.abs_max = COCA_rtb_abs;

    /* '<S14>:1:43' */
  }
  else
  {
    /* '<S14>:1:45' */
    /* '<S14>:1:46' */
    CalibrationMotorbike_v2_DWork.abs_max = 0.0;

    /* '<S14>:1:47' */
  }

  /* End of MATLAB Function: '<Root>/Direction_Vector' */
  /* '<S14>:1:51' */
  CalibrationMotor_MovingAverage1(COCA_rtb_abs,
    &CalibrationMotorbike_v2_DWork.MovingAverage1);

  /* MATLABSystem: '<Root>/Moving Variance4' */
  if (CalibrationMotorbike_v2_DWork.obj.TunablePropsChanged)
  {
    CalibrationMotorbike_v2_DWork.obj.TunablePropsChanged = false;
  }

  obj_1 = CalibrationMotorbike_v2_DWork.obj.pStatistic;
  if (obj_1->isInitialized != 1)
  {
    obj_1->isSetupComplete = false;
    obj_1->isInitialized = 1;
    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseSamples[i] = 0.0;
    }

    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseT[i] = 0.0;
    }

    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseS[i] = 0.0;
    }

    obj_1->pT = 0.0;
    obj_1->pS = 0.0;
    obj_1->pM = 0.0;
    obj_1->pCounter = 0.0;
    obj_1->isSetupComplete = true;
    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseSamples[i] = 0.0;
    }

    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseT[i] = 0.0;
    }

    for (i = 0; i < 50; i++)
    {
      obj_1->pReverseS[i] = 0.0;
    }

    obj_1->pT = 0.0;
    obj_1->pS = 0.0;
    obj_1->pM = 0.0;
    obj_1->pCounter = 1.0;
  }

  for (i = 0; i < 50; i++)
  {
    reverseSamples_0[i] = obj_1->pReverseSamples[i];
  }

  for (i = 0; i < 50; i++)
  {
    reverseT_0[i] = obj_1->pReverseT[i];
  }

  for (i = 0; i < 50; i++)
  {
    reverseS_0[i] = obj_1->pReverseS[i];
  }

  T_0 = obj_1->pT;
  S_0 = obj_1->pS;
  M_0 = obj_1->pM;
  counter_0 = obj_1->pCounter;
  T_0 += COCA_rtb_alpha;
  a = M_0;
  M_0 += 1.0 / counter_0 * (COCA_rtb_alpha - M_0);
  a = COCA_rtb_alpha - a;
  S_0 += (counter_0 - 1.0) * a * a / counter_0;
  a = (50.0 - counter_0) / counter_0 * T_0 - reverseT_0[(int32_T)(real_T)(50.0 -
    counter_0) - 1];
  a = (counter_0 / (((50.0 - counter_0) + counter_0) * (50.0 - counter_0)) * (a *
        a) + (reverseS_0[(int32_T)(real_T)(50.0 - counter_0) - 1] + S_0)) / 49.0;
  reverseSamples_0[(int32_T)(real_T)(50.0 - counter_0) - 1] = COCA_rtb_alpha;
  if (counter_0 < 49.0)
  {
    counter_0++;
  }
  else
  {
    counter_0 = 1.0;
    memcpy(&reverseT_0[0], &reverseSamples_0[0], 50U * sizeof(real_T));
    T_0 = 0.0;
    S_0 = 0.0;
    for (i = 0; i < 49; i++)
    {
      M_0 = reverseSamples_0[i];
      reverseT_0[i + 1] += reverseT_0[i];
      reverseMPrev = T_0;
      T_0 += 1.0 / ((real_T)i + 1.0) * (M_0 - T_0);
      M_0 -= reverseMPrev;
      S_0 += (((real_T)i + 1.0) - 1.0) * M_0 * M_0 / ((real_T)i + 1.0);
      reverseS_0[i] = S_0;
    }

    T_0 = 0.0;
    S_0 = 0.0;
    M_0 = 0.0;
  }

  for (i = 0; i < 50; i++)
  {
    obj_1->pReverseSamples[i] = reverseSamples_0[i];
  }

  for (i = 0; i < 50; i++)
  {
    obj_1->pReverseT[i] = reverseT_0[i];
  }

  for (i = 0; i < 50; i++)
  {
    obj_1->pReverseS[i] = reverseS_0[i];
  }

  obj_1->pT = T_0;
  obj_1->pS = S_0;
  obj_1->pM = M_0;
  obj_1->pCounter = counter_0;
  CalibrationMotor_MovingAverage1(COCA_rtb_alpha,
    &CalibrationMotorbike_v2_DWork.MovingAverage2);

  /* SignalConversion generated from: '<S13>/ SFunction ' incorporates:
   *  Chart: '<Root>/CalibrationState'
   *  Constant: '<Root>/Constant14'
   */
  CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[0] = csum;
  CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[1] =
    COCA_rtb_Divide_iu;
  CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[2] =
    COCA_rtb_Divide_k;
  CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[3] = 0.0;
  CalibrationMotorbike_v2_DWork.TmpSignalConversionAtSFunctionI[4] = 0.0;

  /* Chart: '<Root>/CalibrationState' incorporates:
   *  MATLABSystem: '<Root>/Moving Variance4'
   */
  if ((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i1 < 1023U)
  {
    CalibrationMotorbike_v2_DWork.temporalCounter_i1 = (uint16_T)((uint32_T)
      CalibrationMotorbike_v2_DWork.temporalCounter_i1 + 1U);
  }

  if ((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i2 < 255U)
  {
    CalibrationMotorbike_v2_DWork.temporalCounter_i2 = (uint8_T)((uint32_T)
      CalibrationMotorbike_v2_DWork.temporalCounter_i2 + 1U);
  }

  if ((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i3 < 255U)
  {
    CalibrationMotorbike_v2_DWork.temporalCounter_i3 = (uint8_T)((uint32_T)
      CalibrationMotorbike_v2_DWork.temporalCounter_i3 + 1U);
  }

  /* Gateway: CalibrationState */
  /* During: CalibrationState */
  if ((uint32_T)CalibrationMotorbike_v2_DWork.is_active_c12_CalibrationMotorb ==
      0U)
  {
    /* Entry: CalibrationState */
    CalibrationMotorbike_v2_DWork.is_active_c12_CalibrationMotorb = 1U;

    /* Entry Internal: CalibrationState */
    /* Entry Internal 'ENGINE_STATE_ESTIMATOR': '<S13>:140' */
    /* Transition: '<S13>:137' */
    CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR =
      CalibrationMotorb_IN_ENGINE_OFF;

    /* Entry 'ENGINE_OFF': '<S13>:42' */
    /* Entry Internal 'ACCELERATION_STATE_ESTIMATOR': '<S13>:159' */
    /* Transition: '<S13>:158' */
    CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
      CalibrationMo_IN_INIT_DIRECTION;

    /* Entry 'INIT_DIRECTION': '<S13>:195' */
    CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd = -1.0;

    /* Entry Internal 'RIDING_STATE_ESTIMATION': '<S13>:161' */
    /* Transition: '<S13>:45' */
    CalibrationMotorbike_v2_DWork.speed_kmh_prev = 0.0F;
    CalibrationMotorbike_v2_DWork.speed_kmh_prev_n2 = 0.0F;
    CalibrationMotorbike_v2_DWork.is_RIDING_STATE_ESTIMATION =
      CalibrationMotorbik_IN_STANDING;

    /* Entry 'STANDING': '<S13>:50' */
    /* Entry Internal 'CURVE_STATE_ESTIMATION': '<S13>:163' */
    /* Transition: '<S13>:103' */
    CalibrationMotorbike_v2_DWork.is_CURVE_STATE_ESTIMATION =
      CalibrationMotorbik_IN_STRAIGHT;

    /* Entry 'STRAIGHT': '<S13>:82' */
    /* Entry Internal 'STABLEDIRECTION_STATE_ESTIMATION': '<S13>:165' */
    /* Transition: '<S13>:99' */
    CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
      Calibratio_IN_UNKNOWN_DIRECTION;

    /* Entry 'UNKNOWN_DIRECTION': '<S13>:98' */
    /* Entry Internal 'CALIBRATION_STATE_ESTIMATOR': '<S13>:166' */
    /* Transition: '<S13>:138' */
    CalibrationMotorbike_v2_DWork.state_Ignition = 0.0;
    CalibrationMotorbike_v2_DWork.state_Acceleration = 0.0;
    CalibrationMotorbike_v2_DWork.state_Riding = 0.0;
    CalibrationMotorbike_v2_DWork.state_Direction = 0.0;
    for (i = 0; i < 5; i++)
    {
      CalibrationMotorbike_v2_DWork.GravityStanding[i] = 0.0;
      CalibrationMotorbike_v2_DWork.GravityRiding[i] = 0.0;
      CalibrationMotorbike_v2_DWork.GravityBreaking[i] = 0.0;
      CalibrationMotorbike_v2_DWork.GravityAccel[i] = 0.0;
      CalibrationMotorbike_v2_DWork.Calibration_Vector[i] = 0.0;
    }

    memset(&CalibrationMotorbike_v2_DWork.calibrationOUT[0], 0, 12U * sizeof
           (real_T));
    CalibrationMotorbike_v2_DWork.is_CALIBRATION_STATE_ESTIMATOR =
      CalibrationMotorbike_v_IN_IDLE1;

    /* Entry 'IDLE1': '<S13>:107' */
    gyrSfmdegs_FiltAverage = 0.0;
    CalibrationM_update_Calibration(0.0);
  }
  else
  {
    /* During 'ENGINE_STATE_ESTIMATOR': '<S13>:140' */
    if ((int32_T)CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR == 1)
    {
      /* During 'ENGINE_OFF': '<S13>:42' */
      if (Divide > 4000.0)
      {
        /* Transition: '<S13>:43' */
        CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR =
          CalibrationMotorbi_IN_ENGINE_ON;
        CalibrationMotorbike_v2_DWork.temporalCounter_i1 = 0U;

        /* Entry 'ENGINE_ON': '<S13>:41' */
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Ignition = 0.0;
      }
    }
    else
    {
      /* During 'ENGINE_ON': '<S13>:41' */
      if (Divide < 1000.0)
      {
        /* Transition: '<S13>:40' */
        CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR =
          CalibrationMotorb_IN_ENGINE_OFF;

        /* Entry 'ENGINE_OFF': '<S13>:42' */
        CalibrationMotorbike_v2_DWork.state_Ignition = 0.0;
      }
      else
      {
        if (((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i1 >= 1000U)
            || (CalibrationMotorbike_v2_DWork.speedKmh > 5.0F))
        {
          /* Transition: '<S13>:232' */
          CalibrationMotorbike_v2_DWork.state_Ignition = 1.0;
          CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR =
            CalibrationMotorbi_IN_ENGINE_ON;
          CalibrationMotorbike_v2_DWork.temporalCounter_i1 = 0U;

          /* Entry 'ENGINE_ON': '<S13>:41' */
        }
      }
    }

    /* During 'ACCELERATION_STATE_ESTIMATOR': '<S13>:159' */
    switch (CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR)
    {
     case Calibr_IN_ACCELERATION_NEGATIVE:
      /* During 'ACCELERATION_NEGATIVE': '<S13>:157' */
      if ((counter < 175.0F) || (fabs(CalibrationMotorbike_angle_diff
            (CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage,
             CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd)) < 90.0))
      {
        /* Transition: '<S13>:155' */
        CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
          CalibrationMotorb_IN_STATIONARY;

        /* Entry 'STATIONARY': '<S13>:151' */
        CalibrationMotorbike_v2_DWork.state_Acceleration = 4.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Acceleration = 3.0;
      }
      break;

     case Calibr_IN_ACCELERATION_POSITIVE:
      /* During 'ACCELERATION_POSITIVE': '<S13>:152' */
      if ((counter < 175.0F) || (fabs(CalibrationMotorbike_angle_diff
            (CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage,
             CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd)) > 90.0))
      {
        /* Transition: '<S13>:154' */
        CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
          CalibrationMotorb_IN_STATIONARY;

        /* Entry 'STATIONARY': '<S13>:151' */
        CalibrationMotorbike_v2_DWork.state_Acceleration = 4.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Acceleration = 5.0;
      }
      break;

     case Calibr_IN_DIRECTION_FOUND_ACCEL:
      /* During 'DIRECTION_FOUND_ACCEL': '<S13>:200' */
      /* Transition: '<S13>:201' */
      CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
        CalibrationMotorb_IN_STATIONARY;

      /* Entry 'STATIONARY': '<S13>:151' */
      CalibrationMotorbike_v2_DWork.state_Acceleration = 4.0;
      break;

     case Calibr_IN_DIRECTION_FOUND_BREAK:
      /* During 'DIRECTION_FOUND_BREAK': '<S13>:206' */
      /* Transition: '<S13>:209' */
      CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
        CalibrationMotorb_IN_STATIONARY;

      /* Entry 'STATIONARY': '<S13>:151' */
      CalibrationMotorbike_v2_DWork.state_Acceleration = 4.0;
      break;

     case CalibrationMo_IN_INIT_DIRECTION:
      /* During 'INIT_DIRECTION': '<S13>:195' */
      if ((counter > 200.0F) && (CalibrationMotorbike_v2_DWork.state_Direction >
           1.0) && ((CalibrationMotorbike_v2_DWork.state_Riding == 5.0) ||
                    (CalibrationMotorbike_v2_DWork.state_Riding == 3.0)))
      {
        /* Transition: '<S13>:196' */
        if (CalibrationMotorbike_v2_DWork.state_Riding == 5.0)
        {
          /* Transition: '<S13>:205' */
          CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
            Calibr_IN_DIRECTION_FOUND_ACCEL;

          /* Entry 'DIRECTION_FOUND_ACCEL': '<S13>:200' */
          CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd =
            CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage;
        }
        else
        {
          /* Transition: '<S13>:208' */
          CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
            Calibr_IN_DIRECTION_FOUND_BREAK;

          /* Entry 'DIRECTION_FOUND_BREAK': '<S13>:206' */
          CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd =
            CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage +
            180.0;
          if (CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd > 360.0)
          {
            CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd -= 360.0;
          }
        }
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Acceleration = 0.0;
        CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd = -1.0;
      }
      break;

     default:
      /* During 'STATIONARY': '<S13>:151' */
      if (counter > 300.0F)
      {
        /* Transition: '<S13>:192' */
        if (fabs(CalibrationMotorbike_angle_diff
                 (CalibrationMotorbike_v2_DWork.MovingAverage2.Direction_absAverage,
                  CalibrationMotorbike_v2_DWork.rough_direction_angle_fwd)) <
            90.0)
        {
          /* Transition: '<S13>:153' */
          CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
            Calibr_IN_ACCELERATION_POSITIVE;

          /* Entry 'ACCELERATION_POSITIVE': '<S13>:152' */
          CalibrationMotorbike_v2_DWork.state_Acceleration = 5.0;
        }
        else
        {
          /* Transition: '<S13>:156' */
          CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
            Calibr_IN_ACCELERATION_NEGATIVE;

          /* Entry 'ACCELERATION_NEGATIVE': '<S13>:157' */
          CalibrationMotorbike_v2_DWork.state_Acceleration = 3.0;
        }
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Acceleration = 4.0;
      }
      break;
    }

    Calibra_RIDING_STATE_ESTIMATION();

    /* During 'CURVE_STATE_ESTIMATION': '<S13>:163' */
    if ((int32_T)CalibrationMotorbike_v2_DWork.is_CURVE_STATE_ESTIMATION == 1)
    {
      /* During 'CURVE': '<S13>:83' */
      if (gyrSfmdegs_FiltAverage < 4000.0)
      {
        /* Transition: '<S13>:86' */
        CalibrationMotorbike_v2_DWork.is_CURVE_STATE_ESTIMATION =
          CalibrationMotorbik_IN_STRAIGHT;

        /* Entry 'STRAIGHT': '<S13>:82' */
        counter_0 = 0.0;
      }
      else
      {
        counter_0 = 1.0;
      }
    }
    else
    {
      /* During 'STRAIGHT': '<S13>:82' */
      if (gyrSfmdegs_FiltAverage > 6000.0)
      {
        /* Transition: '<S13>:85' */
        CalibrationMotorbike_v2_DWork.is_CURVE_STATE_ESTIMATION =
          CalibrationMotorbike_v_IN_CURVE;

        /* Entry 'CURVE': '<S13>:83' */
        counter_0 = 1.0;
      }
      else
      {
        counter_0 = 0.0;
      }
    }

    /* During 'STABLEDIRECTION_STATE_ESTIMATION': '<S13>:165' */
    switch (CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA)
    {
     case CalibrationM_IN_KNOWN_DIRECTION:
      /* During 'KNOWN_DIRECTION': '<S13>:100' */
      if ((a > 15.0) ||
          (CalibrationMotorbike_v2_DWork.MovingAverage1.Direction_absAverage <
           50.0))
      {
        /* Transition: '<S13>:102' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          Calibratio_IN_UNKNOWN_DIRECTION;

        /* Entry 'UNKNOWN_DIRECTION': '<S13>:98' */
        CalibrationMotorbike_v2_DWork.state_Direction = 0.0;
      }
      else if ((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i3 >=
               100U)
      {
        /* Transition: '<S13>:219' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          Calibration_IN_STABLE_DIRECTION;
        CalibrationMotorbike_v2_DWork.temporalCounter_i3 = 0U;

        /* Entry 'STABLE_DIRECTION': '<S13>:239' */
        CalibrationMotorbike_v2_DWork.state_Direction = 2.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Direction = 1.0;
      }
      break;

     case Calibration_IN_STABLE_DIRECTION:
      /* During 'STABLE_DIRECTION': '<S13>:239' */
      if (((uint32_T)CalibrationMotorbike_v2_DWork.temporalCounter_i3 >= 200U) &&
          (a < 1.0))
      {
        /* Transition: '<S13>:237' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          Calibrat_IN_TRUSTABLE_DIRECTION;

        /* Entry 'TRUSTABLE_DIRECTION': '<S13>:240' */
        CalibrationMotorbike_v2_DWork.state_Direction = 3.0;
      }
      else if ((a > 20.0) ||
               (CalibrationMotorbike_v2_DWork.MovingAverage1.Direction_absAverage
                < 40.0))
      {
        /* Transition: '<S13>:244' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          Calibratio_IN_UNKNOWN_DIRECTION;

        /* Entry 'UNKNOWN_DIRECTION': '<S13>:98' */
        CalibrationMotorbike_v2_DWork.state_Direction = 0.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Direction = 2.0;
      }
      break;

     case Calibrat_IN_TRUSTABLE_DIRECTION:
      /* During 'TRUSTABLE_DIRECTION': '<S13>:240' */
      if (a > 5.0)
      {
        /* Transition: '<S13>:241' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          Calibratio_IN_UNKNOWN_DIRECTION;

        /* Entry 'UNKNOWN_DIRECTION': '<S13>:98' */
        CalibrationMotorbike_v2_DWork.state_Direction = 0.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Direction = 3.0;
      }
      break;

     default:
      /* During 'UNKNOWN_DIRECTION': '<S13>:98' */
      if ((a < 10.0) &&
          (CalibrationMotorbike_v2_DWork.MovingAverage1.Direction_absAverage >
           100.0))
      {
        /* Transition: '<S13>:101' */
        CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
          CalibrationM_IN_KNOWN_DIRECTION;
        CalibrationMotorbike_v2_DWork.temporalCounter_i3 = 0U;

        /* Entry 'KNOWN_DIRECTION': '<S13>:100' */
        CalibrationMotorbike_v2_DWork.state_Direction = 1.0;
      }
      else
      {
        CalibrationMotorbike_v2_DWork.state_Direction = 0.0;
      }
      break;
    }

    Cal_CALIBRATION_STATE_ESTIMATOR(&Divide, &gyrSfmdegs_FiltAverage, &counter_0);
  }

  for (i = 0; i < 5; i++)
  {
    /* UnitDelay: '<S9>/Unit Delay' */
    counter_0 = CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_i[i];

    /* UnitDelay: '<S9>/Unit Delay3' */
    COCA_rtb_UnitDelay3_p[i] =
      CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_o[i];

    /* Product: '<S9>/Divide' incorporates:
     *  Gain: '<S9>/Gain2'
     *  Product: '<S9>/Product1'
     *  Product: '<S9>/Product2'
     *  Product: '<S9>/Product3'
     *  Product: '<S9>/Product7'
     *  Product: '<S9>/Product9'
     *  Sum: '<S9>/Add'
     *  Sum: '<S9>/Add1'
     *  Sum: '<S9>/Add4'
     *  UnitDelay: '<S9>/Unit Delay1'
     *  UnitDelay: '<S9>/Unit Delay3'
     *  UnitDelay: '<S9>/Unit Delay4'
     */
    a = (((2.0 * counter_0 * 0.3947841760435743 + 0.3947841760435743 *
           CalibrationMotorbike_v2_DWork.Calibration_Vector[i]) +
          0.3947841760435743 *
          CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f[i]) -
         (-79999.210431647909 *
          CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_o[i] +
          39822.679466649708 *
          CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_g[i])) /
      40178.110101702383;

    /* DataTypeConversion: '<Root>/Cast To Single' */
    COCA_rtb_CastToSingle[i] = (real32_T)a;

    /* UnitDelay: '<S9>/Unit Delay' */
    COCA_rtb_UnitDelay_c[i] = counter_0;

    /* Product: '<S9>/Divide' */
    COCA_rtb_Divide_jd[i] = a;
  }

  /* FunctionCaller: '<Root>/Function Caller' */
  CalibrationMotorbike_v2_Gravity_2_RotMatrix(&COCA_rtb_CastToSingle[0],
    COCA_rtb_rot_Matrix);

  /* RelationalOperator: '<Root>/GreaterThanOrEqual' incorporates:
   *  Constant: '<Root>/Constant15'
   */
  COCA_rtb_GreaterThanOrEqual = (CalibrationMotorbike_v2_DWork.calibrationOUT[0]
    >= 4.0);

  /* MATLAB Function: '<Root>/MATLAB Function1' incorporates:
   *  Inport: '<Root>/initRotMatSf2Bf [3x3]'
   */
  /* MATLAB Function 'MATLAB Function1': '<S16>:1' */
  if ((MOCA_in.initRotMatSf2Bf_3x3[0] + MOCA_in.initRotMatSf2Bf_3x3[4]) +
      MOCA_in.initRotMatSf2Bf_3x3[8] == 3.0F)
  {
    /* '<S16>:1:4' */
    /* '<S16>:1:5' */
    xpageoffset = 0;
  }
  else
  {
    for (i = 0; i < 3; i++)
    {
      xpageoffset = i * 3;
      COCA_rtb_gyrBfmdegs_n = MOCA_in.initRotMatSf2Bf_3x3[xpageoffset];
      COCA_rtb_gyrBfmdegs_n += MOCA_in.initRotMatSf2Bf_3x3[xpageoffset + 1];
      COCA_rtb_gyrBfmdegs_n += MOCA_in.initRotMatSf2Bf_3x3[xpageoffset + 2];
      COCA_rtb_gyrBfmdegs[i] = COCA_rtb_gyrBfmdegs_n;
    }

    if ((COCA_rtb_gyrBfmdegs[0] + COCA_rtb_gyrBfmdegs[1]) + COCA_rtb_gyrBfmdegs
        [2] == 0.0F)
    {
      /* '<S16>:1:4' */
      /* '<S16>:1:5' */
      xpageoffset = 0;
    }
    else
    {
      /* '<S16>:1:7' */
      xpageoffset = 1;
    }
  }

  /* End of MATLAB Function: '<Root>/MATLAB Function1' */

  /* Switch: '<Root>/Switch1' incorporates:
   *  FunctionCaller: '<Root>/Function Caller'
   *  Inport: '<Root>/initRotMatSf2Bf [3x3]'
   *  Switch: '<Root>/Switch'
   */
  if (!COCA_rtb_GreaterThanOrEqual)
  {
    /* Switch: '<Root>/Switch' */
    COCA_rtb_init_valid_0 = (xpageoffset > 0);
    for (i = 0; i < 9; i++)
    {
      COCA_rtb_rot_Matrix_b = COCA_rtb_rot_Matrix[i];
      COCA_rtb_rot_Matrix_g = COCA_rtb_rot_Matrix_b;

      /* Switch: '<Root>/Switch' incorporates:
       *  FunctionCaller: '<Root>/Function Caller'
       *  Inport: '<Root>/initRotMatSf2Bf [3x3]'
       */
      if (COCA_rtb_init_valid_0)
      {
        COCA_rtb_rot_Matrix_g = MOCA_in.initRotMatSf2Bf_3x3[i];
      }

      COCA_rtb_rot_Matrix_b = COCA_rtb_rot_Matrix_g;
      COCA_rtb_rot_Matrix[i] = COCA_rtb_rot_Matrix_b;
    }
  }

  /* End of Switch: '<Root>/Switch1' */

  /* Product: '<Root>/Matrix Multiply' incorporates:
   *  SignalConversion generated from: '<Root>/Matrix Multiply'
   *  Switch: '<Root>/Switch1'
   */
  for (i = 0; i < 3; i++)
  {
    COCA_rtb_gyrBfmdegs_jk = 0.0F;
    COCA_rtb_gyrBfmdegs_jk = COCA_rtb_rot_Matrix[i] * COCA_rtb_accSfX_mg;
    COCA_rtb_gyrBfmdegs_jk += COCA_rtb_rot_Matrix[i + 3] * COCA_rtb_accSfY_mg;
    COCA_rtb_gyrBfmdegs_jk += COCA_rtb_rot_Matrix[i + 6] * COCA_rtb_accSfZ_mg;
    COCA_rtb_gyrBfmdegs[i] = COCA_rtb_gyrBfmdegs_jk;
  }

  /* End of Product: '<Root>/Matrix Multiply' */

  /* DataTypeConversion: '<Root>/Data Type Conversion10' */
  COCA_accBfXmg = (int16_T)COCA_rtb_gyrBfmdegs[0];

  /* DataTypeConversion: '<Root>/Data Type Conversion13' */
  COCA_accBfYmg = (int16_T)COCA_rtb_gyrBfmdegs[1];

  /* DataTypeConversion: '<Root>/Data Type Conversion15' */
  COCA_accBfZmg = (int16_T)COCA_rtb_gyrBfmdegs[2];

  /* Product: '<Root>/Matrix Multiply1' incorporates:
   *  Switch: '<Root>/Switch1'
   */
  for (i = 0; i < 3; i++)
  {
    COCA_rtb_gyrBfmdegs_f0 = 0.0F;
    COCA_rtb_gyrBfmdegs_f0 = COCA_rtb_rot_Matrix[i] * Mprev;
    COCA_rtb_gyrBfmdegs_f0 += COCA_rtb_rot_Matrix[i + 3] *
      COCA_rtb_accSfNorm_Raw;
    COCA_rtb_gyrBfmdegs_f0 += COCA_rtb_rot_Matrix[i + 6] * T;
    COCA_rtb_gyrBfmdegs[i] = COCA_rtb_gyrBfmdegs_f0;
  }

  /* End of Product: '<Root>/Matrix Multiply1' */

  /* DataTypeConversion: '<Root>/Data Type Conversion16' */
  COCA_gyrBfXmdegs = (int32_T)COCA_rtb_gyrBfmdegs[0];

  /* DataTypeConversion: '<Root>/Data Type Conversion17' */
  COCA_gyrBfYmdegs = (int32_T)COCA_rtb_gyrBfmdegs[1];

  /* DataTypeConversion: '<Root>/Data Type Conversion18' */
  COCA_gyrBfZmdegs = (int32_T)COCA_rtb_gyrBfmdegs[2];

  /* DataTypeConversion: '<Root>/Data Type Conversion19' incorporates:
   *  Constant: '<Root>/Constant17'
   *  Logic: '<Root>/Logical Operator'
   *  Logic: '<Root>/Logical Operator1'
   *  RelationalOperator: '<Root>/GreaterThanOrEqual1'
   */
  COCA_calibrationFlag = (int16_T)((COCA_rtb_GreaterThanOrEqual || (xpageoffset
    != 0)) && (CalibrationMotorbike_v2_DWork.state_Ignition >= 1.0) ? 1 : 0);
  for (i = 0; i < 9; i++)
  {
    /* DataTypeConversion: '<Root>/Data Type Conversion23' incorporates:
     *  Switch: '<Root>/Switch1'
     */
    MOCA_out.rotMatSf2BfOut_3x3[i] = COCA_rtb_rot_Matrix[i];
  }

  /* Logic: '<Root>/NOT' incorporates:
   *  Constant: '<Root>/Constant18'
   *  Logic: '<Root>/Logical Operator2'
   *  RelationalOperator: '<Root>/GreaterThan'
   */
  COCA_rtb_GreaterThanOrEqual = ((!COCA_rtb_GreaterThanOrEqual) ||
    (gyrSfmdegs_FiltAverage <= 0.0));

  /* DataTypeConversion: '<Root>/Data Type Conversion27' incorporates:
   *  Delay: '<S15>/Delay'
   *  Logic: '<S15>/Logical Operator'
   *  Logic: '<S15>/Logical Operator1'
   */
  MOCA_out.rotMatUpdate = (int16_T)(COCA_rtb_GreaterThanOrEqual &&
    (!CalibrationMotorbike_v2_DWork.Delay_DSTATE) ? 1 : 0);

  /* Update for UnitDelay: '<S10>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE = COCA_rtb_Min1;

  /* Update for UnitDelay: '<S10>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE = COCA_rtb_UnitDelay;

  /* Update for UnitDelay: '<S10>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE = Divide;

  /* Update for UnitDelay: '<S10>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE = COCA_rtb_UnitDelay3;

  /* Update for UnitDelay: '<S8>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[0] = Mprev;

  /* Update for UnitDelay: '<S8>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[0] = S;

  /* Update for UnitDelay: '<S8>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[0] = COCA_rtb_Divide_idx_0;

  /* Update for UnitDelay: '<S8>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[0] =
    COCA_rtb_UnitDelay3_o_idx_0;

  /* Update for UnitDelay: '<S8>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[1] = COCA_rtb_accSfNorm_Raw;

  /* Update for UnitDelay: '<S8>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[1] = M;

  /* Update for UnitDelay: '<S8>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[1] = COCA_rtb_Divide_idx_1;

  /* Update for UnitDelay: '<S8>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[1] =
    COCA_rtb_UnitDelay3_o_idx_1;

  /* Update for UnitDelay: '<S8>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_c[2] = T;

  /* Update for UnitDelay: '<S8>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f5[2] =
    COCA_rtb_UnitDelay_d_idx_2;

  /* Update for UnitDelay: '<S8>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_p[2] = COCA_rtb_Divide_idx_2;

  /* Update for UnitDelay: '<S8>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_l[2] =
    COCA_rtb_UnitDelay3_o_idx_2;

  /* Update for UnitDelay: '<S5>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_o =
    CalibrationMotorbike_v2_DWork.sf_SmartFilter2_b.y_out;

  /* Update for UnitDelay: '<S5>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_l = COCA_rtb_Sqrt2;

  /* Update for UnitDelay: '<S5>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_j = csum;

  /* Update for UnitDelay: '<S5>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_e = cumRevIndex;

  /* Update for UnitDelay: '<S6>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_m =
    CalibrationMotorbike_v2_DWork.sf_SmartFilter2.y_out;

  /* Update for UnitDelay: '<S6>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_j = z;

  /* Update for UnitDelay: '<S6>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_c = COCA_rtb_Divide_iu;

  /* Update for UnitDelay: '<S6>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_c = COCA_rtb_UnitDelay3_c;

  /* Update for UnitDelay: '<S7>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_e =
    CalibrationMotorbike_v2_DWork.sf_SmartFilter2_j.y_out;

  /* Update for UnitDelay: '<S7>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_d = COCA_rtb_UnitDelay_m;

  /* Update for UnitDelay: '<S7>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_cs = COCA_rtb_Divide_k;

  /* Update for UnitDelay: '<S7>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_b = COCA_rtb_UnitDelay3_f;

  /* Update for UnitDelay: '<S12>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_ob = COCA_rtb_y_rot;

  /* Update for UnitDelay: '<S12>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_k = COCA_rtb_UnitDelay_gd;

  /* Update for UnitDelay: '<S12>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_g = n2;

  /* Update for UnitDelay: '<S12>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_o = n1;

  /* Update for UnitDelay: '<S4>/Unit Delay' */
  CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_n = COCA_rtb_z_rot;

  /* Update for UnitDelay: '<S4>/Unit Delay1' */
  CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_n = COCA_rtb_UnitDelay_kh;

  /* Update for UnitDelay: '<S4>/Unit Delay3' */
  CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_pt = COCA_rtb_Divide_n;

  /* Update for UnitDelay: '<S4>/Unit Delay4' */
  CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_j = n3;
  for (i = 0; i < 5; i++)
  {
    /* Update for UnitDelay: '<S9>/Unit Delay' */
    CalibrationMotorbike_v2_DWork.UnitDelay_DSTATE_i[i] =
      CalibrationMotorbike_v2_DWork.Calibration_Vector[i];

    /* Update for UnitDelay: '<S9>/Unit Delay1' */
    CalibrationMotorbike_v2_DWork.UnitDelay1_DSTATE_f[i] =
      COCA_rtb_UnitDelay_c[i];

    /* Update for UnitDelay: '<S9>/Unit Delay3' */
    CalibrationMotorbike_v2_DWork.UnitDelay3_DSTATE_o[i] = COCA_rtb_Divide_jd[i];

    /* Update for UnitDelay: '<S9>/Unit Delay4' */
    CalibrationMotorbike_v2_DWork.UnitDelay4_DSTATE_g[i] =
      COCA_rtb_UnitDelay3_p[i];
  }

  /* Update for Delay: '<S15>/Delay' */
  CalibrationMotorbike_v2_DWork.Delay_DSTATE = COCA_rtb_GreaterThanOrEqual;
}

/* Model initialize function */
void CalibrationMotorbike_v2_initialize(void)
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
  (void) memset((void *)&CalibrationMotorbike_v2_DWork, 0,
                sizeof(D_Work_CalibrationMotorbike_v2));

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

  {
    dsp_simulink_MovingAverage_Ca_h *obj_1;
    dsp_simulink_MovingVariance_C_h *obj_3;
    dsp_simulink_MovingVariance_Cal *obj;
    g_dsp_private_SlidingWindowA_hd *obj_2;
    g_dsp_private_SlidingWindowVa_h *obj_4;
    g_dsp_private_SlidingWindowVari *obj_0;
    int32_T i;

    /* InitializeConditions for Delay: '<S15>/Delay' */
    CalibrationMotorbike_v2_DWork.Delay_DSTATE = true;

    /* SystemInitialize for MATLAB Function: '<S20>/SmartFilter2' */
    CalibrationMo_SmartFilter2_Init
      (&CalibrationMotorbike_v2_DWork.sf_SmartFilter2_b);

    /* SystemInitialize for MATLAB Function: '<S19>/SmartFilter2' */
    CalibrationMo_SmartFilter2_Init
      (&CalibrationMotorbike_v2_DWork.sf_SmartFilter2);

    /* SystemInitialize for MATLAB Function: '<S21>/SmartFilter2' */
    CalibrationMo_SmartFilter2_Init
      (&CalibrationMotorbike_v2_DWork.sf_SmartFilter2_j);

    /* SystemInitialize for MATLAB Function: '<Root>/Direction_Vector' */
    CalibrationMotorbike_v2_DWork.abs_max = 0.0;

    /* SystemInitialize for Chart: '<Root>/CalibrationState' */
    CalibrationMotorbike_v2_DWork.is_ACCELERATION_STATE_ESTIMATOR =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.is_CALIBRATION_STATE_ESTIMATOR =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.is_ENGINE_ON = CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.is_CURVE_STATE_ESTIMATION =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.is_ENGINE_STATE_ESTIMATOR =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.temporalCounter_i1 = 0U;
    CalibrationMotorbike_v2_DWork.is_RIDING_STATE_ESTIMATION =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.is_RIDING = CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.temporalCounter_i2 = 0U;
    CalibrationMotorbike_v2_DWork.is_STABLEDIRECTION_STATE_ESTIMA =
      CalibrationM_IN_NO_ACTIVE_CHILD;
    CalibrationMotorbike_v2_DWork.temporalCounter_i3 = 0U;
    CalibrationMotorbike_v2_DWork.is_active_c12_CalibrationMotorb = 0U;
    CalibrationMotorbike_v2_DWork.calibration.state = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n_standing = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n_riding = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n_breaking = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n_acclerating = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.n_block = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.last_state = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_standing = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_riding = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_breaking = 0.0;
    CalibrationMotorbike_v2_DWork.calibration.blockCnt_acclerating = 0.0;

    /* Start for MATLABSystem: '<Root>/Moving Variance2' */
    CalibrationMotorbike_v2_DWork.obj_l.matlabCodegenIsDeleted = true;
    CalibrationMotorbike_v2_DWork.obj_l.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj_l.NumChannels = -1;
    CalibrationMotorbike_v2_DWork.obj_l.matlabCodegenIsDeleted = false;
    obj = &CalibrationMotorbike_v2_DWork.obj_l;
    CalibrationMotorbike_v2_DWork.obj_l.isSetupComplete = false;
    CalibrationMotorbike_v2_DWork.obj_l.isInitialized = 1;
    CalibrationMotorbike_v2_DWork.obj_l.NumChannels = 1;
    obj->_pobj0.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj_l.pStatistic = &obj->_pobj0;
    CalibrationMotorbike_v2_DWork.obj_l.isSetupComplete = true;
    CalibrationMotorbike_v2_DWork.obj_l.TunablePropsChanged = false;

    /* InitializeConditions for MATLABSystem: '<Root>/Moving Variance2' */
    obj_0 = CalibrationMotorbike_v2_DWork.obj_l.pStatistic;
    if (obj_0->isInitialized == 1)
    {
      for (i = 0; i < 40; i++)
      {
        obj_0->pReverseSamples[i] = 0.0F;
      }

      for (i = 0; i < 40; i++)
      {
        obj_0->pReverseT[i] = 0.0F;
      }

      for (i = 0; i < 40; i++)
      {
        obj_0->pReverseS[i] = 0.0F;
      }

      obj_0->pT = 0.0F;
      obj_0->pS = 0.0F;
      obj_0->pM = 0.0F;
      obj_0->pCounter = 1.0F;
    }

    /* End of InitializeConditions for MATLABSystem: '<Root>/Moving Variance2' */

    /* Start for MATLABSystem: '<Root>/Moving Average' */
    CalibrationMotorbike_v2_DWork.obj_d.matlabCodegenIsDeleted = true;
    CalibrationMotorbike_v2_DWork.obj_d.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj_d.NumChannels = -1;
    CalibrationMotorbike_v2_DWork.obj_d.matlabCodegenIsDeleted = false;
    obj_1 = &CalibrationMotorbike_v2_DWork.obj_d;
    CalibrationMotorbike_v2_DWork.obj_d.isSetupComplete = false;
    CalibrationMotorbike_v2_DWork.obj_d.isInitialized = 1;
    CalibrationMotorbike_v2_DWork.obj_d.NumChannels = 1;
    obj_1->_pobj0.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj_d.pStatistic = &obj_1->_pobj0;
    CalibrationMotorbike_v2_DWork.obj_d.isSetupComplete = true;
    CalibrationMotorbike_v2_DWork.obj_d.TunablePropsChanged = false;

    /* InitializeConditions for MATLABSystem: '<Root>/Moving Average' */
    obj_2 = CalibrationMotorbike_v2_DWork.obj_d.pStatistic;
    if (obj_2->isInitialized == 1)
    {
      obj_2->pCumSum = 0.0;
      for (i = 0; i < 9; i++)
      {
        obj_2->pCumSumRev[i] = 0.0;
      }

      obj_2->pCumRevIndex = 1.0;
    }

    /* End of InitializeConditions for MATLABSystem: '<Root>/Moving Average' */
    Calibration_MovingAverage2_Init
      (&CalibrationMotorbike_v2_DWork.MovingAverage2_pn);
    C_MovingStandardDeviation2_Init
      (&CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_p);
    Calibration_MovingAverage2_Init
      (&CalibrationMotorbike_v2_DWork.MovingAverage2_p);
    C_MovingStandardDeviation2_Init
      (&CalibrationMotorbike_v2_DWork.MovingStandardDeviation2);
    Calibration_MovingAverage2_Init
      (&CalibrationMotorbike_v2_DWork.MovingAverage2_pna);
    C_MovingStandardDeviation2_Init
      (&CalibrationMotorbike_v2_DWork.MovingStandardDeviation2_pn);
    Calibration_MovingAverage1_Init
      (&CalibrationMotorbike_v2_DWork.MovingAverage1);

    /* Start for MATLABSystem: '<Root>/Moving Variance4' */
    CalibrationMotorbike_v2_DWork.obj.matlabCodegenIsDeleted = true;
    CalibrationMotorbike_v2_DWork.obj.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj.NumChannels = -1;
    CalibrationMotorbike_v2_DWork.obj.matlabCodegenIsDeleted = false;
    obj_3 = &CalibrationMotorbike_v2_DWork.obj;
    CalibrationMotorbike_v2_DWork.obj.isSetupComplete = false;
    CalibrationMotorbike_v2_DWork.obj.isInitialized = 1;
    CalibrationMotorbike_v2_DWork.obj.NumChannels = 1;
    obj_3->_pobj0.isInitialized = 0;
    CalibrationMotorbike_v2_DWork.obj.pStatistic = &obj_3->_pobj0;
    CalibrationMotorbike_v2_DWork.obj.isSetupComplete = true;
    CalibrationMotorbike_v2_DWork.obj.TunablePropsChanged = false;

    /* InitializeConditions for MATLABSystem: '<Root>/Moving Variance4' */
    obj_4 = CalibrationMotorbike_v2_DWork.obj.pStatistic;
    if (obj_4->isInitialized == 1)
    {
      for (i = 0; i < 50; i++)
      {
        obj_4->pReverseSamples[i] = 0.0;
      }

      for (i = 0; i < 50; i++)
      {
        obj_4->pReverseT[i] = 0.0;
      }

      for (i = 0; i < 50; i++)
      {
        obj_4->pReverseS[i] = 0.0;
      }

      obj_4->pT = 0.0;
      obj_4->pS = 0.0;
      obj_4->pM = 0.0;
      obj_4->pCounter = 1.0;
    }

    /* End of InitializeConditions for MATLABSystem: '<Root>/Moving Variance4' */
    Calibration_MovingAverage1_Init
      (&CalibrationMotorbike_v2_DWork.MovingAverage2);
  }
}

/*
 * File trailer for Real-Time Workshop generated code.
 *
 * [EOF]
 */
