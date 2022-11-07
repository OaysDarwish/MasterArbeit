/*
 * File: CalibrationMotorbike_v2.h
 *
 * Code generated for Simulink model 'CalibrationMotorbike_v2'.
 *
 * Model version                  : 4.9
 * Simulink Coder version         : 9.4 (R2020b) 29-Jul-2020
 * C/C++ source code generated on : Sat Jul 30 14:27:26 2022
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

#ifndef RTW_HEADER_CalibrationMotorbike_v2_h_
#define RTW_HEADER_CalibrationMotorbike_v2_h_
#include "rtwtypes.h"
#include <math.h>
#include <string.h>
#ifndef CalibrationMotorbike_v2_COMMON_INCLUDES_
#define CalibrationMotorbike_v2_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                            /* CalibrationMotorbike_v2_COMMON_INCLUDES_ */

/* Model Code Variants */

/* Includes for objects with custom storage classes. */
#include "Sensordata.h"

/* Macros for accessing real-time model data structure */
#ifndef struct_tag_7QELo3J0lMISPuuu3CQZ0B
#define struct_tag_7QELo3J0lMISPuuu3CQZ0B

struct tag_7QELo3J0lMISPuuu3CQZ0B
{
  int32_T isInitialized;
  boolean_T isSetupComplete;
  real_T pCumSum;
  real_T pCumSumRev[49];
  real_T pCumRevIndex;
};

#endif                                 /*struct_tag_7QELo3J0lMISPuuu3CQZ0B*/

#ifndef typedef_g_dsp_private_SlidingWindowAver
#define typedef_g_dsp_private_SlidingWindowAver

typedef struct tag_7QELo3J0lMISPuuu3CQZ0B g_dsp_private_SlidingWindowAver;

#endif                               /*typedef_g_dsp_private_SlidingWindowAver*/

#ifndef struct_tag_PMfBDzoakfdM9QAdfx2o6D
#define struct_tag_PMfBDzoakfdM9QAdfx2o6D

struct tag_PMfBDzoakfdM9QAdfx2o6D
{
  uint32_T f1[8];
};

#endif                                 /*struct_tag_PMfBDzoakfdM9QAdfx2o6D*/

#ifndef typedef_cell_wrap_CalibrationMotorbike_
#define typedef_cell_wrap_CalibrationMotorbike_

typedef struct tag_PMfBDzoakfdM9QAdfx2o6D cell_wrap_CalibrationMotorbike_;

#endif                               /*typedef_cell_wrap_CalibrationMotorbike_*/

#ifndef struct_tag_RX7Vsy7zw2aPY01krLbKaC
#define struct_tag_RX7Vsy7zw2aPY01krLbKaC

struct tag_RX7Vsy7zw2aPY01krLbKaC
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowAver *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowAver _pobj0;
};

#endif                                 /*struct_tag_RX7Vsy7zw2aPY01krLbKaC*/

#ifndef typedef_dsp_simulink_MovingAverage_Cali
#define typedef_dsp_simulink_MovingAverage_Cali

typedef struct tag_RX7Vsy7zw2aPY01krLbKaC dsp_simulink_MovingAverage_Cali;

#endif                               /*typedef_dsp_simulink_MovingAverage_Cali*/

#ifndef struct_tag_fHfGlre2Dbf7tK7LNIDBuD
#define struct_tag_fHfGlre2Dbf7tK7LNIDBuD

struct tag_fHfGlre2Dbf7tK7LNIDBuD
{
  int32_T isInitialized;
  boolean_T isSetupComplete;
  real32_T pCumSum;
  real32_T pCumSumRev[39];
  real32_T pCumRevIndex;
};

#endif                                 /*struct_tag_fHfGlre2Dbf7tK7LNIDBuD*/

#ifndef typedef_g_dsp_private_SlidingWindowAv_h
#define typedef_g_dsp_private_SlidingWindowAv_h

typedef struct tag_fHfGlre2Dbf7tK7LNIDBuD g_dsp_private_SlidingWindowAv_h;

#endif                               /*typedef_g_dsp_private_SlidingWindowAv_h*/

#ifndef struct_tag_3PXL3p0DR1x0QqyihvQWzF
#define struct_tag_3PXL3p0DR1x0QqyihvQWzF

