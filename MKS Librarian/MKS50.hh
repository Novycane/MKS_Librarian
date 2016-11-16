//
//  MKS50.h
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patch.h"
#import "Tone.h"
#import "MyMidi.hh"

@interface MKS50 : NSObject

@property MyMidiInterface *midiInterface;
@property int midiChannel;
@property int patchNumber;
@property int toneNumber;


-(bool) autoDetectMidi;
-(bool) loadPatch:(Patch*) patchToLoad;
-(bool) loadTone:(Tone*) toneToLoad;
-(bool) changeParam: (int) param toValue: (int)value;
-(bool) changePatch: (int) patchNum;

@end
