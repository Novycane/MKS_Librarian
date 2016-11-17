//
//  MidiInterface.h
//  MKS Librarian
//
//  Created by Steven Novak on 11/16/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <Foundation/Foundation.h>
#import "MKSProtocol.hh"
#import <vector>


@interface MidiInterface : NSObject

@property MIDIClientRef Client;
@property MIDIPortRef InPort;
@property MIDIPortRef OutPort;

@property MIDIEndpointRef InEndpoint;
@property MIDIEndpointRef OutEndpoint;

@property std::vector<CFStringRef> inputs;
@property std::vector<CFStringRef> outputs;

@property NSMutableArray* dataBuffer;
@property(nonatomic, weak)id <MKSInterfaceDelegate> delegate;

-(void) setClient: (MIDIClientRef) thisClient;
-(void) setInPort: (MIDIPortRef) thisPort;
-(void) setOutPort: (MIDIPortRef) thisPort;
-(void) addInput: (CFStringRef) input;
-(void) addOutput: (CFStringRef) output;

@end
