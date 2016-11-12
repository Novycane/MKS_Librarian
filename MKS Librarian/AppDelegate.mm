//
//  AppDelegate.m
//  MKS Librarian
//
//  Created by Steven Novak on 10/11/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "AppDelegate.hh"
#import "SliderEnum.hh"
#import "MyMidi.hpp"
#import "MKSConstant.h"
#import "UtilityFunctions.hpp"
#import "PatchButton.h"

@interface AppDelegate ()

@property MyMidiInterface *midiInterface;

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSSlider *LFORateSlider;
@property (weak) IBOutlet NSSlider *LFODelaySlider;
@property (weak) IBOutlet NSSlider *DCORangeSlider;
@property (weak) IBOutlet NSSlider *DCOLFOSlider;
@property (weak) IBOutlet NSSlider *DCOEnvelopeSlider;
@property (weak) IBOutlet NSSlider *DCOEnvelopeMode;
@property (weak) IBOutlet NSSlider *DCOAfterTouchSlider;
@property (weak) IBOutlet NSSlider *pulseWaveSlider;
@property (weak) IBOutlet NSSlider *sawWaveSlider;
@property (weak) IBOutlet NSSlider *subWaveSlider;
@property (weak) IBOutlet NSSlider *subLevelSlider;
@property (weak) IBOutlet NSSlider *noiseLevelSlider;
@property (weak) IBOutlet NSSlider *PWMAmountSlider;
@property (weak) IBOutlet NSSlider *PWMRateSlider;
@property (weak) IBOutlet NSSlider *HPFSlider;
@property (weak) IBOutlet NSSlider *VCFFreqSlider;
@property (weak) IBOutlet NSSlider *VCFResSlider;
@property (weak) IBOutlet NSSlider *VCFLFOSlider;
@property (weak) IBOutlet NSSlider *VCFEnvSlider;
@property (weak) IBOutlet NSSlider *VDFEnvShapeSlider;
@property (weak) IBOutlet NSSlider *VCFKeyFollowSlider;
@property (weak) IBOutlet NSSlider *VCFAfterSlider;
@property (weak) IBOutlet NSSlider *VCALevelSlider;
@property (weak) IBOutlet NSSlider *EnvelopeModeSlider;
@property (weak) IBOutlet NSSlider *envelopeAfterTouchSlide;
@property (weak) IBOutlet NSSlider *chorusOnOffSlider;
@property (weak) IBOutlet NSSlider *chorusRateSlider;
@property (weak) IBOutlet NSSlider *envelopeT1Slider;
@property (weak) IBOutlet NSSlider *envelopeL1Slider;
@property (weak) IBOutlet NSSlider *envelopeT2Slider;
@property (weak) IBOutlet NSSlider *envelopeL2Slider;
@property (weak) IBOutlet NSSlider *envelopeT3Slider;
@property (weak) IBOutlet NSSlider *envelopeL3Slider;
@property (weak) IBOutlet NSSlider *envelopeT4Slider;
@property (weak) IBOutlet NSSlider *envelopeKeyFollowSlider;

@property int bankNumber;
@property int patchNumber;
@property int toneNumber;
@property int midiChannel;
@property PatchButton* lastButtonPressed;

@end

@implementation AppDelegate



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.midiChannel = 0;
    self.bankNumber = 0;
    self.patchNumber = 0;
    self.toneNumber = 0;
    
    self.midiInterface = new MyMidiInterface();

    GetInputs(self.midiInterface);
    GetOutputs(self.midiInterface);
    
    InitMIDI(self.midiInterface);

    MyMidiConnectInput(self.midiInterface,
                       self.midiInterface->inputs[3]);
    MyMidiConnectOutput(self.midiInterface,
                        self.midiInterface->outputs[2]);

}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

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
    MyPacket.packet[0].data[6] = 0x02;  // Group #
    MyPacket.packet[0].data[7] = MKSTone;  // Parameter
    MyPacket.packet[0].data[8] = value; // Value
    MyPacket.packet[0].data[9] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
}

