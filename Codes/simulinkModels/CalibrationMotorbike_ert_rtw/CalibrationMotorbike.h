/*
 * File: CalibrationMotorbike.h
 *
 * Code generated for Simulink model 'CalibrationMotorbike'.
 *
 * Model version                  : 1.1438
 * Simulink Coder version         : 9.1 (R2019a) 23-Nov-2018
 * C/C++ source code generated on : Wed Jul  8 17:53:59 2020
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

#ifndef RTW_HEADER_CalibrationMotorbike_h_
#define RTW_HEADER_CalibrationMotorbike_h_
#include <math.h>
#include <string.h>
#ifndef CalibrationMotorbike_COMMON_INCLUDES_
# define CalibrationMotorbike_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                               /* CalibrationMotorbike_COMMON_INCLUDES_ */

/* Includes for objects with custom storage classes. */
#include "Sensordata.h"

/* Macros for accessing real-time model data structure */

/* Block signals and states (default storage) for system '<Root>' */

extern real32_T calibrationModuleVersion;

typedef struct
{
  real_T AtmPressureFilt;              /* '<S4>/Divide' */
  real_T UnitDelay3_DSTATE;            /* '<S1>/Unit Delay3' */
  real_T UnitDelay4_DSTATE;            /* '<S1>/Unit Delay4' */
  real_T UnitDelay3_DSTATE_j;          /* '<S2>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_f;          /* '<S2>/Unit Delay4' */
  real_T UnitDelay3_DSTATE_p;          /* '<S3>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_n;          /* '<S3>/Unit Delay4' */
  real_T UnitDelay4_DSTATE_e;          /* '<S4>/Unit Delay4' */
  real_T UnitDelay3_DSTATE_h;          /* '<S5>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_nq;         /* '<S5>/Unit Delay4' */
  real_T SE_initPressure;              /* '<Root>/SlopeEstimation' */
  real_T SE_initPressure2;             /* '<Root>/SlopeEstimation' */
  real32_T ringBufGyrX[300];           /* '<Root>/MATLAB Function2' */
  real32_T ringBufGyrY[300];           /* '<Root>/MATLAB Function2' */
  real32_T ringBufGyrZ[300];           /* '<Root>/MATLAB Function2' */
  real32_T accSfVecRidingConstant[3];  /* '<Root>/MATLAB Function' */
  real32_T longAccVecSf[3];            /* '<Root>/MATLAB Function' */
  real32_T rotMatSf2Bf[9];             /* '<Root>/MATLAB Function' */
  real32_T gyrSfX_mdegs;               /* '<Root>/Data Type Conversion8' */
  real32_T gyrSfY_mdegs;               /* '<Root>/Data Type Conversion9' */
  real32_T gyrSfZ_mdegs;               /* '<Root>/Data Type Conversion7' */
  real32_T pressure_Pa;                /* '<Root>/Data Type Conversion12' */
  real32_T AtmPressureFiltTransFer;    /* '<S11>/Sum' */
  real32_T speedKmh_filt;              /* '<S12>/Sum' */
  real32_T curSlopePressureFilt;       /* '<S14>/Sum' */
  real32_T curSlopePressure;           /* '<Root>/SlopeEstimation' */
  real32_T SE_timer;                   /* '<Root>/SlopeEstimation' */
  real32_T SE_2EstFlag;                /* '<Root>/SlopeEstimation' */
  real32_T RSD_accSfXExtrema;          /* '<Root>/RSD_RidingStateDetection' */
  real32_T RSD_accSfYExtrema;          /* '<Root>/RSD_RidingStateDetection' */
  real32_T RSD_accSfZExtrema;          /* '<Root>/RSD_RidingStateDetection' */
  real32_T UnitDelay_DSTATE;           /* '<S1>/Unit Delay' */
  real32_T UnitDelay1_DSTATE;          /* '<S1>/Unit Delay1' */
  real32_T UnitDelay_DSTATE_n;         /* '<S2>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_f;        /* '<S2>/Unit Delay1' */
  real32_T UnitDelay_DSTATE_nf;        /* '<S3>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_p;        /* '<S3>/Unit Delay1' */
  real32_T UD_DSTATE;                  /* '<S13>/UD' */
  real32_T UD_DSTATE_j;                /* '<S6>/UD' */
  real32_T UnitDelay_DSTATE_k;         /* '<Root>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_i;        /* '<Root>/Unit Delay1' */
  real32_T UnitDelay_DSTATE_e;         /* '<S4>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_h;        /* '<S4>/Unit Delay1' */
  real32_T UnitDelay2_DSTATE;          /* '<S4>/Unit Delay2' */
  real32_T UD_DSTATE_e;                /* '<S11>/UD' */
  real32_T UnitDelay_DSTATE_c;         /* '<S5>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_a;        /* '<S5>/Unit Delay1' */
  real32_T SE_curDistanceM;            /* '<Root>/SlopeEstimation' */
  real32_T SE_curDistance2M;           /* '<Root>/SlopeEstimation' */
  real32_T RSD_curExtrema;             /* '<Root>/RSD_RidingStateDetection' */
  real32_T RSD_curAccExtrema;          /* '<Root>/RSD_RidingStateDetection' */
  real32_T accSFFiltNormRidingConstant;/* '<Root>/MATLAB Function' */
  int16_T i;                           /* '<Root>/MATLAB Function2' */
  uint16_T RSD_constantRiding;         /* '<Root>/RSD_RidingStateDetection' */
  uint16_T RSD_decelerationFlag;       /* '<Root>/RSD_RidingStateDetection' */
  uint16_T RSD_accNormExtremaFlag;     /* '<Root>/RSD_RidingStateDetection' */
  uint16_T RSD_accelerationFlag;       /* '<Root>/RSD_RidingStateDetection' */
  uint16_T RSD_accExtremaFlag;         /* '<Root>/RSD_RidingStateDetection' */
  uint16_T UnitDelay2_DSTATE_n;        /* '<Root>/Unit Delay2' */
  uint16_T temporalCounter_i1;         /* '<Root>/RSD_RidingStateDetection' */
  uint16_T temporalCounter_i2;         /* '<Root>/RSD_RidingStateDetection' */
  uint16_T temporalCounter_i3;         /* '<Root>/RSD_RidingStateDetection' */
  uint16_T firstRidindConstantFlag;    /* '<Root>/MATLAB Function' */
  uint16_T firstLongAccFlag;           /* '<Root>/MATLAB Function' */
  uint16_T calibFlag;                  /* '<Root>/MATLAB Function' */
  uint8_T is_active_c1_CalibrationMotorbi;/* '<Root>/SlopeEstimation' */
  uint8_T is_Slope1;                   /* '<Root>/SlopeEstimation' */
  uint8_T is_Slope2;                   /* '<Root>/SlopeEstimation' */
  uint8_T temporalCounter_i1_i;        /* '<Root>/SlopeEstimation' */
  uint8_T temporalCounter_i2_l;        /* '<Root>/SlopeEstimation' */
  uint8_T is_active_c3_CalibrationMotorbi;/* '<Root>/RSD_RidingStateDetection' */
  uint8_T is_CheckForConstantRiding;   /* '<Root>/RSD_RidingStateDetection' */
  uint8_T is_CheckForDeceleration;     /* '<Root>/RSD_RidingStateDetection' */
  uint8_T is_CheckForAccNormMax;       /* '<Root>/RSD_RidingStateDetection' */
  uint8_T is_CheckForAccelerationPhase;/* '<Root>/RSD_RidingStateDetection' */
  uint8_T is_CheckForAccNormMaxAccelerati;/* '<Root>/RSD_RidingStateDetection' */
  boolean_T calibFlag_not_empty;       /* '<Root>/MATLAB Function' */
}
D_Work_CalibrationMotorbike;

