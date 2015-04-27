//
//  MXMDeepLinkHelper.m
//  MXMDeepLink
//
//  Created by Loreto Parisi on 15/02/14.
//  Copyright (c) 2014 MusiXmatch Spa. All rights reserved.
//

#import "MXMDeepLinkHelper.h"
#import <UIKit/UIKit.h>

@implementation MXMDeepLinkHelper

@synthesize callerAppID,appID,isAppAvailable;

#pragma mark - Singleton Methods

#define MXM_DEEPLINK_SEPARATOR @"&"
#define MXM_DEEPLINK_PATH_SEPARATOR @"/"
#define MXM_DEEPLINK_PATH_SEPARATOR_OLD @":"
#define MXM_DEEPLINK_PROTOCOL @"mxm://"
#define MXM_NEWPROTOCOL NO

enum {
    
    MXMDeepLinkHostTypeUndefined,
    MXMDeepLinkHostTypeMatch,
    MXMDeepLinkHostTypeLyrics,
    MXMDeepLinkHostTypeView

} typedef MXMDeepLinkHostType;

enum {
    
    MXMDeepLinkActionTypeNowPlaying,
    MXMDeepLinkActionTypeMusicID,
    MXMDeepLinkActionTypeInapp

} typedef MXMDeepLinkActionType;

+(instancetype)sharedInstance {
    static dispatch_once_t pred;
    static MXMDeepLinkHelper *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[MXMDeepLinkHelper alloc] init];
    });
    return shared;
}

-(id) init {
    
    if( self = [super init] ) {
        
        self.isAppAvailable=[MXMDeepLinkHelper canOpenMusixmatchApp];
        self.appID=@"";
        self.callerAppID=@"";
        
    }
    
    return self;
    
}

-(NSString*)composeQueryStringWithArray:(NSArray*)params {

    NSString *uri=@"";
    if ( MXM_NEWPROTOCOL ) uri = [uri stringByAppendingFormat:@"%@%@", MXM_DEEPLINK_PATH_SEPARATOR, @"?"];
    for(NSString *param in params) {
        uri = [uri stringByAppendingFormat:@"%@%@", MXM_NEWPROTOCOL?MXM_DEEPLINK_SEPARATOR:MXM_DEEPLINK_PATH_SEPARATOR_OLD, param];
    }
    
    return uri;
    
}

-(NSString*)composeUriForAction:(MXMDeepLinkActionType)actionType withHost:(NSString*)host {

    NSString *path=@"";
    
    switch (actionType) {
        case MXMDeepLinkActionTypeNowPlaying:
            path=@"nowplaying";
            break;
        case MXMDeepLinkActionTypeMusicID:
            path=@"musicID";
            break;
        case MXMDeepLinkActionTypeInapp:
            path=@"inapp";
            break;
        default:
            path=@"";
            break;
    }
    
    path = [host stringByAppendingFormat:@"%@%@",MXM_NEWPROTOCOL?MXM_DEEPLINK_PATH_SEPARATOR:MXM_DEEPLINK_PATH_SEPARATOR_OLD, path];
    
    return path;

}

-(NSString*)composeUrlForHost:(MXMDeepLinkHostType)hostType {
    
    NSString *path=@"";
    
    switch (hostType) {
        case MXMDeepLinkHostTypeMatch:
            path=@"match";
            break;
        case MXMDeepLinkHostTypeLyrics:
            path=@"lyrics";
            break;
        case MXMDeepLinkHostTypeView:
            path=@"view";
            break;
        default:
            path=@"";
            break;
    }
    
    NSString *uri = [NSString stringWithFormat:@"%@%@", MXM_DEEPLINK_PROTOCOL, path];
    
    return uri;
    
}

+(BOOL)canOpenMusixmatchApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mxm://noprotocol"]];
}

+(void)getMusixmatchApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id448278467"]];
}

