//
//  Patch.h
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patch : NSObject

@property int toneNubmer;
@property int keyRangeLow;
@property int keyRangeHigh;
@property int portamentoTime;
@property int portamento;
@property int modSensitivity;
@property int keyShift;
@property int volume;
@property int detune;
@property int midiFunction;
@property int monoRange;
@property int chordMemory;
@property int keyAssign;
@property NSString* text;

-(NSString*) getCharAtIndex :(int) index;

@end