/* Type definition for custom storage class: Struct */
typedef struct MOCA_in_tag
{
  real32_T initRotMatSf2Bf_3x3[9];
}
MOCA_in_type;

typedef struct MOCA_out_tag
{
  real32_T rotMatSf2BfOut_3x3[9];
  int16_T rotMatUpdate;
}
MOCA_out_type;

typedef struct MOCA_par_tag
{
  real32_T maxAngleChange_deg;
  real32_T maxLongAccNorm_mg;
  real32_T minLongAccNorm_mg;
  real32_T minSpeedRSD_kmh;
  real32_T samplePeriod_s;
}
MOCA_par_type;

/* Block signals and states (default storage) */
extern D_Work_CalibrationMotorbike CalibrationMotorbike_DWork;

/* Model entry point functions */
void CalibrationMotorbike_initialize(void);
void CalibrationMotorbike_step(void);

/* Exported data declaration */

/* Declaration for custom storage class: ImportFromFile */
extern int16_T COCA_accBfXmg;
extern int16_T COCA_accBfYmg;
extern int16_T COCA_accBfZmg;
extern int16_T COCA_calibrationFlag;
extern int32_T COCA_gyrBfXmdegs;
extern int32_T COCA_gyrBfYmdegs;
extern int32_T COCA_gyrBfZmdegs;

/* Declaration for custom storage class: Struct */
extern MOCA_in_type MOCA_in;
extern MOCA_out_type MOCA_out;
extern MOCA_par_type MOCA_par;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'CalibrationMotorbike'
 * '<S1>'   : 'CalibrationMotorbike/Butterworth2nd1'
 * '<S2>'   : 'CalibrationMotorbike/Butterworth2nd2'
 * '<S3>'   : 'CalibrationMotorbike/Butterworth2nd3'
 * '<S4>'   : 'CalibrationMotorbike/Butterworth2nd4'
 * '<S5>'   : 'CalibrationMotorbike/Butterworth2nd5'
 * '<S6>'   : 'CalibrationMotorbike/Discrete Derivative'
 * '<S7>'   : 'CalibrationMotorbike/MATLAB Function'
 * '<S8>'   : 'CalibrationMotorbike/MATLAB Function2'
 * '<S9>'   : 'CalibrationMotorbike/RSD_RidingStateDetection'
 * '<S10>'  : 'CalibrationMotorbike/SlopeEstimation'
 * '<S11>'  : 'CalibrationMotorbike/Transfer Fcn First Order2'
 * '<S12>'  : 'CalibrationMotorbike/Transfer Fcn First Order3'
 * '<S13>'  : 'CalibrationMotorbike/Transfer Fcn First Order4'
 * '<S14>'  : 'CalibrationMotorbike/Transfer Fcn First Order9'
 * '<S15>'  : 'CalibrationMotorbike/Butterworth2nd4/Compare To Constant'
 */
#endif                                 /* RTW_HEADER_CalibrationMotorbike_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
