//
//  EVCFlingMessagingViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCFlingMessagingViewController.h"

@interface EVCFlingMessagingViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *messages2;

@property (nonatomic, strong) NSArray *searchResult;


@end

@implementation EVCFlingMessagingViewController

- (id) initWithChatroom:(MessageChatroom *)chatroom {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        
        self.messages = [[NSMutableArray alloc] init];
        self.messages2 = [[NSMutableArray alloc] init];
        self.searchResult = [[NSMutableArray alloc] init];
        
        self.chatroom = chatroom;
        
        
        self.bounces = YES;
        self.shakeToClearEnabled = YES;
        self.keyboardPanningEnabled = YES;
        self.shouldScrollToBottomAfterKeyboardShows = NO;
        self.inverted = YES;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
        
        self.textView.placeholder = NSLocalizedString(@"Message", nil);
        self.textView.placeholderColor = [UIColor lightGrayColor];
        self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
        self.textView.pastableMediaTypes = SLKPastableMediaTypeAll|SLKPastableMediaTypePassbook;
        
        [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
        [self.leftButton setTintColor:[UIColor grayColor]];
        
        [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        
        [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
        [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
        [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
        
        self.textInputbar.autoHideRightButton = YES;
        self.textInputbar.maxCharCount = 140;
        self.textInputbar.counterStyle = SLKCounterStyleSplit;
        
        self.typingIndicatorView.canResignByTouch = YES;
        
        [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
        [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":"]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMessagesAsync];
}

- (void) getMessagesAsync {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        self.messages2 = [[NSMutableArray alloc] initWithArray:[[RestAPI getInstance] getMessagesForChatroomWithID:self.chatroom.chatroomID] copyItems:YES];
        
        for (VerveMessage * m in self.messages2) {
            self.messages = [[NSMutableArray alloc] init];
            [self.messages addObject:m.message];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
    
}

- (void) writeMessageAsync:(NSString *) message {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        
        [[RestAPI getInstance] writeMessage:message asUser:[[RestAPI getInstance] getCurrentUser] inChatRoomWithID:self.chatroom.chatroomID atTime:milliseconds];
        
        VerveMessage *m = [[VerveMessage alloc] init];
        m.message = message;
        m.screenName = [[RestAPI getInstance] getCurrentUser].screenName;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            
            [self.tableView beginUpdates];
            [self.messages insertObject:message atIndex:0];
            [self.messages2 insertObject:m atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
            [self.tableView slk_scrollToTopAnimated:YES];
        });
    });
}

#pragma mark - Overriden Methods

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.
    
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.
    
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    NSString *message = [self.textView.text copy];
    
    [self writeMessageAsync:message];
    
    
    [super didPressRightButton:sender];
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo
{
    // Notifies the view controller when the user has pasted an image inside of the text view.
    
    NSLog(@"%s : %@",__FUNCTION__, userInfo);
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    
    NSString *message = [self.textView.text copy];
    
    VerveMessage *m = [[VerveMessage alloc] init];
    m.message = message;
    m.screenName = [[RestAPI getInstance] getCurrentUser].screenName;
    
    [self.messages removeObjectAtIndex:0];
    [self.messages insertObject:message atIndex:0];
    [self.messages2 removeObjectAtIndex:0];
    [self.messages2 insertObject:m atIndex:0];
    [self.tableView reloadData];
    
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button
    
    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowAutoCompletion
{
    return NO;
}

- (CGFloat)heightForAutoCompletionView
{
    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cellHeight*self.searchResult.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessengerCellIdentifier];
    }
    
    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    cell.usedForMessage = YES;
    VerveMessage *m = [self.messages2 objectAtIndex:indexPath.row];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)]) {
        scale = [UIScreen mainScreen].nativeScale;
    }
    
    CGSize imgSize = CGSizeMake(kMessageTableViewCellAvatarHeight*scale, kMessageTableViewCellAvatarHeight*scale);
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:m.screenName];
        NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            UIImage *img = [UIImage imageWithData:imageData];
            
            cell.imageView.image = [EVCCommonMethods imageWithImage:img scaledToSize:imgSize];
            
        });
        
    });
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        NSString *message = self.messages[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-(kMessageTableViewCellAvatarHeight*2.0+10);
        
        CGRect bounds = [message boundingRectWithSize:CGSizeMake(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (message.length == 0) {
            return 0.0;
        }
        
        CGFloat height = roundf(CGRectGetHeight(bounds)+kMessageTableViewCellAvatarHeight);
        
        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }
        
        return height;
    }
    else {
        return kMessageTableViewCellMinimumHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.autoCompletionView]) {
        UIView *topView = [UIView new];
        topView.backgroundColor = self.autoCompletionView.separatorColor;
        return topView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.autoCompletionView]) {
        return 0.5;
    }
    return 0.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoCompletionView]) {
        
        NSMutableString *item = [self.searchResult[indexPath.row] mutableCopy];
        
        if ([self.foundPrefix isEqualToString:@"@"] || [self.foundPrefix isEqualToString:@":"]) {
            [item appendString:@":"];
        }
        
        [item appendString:@" "];
        
        [self acceptAutoCompletionWithString:item];
    }
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
}




@end