struct tag_3PXL3p0DR1x0QqyihvQWzF
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowAv_h *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowAv_h _pobj0;
};

#endif                                 /*struct_tag_3PXL3p0DR1x0QqyihvQWzF*/

#ifndef typedef_dsp_simulink_MovingAverage_Ca_e
#define typedef_dsp_simulink_MovingAverage_Ca_e

typedef struct tag_3PXL3p0DR1x0QqyihvQWzF dsp_simulink_MovingAverage_Ca_e;

#endif                               /*typedef_dsp_simulink_MovingAverage_Ca_e*/

#ifndef struct_tag_RXRrDQQCpDh2yIDIwe5f1F
#define struct_tag_RXRrDQQCpDh2yIDIwe5f1F

struct tag_RXRrDQQCpDh2yIDIwe5f1F
{
  int32_T isInitialized;
  boolean_T isSetupComplete;
  real32_T pReverseSamples[40];
  real32_T pReverseT[40];
  real32_T pReverseS[40];
  real32_T pT;
  real32_T pS;
  real32_T pM;
  real32_T pCounter;
};

#endif                                 /*struct_tag_RXRrDQQCpDh2yIDIwe5f1F*/

#ifndef typedef_g_dsp_private_SlidingWindowVari
#define typedef_g_dsp_private_SlidingWindowVari

typedef struct tag_RXRrDQQCpDh2yIDIwe5f1F g_dsp_private_SlidingWindowVari;

#endif                               /*typedef_g_dsp_private_SlidingWindowVari*/

#ifndef struct_tag_V501qkcGSM9Fs0MY8ynKdC
#define struct_tag_V501qkcGSM9Fs0MY8ynKdC

struct tag_V501qkcGSM9Fs0MY8ynKdC
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowVari *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowVari _pobj0;
};

#endif                                 /*struct_tag_V501qkcGSM9Fs0MY8ynKdC*/

#ifndef typedef_dsp_simulink_MovingStandardDevi
#define typedef_dsp_simulink_MovingStandardDevi

typedef struct tag_V501qkcGSM9Fs0MY8ynKdC dsp_simulink_MovingStandardDevi;

#endif                               /*typedef_dsp_simulink_MovingStandardDevi*/

/* Custom Type definition for Chart: '<Root>/CalibrationState' */
#ifndef struct_tag_s0gXP0oEBHGQrmmgTsgkO2D
#define struct_tag_s0gXP0oEBHGQrmmgTsgkO2D

struct tag_s0gXP0oEBHGQrmmgTsgkO2D
{
  real_T state;
  real_T n;
  real_T n_standing;
  real_T n_riding;
  real_T n_breaking;
  real_T n_acclerating;
  real_T n_block;
  real_T last_state;
  real_T blockCnt_standing;
  real_T blockCnt_riding;
  real_T blockCnt_breaking;
  real_T blockCnt_acclerating;
};

#endif                                 /*struct_tag_s0gXP0oEBHGQrmmgTsgkO2D*/

#ifndef typedef_s0gXP0oEBHGQrmmgTsgkO2D_Calibra
#define typedef_s0gXP0oEBHGQrmmgTsgkO2D_Calibra

typedef struct tag_s0gXP0oEBHGQrmmgTsgkO2D s0gXP0oEBHGQrmmgTsgkO2D_Calibra;

#endif                               /*typedef_s0gXP0oEBHGQrmmgTsgkO2D_Calibra*/

#ifndef struct_tag_80AwAGWuE9fVrIKDJpJKoC
#define struct_tag_80AwAGWuE9fVrIKDJpJKoC

struct tag_80AwAGWuE9fVrIKDJpJKoC
{
  int32_T isInitialized;
  boolean_T isSetupComplete;
  real_T pCumSum;
  real_T pCumSumRev[9];
  real_T pCumRevIndex;
};

#endif                                 /*struct_tag_80AwAGWuE9fVrIKDJpJKoC*/

#ifndef typedef_g_dsp_private_SlidingWindowA_hd
#define typedef_g_dsp_private_SlidingWindowA_hd

typedef struct tag_80AwAGWuE9fVrIKDJpJKoC g_dsp_private_SlidingWindowA_hd;

#endif                               /*typedef_g_dsp_private_SlidingWindowA_hd*/

#ifndef struct_tag_fySbZAOKPwKo4qrQA2PQwC
#define struct_tag_fySbZAOKPwKo4qrQA2PQwC

