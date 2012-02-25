//
//  PLCommand.h
//  Nijikon
//
//  Created by Martin Fellner on 250212.
//  Copyright (c) 2012 PiKp (gebbwgl). All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLCommand <NSObject>

- (void)setExecuted;
- (NSData*)commandData;
- (void)parseResult:(NSData*)resultData;

- (NSDictionary*)parameters;
- (void)setParameters:(NSDictionary*)newParameters;
- (void)setParameter:(NSString*)key toValue:(NSString*)value;

- (int)returnCode;
- (NSDictionary*)results;

@end

typedef enum ReturnCode {
    ADBLoginAccepted = 200,
    ADBLoginAcceptedNewVersion = 201,
    ADBLoggedOut = 203,
    ADBResource = 205,
    ADBStats = 206,
    ADBTop = 207,
    ADBUptime = 208,
    ADBEncryptionEnabled = 209,
    ADBMylistEntryAdded = 210,
    ADBMylistEntryDeleted = 211,
    ADBAddedFile = 214,
    ADBAddedStream = 215,
    ADBExportQueued = 217,
    ADBExportCancelled = 218,
    ADBEncodingChanged = 219,
    ADBFile = 220,
    ADBMylist = 221,
    ADBMylistStats = 222,
    WISHLIST                                 = 223,
    NOTIFICATION                             = 224,
    GROUP_STATUS                             = 225,
    WISHLIST_ENTRY_ADDED                     = 226,
    WISHLIST_ENTRY_DELETED                   = 227,
    WISHLIST_ENTRY_UPDATED                   = 228,
    MULTIPLE_WISHLIST                        = 229,
    ANIME                                    = 230,
    ANIME_BEST_MATCH                         = 231,
    RANDOM_ANIME                             = 232,
    ANIME_DESCRIPTION                        = 233,
    REVIEW                                   = 234,
    CHARACTER                                = 235,
    SONG                                     = 236,
    ANIMETAG                                 = 237,
    CHARACTERTAG                             = 238,
    EPISODE                                  = 240,
    UPDATED                                  = 243,
    TITLE                                    = 244,
    CREATOR                                  = 245,
    NOTIFICATION_ENTRY_ADDED                 = 246,
    NOTIFICATION_ENTRY_DELETED               = 247,
    NOTIFICATION_ENTRY_UPDATE                = 248,
    MULTIPLE_NOTIFICATION                    = 249,
    GROUP                                    = 250,
    CATEGORY                                 = 251,
    BUDDY_LIST                               = 253,
    BUDDY_STATE                              = 254,
    BUDDY_ADDED                              = 255,
    BUDDY_DELETED                            = 256,
    BUDDY_ACCEPTED                           = 257,
    BUDDY_DENIED                             = 258,
    VOTED                                    = 260,
    VOTE_FOUND                               = 261,
    VOTE_UPDATED                             = 262,
    VOTE_REVOKED                             = 263,
    HOT_ANIME                                = 265,
    RANDOM_RECOMMENDATION                    = 266,
    RANDOM_SIMILAR                           = 267,
    NOTIFICATION_ENABLED                     = 270,
    NOTIFYACK_SUCCESSFUL_MESSAGE             = 281,
    NOTIFYACK_SUCCESSFUL_NOTIFIATION         = 282,
    NOTIFICATION_STATE                       = 290,
    NOTIFYLIST                               = 291,
    NOTIFYGET_MESSAGE                        = 292,
    NOTIFYGET_NOTIFY                         = 293,
    SENDMESSAGE_SUCCESSFUL                   = 294,
    USER_ID                                  = 295,
    CALENDAR                                 = 297,
    PONG                                     = 300,
    AUTHPONG                                 = 301,
    NO_SUCH_RESOURCE                         = 305,
    API_PASSWORD_NOT_DEFINED                 = 309,
    FILE_ALREADY_IN_MYLIST                   = 310,
    MYLIST_ENTRY_EDITED                      = 311,
    MULTIPLE_MYLIST_ENTRIES                  = 312,
    WATCHED                                  = 313,
    SIZE_HASH_EXISTS                         = 314,
    INVALID_DATA                             = 315,
    STREAMNOID_USED                          = 316,
    EXPORT_NO_SUCH_TEMPLATE                  = 317,
    EXPORT_ALREADY_IN_QUEUE                  = 318,
    EXPORT_NO_EXPORT_QUEUED_OR_IS_PROCESSING = 319,
    ADBNoSuchFile = 320,
    ADBNoSuchEntry = 321,
    ADBMultipleFilesFound = 322,
    ADBNoSuchWishlist = 323,
    ADBNoSuchNotification = 324,
    NO_GROUPS_FOUND                          = 325,
    NO_SUCH_ANIME                            = 330,
    NO_SUCH_DESCRIPTION                      = 333,
    NO_SUCH_REVIEW                           = 334,
    NO_SUCH_CHARACTER                        = 335,
    NO_SUCH_SONG                             = 336,
    NO_SUCH_ANIMETAG                         = 337,
    NO_SUCH_CHARACTERTAG                     = 338,
    NO_SUCH_EPISODE                          = 340,
    NO_SUCH_UPDATES                          = 343,
    NO_SUCH_TITLES                           = 344,
    NO_SUCH_CREATOR                          = 345,
    NO_SUCH_GROUP                            = 350,
    NO_SUCH_CATEGORY                         = 351,
    BUDDY_ALREADY_ADDED                      = 355,
    NO_SUCH_BUDDY                            = 356,
    BUDDY_ALREADY_ACCEPTED                   = 357,
    BUDDY_ALREADY_DENIED                     = 358,
    NO_SUCH_VOTE                             = 360,
    INVALID_VOTE_TYPE                        = 361,
    INVALID_VOTE_VALUE                       = 362, 
    PERMVOTE_NOT_ALLOWED                     = 363,
    ALREADY_PERMVOTED                        = 364,
    HOT_ANIME_EMPTY                          = 365,
    RANDOM_RECOMMENDATION_EMPTY              = 366,
    RANDOM_SIMILAR_EMPTY                     = 367,
    NOTIFICATION_DISABLED                    = 370,
    NO_SUCH_ENTRY_MESSAGE                    = 381,
    NO_SUCH_ENTRY_NOTIFICATION               = 382,
    NO_SUCH_MESSAGE                          = 392,
    NO_SUCH_NOTIFY                           = 393,
    NO_SUCH_USER                             = 394,
    CALENDAR_EMPTY                           = 397,
    NO_CHANGES                               = 399,
    NotLoggedIn = 403,
    NO_SUCH_MYLIST_FILE                      = 410,
    NO_SUCH_MYLIST_ENTRY                     = 411,
    MYLIST_UNAVAILABLE                       = 412,
    ADBLoginFailed = 500,
    ADBLoginFirst = 501,
    ADBAccessDenied = 502,
    ADBClientVersionOutdated = 503,
    ADBClientBanned = 504,
    ADBIllegalInputOrAccessDenied = 505,
    INVALID_SESSION                          = 506,
    NO_SUCH_ENCRYPTION_TYPE                  = 509,
    ENCODING_NOT_SUPPORTED                   = 519,
    ADBBanned = 555,
    ADBUnkownCommand = 598,
    ADBInternalServerError = 600,
    ADBAnidbOutOfService = 601,
    ADBServerBusy = 602,
    NO_DATA                                  = 603,
    TIMEOUT                                  = 604,
    API_VIOLATION                            = 666,
    PUSHACK_CONFIRMED                        = 701,
    NO_SUCH_PACKET_PENDING                   = 702
} ReturnCode;