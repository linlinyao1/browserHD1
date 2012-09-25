//
//  RCFolderTable.m
//  browserHD
//
//  Created by imac on 12-9-13.
//  Copyright (c) 2012年 2345. All rights reserved.
//

#import "RCFolderTable.h"

@interface RCTreeTable ()
-(void)miniMizeThisRows:(NSArray*)ar;
@property (nonatomic,strong) NSMutableArray *listContent;

@end

@implementation RCFolderTable
@synthesize delegate = _delegate;
@synthesize rootFolder = _rootFolder;

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
////    self.listContent = 
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.alwaysExpanded) {
//        return;
//    }
//    
//    
//    NSDictionary *object = [self.listContent objectAtIndex:indexPath.row];
//    NSDictionary*parent = nil;
//    if (indexPath.row>0) {
//        parent = [self.listContent objectAtIndex:indexPath.row-1];
//    }
//    NSArray* content = [object valueForKey:@"content"];
//    
//    if (self.tableView.isEditing) {
//        
//    }else{
//
//        if (content) {
//            
//            BOOL isAlreadyInserted=NO;
//            
//            for(NSDictionary *dInner in content ){
//                if (![dInner isKindOfClass:[NSMutableDictionary class]]) {
//                    continue;
//                }
//                NSInteger index=[self.listContent indexOfObjectIdenticalTo:dInner];
//                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
//                if(isAlreadyInserted) break;
//            }
//            
//            if (isAlreadyInserted) {
//                [self miniMizeThisRows:content];
//            }else{
//                NSUInteger count=indexPath.row+1;
//                NSMutableArray *arCells=[NSMutableArray array];
//                NSMutableArray* files = [NSMutableArray array];
//                for(NSDictionary *dInner in content ) {
//                    if (![dInner isKindOfClass:[NSMutableDictionary class]]) {
//                        continue;
//                    }
//                    /////////////////////////////////////////////////////////////////////////////////////////////////
//                    if (![dInner objectForKey:@"content"]) {
//                        [files addObject:dInner];
//                        continue;
//                    }
//                    /////////////////////////////////////////////////////////////////////////////////////////////////
//                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
//                    [self.listContent insertObject:dInner atIndex:count++];
//                }
//                
//                ////////////////////////////////////////////////////////////////////////////////////////////////////
//                [self.delegate FolderTable:self filesOfFolder:files inSelectIndexPath:indexPath];
//                ////////////////////////////////////////////////////////////////////////////////////////////////////
//                
//                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
//            }
//        }
//    }
//    
//    [self.delegate FolderTable:self folderSelected:object parentFolder:parent isEditing:self.tableView.isEditing];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate FolderTable:self folderSelected:[self.listContent objectAtIndex:indexPath.row] isEditing:self.tableView.isEditing];
}

//-(NSInteger)numberofFoldersInFolder:(Folder*)root
//{
//    NSInteger count=0;
//    for (Folder* folder in root.child) {
//        count++;
//        if (folder.child.count>0) {
//            count = count + [self numberofFoldersInFolder:folder];
//        }
//    }
//    return count;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[CoreDataManager defaultManager] getAllFolders].count;
    return self.listContent.count;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        if (self.cellBG) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:self.cellBG];
        }
        if (self.selectedCellBG) {
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:self.selectedCellBG];
        }
        if (self.isPopup) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.image = [UIImage imageNamed:@"bookmark_folderEdit_folder"];
        }else{
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.imageView.image = [UIImage imageNamed:@"bookmark_leftCellImage"];
        }

	}
    Folder* folder = [self.listContent objectAtIndex:indexPath.row];
        
    cell.textLabel.text = folder.title;
    cell.indentationLevel = folder.level.intValue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate FolderTable:self folderDeleted:[self.listContent objectAtIndex:indexPath.row]];
    }
}


@end
