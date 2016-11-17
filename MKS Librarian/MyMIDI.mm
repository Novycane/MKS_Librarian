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

void InitMIDI(MidiInterface* MyMidiInterface )
{
    MIDIClientRef Client;
    MIDIPortRef InPort;
    MIDIPortRef OutPort;
    
    CheckError(MIDIClientCreate(CFSTR("Midi Interface"),
                     MyMidiNotifyProc,
                     &MyMidiInterface,
                     &Client),
               "Couldn't Create MIDI Client");
    [MyMidiInterface setClient:Client];
    
    CheckError(MIDIInputPortCreate(MyMidiInterface.Client,
                        CFSTR("Input Port"),
                        MyMidiReadProc,
                        &MyMidiInterface,
                        &InPort),
               "Could Not Create Input Port");
    [MyMidiInterface setInPort:InPort];

    CheckError(MIDIOutputPortCreate(MyMidiInterface.Client,
                        CFSTR("Output Port"),
                        &OutPort),
               "Could Not Create Output Port");
    [MyMidiInterface setOutPort:OutPort];
    
}

void MyMidiNotifyProc(const MIDINotification* message, void* refcon)
{
    printf("MIDI Notify, messageID=%d", message->messageID);
}

void MyMidiReadProc(const MIDIPacketList* pktlist, void* refcon, void* connRefcon)
{
    MidiInterface* MyMidiInterface = (__bridge MidiInterface*) refcon;
    MIDIPacket* packet = (MIDIPacket*) pktlist->packet;
    
    // Need to queue up MIDI data then process
    if(packet->data[0] == 0xF0)
    {
        // init data buffer routine
        sysexRecieved = true;
        byteCount=0;
        MyMidiInterface.dataBuffer = [[NSMutableArray alloc] init];
        for(int i=0; i< packet->length; i++)
        {
            printf("Sysex byte %d : %2X\n", i, packet->data[i]);
            [MyMidiInterface.dataBuffer addObject:[NSNumber numberWithInt:packet->data[i]]];
            if(packet->data[i] == 0xF7)
            {
                sysexRecieved = false;
                //MyMidiInterface->parseBuffer(MidiInterface->dataBuffer);
                [MyMidiInterface.delegate parseSysex: MyMidiInterface.dataBuffer];
            }
        }
    }
    else if (sysexRecieved)
    {
        for(int i=0; i< packet->length; i++)
        {
            printf("Sysex byte %d : %2X\n", i, packet->data[i]);
            [MyMidiInterface.dataBuffer addObject:[NSNumber numberWithInt:packet->data[i]]];
            if(packet->data[i] == 0xF7)
            {
                sysexRecieved = false;
                [MyMidiInterface.delegate parseSysex: MyMidiInterface.dataBuffer];
            }
        }
    }
    else
    {
        sysexRecieved = false;
        CheckError(MIDISend(MyMidiInterface.OutPort, MyMidiInterface.OutEndpoint, pktlist),
                   "Could Not Echo MIDI Message");
    }
}

// -------------------------------
//
//  Connect Midi Input
//
// -------------------------------
void MyMidiConnectInput(MidiInterface* MidiInterface, CFStringRef InputName)
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
                        MidiInterface.InEndpoint = ThisEndpoint;
                        CheckError(MIDIPortConnectSource(MidiInterface.InPort,
                                                         MidiInterface.InEndpoint,
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

void MyMidiConnectOutput(MidiInterface* MyMidiInterface, CFStringRef OutputName)
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
                        MyMidiInterface.OutEndpoint = ThisEndpoint;
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

void GetInputs(MidiInterface* MyMidiInterface)
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
                    
                    MyMidiInterface.inputs.push_back(mDeviceName);
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

void GetOutputs(MidiInterface* MyMidiInterface)
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
                    
                    MyMidiInterface.outputs.push_back(mDeviceName);
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
void SendMidi(MidiInterface* MyMidiInterface, MIDIPacketList* MIDIPackets)
{
    CheckError(MIDISend(MyMidiInterface.OutPort, MyMidiInterface.OutEndpoint, MIDIPackets),
               "Could Not Send MIDI Message");
}






