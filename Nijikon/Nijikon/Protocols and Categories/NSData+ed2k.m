//
//  NSData+ed2k.m
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import "NSData+ed2k.h"

#import <CommonCrypto/CommonDigest.h>
#define BLOCKSIZE 9728000

@implementation NSData (ed2k)

- (NSString*)ed2k {
    unsigned char rDigest[16];
    unsigned char bDigest[16];
    const unsigned char* data = [self bytes];
    int len = (int)[self length];
    
    if (len <= BLOCKSIZE) {
        CC_MD4(data, len, bDigest);
        if (len == BLOCKSIZE) {
            CC_MD4(rDigest, 0, rDigest);
            unsigned char hashlist[32];
            memcpy(hashlist, bDigest, 16);
            memcpy(hashlist + 16, rDigest, 16);
            CC_MD4(hashlist, 32, rDigest);
        } else
            memcpy(rDigest, bDigest, 16);
    } else {
        int blocks = (len - (len % BLOCKSIZE)) / BLOCKSIZE;
        unsigned char* hashlist = malloc(((blocks + 1) * 16));
        memset(hashlist, 0x00, (blocks + 1) * 16);
        int i;
        for (i = 0; i < blocks; i++) {
            CC_MD4(data, BLOCKSIZE, bDigest);
            memcpy(hashlist + (i * 16), bDigest, 16);
            data += BLOCKSIZE;
        }
        CC_MD4(data, len % BLOCKSIZE, bDigest);
        memcpy(hashlist + (blocks * 16), bDigest, 16);
        CC_MD4(hashlist, (blocks + 1) * 16, rDigest);
        if ((len % BLOCKSIZE) == 0)
            CC_MD4(hashlist, blocks * 16, bDigest);
        else
            memcpy(bDigest, rDigest, 16);
        free(hashlist);
    }
    
    char hexstr[32];
    const char hexdgts[16] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
    int i = 0;
    for (i = 0; i < 16; i++) {
        hexstr[(i * 2)] = hexdgts[(rDigest[i] & 0xf0) >> 4];
        hexstr[(i * 2) + 1] = hexdgts[(rDigest[i] & 0x0f)];
    }
    
    return [[[NSString stringWithCString:hexstr encoding:NSASCIIStringEncoding] lowercaseString] substringToIndex:32];
}

@end
