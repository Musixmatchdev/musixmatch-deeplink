/**
 *
 * Musixmatch iOS Lyrics Extention Demo
 *
 * About: https://developer.musixmatch.com/documentation/ios-lyrics-extension
 * Github: https://github.com/Musixmatchdev/musixmatch-app-extension
 *
 * Copyright (c) 2014-2015 musixmatch. All rights reserved.
 */

#import "ViewController.h"
#import <MXMDeepLink/MXMDeepLink.h>

@interface ViewController () < MPMediaPickerControllerDelegate > {

    NSTimer *progressUpdateTimer;
    
    NSString *appIdentifier;
    

}

@property(nonatomic,strong) MPMediaPickerController *pickerController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MPMusicPlayerController systemMusicPlayer] beginGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nowPlayingItmeChanged:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateDidChange:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    
    
    // create a simple media query of all music library
    MPMediaQuery *mediaQuery =  [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *IsMusicMediaTypePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [mediaQuery addFilterPredicate:IsMusicMediaTypePredicate];
    [[MPMusicPlayerController systemMusicPlayer] setQueueWithQuery:mediaQuery];
    
    ///
    /// Initialize Musixmatch Deeplink Helper
    /// Pass your App identifier for Deep linking
    /// This helps to Go Back To App programmatically
    /// From Musixmatch App
    ///
    appIdentifier = @"deeplinksample";
    [[MXMDeepLinkHelper sharedInstance] setAppID:appIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    
    MPMediaItem *item = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    
    if (item) {
        titleTrack.text = item.title;
        artist.text = item.artist;
        album.text = item.albumTitle;
        artWork.image = [item.artwork imageWithSize:artWork.frame.size];
    }else {
        titleTrack.text = artist.text = album.text = @"";
        artWork.image = nil;
    }
    
}

#pragma mark - Deep Link Tests

-(void)runTestCanOpenMusixmatch {
    BOOL canOpenApp=[[MXMDeepLinkHelper sharedInstance] canOpenCallerApp];
    NSLog(@"runTestDeepLinkMusicID can open %d", canOpenApp);
}

-(void) runtTestDeepLinkTrackWithTrackID {
    
    /// Following please use a valid Musixmatch Track Identifier
    /// To get a Musixmatch App Id (trackid) please refer to
    /// https://developer.musixmatch.com/documentation/api-reference/track-get
    ///
    /// Sign up to get an API Key Musixmatch API
    /// https://developer.musixmatch.com/documentation
    ///
    NSString *trackId = @"12345678";
    [[MXMDeepLinkHelper sharedInstance] openMusixmatchWithTrackID:trackId];
}

-(void) runTestDeepLinkMusicID {
    
    BOOL canOpenApp=[[MXMDeepLinkHelper sharedInstance] canOpenCallerApp];
    NSLog(@"runTestDeepLinkMusicID can open %d", canOpenApp);
    
    [[MXMDeepLinkHelper sharedInstance] setAppID:appIdentifier];
    [[MXMDeepLinkHelper sharedInstance] openMusixmatchMusicID];
    
}

-(void) runTestDeepLinkNowPlaying {
    [[MXMDeepLinkHelper sharedInstance] setAppID:appIdentifier];
    [[MXMDeepLinkHelper sharedInstance] openMusixmatchNowPlayingTrack];
}


-(void) runTestDeepLinkTrackWithTrackID {
    [self runtTestDeepLinkTrackWithTrackID];
}

-(void) runTestDeepLinkTrack {
    
    MPMediaItem *item = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    if(!item) {
        [self showAlertWithTitle:@"INFO" message:@"Please choose a track first" delegate:self];
        return;
    }
    
    titleTrack.text = item.title;
    artist.text = item.artist;
    album.text = item.albumTitle;
    artWork.image = [item.artwork imageWithSize:artWork.frame.size];
   
    [[MXMDeepLinkHelper sharedInstance] openMusixmatchWithTrackName:titleTrack.text
     andArtistName:artist.text
     andAlbumName:album.text ];

}

-(void) runTestDeepLinkTrackWithSynced {
    
    MPMediaItem *item = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
    if(!item) {
        [self showAlertWithTitle:@"INFO" message:@"Please choose a track first" delegate:self];
        return;
    }
    
    NSTimeInterval duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
    long currentPlaybackTime = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
    
    titleTrack.text = item.title;
    artist.text = item.artist;
    album.text = item.albumTitle;
    artWork.image = [item.artwork imageWithSize:artWork.frame.size];
    
    
    // UTC date formatter
    NSDate *now = [NSDate date];
    NSDateFormatter *utcDateFormatter;
    utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setDateFormat: @"YMMdd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [utcDateFormatter setTimeZone:timeZone];
    NSString *startTime = [utcDateFormatter stringFromDate:now];
    
    [[MXMDeepLinkHelper sharedInstance] openMusixmatchWithTrackName:titleTrack.text
                                                        andArtistName:artist.text
                                                        andAlbumName:album.text
                                                        andPosition:currentPlaybackTime
                                                        andDuration:duration
                                                       andStartTime:startTime];
    
    
}

#pragma mark - Buttons

- (IBAction)addMusic:(id)sender {
    
    self.pickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    [self.pickerController setDelegate:self];
    [self presentViewController:self.pickerController
                       animated:YES
                     completion:nil];
}

-(IBAction)nextTrack:(id)sender {
    [[MPMusicPlayerController systemMusicPlayer] skipToNextItem];
}

-(IBAction)prevTrack:(id)sender {
    if ([[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime] < 2.0f) {
        [[MPMusicPlayerController systemMusicPlayer] skipToPreviousItem];
    } else {
        [[MPMusicPlayerController systemMusicPlayer] skipToBeginning];
    }
}

-(IBAction)playPause:(id)sender {

    MPMusicPlaybackState playbackState = [[MPMusicPlayerController systemMusicPlayer] playbackState];
    if( playbackState == MPMoviePlaybackStatePlaying ) { // playing, pause
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else { // paused or stopped, play
        [[MPMusicPlayerController systemMusicPlayer] play];
    }
    
}

- (IBAction)seek:(UISlider*)sender {
    
    // total time
    NSTimeInterval duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
    float seekTime = sender.value * duration;
    [[MPMusicPlayerController systemMusicPlayer] setCurrentPlaybackTime:seekTime];
}

#pragma mark - Notifications

- (void)playbackStateDidChange:(id)sender {

    MPMusicPlaybackState playbackState = [[MPMusicPlayerController systemMusicPlayer] playbackState];
    if( playbackState == MPMoviePlaybackStatePlaying ) { // play
        
        [playPauseButton setImage:[UIImage imageNamed:@"player_pause_button"] forState:UIControlStateNormal];
        progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                               target:self
                                                             selector:@selector(updateProgress:)
                                                             userInfo:nil
                                                              repeats:YES];
    } else { // pause
        [playPauseButton setImage:[UIImage imageNamed:@"player_play_button"] forState:UIControlStateNormal];
        if(progressUpdateTimer != nil) {
            [progressUpdateTimer invalidate];
            progressUpdateTimer = nil;
        }
    }
}

- (void)nowPlayingItmeChanged:(id)sender {
    [self updateView];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {

    [[MPMusicPlayerController systemMusicPlayer] setQueueWithItemCollection:mediaItemCollection];
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:^{
                                        [[MPMusicPlayerController systemMusicPlayer] play];
                                    }];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES
                                    completion:nil];
}

#pragma mark - Player Control

-(void) playerUpdateInfo {
    
    // total time
    long duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
    // elapsed time
    long currentPlaybackTime = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
    // remaining time
    long remainingPlaybackTime = duration - currentPlaybackTime;
    
    // elapsed minutes and seconds
    int currentMinutes = (int)((currentPlaybackTime / 60) - (currentPlaybackTime / 3600)*60);
    int currentSeconds = (currentPlaybackTime % 60);
    
    // remaining minutes and seconds
    int remainingMinutes = (int)((remainingPlaybackTime / 60) - (remainingPlaybackTime / 3600)*60);
    int remainingSeconds = ( remainingPlaybackTime % 60 );
    
    trackElapsedTime.text = [NSString stringWithFormat:@"%02d:%02d", currentMinutes, currentSeconds];
    trackRemainingTime.text  = [NSString stringWithFormat:@"-%02d:%02d",remainingMinutes,remainingSeconds];
    
}

- (void)updateProgress:(NSTimer *)_timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval progress = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
        NSTimeInterval duration = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem].playbackDuration;
        if ( progress >=0.0 && duration>0.0) {
            [trackProgress setValue: progress / duration animated:YES];
            [self playerUpdateInfo];
        }
    });
}

#pragma mark  - UI Helper

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)_delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:_delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Close", nil];
    [alert show];
}

@end
