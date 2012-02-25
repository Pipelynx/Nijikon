//
//  NijikonTests.m
//  NijikonTests
//
//  Created by Martin Fellner on 240212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import "NijikonTests.h"

@implementation NijikonTests

- (void)setUp {
    [super setUp];
    
    anidb = [[PLAnidb alloc] initWithHost:@"api.anidb.net" port:9000];
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBasics {
    PLAnidbPing* ping = [PLAnidbCommand ping];
    [ping setParameter:@"nat" toValue:@"1"];
    [anidb executeCommand:ping];
    NSLog(@"Command: %@", [[NSString alloc] initWithData:[ping commandData] encoding:NSUTF8StringEncoding]);
    NSLog(@"Results: %@", [ping results]);
    
    PLAnidbAuth* auth = [PLAnidbCommand auth];
    [auth setParameter:@"user" toValue:@"pipelynx"];
    [auth setParameter:@"pass" toValue:@"53-Ln44~"];
    [auth setParameter:@"client" toValue:@"nijikon"];
    [auth setParameter:@"clientver" toValue:@"1"];
    [auth setParameter:@"nat" toValue:@"1"];
    [auth setParameter:@"imgserver" toValue:@"1"];
    [anidb executeCommand:auth];
    NSLog(@"Command: %@", [[NSString alloc] initWithData:[auth commandData] encoding:NSUTF8StringEncoding]);
    NSLog(@"Results: %@", [auth results]);
    
    NSData* data = [NSData dataWithContentsOfFile:@"/Users/Pipelynx/Downloads/x.mkv"];
    PLAnidbFile* file = [PLAnidbCommand fileByEd2k];
    [file setParameter:@"size" toValue:[NSString stringWithFormat:@"%i", [data length]]];
    [file setParameter:@"ed2k" toValue:[data ed2k]];
    [anidb executeCommand:file];
    NSLog(@"Command: %@", [[NSString alloc] initWithData:[file commandData] encoding:NSUTF8StringEncoding]);
    NSLog(@"Results: %@", [file results]);
    NSString* format = @"[$group short name$]$romaji name$ - $epno$.$file extension$";
    NSLog(@"Format: %@", format);
    NSLog(@"Filename: %@", [file stringWithFormat:format]);
    
    PLAnidbLogout* logout = [PLAnidbCommand logout];
    [anidb executeCommand:logout];
    NSLog(@"Command: %@", [[NSString alloc] initWithData:[logout commandData] encoding:NSUTF8StringEncoding]);
    NSLog(@"Results: %@", [logout results]);
}

@end
