//
//  AppDelegate.m
//  MKS Librarian
//
//  Created by Steven Novak on 10/11/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "AppDelegate.hh"
#import "SliderEnum.hh"
#import "MKSConstant.h"
#import "PatchButton.h"
#import "MKS50.hh"

@interface AppDelegate ()


@property MKS50* Synth;
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

@property (weak) IBOutlet NSTextField *toneName;

@property PatchButton* lastButtonPressed;

@end

@implementation AppDelegate

- (IBAction)textDidChange:(id)sender
{
    [_Synth updateText:[_toneName stringValue]];
    //NSLog(@"%@", [_toneName stringValue]);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _Synth = [[MKS50 alloc] initWithDelegate: self];
    [_Synth loadPatch:[[Patch alloc] init]];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
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
    [_Synth changeParam:(int)[sliderNum integerValue] toValue:(int)[thisSlider integerValue]];
    //[self sendPatchMessageTo: [sliderNum integerValue] withValue: [thisSlider integerValue] ];
}

- (IBAction)fileNewHooverToneClicked:(id)sender
{
    Tone* initTone = [[Tone alloc] initWithHoover];
    [_Synth loadTone:initTone];
    [self updateSliders:initTone];
}

- (IBAction)fileNewToneClicked:(id)sender
{
    Tone* initTone = [[Tone alloc] init];
    [_Synth loadTone:initTone];
    [self updateSliders:initTone];
}

- (IBAction)fileNewPatchClicked:(id)sender
{
    Patch* initPatch = [[Patch alloc] init];
    initPatch.toneNubmer = _Synth.patchNumber;
    [_Synth loadPatch:initPatch];
}

- (IBAction)patchButtonPressed:(id)sender
{
    if(self.lastButtonPressed != nil)
        [self.lastButtonPressed setNextState];
    self.lastButtonPressed = (PatchButton*) sender;
    [_Synth changePatch:(int)[[sender title] integerValue]];
}