struct tag_fySbZAOKPwKo4qrQA2PQwC
{
  int32_T isInitialized;
  boolean_T isSetupComplete;
  real_T pReverseSamples[50];
  real_T pReverseT[50];
  real_T pReverseS[50];
  real_T pT;
  real_T pS;
  real_T pM;
  real_T pCounter;
};

#endif                                 /*struct_tag_fySbZAOKPwKo4qrQA2PQwC*/

#ifndef typedef_g_dsp_private_SlidingWindowVa_h
#define typedef_g_dsp_private_SlidingWindowVa_h

typedef struct tag_fySbZAOKPwKo4qrQA2PQwC g_dsp_private_SlidingWindowVa_h;

#endif                               /*typedef_g_dsp_private_SlidingWindowVa_h*/

#ifndef struct_tag_RoFcBL3cgrPNAPUZAtdOnE
#define struct_tag_RoFcBL3cgrPNAPUZAtdOnE

struct tag_RoFcBL3cgrPNAPUZAtdOnE
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowA_hd *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowA_hd _pobj0;
};

#endif                                 /*struct_tag_RoFcBL3cgrPNAPUZAtdOnE*/

#ifndef typedef_dsp_simulink_MovingAverage_Ca_h
#define typedef_dsp_simulink_MovingAverage_Ca_h

typedef struct tag_RoFcBL3cgrPNAPUZAtdOnE dsp_simulink_MovingAverage_Ca_h;

#endif                               /*typedef_dsp_simulink_MovingAverage_Ca_h*/

#ifndef struct_tag_dTqYQq03zqkvdAgjAKhgOG
#define struct_tag_dTqYQq03zqkvdAgjAKhgOG

struct tag_dTqYQq03zqkvdAgjAKhgOG
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowVari *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowVari _pobj0;
};

#endif                                 /*struct_tag_dTqYQq03zqkvdAgjAKhgOG*/

#ifndef typedef_dsp_simulink_MovingVariance_Cal
#define typedef_dsp_simulink_MovingVariance_Cal

typedef struct tag_dTqYQq03zqkvdAgjAKhgOG dsp_simulink_MovingVariance_Cal;

#endif                               /*typedef_dsp_simulink_MovingVariance_Cal*/

#ifndef struct_tag_ShuGhLe49LiDjswcqGRpcB
#define struct_tag_ShuGhLe49LiDjswcqGRpcB

struct tag_ShuGhLe49LiDjswcqGRpcB
{
  boolean_T matlabCodegenIsDeleted;
  int32_T isInitialized;
  boolean_T isSetupComplete;
  boolean_T TunablePropsChanged;
  cell_wrap_CalibrationMotorbike_ inputVarSize;
  g_dsp_private_SlidingWindowVa_h *pStatistic;
  int32_T NumChannels;
  g_dsp_private_SlidingWindowVa_h _pobj0;
};

#endif                                 /*struct_tag_ShuGhLe49LiDjswcqGRpcB*/

#ifndef typedef_dsp_simulink_MovingVariance_C_h
#define typedef_dsp_simulink_MovingVariance_C_h

typedef struct tag_ShuGhLe49LiDjswcqGRpcB dsp_simulink_MovingVariance_C_h;

#endif                               /*typedef_dsp_simulink_MovingVariance_C_h*/

/* Block signals and states (default storage) for system '<Root>/Moving Average1' */
typedef struct
{
  dsp_simulink_MovingAverage_Cali obj; /* '<Root>/Moving Average1' */
  real_T Direction_absAverage;         /* '<Root>/Moving Average1' */
  boolean_T objisempty;                /* '<Root>/Moving Average1' */
}
rtDW_MovingAverage1_Calibration;

/* Block signals and states (default storage) for system '<S19>/Moving Average2' */
typedef struct
{
  dsp_simulink_MovingAverage_Ca_e obj; /* '<S19>/Moving Average2' */
  real32_T accSfXmg_Average20;         /* '<S19>/Moving Average2' */
  boolean_T objisempty;                /* '<S19>/Moving Average2' */
}
rtDW_MovingAverage2_Calibration;

