//
//  PLAnidbData.m
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import "PLAnidbData.h"

@implementation PLAnidbFile
#define FILE_BY_FID @"FILE fid=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
#define FILE_BY_ED2K @"FILE size=%@&ed2k=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
#define FILE_BY_AN_GN @"FILE aname=%@&gname=%@&epno=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
#define FILE_BY_AN_GI @"FILE aname=%@&gid=%@&epno=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
#define FILE_BY_AI_GN @"FILE aid=%@&gname=%@&epno=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
#define FILE_BY_AI_DI @"FILE aid=%@&gid=%@&epno=%@&fmask=7FF8FFF9FE&amask=FEFCFCC1&tag=%@&s=%@"
- (NSData*)commandData {
    if ([parameters objectForKey:@"fid"])
        return [[NSString stringWithFormat:FILE_BY_FID, [parameters objectForKey:@"fid"], [parameters objectForKey:@"tag"], [parameters objectForKey:@"session key"]] dataUsingEncoding:enc];
    if ([parameters objectForKey:@"ed2k"])
        return [[NSString stringWithFormat:FILE_BY_ED2K, [parameters objectForKey:@"size"], [parameters objectForKey:@"ed2k"], [parameters objectForKey:@"tag"], [parameters objectForKey:@"session key"]] dataUsingEncoding:enc];
    return nil;
}
- (void)parseResult:(NSData*)resultData {
    [super parseResult:resultData];
    NSArray* result = [[[[[NSString alloc] initWithData:resultData encoding:enc] componentsSeparatedByString:@"\n"] objectAtIndex:1] componentsSeparatedByString:@"|"];
    NSArray* keys = [NSArray arrayWithObjects:@"fid", @"aid", @"eid", @"gid", @"lid", @"other episodes", @"is deprecated", @"state", @"size", @"ed2k", @"md5", @"sha1", @"crc32", @"quality", @"source", @"audio codec list", @"audio bitrate list", @"video codec", @"video bitrate", @"video resolution", @"file extension", @"dub language", @"sub language", @"length", @"description", @"aired date", @"anidb filename", @"mylist state", @"mylist filestate", @"mylist viewed", @"mylist viewdate", @"mylist storage", @"mylist source", @"mylist other", @"anime total episodes", @"highest episode number", @"year", @"type", @"related aid list", @"related aid type", @"category list", @"romaji name", @"kanji name", @"english name", @"other name list", @"short name list", @"synonym list", @"epno", @"ep name", @"ep romaji name", @"ep kanji name", @"episode rating", @"episode vote", @"group name", @"group short name", @"date aid record updated", nil];
    switch ([[results objectForKey:@"return code"] intValue]) {
        case ADBFile:
            //1036352|8658|136691|8697|0||0|1|212030288|79dabdf4ac558681dba71e2f8d3608df|5168d6439b4b2ef85cd7332b62738897|bff8f92fac1c77cdf95f9781ba0ebbc4f774dc16|fb7549dd|high|HDTV|AAC|189|H264/AVC|961|1280x720|mkv|japanese|english|1450||1329609600|Nisemonogatari - 07 - Karen Bee, Part 7 - [Commie](fb7549dd).mkv||||||||11|8|2012|TV Series|6327|2|Asia,Contemporary Fantasy,Seinen,Earth,Novel,Japan,Harem,Nudity,Comedy,Vampires|Nisemonogatari|\U507d\U7269\U8a9e|Nisemonogatari|\U507d\U7269\U8a9e'Nisemonogatari'Nisemonogatari (Histoires d`Imposture)||Impostory|07|Karen Bee, Part 7|Karen Bee Sono Nana|\U304b\U308c\U3093\U30d3\U30fc \U5176\U30ce\U6f06|881|6|Commie|Commie|1328561041
            [results setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:result forKeys:keys]];
            [results setValue:[[results valueForKey:@"category list"] componentsSeparatedByString:@","] forKey:@"category list"];
            [results setValue:[[results valueForKey:@"other name list"] componentsSeparatedByString:@"'"] forKey:@"other name list"];
            break;
        case ADBMultipleFilesFound:
            break;
        case ADBNoSuchFile:
            break;
    }
}

- (NSString*)stringWithFormat:(NSString*)format {
    NSString* name = [NSString stringWithString:format];
    NSString* key;
    for (int i = 0; i < [[self results] count]; i++) {
        key = [[results allKeys] objectAtIndex:i];
        name = [name stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"$%@$", key] withString:[results objectForKey:key]];
    }
    return name;
}

@end