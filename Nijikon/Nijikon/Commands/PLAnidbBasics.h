//
//  PLAnidbBasics.h
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLCommand.h"

#define enc NSUTF8StringEncoding

@class PLAnidbPing;
@class PLAnidbAuth;
@class PLAnidbLogout;
@class PLAnidbFile;

@interface PLAnidbCommand : NSObject < PLCommand > {
    NSMutableDictionary* parameters;
    NSMutableDictionary* results;
    BOOL executed;
}

+ (PLAnidbPing*)ping;
+ (PLAnidbAuth*)auth;
+ (PLAnidbLogout*)logout;
+ (PLAnidbFile*)fileByFid;
+ (PLAnidbFile*)fileByEd2k;

@end

@interface PLAnidbPing : PLAnidbCommand @end
@interface PLAnidbAuth : PLAnidbCommand @end
@interface PLAnidbLogout : PLAnidbCommand @end