/* Block signals and states (default storage) for system '<S19>/Moving Standard Deviation2' */
typedef struct
{
  dsp_simulink_MovingStandardDevi obj; /* '<S19>/Moving Standard Deviation2' */
  real32_T MovingStandardDeviation2;   /* '<S19>/Moving Standard Deviation2' */
  boolean_T objisempty;                /* '<S19>/Moving Standard Deviation2' */
}
rtDW_MovingStandardDeviation2_C;

/* Block signals and states (default storage) for system '<S19>/SmartFilter2' */
typedef struct
{
  real_T y_out;                        /* '<S19>/SmartFilter2' */
  real_T y;                            /* '<S19>/SmartFilter2' */
  real_T k;                            /* '<S19>/SmartFilter2' */
  boolean_T y_not_empty;               /* '<S19>/SmartFilter2' */
}
rtDW_SmartFilter2_CalibrationMo;

/* Block signals and states (default storage) for system '<Root>' */

extern real32_T calibrationModuleVersion;

typedef struct
{
  rtDW_SmartFilter2_CalibrationMo sf_SmartFilter2_j;/* '<S21>/SmartFilter2' */
  rtDW_MovingStandardDeviation2_C MovingStandardDeviation2_pn;/* '<S19>/Moving Standard Deviation2' */
  rtDW_MovingAverage2_Calibration MovingAverage2_pna;/* '<S19>/Moving Average2' */
  rtDW_SmartFilter2_CalibrationMo sf_SmartFilter2_b;/* '<S20>/SmartFilter2' */
  rtDW_MovingStandardDeviation2_C MovingStandardDeviation2_p;/* '<S19>/Moving Standard Deviation2' */
  rtDW_MovingAverage2_Calibration MovingAverage2_pn;/* '<S19>/Moving Average2' */
  rtDW_SmartFilter2_CalibrationMo sf_SmartFilter2;/* '<S19>/SmartFilter2' */
  rtDW_MovingStandardDeviation2_C MovingStandardDeviation2;/* '<S19>/Moving Standard Deviation2' */
  rtDW_MovingAverage2_Calibration MovingAverage2_p;/* '<S19>/Moving Average2' */
  rtDW_MovingAverage1_Calibration MovingAverage2;/* '<Root>/Moving Average1' */
  rtDW_MovingAverage1_Calibration MovingAverage1;/* '<Root>/Moving Average1' */
  dsp_simulink_MovingVariance_C_h obj; /* '<Root>/Moving Variance4' */
  dsp_simulink_MovingVariance_Cal obj_l;/* '<Root>/Moving Variance2' */
  dsp_simulink_MovingAverage_Ca_h obj_d;/* '<Root>/Moving Average' */
  s0gXP0oEBHGQrmmgTsgkO2D_Calibra calibration;/* '<Root>/CalibrationState' */
  real_T TmpSignalConversionAtSFunctionI[5];/* '<Root>/CalibrationState' */
  real_T calibrationOUT[12];           /* '<Root>/CalibrationState' */
  real_T Calibration_Vector[5];        /* '<Root>/CalibrationState' */
  real_T GravityStanding[5];           /* '<Root>/CalibrationState' */
  real_T GravityRiding[5];             /* '<Root>/CalibrationState' */
  real_T GravityBreaking[5];           /* '<Root>/CalibrationState' */
  real_T GravityAccel[5];              /* '<Root>/CalibrationState' */
  real_T UnitDelay3_DSTATE_p[3];       /* '<S8>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_l[3];       /* '<S8>/Unit Delay4' */
  real_T UnitDelay_DSTATE_i[5];        /* '<S9>/Unit Delay' */
  real_T UnitDelay1_DSTATE_f[5];       /* '<S9>/Unit Delay1' */
  real_T UnitDelay3_DSTATE_o[5];       /* '<S9>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_g[5];       /* '<S9>/Unit Delay4' */
  real_T state_Ignition;               /* '<Root>/CalibrationState' */
  real_T state_Riding;                 /* '<Root>/CalibrationState' */
  real_T state_Acceleration;           /* '<Root>/CalibrationState' */
  real_T state_Direction;              /* '<Root>/CalibrationState' */
  real_T UnitDelay_DSTATE;             /* '<S10>/Unit Delay' */
  real_T UnitDelay1_DSTATE;            /* '<S10>/Unit Delay1' */
  real_T UnitDelay3_DSTATE;            /* '<S10>/Unit Delay3' */
  real_T UnitDelay4_DSTATE;            /* '<S10>/Unit Delay4' */
  real_T UnitDelay_DSTATE_o;           /* '<S5>/Unit Delay' */
  real_T UnitDelay1_DSTATE_l;          /* '<S5>/Unit Delay1' */
  real_T UnitDelay3_DSTATE_j;          /* '<S5>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_e;          /* '<S5>/Unit Delay4' */
  real_T UnitDelay_DSTATE_m;           /* '<S6>/Unit Delay' */
  real_T UnitDelay1_DSTATE_j;          /* '<S6>/Unit Delay1' */
  real_T UnitDelay3_DSTATE_c;          /* '<S6>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_c;          /* '<S6>/Unit Delay4' */
  real_T UnitDelay_DSTATE_e;           /* '<S7>/Unit Delay' */
  real_T UnitDelay1_DSTATE_d;          /* '<S7>/Unit Delay1' */
  real_T UnitDelay3_DSTATE_cs;         /* '<S7>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_b;          /* '<S7>/Unit Delay4' */
  real_T UnitDelay3_DSTATE_g;          /* '<S12>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_o;          /* '<S12>/Unit Delay4' */
  real_T UnitDelay3_DSTATE_pt;         /* '<S4>/Unit Delay3' */
  real_T UnitDelay4_DSTATE_j;          /* '<S4>/Unit Delay4' */
  real_T abs_max;                      /* '<Root>/Direction_Vector' */
  real_T rough_direction_angle_fwd;    /* '<Root>/CalibrationState' */
  real32_T GeneratedFilterBlock_FILT_STATE[4];/* '<S1>/Generated Filter Block' */
  real32_T GeneratedFilterBlock_FILT_STA_n[4];/* '<S2>/Generated Filter Block' */
  real32_T GeneratedFilterBlock_FILT_STA_p[4];/* '<S3>/Generated Filter Block' */
  real32_T UnitDelay_DSTATE_c[3];      /* '<S8>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_f5[3];    /* '<S8>/Unit Delay1' */
  real32_T speedKmh;                   /* '<Root>/Data Type Conversion14' */
  real32_T UnitDelay_DSTATE_ob;        /* '<S12>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_k;        /* '<S12>/Unit Delay1' */
  real32_T UnitDelay_DSTATE_n;         /* '<S4>/Unit Delay' */
  real32_T UnitDelay1_DSTATE_n;        /* '<S4>/Unit Delay1' */
  real32_T speed_kmh_prev;             /* '<Root>/CalibrationState' */
  real32_T speed_kmh_prev_n2;          /* '<Root>/CalibrationState' */
  uint16_T temporalCounter_i1;         /* '<Root>/CalibrationState' */
  uint8_T is_active_c12_CalibrationMotorb;/* '<Root>/CalibrationState' */
  uint8_T is_ENGINE_STATE_ESTIMATOR;   /* '<Root>/CalibrationState' */
  uint8_T is_ACCELERATION_STATE_ESTIMATOR;/* '<Root>/CalibrationState' */
  uint8_T is_CALIBRATION_STATE_ESTIMATOR;/* '<Root>/CalibrationState' */
  uint8_T is_ENGINE_ON;                /* '<Root>/CalibrationState' */
  uint8_T is_RIDING_STATE_ESTIMATION;  /* '<Root>/CalibrationState' */
  uint8_T is_RIDING;                   /* '<Root>/CalibrationState' */
  uint8_T is_CURVE_STATE_ESTIMATION;   /* '<Root>/CalibrationState' */
  uint8_T is_STABLEDIRECTION_STATE_ESTIMA;/* '<Root>/CalibrationState' */
  uint8_T temporalCounter_i2;          /* '<Root>/CalibrationState' */
  uint8_T temporalCounter_i3;          /* '<Root>/CalibrationState' */
  boolean_T Delay_DSTATE;              /* '<S15>/Delay' */
}
D_Work_CalibrationMotorbike_v2;

