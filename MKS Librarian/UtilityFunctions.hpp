//
//  UtilityFunctions.hpp
//  MidiInterface
//
//  Created by Steven Novak on 6/9/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#ifndef UtilityFunctions_hpp
#define UtilityFunctions_hpp

#include <AudioToolbox/AudioToolbox.h>

static void CheckError(OSStatus error, const char *operation)
{
    if(error == noErr)
        return;
    
    char errorString[20];
    *(UInt32*)(errorString +1) = CFSwapInt32HostToBig(error);
    if(isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4]))
    {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    }
    else
    {
        sprintf(errorString, "%d", (int)error);
    }   // End if
    
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    
    exit(1);
}   // End check error


#endif /* UtilityFunctions_hpp */
