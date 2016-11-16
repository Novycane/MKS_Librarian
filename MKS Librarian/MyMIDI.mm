//
//  MyMIDI.cpp
//  MidiInterface
//
//  Created by Steven Novak on 6/9/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#include "MyMIDI.hh"
#include "UtilityFunctions.hpp"

static int byteCount = 0;
static bool sysexRecieved = false;

void InitMIDI(MyMidiInterface* MidiInterface )
{
    CheckError(MIDIClientCreate(CFSTR("Midi Interface"),
                     MyMidiNotifyProc,
                     MidiInterface,
                     &MidiInterface->Client),
               "Couldn't Create MIDI Client");
    
    CheckError(MIDIInputPortCreate(MidiInterface->Client,
                        CFSTR("Input Port"),
                        MyMidiReadProc,
                        MidiInterface,
                        &MidiInterface->InPort),
               "Could Not Create Input Port");
    

    CheckError(MIDIOutputPortCreate(MidiInterface->Client,
                        CFSTR("Output Port"),
                        &MidiInterface->OutPort),
               "Could Not Create Output Port");
    
    
}

void MyMidiNotifyProc(const MIDINotification* message, void* refcon)
{
    printf("MIDI Notify, messageID=%d", message->messageID);
}

void MyMidiReadProc(const MIDIPacketList* pktlist, void* refcon, void* connRefcon)
{
    MyMidiInterface* MidiInterface = (MyMidiInterface*) refcon;
    MIDIPacket* packet = (MIDIPacket*) pktlist->packet;
    
    // Need to queue up MIDI data then process
    if(packet->data[0] == 0xF0)
    {
        // init data buffer routine
        sysexRecieved = true;
        byteCount=0;
        MidiInterface->dataBuffer = [[NSMutableArray alloc] init];
        for(int i=0; i< packet->length; i++)
        {
            [MidiInterface->dataBuffer addObject:[NSNumber numberWithInt:packet->data[i]]];
            if(packet->data[i] == 0xF7)
            {
                sysexRecieved = false;
                MidiInterface->parseBuffer(MidiInterface->dataBuffer);
            }
            printf("Sysex byte %d : %2X\n", i, packet->data[i]);
            
        }
    }
    else if (sysexRecieved)
    {
        for(int i=0; i< packet->length; i++)
        {
            [MidiInterface->dataBuffer addObject:[NSNumber numberWithInt:packet->data[i]]];
            printf("Sysex byte %d : %2X\n", i, packet->data[i]);
        }
    }
    else
    {
        sysexRecieved = false;
        CheckError(MIDISend(MidiInterface->OutPort, MidiInterface->OutEndpoint, pktlist),
                   "Could Not Echo MIDI Message");
    }
}

// -------------------------------
//
//  Connect Midi Input
//
// -------------------------------
void MyMidiConnectInput(MyMidiInterface* MidiInterface, CFStringRef InputName)
{
    unsigned long numDevices = MIDIGetNumberOfDevices();
    
    for (int i=0; i<numDevices; i++)
    {
        MIDIDeviceRef MidiDevice = MIDIGetDevice(i);
        
        SInt32 IsOffline = 0;
        MIDIObjectGetIntegerProperty(MidiDevice,
                                     kMIDIPropertyOffline,
                                     &IsOffline);
        // ----------------------------------------------- Check If Midi Device Is Online
        if (!IsOffline)
        {
            CFStringRef deviceName = nil;
            MIDIObjectGetStringProperty(MidiDevice,
                                        kMIDIPropertyName,
                                        &deviceName);
            
            ItemCount EntityCount = MIDIDeviceGetNumberOfEntities(MidiDevice);
            
            for(int j=0; j<EntityCount; j++)
            {
                MIDIEntityRef ThisEntity = MIDIDeviceGetEntity(MidiDevice, j);
                
                ItemCount SourceEndpoints = MIDIEntityGetNumberOfSources(ThisEntity);
                
                for(int k=0; k<SourceEndpoints; k++)
                {
                    MIDIEndpointRef ThisEndpoint = MIDIEntityGetSource(ThisEntity, k);
                    CFStringRef EndpointName  = nil;
                    MIDIObjectGetStringProperty(ThisEndpoint, kMIDIPropertyName, &EndpointName);
                    
                    CFMutableStringRef mDeviceName = CFStringCreateMutable(NULL, 0);
                    CFStringAppend(mDeviceName, deviceName);
                    CFStringAppend(mDeviceName, EndpointName);
                    
                    //CFComparisonResult result = CFStringCompare(mDeviceName, InputName, kCFCompareCaseInsensitive);
                    
                    //if(result == kCFCompareEqualTo)
                    //{
                        MidiInterface->InEndpoint = ThisEndpoint;
                        CheckError(MIDIPortConnectSource(MidiInterface->InPort,
                                                         MidiInterface->InEndpoint,
                                                         NULL),
                                   "Couldn't Connect MIDI Source");
                      
                    //}
                } // End For k
            } // End For j
        }// End If Offline
    } // End For i
    

}

// -------------------------------
//
//  Connect Midi Output
//
// -------------------------------