/* Type definition for custom storage class: Struct */
typedef struct MOCA_in_tag
{
  real32_T initRotMatSf2Bf_3x3[9];     /* '<Root>/initRotMatSf2Bf [3x3]' */
}
MOCA_in_type;

typedef struct MOCA_out_tag
{
  real32_T rotMatSf2BfOut_3x3[9];      /* '<Root>/Data Type Conversion23' */
  int16_T rotMatUpdate;                /* '<Root>/Data Type Conversion27' */
}
MOCA_out_type;

/* Block signals and states (default storage) */
extern D_Work_CalibrationMotorbike_v2 CalibrationMotorbike_v2_DWork;

/* Model entry point functions */
void CalibrationMotorbike_v2_initialize(void);
void CalibrationMotorbike_v2_step(void);
void CalibrationMotorbike_v2_Gravity_2_RotMatrix(const real32_T
  COCA_rtu_gravity[4], real32_T COCA_rty_rot_Matrix[9]);

/* Exported data declaration */

/* Declaration for custom storage class: ImportFromFile */
extern int16_T COCA_accBfXmg;          /* '<Root>/Data Type Conversion10' */
extern int16_T COCA_accBfYmg;          /* '<Root>/Data Type Conversion13' */
extern int16_T COCA_accBfZmg;          /* '<Root>/Data Type Conversion15' */
extern int16_T COCA_calibrationFlag;   /* '<Root>/Data Type Conversion19' */
extern int32_T COCA_gyrBfXmdegs;       /* '<Root>/Data Type Conversion16' */
extern int32_T COCA_gyrBfYmdegs;       /* '<Root>/Data Type Conversion17' */
extern int32_T COCA_gyrBfZmdegs;       /* '<Root>/Data Type Conversion18' */

