/**
 *
 * Musixmatch iOS Lyrics Extention Demo
 *
 * About: https://developer.musixmatch.com/documentation/ios-lyrics-extension
 * Github: https://github.com/Musixmatchdev/musixmatch-app-extension
 *
 * Copyright (c) 2014-2015 musixmatch. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController {
    
    IBOutlet UIImageView *artWork;
    IBOutlet UILabel *titleTrack;
    IBOutlet UILabel *artist;
    IBOutlet UILabel *album;
    IBOutlet UIButton *playPauseButton;
    IBOutlet UIButton *nextTrackButton;
    IBOutlet UIButton *prevTrackButton;
    IBOutlet UISlider *trackProgress;
    IBOutlet UILabel *trackElapsedTime;
    IBOutlet UILabel *trackRemainingTime;
    
}

@property(nonatomic,strong) IBOutlet UIImageView *artWork;
@property(nonatomic,strong) IBOutlet UILabel *titleTrack;
@property(nonatomic,strong) IBOutlet UILabel *artist;
@property(nonatomic,strong) IBOutlet UILabel *album;
@property(nonatomic,strong) IBOutlet UIButton *playPauseButton;
@property(nonatomic,strong) IBOutlet UIButton *nextTrackButton;
@property(nonatomic,strong) IBOutlet UIButton *prevTrackButton;
@property(nonatomic,strong) IBOutlet UISlider *trackProgress;
@property(nonatomic,strong) IBOutlet UILabel *trackRemainingTime;

@end

