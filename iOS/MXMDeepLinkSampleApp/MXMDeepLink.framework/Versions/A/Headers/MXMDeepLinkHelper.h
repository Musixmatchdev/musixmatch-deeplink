//
//  MXMDeepLinkHelper.h
//
//  Created by Loreto Parisi on 12/02/14.
//  Copyright (c) 2014 Loreto Parisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXMDeepLinkHelper : NSObject {
    
    NSString *appID;
    NSString *callerAppID;
    BOOL isAppAvailable;
}

+ (MXMDeepLinkHelper *)sharedInstance;

@property(nonatomic,retain) NSString *appID;
@property (nonatomic, retain) NSString *callerAppID;
@property(nonatomic) BOOL isAppAvailable;

+(BOOL)canOpenMusixmatchApp;
+(void)getMusixmatchApp;
-(void)openMusixmatchWithTrackID:(NSString*)trackID;
-(void)openMusixmatchWithTrackName:(NSString*)trackName andArtistName:(NSString*)artistName andAlbumName:(NSString*)albumName;
-(void)openMusixmatchWithTrackName:(NSString*)trackName andArtistName:(NSString*)artistName andAlbumName:(NSString*)albumName
                       andPosition:(double)position andDuration:(double)duration andStartTime:(NSString*)startTime;
-(void)openMusixmatchNowPlayingTrack;
-(void)openMusixmatchMusicID;
-(void)backToCallerApp;
-(BOOL)canOpenCallerApp;

@end
