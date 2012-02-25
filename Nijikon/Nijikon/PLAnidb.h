//
//  PLAnidb.h
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncUdpSocket.h"
#import "PLAnidbBasics.h"
#import "PLAnidbData.h"

@interface PLAnidb : NSObject < GCDAsyncUdpSocketDelegate > {
    GCDAsyncUdpSocket* socket;
    NSDate* lastCommand;
    long currentTag;
    NSMutableDictionary* queue;
    NSString* sessionKey;
}

- (id)initWithHost:(NSString*)host port:(uint16_t)port;

- (BOOL)executeCommand:(id<PLCommand>)aCommand;

@end