/* Declaration for custom storage class: Struct */
extern MOCA_in_type MOCA_in;
extern MOCA_out_type MOCA_out;

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
 * '<Root>' : 'CalibrationMotorbike_v2'
 * '<S1>'   : 'CalibrationMotorbike_v2/Bandpass Filter3'
 * '<S2>'   : 'CalibrationMotorbike_v2/Bandpass Filter4'
 * '<S3>'   : 'CalibrationMotorbike_v2/Bandpass Filter5'
 * '<S4>'   : 'CalibrationMotorbike_v2/Butterworth2nd10'
 * '<S5>'   : 'CalibrationMotorbike_v2/Butterworth2nd11'
 * '<S6>'   : 'CalibrationMotorbike_v2/Butterworth2nd12'
 * '<S7>'   : 'CalibrationMotorbike_v2/Butterworth2nd13'
 * '<S8>'   : 'CalibrationMotorbike_v2/Butterworth2nd16'
 * '<S9>'   : 'CalibrationMotorbike_v2/Butterworth2nd5'
 * '<S10>'  : 'CalibrationMotorbike_v2/Butterworth2nd6'
 * '<S11>'  : 'CalibrationMotorbike_v2/Butterworth2nd8'
 * '<S12>'  : 'CalibrationMotorbike_v2/Butterworth2nd9'
 * '<S13>'  : 'CalibrationMotorbike_v2/CalibrationState'
 * '<S14>'  : 'CalibrationMotorbike_v2/Direction_Vector'
 * '<S15>'  : 'CalibrationMotorbike_v2/Edge Detector'
 * '<S16>'  : 'CalibrationMotorbike_v2/MATLAB Function1'
 * '<S17>'  : 'CalibrationMotorbike_v2/Rotate_to_Gravity'
 * '<S18>'  : 'CalibrationMotorbike_v2/Simulink Function'
 * '<S19>'  : 'CalibrationMotorbike_v2/SmartACCFilter1'
 * '<S20>'  : 'CalibrationMotorbike_v2/SmartACCFilter2'
 * '<S21>'  : 'CalibrationMotorbike_v2/SmartACCFilter3'
 * '<S22>'  : 'CalibrationMotorbike_v2/Edge Detector/Check Signal Attributes'
 * '<S23>'  : 'CalibrationMotorbike_v2/Edge Detector/Check Signal Attributes1'
 * '<S24>'  : 'CalibrationMotorbike_v2/Simulink Function/Gravity_2_RotMatrixMat'
 * '<S25>'  : 'CalibrationMotorbike_v2/SmartACCFilter1/SmartFilter2'
 * '<S26>'  : 'CalibrationMotorbike_v2/SmartACCFilter2/SmartFilter2'
 * '<S27>'  : 'CalibrationMotorbike_v2/SmartACCFilter3/SmartFilter2'
 */
#endif                               /* RTW_HEADER_CalibrationMotorbike_v2_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
