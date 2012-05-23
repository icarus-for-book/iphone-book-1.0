//
//  OptionViewController.m
//  icomicviewer
//
//  Created by 진섭 안 on 11. 5. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionViewController.h"

@implementation OptionViewController

@synthesize title, options, selectedIndex, delegate,optionKind;


- (id) initWithTitle:(NSString*)titleVal 
             options:(NSArray*)optionsVal 
       selectedIndex:(NSInteger)index
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    
    if(self)
    {
        self.title = titleVal;
        self.options = optionsVal;
        self.selectedIndex = index;
        
    }
    
    return self;
}

- (void)dealloc
{
    [title release];
    [options release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.title;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == self.selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // unchecked old selected row
    NSIndexPath *oldSelectedRow = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldSelectedRow];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    
    // check selected row
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    curCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndex = indexPath.row;
    
    // call delegate
    if (delegate && [delegate respondsToSelector:@selector(optionView:isValueChanged:)]) {
        [delegate optionView:self isValueChanged:self.selectedIndex];
    }
    
}

@end
