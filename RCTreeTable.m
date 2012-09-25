//
//  RCTreeTable.m
//  Examinations
//
//  Created by imac on 12-9-12.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCTreeTable.h"

@interface RCTreeTable ()
@property (nonatomic,strong) NSMutableArray *listContent;
@end

@implementation RCTreeTable
@synthesize tableView = _tableView;
@synthesize listContent = _listContent;
@synthesize cellBG = _cellBG;
@synthesize selectedCellBG = _selectedCellBG;

-(void)testData
{
    NSMutableDictionary* item0 = [NSMutableDictionary dictionary];
    [item0 setObject:@"level0" forKey:@"title"];
    [item0 setObject:[NSNumber numberWithInt:0] forKey:@"level"];
    [item0 setObject:[NSMutableArray array] forKey:@"content"];
    
    NSMutableDictionary* item1 = [NSMutableDictionary dictionary];
    [item1 setObject:@"level1" forKey:@"title"];
    [item1 setObject:[NSNumber numberWithInt:1] forKey:@"level"];
    [item1 setObject:[NSMutableArray array] forKey:@"content"];

    NSMutableDictionary* item2 = [NSMutableDictionary dictionary];
    [item2 setObject:@"level1" forKey:@"title"];
    [item2 setObject:[NSNumber numberWithInt:1] forKey:@"level"];
    
    NSMutableArray*array0 = [item0 objectForKey:@"content"];
    [array0 addObject:item1];
    [array0 addObject:item2];
    
    NSMutableDictionary* item3 = [NSMutableDictionary dictionary];
    [item3 setObject:@"level2" forKey:@"title"];
    [item3 setObject:[NSNumber numberWithInt:2] forKey:@"level"];
    [item3 setObject:[NSMutableArray array] forKey:@"content"];

    NSMutableArray*array1 = [item1 objectForKey:@"content"];
    [array1 addObject:item3];
    
    
    NSMutableDictionary* item4 = [NSMutableDictionary dictionary];
    [item4 setObject:@"level3" forKey:@"title"];
    [item4 setObject:[NSNumber numberWithInt:3] forKey:@"level"];
    
    NSMutableArray*array3 = [item3 objectForKey:@"content"];
    [array3 addObject:item4];
    
    
    self.listContent = [NSMutableArray arrayWithObject:item0];
}


-(void)setUpData:(NSMutableArray *)data
{
    self.listContent = data;
    [self.tableView reloadData];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.autoresizingMask = RCViewAutoresizingALL;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        
//        [self testData];
    }
    return self;
}

-(void)awakeFromNib
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = RCViewAutoresizingALL;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:self.cellBG];
        cell.backgroundView = imageView;
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:self.selectedCellBG];
	}

//    [cell.contentView insertSubview:self.cellBG atIndex:0];
    
    NSDictionary *object = [self.listContent objectAtIndex:indexPath.row];

    cell.textLabel.text = [object objectForKey:@"title"];
    cell.indentationLevel = [[object objectForKey:@"level"] intValue];

    
    return cell;
}

-(void)miniMizeThisRows:(NSArray*)ar{
	
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.listContent indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"content"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.listContent indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.listContent removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationLeft];
		}
	}
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *object = [self.listContent objectAtIndex:indexPath.row];
    NSArray* content = [object valueForKey:@"content"];
    if (content) {
        
        BOOL isAlreadyInserted=NO;
		
		for(NSDictionary *dInner in content ){
            if (![dInner isKindOfClass:[NSMutableDictionary class]]) {
                continue;
            }
			NSInteger index=[self.listContent indexOfObjectIdenticalTo:dInner];
			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
			if(isAlreadyInserted) break;
		}
        
        if (isAlreadyInserted) {
            [self miniMizeThisRows:content];
        }else{
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *dInner in content ) {
                if (![dInner isKindOfClass:[NSMutableDictionary class]]) {
                    continue;
                }
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.listContent insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }

    }
}

#pragma mark - public methods
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.tableView setEditing:editing animated:animated];
}

-(NSString *)nameForCurrentFolder
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    return cell.textLabel.text;
}
@end
