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
    bool (*parseBuffer)(NSMutableArray*);
    
} MyMidiInterface;

void InitMIDI(MyMidiInterface* MidiInterface);
void MyMidiNotifyProc(const MIDINotification*, void* refcon);
void MyMidiReadProc(const MIDIPacketList*, void* refcon, void* connRefcon);
void MyMidiConnectOutput(MyMidiInterface* MidiInterface, CFStringRef OutputName);
void SendMidi(MyMidiInterface* MidiInterface, MIDIPacketList* MIDIPackets);
void MyMidiConnectInput(MyMidiInterface* MidiInterface, CFStringRef InputName);

void GetInputs(MyMidiInterface*);
void GetOutputs(MyMidiInterface*);

OSStatus SendMidiMessage();




#endif /* MyMIDI_hpp */
