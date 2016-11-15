//
//  Tone.h
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tone : NSObject

@property int DCO_Env_Mode;
@property int VCF_Env_Mode;
@property int VCA_Env_Mode;
@property int DCO_Sub_Wave;
@property int DCO_Saw_Wave;
@property int DCO_Pulse_Wave;
@property int DCO_Range;
@property int DCO_Sub_Level;
@property int DCO_NoiseL_Level;
@property int HPF_Cuttoff;
@property int Chorus_On;
@property int DCO_LFO_Mod_Depth;
@property int DCO_Env_Mod_Depth;
@property int DCO_After_Depth;
@property int DCO_PWM_Depth;
@property int DCO_PWM_Rate;
@property int VCF_Cutoff_Freq;
@property int VCF_Resonance;
@property int VCF_LFO_MOD_Depth;
@property int VCF_Env_MOD_Depth;
@property int VCF_Key_Follow;
@property int VCF_After_Depth;
@property int VCA_Level;
@property int VCA_After_Depth;
@property int LFO_Rate;
@property int LFO_Delay_Time;
@property int Env_T1;
@property int ENV_L1;
@property int Env_T2;
@property int Env_L2;
@property int Env_T3;
@property int Env_L3;
@property int Env_T4;
@property int Env_Key_Follow;
@property int Chorus_Rate;
@property int Bender_Range;
@property NSString* text;

-(NSString*) getCharAtIndex :(int) index;

@end
