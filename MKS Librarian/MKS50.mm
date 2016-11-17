//
//  MKS50.m
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "MKS50.hh"

@implementation MKS50
{
    NSDictionary *MKSLetters;
}

#pragma mark Constructors

-(id) initWithDelegate: (id <MKSInterfaceDelegate>) newDelegate
{
    self = [super init];
    [self setupFunction];
    self.midiInterface.delegate = self.delegate = newDelegate;
    return self;
}

-(id) init
{
    self = [self initWithDelegate: nil];
    return self;
}

-(void) setupFunction
{
    // Insert code here to initialize your application
    self.midiChannel = 0;
    self.patchNumber = 0;
    self.toneNumber = 0;
    
    self.midiInterface = [[MidiInterface alloc] init];
    
    _currentTone = [[Tone alloc] init];
    _currentPatch = [[Patch alloc] init];
    
    GetInputs(self.midiInterface);
    GetOutputs(self.midiInterface);
    
    InitMIDI(self.midiInterface);
    
    MyMidiConnectInput(self.midiInterface,
                       self.midiInterface.inputs[3]);
    MyMidiConnectOutput(self.midiInterface,
                        self.midiInterface.outputs[2]);
    
    MKSLetters = @{
                   @"A": @k_A,
                   @"B": @k_B,
                   @"C": @k_C,
                   @"D": @k_D,
                   @"E": @k_E,
                   @"F": @k_F,
                   @"G": @k_G,
                   @"H": @k_H,
                   @"I": @k_I,
                   @"J": @k_J,
                   @"K": @k_K,
                   @"L": @k_L,
                   @"M": @k_M,
                   @"N": @k_N,
                   @"O": @k_O,
                   @"P": @k_P,
                   @"Q": @k_Q,
                   @"R": @k_R,
                   @"S": @k_S,
                   @"T": @k_T,
                   @"U": @k_U,
                   @"V": @k_V,
                   @"W": @k_W,
                   @"X": @k_X,
                   @"Y": @k_Y,
                   @"Z": @k_Z,
                   @"a": @k_a,
                   @"b": @k_b,
                   @"c": @k_c,
                   @"d": @k_d,
                   @"e": @k_e,
                   @"f": @k_f,
                   @"g": @k_g,
                   @"h": @k_h,
                   @"i": @k_i,
                   @"j": @k_j,
                   @"k": @k_k,
                   @"l": @k_l,
                   @"m": @k_m,
                   @"n": @k_n,
                   @"o": @k_o,
                   @"p": @k_p,
                   @"q": @k_q,
                   @"r": @k_r,
                   @"s": @k_s,
                   @"t": @k_t,
                   @"u": @k_u,
                   @"v": @k_v,
                   @"w": @k_w,
                   @"x": @k_x,
                   @"y": @k_y,
                   @"z": @k_z,
                   @" ": @k_space,
                   @"-": @k_minus
                   };

}

#pragma mark Public Methods

-(bool) autoDetectMidi
{
    return YES;
}

-(bool) loadPatch:(Patch*) patchToLoad
{
    MIDIPacketList MyPacket;
    const char *title = [patchToLoad.text UTF8String];
    int bounds = (int)strlen(title) < 10 ? (int)strlen(title) : 10;
    
    _currentPatch = patchToLoad;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 31;
    MyPacket.packet[0].data[0] = 0xF0;  // Sysex
    MyPacket.packet[0].data[1] = 0x41;  // Roland ID
    MyPacket.packet[0].data[2] = 0x35;  // All Patch Parameters (With Name)
    MyPacket.packet[0].data[3] = _midiChannel;  // Midi Channel -- change to variable
    MyPacket.packet[0].data[4] = 0x23;  // MKS-50 Format
    MyPacket.packet[0].data[5] = 0x30;  // MKS-50 (Changed from 0x020)
    MyPacket.packet[0].data[6] = 0x01;  // Group #
    // Patch Data
    MyPacket.packet[0].data[7] = patchToLoad.toneNubmer;
    MyPacket.packet[0].data[8] = patchToLoad.keyRangeLow;
    MyPacket.packet[0].data[9] = patchToLoad.keyRangeHigh;
    MyPacket.packet[0].data[10] = patchToLoad.portamentoTime;
    MyPacket.packet[0].data[11] = patchToLoad.portamento;
    MyPacket.packet[0].data[12] = patchToLoad.modSensitivity;
    MyPacket.packet[0].data[13] = patchToLoad.keyShift;
    MyPacket.packet[0].data[14] = patchToLoad.volume;
    MyPacket.packet[0].data[15] = patchToLoad.detune;
    MyPacket.packet[0].data[16] = patchToLoad.midiFunction;
    MyPacket.packet[0].data[17] = patchToLoad.monoRange;
    MyPacket.packet[0].data[18] = patchToLoad.chordMemory;
    MyPacket.packet[0].data[19] = patchToLoad.keyAssign;
    // Patch Name
    
    for(int i = 0; i < bounds; i++)
    {
        NSString *key = [patchToLoad getCharAtIndex:i];
        MyPacket.packet[0].data[20 + i] = [[MKSLetters valueForKey:key] integerValue];
    }
    for(int i = bounds; i < 10; i++)
    {
        MyPacket.packet[0].data[20 + i] = [[MKSLetters valueForKey:@" "] integerValue];
    }
    MyPacket.packet[0].data[30] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
    return YES;
}

