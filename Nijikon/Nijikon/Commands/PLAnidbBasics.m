//
//  PLAnidbBasics.m
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import "PLAnidbBasics.h"
#import "PLAnidbData.h"

@implementation PLAnidbCommand

- (id)init {
    if (self = [super init]) {
        parameters = [NSMutableDictionary dictionary];
        results = nil;
        executed = NO;
    }
    return self;
}

+ (PLAnidbPing*)ping {
    PLAnidbPing* temp = [[PLAnidbPing alloc] init];
    [temp setParameter:@"nat" toValue:@"0"];
    return temp;
}
+ (PLAnidbAuth*)auth {
    PLAnidbAuth* temp = [[PLAnidbAuth alloc] init];
    [temp setParameter:@"user" toValue:@""];
    [temp setParameter:@"pass" toValue:@""];
    [temp setParameter:@"protover" toValue:@"3"];
    [temp setParameter:@"client" toValue:@""];
    [temp setParameter:@"clientver" toValue:@"1"];
    [temp setParameter:@"nat" toValue:@"0"];
    [temp setParameter:@"comp" toValue:@"0"];
    [temp setParameter:@"enc" toValue:@"UTF8"];
    [temp setParameter:@"mtu" toValue:@"1400"];
    [temp setParameter:@"imgserver" toValue:@"0"];
    return temp;
}

+ (PLAnidbLogout*)logout {
    PLAnidbLogout* temp = [[PLAnidbLogout alloc] init];
    return temp;
}

+ (PLAnidbFile*)file {
    PLAnidbFile* temp = [[PLAnidbFile alloc] init];
    return temp;
}

+ (PLAnidbFile*)fileByFid {
    PLAnidbFile* temp = [self file];
    [temp setParameter:@"fid" toValue:@""];
    return temp;
}

+ (PLAnidbFile*)fileByEd2k {
    PLAnidbFile* temp = [self file];
    [temp setParameter:@"size" toValue:@""];
    [temp setParameter:@"ed2k" toValue:@""];
    return temp;
}

- (void)setExecuted {
    executed = YES;
}

- (NSData*)commandData {
    return nil;
}
- (void)parseResult:(NSData*)resultData {
    if (!results)
        results = [NSMutableDictionary dictionary];
    NSString* result = [[[[NSString alloc] initWithData:resultData encoding:enc] componentsSeparatedByString:@"\n"] objectAtIndex:0];
    NSArray* parts = [result componentsSeparatedByString:@" "];
    [results setValue:[parts objectAtIndex:0] forKey:@"tag"];
    [results setValue:[parts objectAtIndex:1] forKey:@"return code"];
}

- (NSDictionary*)parameters {
    return parameters;
}
- (void)setParameters:(NSDictionary*)newParameters {
    parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
}
- (void)setParameter:(NSString*)key toValue:(NSString*)value {
    [parameters setValue:value forKey:key];
}

- (int)returnCode {
    return [[[self results] objectForKey:@"return code"] intValue];
}
- (NSDictionary*)results {
    int i = 0;
    if (executed)
        while (!results) {
            if (i > 500)
                return nil;
            [NSThread sleepForTimeInterval:0.01];
            i++;
        }
    return results;
}

@end

@implementation PLAnidbPing
#define PING @"PING nat=%@&tag=%@"
- (NSData*)commandData {
    return [[NSString stringWithFormat:PING, [parameters objectForKey:@"nat"], [parameters objectForKey:@"tag"]] dataUsingEncoding:enc];
}
- (void)parseResult:(NSData*)resultData {
    [super parseResult:resultData];
    NSString* result = [[[[NSString alloc] initWithData:resultData encoding:enc] componentsSeparatedByString:@"\n"] objectAtIndex:1];
    [results setValue:result forKey:@"port"];
}

@end

@implementation PLAnidbAuth
#define AUTH @"AUTH user=%@&pass=%@&protover=%@&client=%@&clientver=%@&nat=%@&comp=%@&enc=%@&mtu=%@&imgserver=%@&tag=%@"
- (NSData*)commandData {
    return [[NSString stringWithFormat:AUTH, [parameters objectForKey:@"user"], [parameters objectForKey:@"pass"], [parameters objectForKey:@"protover"], [parameters objectForKey:@"client"], [parameters objectForKey:@"clientver"], [parameters objectForKey:@"nat"], [parameters objectForKey:@"comp"], [parameters objectForKey:@"enc"], [parameters objectForKey:@"mtu"], [parameters objectForKey:@"imgserver"], [parameters objectForKey:@"tag"]] dataUsingEncoding:enc];
}
- (void)parseResult:(NSData*)resultData {
    [super parseResult:resultData];
    NSArray* result = [[[NSString alloc] initWithData:resultData encoding:enc] componentsSeparatedByString:@"\n"];
    NSArray* parts = [[result objectAtIndex:0] componentsSeparatedByString:@" "];
    switch ([[results objectForKey:@"return code"] intValue]) {
        case ADBLoginAccepted:
        case ADBLoginAcceptedNewVersion:
            //1 200 lptaJ 188.23.108.100:62515 LOGIN ACCEPTED
            //img7.anidb.net
            [results setValue:[parts objectAtIndex:2] forKey:@"session key"];
            if ([[parameters objectForKey:@"nat"] isEqualToString:@"1"]) {
                [results setValue:[[[parts objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:0] forKey:@"ip"];
                [results setValue:[[[parts objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1] forKey:@"port"];
            }
            if ([[parameters objectForKey:@"imgserver"] isEqualToString:@"1"])
                [results setValue:[result objectAtIndex:1] forKey:@"image server name"];
            break;
        case ADBLoginFailed:
            break;
        case ADBClientVersionOutdated:
            break;
        case ADBClientBanned:
            break;
        case ADBIllegalInputOrAccessDenied:
            break;
        case ADBAnidbOutOfService:
            break;
    }
}

@end

@implementation PLAnidbLogout
#define LOGOUT @"LOGOUT tag=%@&s=%@"
- (NSData*)commandData {
    return [[NSString stringWithFormat:LOGOUT, [parameters objectForKey:@"tag"], [parameters objectForKey:@"session key"]] dataUsingEncoding:enc];
}
- (void)parseResult:(NSData*)resultData {
    [super parseResult:resultData];
}

@end