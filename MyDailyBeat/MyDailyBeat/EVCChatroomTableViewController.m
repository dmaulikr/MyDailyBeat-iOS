//
//  EVCChatroomTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCChatroomTableViewController.h"

static NSString *CellIdentifier = @"CustomCellReuse";
static NSString *CellIdentifier2 = @"CustomCellReuse2";

@interface EVCChatroomTableViewController ()

@end

@implementation EVCChatroomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EVCChatroomCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadChatroomsAsync];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadChatroomsAsync {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        self.chatrooms = [[NSMutableArray alloc] init];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[[API getInstance] getChatroomsForUser:[[API getInstance] getCurrentUser]] copyItems:YES];
        
        if ([temp count] > 0) {
            self.chatrooms = temp;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
            NSLog(@"count = %lu", (unsigned long)[self.chatrooms count]);
        });
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.chatrooms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.chatrooms count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.textLabel.text = @"No Chatrooms";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        
        EVCChatroomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EVCChatroomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell = [cell changeChatroom:[self.chatrooms objectAtIndex:indexPath.row]];
        return cell;
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.chatrooms count] == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        if (indexPath.row == [self.chatrooms count]) {
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        } else {
            return 85;
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.chatrooms count] == 0) {
        // do nothing
    } else {
        EVCFlingMessagingViewController *messaging = [[EVCFlingMessagingViewController alloc] initWithChatroom:[self.chatrooms objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:messaging animated:YES];
    }
}


@end
