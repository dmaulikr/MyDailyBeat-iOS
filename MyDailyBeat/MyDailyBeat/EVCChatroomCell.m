//
//  EVCChatroomCell.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCChatroomCell.h"

@implementation EVCChatroomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id) changeChatroom:(MessageChatroom *)chatroom {
    self.chatroom = chatroom;
    if ([chatroom.screenNames count] >= 3) {
        NSString *firsts = [chatroom.screenNames objectAtIndex:0];
        NSString *seconds = [chatroom.screenNames objectAtIndex:1];
        NSString *thirds = [chatroom.screenNames objectAtIndex:2];
        self.chatroomNameLbl.text = [NSString stringWithFormat:@"%@, %@, and %lu others", firsts, seconds, [chatroom.screenNames count] - 2];
        
        
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:firsts];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            NSURL *imageURL2 = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:seconds];
            NSData *imageData2 = [NSData dataWithContentsOfURL:imageURL2];
            NSURL *imageURL3 = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:thirds];
            NSData *imageData3 = [NSData dataWithContentsOfURL:imageURL3];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self.first setImage:[UIImage imageWithData:imageData]];
                [self.second setImage:[UIImage imageWithData:imageData2]];
                [self.third setImage:[UIImage imageWithData:imageData3]];
                
            });
            
        });
        
    } else if ([chatroom.screenNames count] == 2) {
        NSString *firsts = [chatroom.screenNames objectAtIndex:0];
        NSString *seconds = [chatroom.screenNames objectAtIndex:1];
        self.chatroomNameLbl.text = [NSString stringWithFormat:@"%@ and %@", firsts, seconds];
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:firsts];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            NSURL *imageURL2 = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:seconds];
            NSData *imageData2 = [NSData dataWithContentsOfURL:imageURL2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self.first setImage:[UIImage imageWithData:imageData]];
                [self.second setImage:[UIImage imageWithData:imageData2]];
                
            });
            
        });
    }
    
    return self;
}

@end