-(bool) loadTone:(Tone*) toneToLoad
{
    MIDIPacketList MyPacket;
    const char *title = [toneToLoad.text UTF8String];
    int bounds = (int)strlen(title) < 10 ? (int)strlen(title) : 10;
    
    _currentTone = toneToLoad;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 54;
    MyPacket.packet[0].data[0] = 0xF0;  // Sysex
    MyPacket.packet[0].data[1] = 0x41;  // Roland ID
    MyPacket.packet[0].data[2] = 0x35;  // All Parameters (With Name)
    MyPacket.packet[0].data[3] = _midiChannel;  // Midi Channel -- change to variable
    MyPacket.packet[0].data[4] = 0x23;  // MKS-50 Format
    MyPacket.packet[0].data[5] = 0x20;  // Level 1
    MyPacket.packet[0].data[6] = 0x01;  // Group #
    
    // Patch Data
    MyPacket.packet[0].data[7] = toneToLoad.DCO_Env_Mode;       // DCO Env Mode
    MyPacket.packet[0].data[8] = toneToLoad.VCF_Env_Mode;       // VCF Env Mode
    MyPacket.packet[0].data[9] = toneToLoad.VCA_Env_Mode;       // VCA Env Mode
    MyPacket.packet[0].data[10] = toneToLoad.DCO_Pulse_Wave;    // DCO Waveform Pulse
    MyPacket.packet[0].data[11] = toneToLoad.DCO_Saw_Wave;      // DCO Waveform Saw
    MyPacket.packet[0].data[12] = toneToLoad.DCO_Sub_Wave;      // DCO WAveform Sub
    MyPacket.packet[0].data[13] = toneToLoad.DCO_Range;         // DCO Range
    MyPacket.packet[0].data[14] = toneToLoad.DCO_Sub_Level;     // DCO Sub Level
    MyPacket.packet[0].data[15] = toneToLoad.DCO_NoiseL_Level;  // DCO Noise Level
    MyPacket.packet[0].data[16] = toneToLoad.HPF_Cuttoff;       // HPF Cuttoff Freq
    MyPacket.packet[0].data[17] = toneToLoad.Chorus_On;         // Chorus
    MyPacket.packet[0].data[18] = toneToLoad.DCO_LFO_Mod_Depth; // DCO LFO Mod Depth
    MyPacket.packet[0].data[19] = toneToLoad.DCO_Env_Mod_Depth; // DCO Env Mod Depth
    MyPacket.packet[0].data[20] = toneToLoad.DCO_After_Depth;   // DCO After Depth
    MyPacket.packet[0].data[21] = toneToLoad.DCO_PWM_Depth;     // DCO PWM Depth
    MyPacket.packet[0].data[22] = toneToLoad.DCO_PWM_Rate;      // DCO PWM Rate
    MyPacket.packet[0].data[23] = toneToLoad.VCF_Cutoff_Freq;   // VCF Cuttoff Freq
    MyPacket.packet[0].data[24] = toneToLoad.VCF_Resonance;     // VCF Resonance
    MyPacket.packet[0].data[25] = toneToLoad.VCF_LFO_MOD_Depth; // VCF LFO Mod Depth
    MyPacket.packet[0].data[26] = toneToLoad.VCF_Env_MOD_Depth; // VCF Env Mod Depth
    MyPacket.packet[0].data[27] = toneToLoad.VCF_Key_Follow;    // VCF Key Follow
    MyPacket.packet[0].data[28] = toneToLoad.VCF_After_Depth;   // VCF After Depth
    MyPacket.packet[0].data[29] = toneToLoad.VCA_Level;         // VCA Level
    MyPacket.packet[0].data[30] = toneToLoad.VCA_After_Depth;   // VCA After Depth
    MyPacket.packet[0].data[31] = toneToLoad.LFO_Rate;          // LFO Rate
    MyPacket.packet[0].data[32] = toneToLoad.LFO_Delay_Time;    // LFO Delay Time
    MyPacket.packet[0].data[33] = toneToLoad.Env_T1;            // Env T1
    MyPacket.packet[0].data[34] = toneToLoad.Env_L1;            // Env L1
    MyPacket.packet[0].data[35] = toneToLoad.Env_T2;            // Env T2
    MyPacket.packet[0].data[36] = toneToLoad.Env_L2;            // Env L2
    MyPacket.packet[0].data[37] = toneToLoad.Env_T3;            // Env T3
    MyPacket.packet[0].data[38] = toneToLoad.Env_L3;            // Env L3
    MyPacket.packet[0].data[39] = toneToLoad.Env_T4;            // Env T4
    MyPacket.packet[0].data[40] = toneToLoad.Env_Key_Follow;    // Env Key Follow
    MyPacket.packet[0].data[41] = toneToLoad.Chorus_Rate;       // Chorus Rate
    MyPacket.packet[0].data[42] = toneToLoad.Bender_Range;      // Bender Range
    
    for(int i = 0; i < bounds; i++)
    {
        NSString *key = [toneToLoad getCharAtIndex:i];
        MyPacket.packet[0].data[43 + i] = [[MKSLetters valueForKey:key] integerValue];
    }
    for(int i = bounds; i < 10; i++)
    {
        MyPacket.packet[0].data[43 + i] = [[MKSLetters valueForKey:@" "] integerValue];
    }
    MyPacket.packet[0].data[53] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
    return YES;
}

