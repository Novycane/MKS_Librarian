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
#import "UtilityFunctions.hpp"
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

@property PatchButton* lastButtonPressed;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    _Synth = [[MKS50 alloc] init];
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

- (IBAction)fileNewToneClicked:(id)sender
{
    Tone* initTone = [[Tone alloc] init];
    [_Synth loadTone:initTone];
    //[self initTone];
}

- (IBAction)fileNewPatchClicked:(id)sender
{
    Patch* initPatch = [[Patch alloc] init];
    initPatch.toneNubmer = _Synth.patchNumber;
    [_Synth loadPatch:initPatch];
    //[self initPatch];
    
}

- (IBAction)patchButtonPressed:(id)sender
{
    if(self.lastButtonPressed != nil)
        [self.lastButtonPressed setNextState];
    self.lastButtonPressed = (PatchButton*) sender;
    [_Synth changePatch:(int)[[sender title] integerValue]];
}


@end