-(void)openMusixmatchWithTrackName:(NSString*)trackName andArtistName:(NSString*)artistName andAlbumName:(NSString*)albumName {

    if(trackName==nil) trackName=@"";
    if(artistName==nil) artistName=@"";
    if(albumName==nil) albumName=@"";
    if(self.appID==nil) self.appID=@"";
    
    NSString * hostString = [self composeUrlForHost:MXMDeepLinkHostTypeMatch];
    NSString * queryString = [self composeQueryStringWithArray:
                              @[[NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_track=%@":@"%@", trackName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_artist=%@":@"%@", artistName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_album=%@":@"%@", albumName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"caller_app=%@":@"%@", self.appID]] ];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", hostString, queryString];
    
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];

}

-(void)openMusixmatchWithTrackName:(NSString*)trackName andArtistName:(NSString*)artistName andAlbumName:(NSString*)albumName
                       andPosition:(double)position andDuration:(double)duration andStartTime:(NSString*)startTime {

    if(trackName==nil) trackName=@"";
    if(artistName==nil) artistName=@"";
    if(albumName==nil) albumName=@"";
    if(startTime==nil) startTime=@"";
    if(self.appID==nil) self.appID=@"";
    
    NSString * hostString = [self composeUrlForHost:MXMDeepLinkHostTypeMatch];
    NSString * queryString = [self composeQueryStringWithArray:
                              @[[NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_track=%@":@"%@", trackName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_artist=%@":@"%@", artistName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"q_album=%@":@"%@", albumName],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"position=%f":@"%f", position],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"duration=%f":@"%f", duration],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"start_time=%@":@"%@", startTime],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"caller_app=%@":@"%@", self.appID]] ];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", hostString, queryString];
    
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
}

-(void)openMusixmatchWithTrackID:(NSString*)trackID {
    if(trackID==nil) trackID=@"";
    if(self.appID==nil) self.appID=@"";
    
    NSString * hostString = [self composeUrlForHost:MXMDeepLinkHostTypeLyrics];
    NSString * queryString = [self composeQueryStringWithArray:
                              @[[NSString stringWithFormat:MXM_NEWPROTOCOL?@"track_id=%@":@"%@", trackID],
                                [NSString stringWithFormat:MXM_NEWPROTOCOL?@"caller_app=%@":@"%@", self.appID]] ];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", hostString, queryString];
    
    NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
}

-(void)openMusixmatchNowPlayingTrack {
    if(!isAppAvailable) {
        [MXMDeepLinkHelper getMusixmatchApp];
        return;
    }
    if(self.appID==nil) self.appID=@"";
    
    NSString * hostString = [self composeUrlForHost:MXMDeepLinkHostTypeView];
    NSString * queryString = [self composeQueryStringWithArray:
                              @[[NSString stringWithFormat:MXM_NEWPROTOCOL?@"caller_app=%@":@"%@", self.appID]] ];
    hostString = [self composeUriForAction:MXMDeepLinkActionTypeNowPlaying withHost:hostString];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", hostString, queryString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)openMusixmatchMusicID {
    if(!isAppAvailable) {
        [MXMDeepLinkHelper getMusixmatchApp];
        return;
    }
    if(self.appID==nil) self.appID=@"";
    
    NSString * hostString = [self composeUrlForHost:MXMDeepLinkHostTypeView];
    NSString * queryString = [self composeQueryStringWithArray:
                              @[[NSString stringWithFormat:MXM_NEWPROTOCOL?@"caller_app=%@":@"%@", self.appID]] ];
    hostString = [self composeUriForAction:MXMDeepLinkActionTypeMusicID withHost:hostString];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", hostString, queryString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)backToCallerApp {
    if(self.callerAppID==nil) return;
    NSString *urlString=[NSString stringWithFormat:@"%@://back",self.callerAppID];
    self.callerAppID=nil;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(BOOL)canOpenCallerApp {
    if(self.callerAppID==nil) return NO;
    return [[UIApplication sharedApplication] canOpenURL:
            [NSURL URLWithString:[NSString stringWithFormat:@"%@://noprotocol",self.callerAppID]]];
}

@end