-(bool) changeParam: (int) param toValue: (int)value
{
    //[self sendPatchMessageTo:param withValue:value];
    [self sendToneMessageTo:param withValue:value];
    return YES;
}

-(bool) changePatch: (int) patchNum
{
    MIDIPacketList MyPacket;
    self.patchNumber = patchNum;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 2;
    MyPacket.packet[0].data[0] = 0xC0;  // Sysex
    MyPacket.packet[0].data[1] = self.patchNumber; // Value
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
    
    return YES;
}

bool parseRawSysex(NSMutableArray* dataBuffer)
{
    
    
    return true;
}

#pragma mark Private Methods

-(void) sendPatchMessageTo: (short) MKSTone withValue : (long ) value
{
    MIDIPacketList MyPacket;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 10;
    MyPacket.packet[0].data[0] = 0xF0;  // Sysex
    MyPacket.packet[0].data[1] = 0x41;  // Roland ID
    MyPacket.packet[0].data[2] = 0x36;  // Individual Patch (IPR)
    MyPacket.packet[0].data[3] = 0x00;  // Midi Channel -- change to variable
    MyPacket.packet[0].data[4] = 0x23;  // MKS-50 Format
    MyPacket.packet[0].data[5] = 0x20;  // MKS-50
    MyPacket.packet[0].data[6] = 0x01;  // Group #
    MyPacket.packet[0].data[7] = MKSTone;  // Parameter
    MyPacket.packet[0].data[8] = value; // Value
    MyPacket.packet[0].data[9] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    [_currentTone updateParam:MKSTone withValue:value];
    SendMidi(self.midiInterface, &MyPacket);
}

-(void) sendToneMessageTo: (short) MKSTone withValue : (long ) value
{
    MIDIPacketList MyPacket;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 10;
    MyPacket.packet[0].data[0] = 0xF0;  // Sysex
    MyPacket.packet[0].data[1] = 0x41;  // Roland ID
    MyPacket.packet[0].data[2] = 0x36;  // Individual Patch (IPR)
    MyPacket.packet[0].data[3] = 0x00;  // Midi Channel -- change to variable
    MyPacket.packet[0].data[4] = 0x23;  // MKS-50 Format
    MyPacket.packet[0].data[5] = 0x20;  // MKS-50
    MyPacket.packet[0].data[6] = 0x01;  // Group #
    MyPacket.packet[0].data[7] = MKSTone;  // Parameter
    MyPacket.packet[0].data[8] = value; // Value
    MyPacket.packet[0].data[9] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    [_currentTone updateParam:MKSTone withValue:value];
    SendMidi(self.midiInterface, &MyPacket);
}

-(bool) updateText: (NSString*) newText
{
    _currentTone.text = [NSString stringWithFormat:@"%@", newText];
    [self loadTone: self.currentTone];
    return YES;
}

@end