void MyMidiConnectOutput(MyMidiInterface* MidiInterface, CFStringRef OutputName)
{
    unsigned long numDevices = MIDIGetNumberOfDevices();
    
    for (int i=0; i<numDevices; i++)
    {
        MIDIDeviceRef MidiDevice = MIDIGetDevice(i);
        
        SInt32 IsOffline = 0;
        MIDIObjectGetIntegerProperty(MidiDevice,
                                     kMIDIPropertyOffline,
                                     &IsOffline);
        // ----------------------------------------------- Check If Midi Device Is Online
        if (!IsOffline)
        {
            CFStringRef deviceName = nil;
            MIDIObjectGetStringProperty(MidiDevice,
                                        kMIDIPropertyName,
                                        &deviceName);
            
            ItemCount EntityCount = MIDIDeviceGetNumberOfEntities(MidiDevice);
            
            for(int j=0; j<EntityCount; j++)
            {
                MIDIEntityRef ThisEntity = MIDIDeviceGetEntity(MidiDevice, j);
                
                ItemCount DestEndpoints = MIDIEntityGetNumberOfDestinations(ThisEntity);
                
                for(int k=0; k<DestEndpoints; k++)
                {
                    MIDIEndpointRef ThisEndpoint = MIDIEntityGetDestination(ThisEntity, k);
                    CFStringRef EndpointName  = nil;
                    MIDIObjectGetStringProperty(ThisEndpoint, kMIDIPropertyName, &EndpointName);
                    
                    CFMutableStringRef mDeviceName = CFStringCreateMutable(NULL, 0);
                    CFStringAppend(mDeviceName, deviceName);
                    CFStringAppend(mDeviceName, EndpointName);
                    
                    CFComparisonResult result = CFStringCompare(mDeviceName, OutputName, kCFCompareCaseInsensitive);
                    
                    if(result == kCFCompareEqualTo)
                    {
                        MidiInterface->OutEndpoint = ThisEndpoint;
                    }
                } // End For k
            } // End For j
        }// End If Offline
    } // End For i
    
}

// -------------------------------
//
//  Find Active Inputs On The System
//
// -------------------------------

void GetInputs(MyMidiInterface* MidiInterface)
{
    unsigned long numDevices = MIDIGetNumberOfDevices();
    
    for (int i=0; i<numDevices; i++)
    {
        MIDIDeviceRef MidiDevice = MIDIGetDevice(i);
        
        SInt32 IsOffline = 0;
        MIDIObjectGetIntegerProperty(MidiDevice,
                                     kMIDIPropertyOffline,
                                     &IsOffline);
        // ----------------------------------------------- Check If Midi Device Is Online
        if (!IsOffline)
        {
            CFStringRef deviceName = nil;
            MIDIObjectGetStringProperty(MidiDevice,
                                        kMIDIPropertyName,
                                        &deviceName);
            
            ItemCount EntityCount = MIDIDeviceGetNumberOfEntities(MidiDevice);
            
            for(int j=0; j<EntityCount; j++)
            {
                MIDIEntityRef ThisEntity = MIDIDeviceGetEntity(MidiDevice, j);
                
                ItemCount SourceEndpoints = MIDIEntityGetNumberOfSources(ThisEntity);
                
                for(int k=0; k<SourceEndpoints; k++)
                {
                    MIDIEndpointRef ThisEndpoint = MIDIEntityGetSource(ThisEntity, k);
                    CFStringRef EndpointName  = nil;
                    MIDIObjectGetStringProperty(ThisEndpoint, kMIDIPropertyName, &EndpointName);
                    
                    CFMutableStringRef mDeviceName = CFStringCreateMutable(NULL, 0);
                    CFStringAppend(mDeviceName, deviceName);
                    CFStringAppend(mDeviceName, EndpointName);
                    
                    MidiInterface->inputs.push_back(mDeviceName);
                } // End For k
            } // End For j
        }// End If Offline
    } // End For i
}

// -------------------------------
//
//  Find Active Outputs In The System
//
// -------------------------------

void GetOutputs(MyMidiInterface* MidiInterface)
{
    unsigned long numDevices = MIDIGetNumberOfDevices();
    
    for (int i=0; i<numDevices; i++)
    {
        MIDIDeviceRef MidiDevice = MIDIGetDevice(i);
        
        SInt32 IsOffline = 0;
        MIDIObjectGetIntegerProperty(MidiDevice,
                                     kMIDIPropertyOffline,
                                     &IsOffline);
        // ----------------------------------------------- Check If Midi Device Is Online
        if (!IsOffline)
        {
            CFStringRef deviceName = nil;
            MIDIObjectGetStringProperty(MidiDevice,
                                        kMIDIPropertyName,
                                        &deviceName);
            
            ItemCount EntityCount = MIDIDeviceGetNumberOfEntities(MidiDevice);
            
            for(int j=0; j<EntityCount; j++)
            {
                MIDIEntityRef ThisEntity = MIDIDeviceGetEntity(MidiDevice, j);
                
                ItemCount DestEndpoints = MIDIEntityGetNumberOfDestinations(ThisEntity);
                
                for(int k=0; k<DestEndpoints; k++)
                {
                    MIDIEndpointRef ThisEndpoint = MIDIEntityGetSource(ThisEntity, k);
                    CFStringRef EndpointName  = nil;
                    MIDIObjectGetStringProperty(ThisEndpoint, kMIDIPropertyName, &EndpointName);
                    
                    CFMutableStringRef mDeviceName = CFStringCreateMutable(NULL, 0);
                    CFStringAppend(mDeviceName, deviceName);
                    CFStringAppend(mDeviceName, EndpointName);
                    
                    MidiInterface->outputs.push_back(mDeviceName);
                } // End For k
            } // End For j
        }// End If Offline
    } // End For i
}


// -------------------------------
//
//  Send MIDI
//
// -------------------------------
void SendMidi(MyMidiInterface* MidiInterface, MIDIPacketList* MIDIPackets)
{
    CheckError(MIDISend(MidiInterface->OutPort, MidiInterface->OutEndpoint, MIDIPackets),
               "Could Not Send MIDI Message");
}






