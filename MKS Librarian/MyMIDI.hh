//
//  MyMIDI.hpp
//  MidiInterface
//
//  Created by Steven Novak on 6/9/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#ifndef MyMIDI_hpp
#define MyMIDI_hpp

#import <CoreMIDI/CoreMIDI.h>
#import <CoreFoundation/CoreFoundation.h>
#import <vector>
#import <Foundation/Foundation.h>
#import "MKSProtocol.hh"
#import "MidiInterface.hh"

/*
typedef struct MyMidiInterface
{
    MIDIClientRef Client;
    MIDIPortRef InPort;
    MIDIPortRef OutPort;
    
    MIDIEndpointRef InEndpoint;
    MIDIEndpointRef OutEndpoint;
    
    std::vector<CFStringRef> inputs;
    std::vector<CFStringRef> outputs;
    
    NSMutableArray* dataBuffer;
    
} MyMidiInterface;
*/

void InitMIDI(MidiInterface* MidiInterface);
void MyMidiNotifyProc(const MIDINotification*, void* refcon);
void MyMidiReadProc(const MIDIPacketList*, void* refcon, void* connRefcon);
void MyMidiConnectOutput(MidiInterface* MidiInterface, CFStringRef OutputName);
void SendMidi(MidiInterface* MidiInterface, MIDIPacketList* MIDIPackets);
void MyMidiConnectInput(MidiInterface* MidiInterface, CFStringRef InputName);

void GetInputs(MidiInterface*);
void GetOutputs(MidiInterface*);

OSStatus SendMidiMessage();




#endif /* MyMIDI_hpp */
