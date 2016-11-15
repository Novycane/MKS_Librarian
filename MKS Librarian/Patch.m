//
//  Patch.m
//  MKS Librarian
//
//  Created by Steven Novak on 11/12/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "Patch.h"

@implementation Patch

-(id) init: (int) toneNum
{
    self = [super init];
    self.text = @"Init      ";
    self.toneNubmer = toneNum;
    self.keyRangeLow = 12;
    self.keyRangeHigh = 109;
    self.portamentoTime = 0;
    self.portamentoTime = 0;
    self.modSensitivity = 127;
    self.keyShift = 15;
    self.volume = 100;
    self.detune = 64;
    self.midiFunction = 0x77;
    self.monoRange = 5;
    self.chordMemory = 0;
    self.keyAssign = 0;
    return self;
}

-(id) init
{
    self = [super init];
    self.text = @"Init      ";
    self.toneNubmer = 0;
    self.keyRangeLow = 12;
    self.keyRangeHigh = 109;
    self.portamentoTime = 0;
    self.portamentoTime = 0;
    self.modSensitivity = 127;
    self.keyShift = 15;
    self.volume = 100;
    self.detune = 64;
    self.midiFunction = 0x77;
    self.monoRange = 5;
    self.chordMemory = 0;
    self.keyAssign = 0;
    return self;
}

-(NSString*) getCharAtIndex :(int) index
{
    return [NSString stringWithFormat:@"%c", [self.text characterAtIndex: index]];
}

@end
