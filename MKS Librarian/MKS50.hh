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
#import "MKSProtocol.hh"
#import "MyMidi.hh"
#import "MKSConstant.h"

@interface MKS50 : NSObject

@property MidiInterface *midiInterface;
@property int midiChannel;
@property int patchNumber;
@property int toneNumber;
@property(nonatomic, weak)id <MKSInterfaceDelegate> delegate;

-(id) initWithDelegate: (id <MKSInterfaceDelegate>) newDelegate;
-(bool) autoDetectMidi;
-(bool) loadPatch:(Patch*) patchToLoad;
-(bool) loadTone:(Tone*) toneToLoad;
-(bool) changeParam: (int) param toValue: (int)value;
-(bool) changePatch: (int) patchNum;

@end
