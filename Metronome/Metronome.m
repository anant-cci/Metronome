//
//  Metronome.m
//  Metronome
//
//  Created by Anant Kannaik on 18/05/18.
//  Copyright © 2018 Anant Kannaik. All rights reserved.
//

#import "Metronome.h"
#import <AVFoundation/AVFoundation.h>

@implementation Metronome {
    AVAudioPlayerNode *audioPlayerNode;
    AVAudioFile *audioFileMainClick;
    AVAudioFile *audioFileAccentedClick;
    AVAudioEngine *audioEngine;
}

- (instancetype)init:(NSURL *)mainClickFile accentedClickFile:(NSURL *)accentedClickFile {
    self = [super init];
    if (self) {
        audioFileMainClick = [[AVAudioFile alloc] initForReading:mainClickFile error:nil];
        audioFileAccentedClick = [[AVAudioFile alloc] initForReading:accentedClickFile error:nil];
        
        audioPlayerNode = [[AVAudioPlayerNode alloc] init];
        
        audioEngine = [[AVAudioEngine alloc] init];
        [audioEngine attachNode:audioPlayerNode];
        
        [audioEngine connect:audioPlayerNode to:audioEngine.mainMixerNode format:audioFileMainClick.processingFormat];
        [audioEngine startAndReturnError:nil];
    }
    return self;
}

- (AVAudioPCMBuffer *)generateBuffer:(double)bpm {
    audioFileMainClick.framePosition = 0;
    audioFileAccentedClick.framePosition = 0;
    
    const AVAudioFrameCount beatLength = audioFileMainClick.processingFormat.sampleRate * 60 / bpm;
    
    AVAudioPCMBuffer *bufferMainClick = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFileMainClick.processingFormat frameCapacity:beatLength];
    [audioFileMainClick readIntoBuffer:bufferMainClick error:nil];
    bufferMainClick.frameLength = beatLength;
    
    AVAudioPCMBuffer *bufferAccentedClick = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFileMainClick.processingFormat frameCapacity:beatLength];
    [audioFileAccentedClick readIntoBuffer:bufferAccentedClick error:nil];
    bufferAccentedClick.frameLength = beatLength;
    
    AVAudioPCMBuffer *bufferBar = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFileMainClick.processingFormat frameCapacity:beatLength];
    bufferBar.frameLength = beatLength;
    
    // don't forget if we have two or more channels then we have to multiply memory pointee at channels count
    NSMutableArray *accentedClickArray = [NSMutableArray new];
    for (AVAudioFrameCount i = 0; i < audioFileMainClick.processingFormat.channelCount * beatLength; i++) {
        [accentedClickArray addObject:@(bufferAccentedClick.floatChannelData[0][i])];
    }
    
    NSMutableArray *mainClickArray = [NSMutableArray new];
    for (AVAudioFrameCount i = 0; i < audioFileMainClick.processingFormat.channelCount * beatLength; i++) {
        [mainClickArray addObject:@(bufferMainClick.floatChannelData[0][i])];
    }
    
    NSMutableArray *barArray = [NSMutableArray new];
//    [barArray addObjectsFromArray:accentedClickArray];
//    [barArray addObjectsFromArray:mainClickArray];
//    [barArray addObjectsFromArray:mainClickArray];
    [barArray addObjectsFromArray:mainClickArray];
    
    for (AVAudioFrameCount i = 0; i < audioFileMainClick.processingFormat.channelCount * bufferBar.frameLength; i++) {
        bufferBar.floatChannelData[0][i] = [[barArray objectAtIndex:i] floatValue];
    }
    
    return bufferBar;
}

- (void)play:(double)bpm {
    AVAudioPCMBuffer *buffer = [self generateBuffer:bpm];
    if (audioPlayerNode.isPlaying) {
        [audioPlayerNode scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferInterruptsAtLoop completionHandler:^{
            NSLog(@"Interrupted");
        }];
    } else {
        [audioPlayerNode play];
    }
    [audioPlayerNode scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:^{
        NSLog(@"Complete");
    }];
}

- (void)stop {
    [audioPlayerNode stop];
}

@end
