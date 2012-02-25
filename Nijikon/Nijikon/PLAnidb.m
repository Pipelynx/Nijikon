//
//  PLAnidb.m
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import "PLAnidb.h"

@implementation PLAnidb

- (id)init {
    if (self = [super init]) {
        socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        lastCommand = [NSDate distantPast];
        currentTag = 0;
        queue = [NSMutableDictionary dictionary];
        sessionKey = @"";
    }
    return self;
}

- (id)initWithHost:(NSString*)host port:(uint16_t)port {
    self = [self init];
    NSError* err = nil;
    if (![socket connectToHost:host onPort:port error:&err])
        NSLog(@"Error: %@", err);
    if (![socket beginReceiving:&err])
        NSLog(@"Error: %@", err);
    return self;
}

- (void)close {
    [socket close];
}

- (BOOL)executeCommand:(id<PLCommand>)aCommand {
    [NSThread sleepUntilDate:[lastCommand dateByAddingTimeInterval:2]];
    [aCommand setParameter:@"tag" toValue:[NSString stringWithFormat:@"%i", currentTag]];
    [aCommand setParameter:@"session key" toValue:sessionKey];
    [queue setValue:aCommand forKey:[[aCommand parameters] objectForKey:@"tag"]];
    [socket sendData:[aCommand commandData] withTimeout:-1 tag:currentTag];
    [aCommand setExecuted];
    lastCommand = [NSDate date];
    currentTag++;
    return YES;
}

#pragma mark GCDAsyncUdpSocket implementation

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData*)address {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError*)error {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError*)error {
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData*)data fromAddress:(NSData*)address withFilterContext:(id)filterContext {
    NSString* tag = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByString:@" "] objectAtIndex:0];
    id<PLCommand> command = [queue objectForKey:tag];
    [command parseResult:data];
    if ([command isKindOfClass:[PLAnidbAuth class]])
        sessionKey = [[command results] objectForKey:@"session key"];
    if ([command isKindOfClass:[PLAnidbLogout class]])
        sessionKey = @"";
    [queue removeObjectForKey:tag];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError*)error {
    
}

@end
