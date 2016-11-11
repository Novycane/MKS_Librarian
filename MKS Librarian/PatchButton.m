//
//  PatchButton.m
//  MKS Librarian
//
//  Created by Steven Novak on 11/11/16.
//  Copyright © 2016 Steven Novak. All rights reserved.
//

#import "PatchButton.h"
IB_DESIGNABLE
@implementation PatchButton

- (void)awakeFromNib
{
    NSImage *litImage =[NSImage imageNamed:@"Patch Button Lit.png"];
    NSImage *idleImage =[NSImage imageNamed:@"Button Idle.png"];
    [self setImage:idleImage];
    [self setAlternateImage:litImage];
}

- (void) setSelected: (BOOL) yn
{
    NSImage *const tmp = [self image];
    [self setImage:[self alternateImage]];
    [self setAlternateImage:tmp];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
