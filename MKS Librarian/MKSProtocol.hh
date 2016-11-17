//
//  MKSProtocol.h
//  MKS Librarian
//
//  Created by Steven Novak on 11/16/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKSInterfaceDelegate <NSObject>

-(bool) parseSysex: (NSMutableArray*) dataBuffer;

@end
