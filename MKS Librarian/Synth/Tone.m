//
//  Tone.m
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "Tone.h"

@implementation Tone

-(id) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    self.DCO_Env_Mode = 0;
    self.VCF_Env_Mode = 0;
    self.VCA_Env_Mode = 0;
    self.DCO_Sub_Wave = 0;
    self.DCO_Saw_Wave = 1;
    self.DCO_Pulse_Wave = 0;
    self.DCO_Range = 0;
    self.DCO_Sub_Level = 0;
    self.DCO_NoiseL_Level = 0;
    self.HPF_Cuttoff = 1;
    self.Chorus_On = 0;
    self.DCO_LFO_Mod_Depth = 0;
    self.DCO_Env_Mod_Depth = 0;
    self.DCO_After_Depth = 0;
    self.DCO_PWM_Depth = 0;
    self.DCO_PWM_Rate = 0;
    self.VCF_Cutoff_Freq = 127;
    self.VCF_Resonance = 0;
    self.VCF_LFO_MOD_Depth = 0;
    self.VCF_Env_MOD_Depth = 0;
    self.VCF_Key_Follow = 0;
    self.VCF_After_Depth = 0;
    self.VCA_Level = 100;
    self.VCA_After_Depth = 0;
    self.LFO_Rate = 0;
    self.LFO_Delay_Time = 0;
    self.Env_T1 = 0;
    self.Env_L1 = 127;
    self.Env_T2 = 0;
    self.Env_L2 = 127;
    self.Env_T3 = 0;
    self.Env_L3 = 127;
    self.Env_T4 = 0;
    self.Env_Key_Follow = 0;
    self.Chorus_Rate = 0;
    self.Bender_Range = 12;
    self.text = @"Init      ";
    
    return self;
}

-(id) initWithHoover
{
    self = [self init];
    
    self.DCO_Env_Mode = 2;
    self.VCF_Env_Mode = 2;
    self.VCA_Env_Mode = 3;      // or 2
    self.DCO_Sub_Wave = 5;
    self.DCO_Saw_Wave = 3;
    self.DCO_Pulse_Wave = 3;
    self.DCO_Range = 3;         // 32'
    self.DCO_Sub_Level = 3;
    self.DCO_NoiseL_Level = 1;
    self.HPF_Cuttoff = 0;
    self.Chorus_On = 1;
    self.DCO_LFO_Mod_Depth = 0;
    self.DCO_Env_Mod_Depth = 127;
    self.DCO_After_Depth = 9;
    self.DCO_PWM_Depth = 127;
    self.DCO_PWM_Rate = 102;
    self.VCF_Cutoff_Freq = 77;
    self.VCF_Resonance = 0;
    self.VCF_LFO_MOD_Depth = 75;
    self.VCF_Env_MOD_Depth = 75;
    self.VCF_Key_Follow = 11;
    self.VCF_After_Depth = 9;
    self.VCA_Level = 60;
    self.VCA_After_Depth = 0;
    self.LFO_Rate = 39;
    self.LFO_Delay_Time = 64;
    self.Env_T1 = 99;
    self.Env_L1 = 68;
    self.Env_T2 = 78;
    self.Env_L2 = 127;
    self.Env_T3 = 75;
    self.Env_L3 = 127;
    self.Env_T4 = 92;
    self.Env_Key_Follow = 9;
    self.Chorus_Rate = 92;
    self.Bender_Range = 5;
    self.text = @"Init Hoov ";
    
    return self;
}

-(NSString*) getCharAtIndex :(int) index
{
    return [NSString stringWithFormat:@"%c", [self.text characterAtIndex: index]];
}

-(void) updateParam : (short) MKSTone withValue : (long ) value
{
    switch (MKSTone)
    {
        case 0:
            self.DCO_Env_Mode = (int)value;
            break;
        case 1:
            self.VCF_Env_Mode = (int)value;
            break;
        case 2:
            self.VCA_Env_Mode = (int)value;
            break;
        case 3:
            self.DCO_Pulse_Wave = (int)value;
            break;
        case 4:
            self.DCO_Saw_Wave = (int)value;
            break;
        case 5:
            self.DCO_Sub_Wave = (int)value;
            break;
        case 6:
            self.DCO_Range = (int)value;
            break;
        case 7:
            self.DCO_Sub_Level = (int)value;
            break;
        case 8:
            self.DCO_NoiseL_Level = (int)value;
            break;
        case 9:
            self.HPF_Cuttoff = (int)value;
            break;
        case 10:
            self.Chorus_On = (int)value;
            break;
        case 11:
            self.DCO_LFO_Mod_Depth = (int)value;
            break;
        case 12:
            self.DCO_Env_Mod_Depth = (int)value;
            break;
        case 13:
            self.DCO_After_Depth = (int)value;
            break;
        case 14:
            self.DCO_PWM_Depth = (int)value;
            break;
        case 15:
            self.DCO_PWM_Rate = (int)value;
            break;
        case 16:
            self.VCF_Cutoff_Freq = (int)value;
            break;
        case 17:
            self.VCF_Resonance = (int)value;
            break;
        case 18:
            self.VCF_LFO_MOD_Depth = (int)value;
            break;
        case 19:
            self.VCF_Env_MOD_Depth = (int)value;
            break;
        case 20:
            self.VCF_Key_Follow = (int)value;
            break;
        case 21:
            self.VCF_After_Depth = (int)value;
            break;
        case 22:
            self.VCA_Level = (int)value;
            break;
        case 23:
            self.VCA_After_Depth = (int)value;
            break;
        case 24:
            self.LFO_Rate = (int)value;
            break;
        case 25:
            self.LFO_Delay_Time = (int)value;
            break;
        case 26:
            self.Env_T1 = (int)value;
            break;
        case 27:
            self.Env_L1 = (int)value;
            break;
        case 28:
            self.Env_T2 = (int)value;
            break;
        case 29:
            self.Env_L2 = (int)value;
            break;
        case 30:
            self.Env_T3 = (int)value;
            break;
        case 31:
            self.Env_L3 = (int)value;
            break;
        case 32:
            self.Env_T4 = (int)value;
            break;
        case 33:
            self.Env_Key_Follow = (int)value;
            break;
        case 34:
            self.Chorus_Rate = (int)value;
            break;
        case 35:
            self.Bender_Range = (int)value;
            break;
        default:
            break;
    }
}

@end
