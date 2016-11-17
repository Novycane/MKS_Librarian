//
//  MidiInterface.m
//  MKS Librarian
//
//  Created by Steven Novak on 11/16/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "MidiInterface.hh"

@implementation MidiInterface

-(id) init
{
    self = [super init];

    
    return self;
}

-(void) addInput: (CFStringRef) input
{
    _inputs.push_back(input);
}

-(void) addOutput: (CFStringRef) output
{
    _outputs.push_back(output);
}



@end
