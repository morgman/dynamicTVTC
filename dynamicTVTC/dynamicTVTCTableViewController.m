//
//  dynamicTVTCTableViewController.m
//  dynamicTVTC
//
//  Created by Morgan Jones on 12/5/14.
//  Copyright (c) 2014 morgman. All rights reserved.
//

#import "dynamicTVTCTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "MultiLineTableViewCell.h"

@interface dynamicTVTCTableViewController () {
    NSString *cellText;
}

@end

@implementation dynamicTVTCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"singleLineCell";
    if (indexPath.row == 4) {
        reuseIdentifier = @"multiLineCell";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row != 4) {
        SingleLineTableViewCell *aCell = (SingleLineTableViewCell *) cell;
        NSString *labelString = [NSString stringWithFormat:@"single line label %ld",(long)indexPath.row];
        [[aCell textLabel] setText:labelString];
    } else {
        MultiLineTableViewCell *aCell = (MultiLineTableViewCell *) cell;
        if ([cellText length] == 0) {
            [[aCell textView] setText:@"Type something here."];
        } else {
            [[aCell textView] setText:cellText];
        }
        [[aCell textView] setDelegate:self];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 4) {
        return 50.0;
    } else {
        
        static MultiLineTableViewCell *sizingCell;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = (MultiLineTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"multiLineCell"];
        });
        
        // configure the cell
        sizingCell.textView.text = self->cellText;
        
        // force layout
        [sizingCell setNeedsLayout];
        [sizingCell layoutIfNeeded];
        // get the fitting size
        CGSize s = [sizingCell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
        
        return s.height+1; // <-- This "+1" seemed to be the issue?!?!?!
    }
}

#pragma mark - UITextView Delegate

- (void) textViewDidChange:(UITextView *)textView {
    
    cellText = [textView text];
    
    [self.tableView beginUpdates]; // This will cause an animated update of
    [self.tableView endUpdates];   // the height of your UITableViewCell
}
@end
