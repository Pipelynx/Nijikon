//
//  main.m
//  anidb
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAnidb.h"
#import "NSData+ed2k.h"

int main (int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSFileManager* fm = [NSFileManager defaultManager];
        
        NSUserDefaults* args = [NSUserDefaults standardUserDefaults];
        NSString* mode = [args stringForKey:@"mode"];
        if ([mode isEqualToString:@""])
            mode = @"sort";
        NSString* src = [args stringForKey:@"src"];
        if ([src isEqualToString:@""])
            src = [fm currentDirectoryPath];
        NSString* dst = [args stringForKey:@"dst"];
        
        PLAnidb* anidb = [[PLAnidb alloc] initWithHost:@"api.anidb.net" port:9000];
        PLAnidbAuth* auth = [PLAnidbCommand auth];
        [auth setParameter:@"user" toValue:@"pipelynx"];
        [auth setParameter:@"pass" toValue:@"53-Ln44~"];
        [auth setParameter:@"client" toValue:@"nijikon"];
        [auth setParameter:@"clientver" toValue:@"1"];
        [auth setParameter:@"nat" toValue:@"1"];
        [auth setParameter:@"imgserver" toValue:@"1"];
        [anidb executeCommand:auth];
        PLAnidbFile* file = nil;
        NSString* srcPath;
        NSString* dstPath;
        
        if ([mode isEqualToString:@"sort"]) {
            NSArray* files = [fm contentsOfDirectoryAtPath:src error:nil];
            for (int i = 0; i < [files count]; i++) {
                srcPath = [src stringByAppendingPathComponent:[files objectAtIndex:i]];
                NSData* data = [NSData dataWithContentsOfFile:[src stringByAppendingPathComponent:[files objectAtIndex:i]]];
                file = [PLAnidbCommand fileByEd2k];
                [file setParameter:@"ed2k" toValue:[data ed2k]];
                [file setParameter:@"size" toValue:[NSString stringWithFormat:@"%i", [data length]]];
                [anidb executeCommand:file];
                if ([file returnCode] == ADBFile) {
                    dstPath = [dst stringByAppendingPathComponent:[file stringWithFormat:@"$romaji name$/[$group short name$]$romaji name$ - $epno$.$file extension$"]];
                    [fm copyItemAtPath:srcPath toPath:dstPath error:nil];
                    fprintf(stdout, "\"%s\" copied\n", [dstPath UTF8String]);
                }
            }
        }
        
        PLAnidbLogout* logout = [PLAnidbCommand logout];
        [anidb executeCommand:logout];
    }
    return 0;
}