- (void) updateSliders: (Tone*) newTone
{
    _LFORateSlider.integerValue = newTone.LFO_Rate;
    _LFODelaySlider.integerValue = newTone.LFO_Delay_Time;
    _DCORangeSlider.integerValue = newTone.DCO_Range;
    _DCOLFOSlider.integerValue = newTone.DCO_LFO_Mod_Depth;
    _DCOEnvelopeSlider.integerValue = newTone.DCO_Env_Mod_Depth;
    _DCOEnvelopeMode.integerValue = newTone.DCO_Env_Mode;
    _DCOAfterTouchSlider.integerValue = newTone.DCO_After_Depth;
    _pulseWaveSlider.integerValue = newTone.DCO_Pulse_Wave;
    _sawWaveSlider.integerValue = newTone.DCO_Saw_Wave;
    _subWaveSlider.integerValue = newTone.DCO_Sub_Wave;
    _subLevelSlider.integerValue = newTone.DCO_Sub_Level;
    _noiseLevelSlider.integerValue = newTone.DCO_NoiseL_Level;
    _PWMAmountSlider.integerValue = newTone.DCO_PWM_Depth;
    _PWMRateSlider.integerValue = newTone.DCO_PWM_Rate;
    _HPFSlider.integerValue = newTone.HPF_Cuttoff;
    _VCFFreqSlider.integerValue = newTone.VCF_Cutoff_Freq;
    _VCFResSlider.integerValue = newTone.VCF_Resonance;
    _VCFLFOSlider.integerValue = newTone.VCF_LFO_MOD_Depth;
    _VCFEnvSlider.integerValue = newTone.VCF_Env_MOD_Depth;
    _VDFEnvShapeSlider.integerValue = newTone.VCF_Env_Mode;
    _VCFKeyFollowSlider.integerValue = newTone.VCF_Key_Follow;
    _VCFAfterSlider.integerValue = newTone.VCF_After_Depth;
    _VCALevelSlider.integerValue = newTone.VCA_Level;
    _EnvelopeModeSlider.integerValue = newTone.VCA_Env_Mode;
    _envelopeAfterTouchSlide.integerValue = newTone.VCA_After_Depth;
    _chorusOnOffSlider.integerValue = newTone.Chorus_On;
    _chorusRateSlider.integerValue = newTone.Chorus_Rate;
    _envelopeT1Slider.integerValue = newTone.Env_T1;
    _envelopeL1Slider.integerValue = newTone.Env_L1;
    _envelopeT2Slider.integerValue = newTone.Env_T2;
    _envelopeL2Slider.integerValue = newTone.Env_L2;
    _envelopeT3Slider.integerValue = newTone.Env_T3;
    _envelopeL3Slider.integerValue = newTone.Env_L3;
    _envelopeT4Slider.integerValue = newTone.Env_T4;
    _envelopeKeyFollowSlider.integerValue = newTone.Env_Key_Follow;
    
    [_LFORateSlider setNeedsDisplay: YES];
    [_LFODelaySlider setNeedsDisplay: YES];
    [_DCORangeSlider setNeedsDisplay: YES];
    [_DCOLFOSlider setNeedsDisplay: YES];
    [_DCOEnvelopeSlider setNeedsDisplay: YES];
    [_DCOEnvelopeMode setNeedsDisplay: YES];
    [_DCOAfterTouchSlider setNeedsDisplay: YES];
    [_pulseWaveSlider setNeedsDisplay: YES];
    [_sawWaveSlider setNeedsDisplay: YES];
    [_subWaveSlider setNeedsDisplay: YES];
    [_subLevelSlider setNeedsDisplay: YES];
    [_noiseLevelSlider setNeedsDisplay: YES];
    [_PWMAmountSlider setNeedsDisplay: YES];
    [_PWMRateSlider setNeedsDisplay: YES];
    [_HPFSlider setNeedsDisplay: YES];
    [_VCFFreqSlider setNeedsDisplay: YES];
    [_VCFResSlider setNeedsDisplay: YES];
    [_VCFLFOSlider setNeedsDisplay: YES];
    [_VCFEnvSlider  setNeedsDisplay: YES];
    [_VDFEnvShapeSlider setNeedsDisplay: YES];
    [_VCFKeyFollowSlider setNeedsDisplay: YES];
    [_VCFAfterSlider setNeedsDisplay: YES];
    [_VCALevelSlider setNeedsDisplay: YES];
    [_EnvelopeModeSlider setNeedsDisplay: YES];
    [_envelopeAfterTouchSlide setNeedsDisplay: YES];
    [_chorusOnOffSlider setNeedsDisplay: YES];
    [_chorusRateSlider setNeedsDisplay: YES];
    [_envelopeT1Slider setNeedsDisplay: YES];
    [_envelopeL1Slider setNeedsDisplay: YES];
    [_envelopeT2Slider setNeedsDisplay: YES];
    [_envelopeL2Slider setNeedsDisplay: YES];
    [_envelopeT3Slider setNeedsDisplay: YES];
    [_envelopeL3Slider setNeedsDisplay: YES];
    [_envelopeT4Slider setNeedsDisplay: YES];
    [_envelopeKeyFollowSlider setNeedsDisplay: YES];
    
}

-(bool) parseSysex: (NSMutableArray*) dataBuffer
{
    if((int)[dataBuffer count] == 31)
    {
        // Handle Patch Change
    }
    else if((int)[dataBuffer count] == 54)
    {
        Tone* newTone = [[Tone alloc] init];
        int i = 7;
        
        newTone.DCO_Env_Mode  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_Env_Mode  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCA_Env_Mode  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_Pulse_Wave  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.DCO_Pulse_Wave  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_Saw_Wave  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_Sub_Wave  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_Range  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.DCO_Sub_Level  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_NoiseL_Level  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.HPF_Cuttoff  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Chorus_On  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.DCO_LFO_Mod_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_Env_Mod_Depth= [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_After_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.DCO_PWM_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.DCO_PWM_Rate  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_Cutoff_Freq  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_Resonance  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_LFO_MOD_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.VCF_Env_MOD_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_Key_Follow  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCF_After_Depth = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.VCA_Level  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.VCA_After_Depth  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.LFO_Rate  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.LFO_Delay_Time  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_T1  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.Env_L1  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_T2  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_L2  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_T3  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.Env_L3  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_T4  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Env_Key_Follow  = [[dataBuffer objectAtIndex:i++] intValue];
        newTone.Chorus_Rate  = [[dataBuffer objectAtIndex:i++] intValue];
        
        newTone.Bender_Range  = [[dataBuffer objectAtIndex:i++] intValue];
        
        [self updateSliders: newTone];

    }
    else
    {
        return NO;
    }
    
    return YES;
}


@end
