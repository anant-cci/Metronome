//
//  Metronome.h
//  Metronome
//
//  Created by Anant Kannaik on 18/05/18.
//  Copyright © 2018 Anant Kannaik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metronome : NSObject

- (instancetype)init:(NSURL *)mainClickFile accentedClickFile:(NSURL *)accentedClickFile;
- (void)play:(double)bpm;
- (void)stop;

@end