-(void) initPatch
{
    MIDIPacketList MyPacket;
    
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
    MyPacket.packet[0].data[7] = _patchNumber;  // Tone Number
    MyPacket.packet[0].data[8] = 12;            // Key Range Low
    MyPacket.packet[0].data[9] = 109;           // Key Range High
    MyPacket.packet[0].data[10] = 0;            // Portamento Time
    MyPacket.packet[0].data[11] = 0;            // Portamento
    MyPacket.packet[0].data[12] = 127;          // Mod Sensitivity
    MyPacket.packet[0].data[13] = 15;           // Key shift (?)
    MyPacket.packet[0].data[14] = 100;          // Volume
    MyPacket.packet[0].data[15] = 64;           // Detune
    MyPacket.packet[0].data[16] = 0x77;         // Midi Function
    MyPacket.packet[0].data[17] = 5;            // Mono Bender Range (Semitones)
    MyPacket.packet[0].data[18] = 0;            // Chord Memory
    MyPacket.packet[0].data[19] = 0;            // Key Assign
    // Patch Name
    MyPacket.packet[0].data[20] = k_I;          // I
    MyPacket.packet[0].data[21] = k_n;          // n
    MyPacket.packet[0].data[22] = k_i;          // i
    MyPacket.packet[0].data[23] = k_t;          // t
    MyPacket.packet[0].data[24] = k_space;      //
    MyPacket.packet[0].data[25] = k_space;      //
    MyPacket.packet[0].data[26] = k_space;      //
    MyPacket.packet[0].data[27] = k_space;      //
    MyPacket.packet[0].data[28] = k_space;      //
    MyPacket.packet[0].data[29] = k_space;      //
    
    MyPacket.packet[0].data[30] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
}

-(void) initTone
{
    MIDIPacketList MyPacket;
    
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
    MyPacket.packet[0].data[7] = 0;             // DCO Env Mode
    MyPacket.packet[0].data[8] = 0;             // VCF Env Mode
    MyPacket.packet[0].data[9] = 0;             // VCA Env Mode
    MyPacket.packet[0].data[10] = 0;             // DCO Waveform Pulse
    MyPacket.packet[0].data[11] = 1;             // DCO Waveform Saw
    MyPacket.packet[0].data[12] = 0;             // DCO WAveform Sub
    MyPacket.packet[0].data[13] = 3;             // DCO Range
    MyPacket.packet[0].data[14] = 0;             // DCO Sub Level
    MyPacket.packet[0].data[15] = 0;             // DCO Noise Level
    MyPacket.packet[0].data[16] = 0;             // HPF Cuttoff Freq
    MyPacket.packet[0].data[17] = 0;             // Chorus
    MyPacket.packet[0].data[18] = 0;             // DCO LFO Mod Depth
    MyPacket.packet[0].data[19] = 0;             // DCO Env Mod Depth
    MyPacket.packet[0].data[20] = 0;             // DCO After Depth
    MyPacket.packet[0].data[21] = 0;             // DCO PWM Depth
    MyPacket.packet[0].data[22] = 0;             // DCO PWM Rate
    MyPacket.packet[0].data[23] = 127;           // VCF Cuttoff Freq
    MyPacket.packet[0].data[24] = 0;             // VCF Resonance
    MyPacket.packet[0].data[25] = 0;             // VCF LFO Mod Depth
    MyPacket.packet[0].data[26] = 0;             // VCF Env Mod Depth
    MyPacket.packet[0].data[27] = 0;             // VCF Key Follow
    MyPacket.packet[0].data[28] = 0;             // VCF After Depth
    MyPacket.packet[0].data[29] = 127;           // VCA Level
    MyPacket.packet[0].data[30] = 0;             // VCA After Depth
    MyPacket.packet[0].data[31] = 0;             // LFO Rate
    MyPacket.packet[0].data[32] = 0;             // LFO Delay Time
    MyPacket.packet[0].data[33] = 0;             // Env T1
    MyPacket.packet[0].data[34] = 127;           // Env L1
    MyPacket.packet[0].data[35] = 0;             // Env T2
    MyPacket.packet[0].data[36] = 127;           // Env L2
    MyPacket.packet[0].data[37] = 0;             // Env T3
    MyPacket.packet[0].data[38] = 127;           // Env L3
    MyPacket.packet[0].data[39] = 0;             // Env T4
    MyPacket.packet[0].data[40] = 0;             // Env Key Follow
    MyPacket.packet[0].data[41] = 0;             // Chorus Rate
    MyPacket.packet[0].data[42] = 0;             // Bender Range
    
    // Patch Name
    MyPacket.packet[0].data[43] = k_I;          // I
    MyPacket.packet[0].data[44] = k_n;          // n
    MyPacket.packet[0].data[45] = k_i;          // i
    MyPacket.packet[0].data[46] = k_t;          // t
    MyPacket.packet[0].data[47] = k_space;      //
    MyPacket.packet[0].data[48] = k_space;      //
    MyPacket.packet[0].data[49] = k_space;      //
    MyPacket.packet[0].data[50] = k_space;      //
    MyPacket.packet[0].data[51] = k_space;      //
    MyPacket.packet[0].data[52] = k_space;      //
    
    MyPacket.packet[0].data[53] = 0xF7;  // End Sysex
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
}

- (IBAction)sliderDidMove:(NSSlider *)sender
{
    NSSlider *thisSlider = (NSSlider*) sender;
    NSString *ID = thisSlider.identifier;
    NSDictionary *sliders = @{
                              kLFO_RATE : [NSNumber numberWithInt: kLFORateTone],
                              kLFO_DELAY :[NSNumber numberWithInt: kLFODelayTimeTone],
                              kDCO_RANGE : [NSNumber numberWithInt: kDCORangeTone],
                              kDCO_LFO : [NSNumber numberWithInt: kDCOLFODepthTone],
                              kDCO_ENVELOPE : [NSNumber numberWithInt: kDCOEnvDepthTone],
                              kDCO_ENVELOPE_MODE : [NSNumber numberWithInt:kDCOEnvModeTone],
                              kDCO_AFTERTOUCH : [NSNumber numberWithInt:kDCOAfterDepthTone],
                              kPULSE_WAVE : [NSNumber numberWithInt:kDCOPulseWaveTone],
                              kSAW_WAVE : [NSNumber numberWithInt:kDCOSawWaveTone],
                              kSUB_WAVE : [NSNumber numberWithInt:kDCOSubWaveTone],
                              kSUB_LEVEL : [NSNumber numberWithInt:kDCOSubLevelTone],
                              kSUB_WAVE : [NSNumber numberWithInt:kDCOSubWaveTone],
                              kNOISE_LEVEL : [NSNumber numberWithInt:kDCONoiseLevelTone],
                              kPWM : [NSNumber numberWithInt:kDCOPWMDepthTone],
                              kPWM_RATE : [NSNumber numberWithInt:kDCOPWMRateTone],
                              kHPF : [NSNumber numberWithInt:kHPFTone],
                              kVCF_FREQ : [NSNumber numberWithInt:kVCFCuttoffTone],
                              kVCF_RES : [NSNumber numberWithInt:kVCFResonanceTone],
                              kVCF_LFO : [NSNumber numberWithInt:kVCFLFOModDepthTone],
                              kVCF_ENVELOPE : [NSNumber numberWithInt: kVCFEnvModDepthTone],
                              kVCF_ENVELOPE_MODE : [NSNumber numberWithInt:kVCFEnvModeTone],
                              kVCF_KEYFOLLOW : [NSNumber numberWithInt:kVCFKeyFollowTone],
                              kVCF_AFTERTOUCH : [NSNumber numberWithInt:kVCFAfterDepthTone],
                              kVCA_LEVEL : [NSNumber numberWithInt:kVCALevelTone],
                              kVCA_ENVELOPE_MODE : [NSNumber numberWithInt: kVCAEnvModeTone],
                              kVCA_AFTERTOUCH : [NSNumber numberWithInt:kVCAAfterDepthTone],
                              kCHORUS : [NSNumber numberWithInt:kChorusTone],
                              kVCA_LEVEL : [NSNumber numberWithInt:kVCALevelTone],
                              kCHORUS_RATE : [NSNumber numberWithInt:kChorusRateTone],
                              kT1 : [NSNumber numberWithInt:kEnvT1Tone],
                              kL1 : [NSNumber numberWithInt:kEnvL1Tone],
                              kT2 : [NSNumber numberWithInt:kEnvT2Tone],
                              kL2 : [NSNumber numberWithInt:kEnvL2Tone],
                              kT3 : [NSNumber numberWithInt:kEnvT3Tone],
                              kL3 : [NSNumber numberWithInt:kEnvL3Tone],
                              kT4 : [NSNumber numberWithInt:kEnvT4Tone],
                              kENVELOPE_KEYFOLLOW : [NSNumber numberWithInt:kEnvKeyFollowTone]
                              };
    
    NSNumber *sliderNum = sliders[ID];

    [self sendPatchMessageTo: [sliderNum integerValue] withValue: [thisSlider integerValue] ];
}

- (IBAction)fileNewToneClicked:(id)sender
{
    [self initTone];
}

- (IBAction)fileNewPatchClicked:(id)sender
{
    [self initPatch];
}

- (IBAction)patchButtonPressed:(id)sender
{
    if(self.lastButtonPressed != nil)
        [self.lastButtonPressed setNextState];
    self.lastButtonPressed = (PatchButton*) sender;
    self.patchNumber =(int)[[sender title] integerValue];
    
    MIDIPacketList MyPacket;
    
    MyPacket.numPackets = 1;
    MyPacket.packet[0].length = 2;
    MyPacket.packet[0].data[0] = 0xC0;  // Sysex
    MyPacket.packet[0].data[1] = self.patchNumber; // Value
    MyPacket.packet[0].timeStamp = 0;
    
    SendMidi(self.midiInterface, &MyPacket);
}


@end
