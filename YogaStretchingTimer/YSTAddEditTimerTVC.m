//
//  YSTAddEditTimerTVC.m
//  YogaStretchingTimer
//
//  Created by Abegael Jackson on 2015-07-08.
//  Copyright (c) 2015 Abbey Jackson. All rights reserved.
//

#import "YSTAddEditTimerTVC.h"

@interface YSTAddEditTimerTVC ()
@property (nonatomic, strong) NSArray *timersArray;
@property (nonatomic, strong) NSIndexPath *timePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@end

@implementation YSTAddEditTimerTVC

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
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row + 1;
    
    UITableViewCell *checkTimePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIPickerView *checkTimePicker = (UIPickerView *)[checkTimePickerCell viewWithTag:99];
    
    hasDatePicker = (checkTimePicker != nil);
    return hasDatePicker;
}


- (void)updateTimePicker{
    if (self.timePickerIndexPath != nil){
        UITableViewCell *associatedTimePickerCell = [self.tableView cellForRowAtIndexPath:self.timePickerIndexPath];
        
        UIPickerView *targetedTimePicker = (UIPickerView *)[associatedTimePickerCell viewWithTag:99];
        
        if (targetedTimePicker != nil){
            NSDictionary *cellData = self.timersArray[self.timePickerIndexPath.row - 1];
//            [targetedTimePicker setDate:[cellData valueForKey:kDateKey] animated:NO] ;
        }
    }
}

- (BOOL)hasInlineTimePicker{
    return (self.timePickerIndexPath != nil);
}


- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath{
    return ([self hasInlineTimePicker] && self.timePickerIndexPath.row == indexPath.row);
}


- (BOOL)indexPathHasTime:(NSIndexPath *)indexPath{
    BOOL hasTime = NO;
    // row == 0 is going to be title of timer
    if ((indexPath.row == 1) || (indexPath.row == 2 || ([self hasInlineTimePicker] && (indexPath.row == 3)))){
        hasTime = YES;
    }
    
    return hasTime;
}




#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self hasInlineTimePicker]){
        NSInteger numRows = self.timersArray.count;
        return ++numRows;
    }
    
    return self.timersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = @"titleCell";
    
    if ([self indexPathHasPicker:indexPath]){
        cellID = @"pickerCell";
    }
    else if ([self indexPathHasTime:indexPath]){
        cellID = @"timeCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSInteger modelRow = indexPath.row;
    if (self.timePickerIndexPath != nil && self.timePickerIndexPath.row <= indexPath.row){
        modelRow--;
    }
    
    NSDictionary *cellData = self.timersArray[modelRow];
    
    if ([cellID isEqualToString:@"timeCell"]){
//        cell.textLabel.text = [cellData valueForKey:kTitleKey];
//        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
    }
    else if ([cellID isEqualToString:@"change this"]){
        cell.textLabel.text = [cellData valueForKey:@"change this"];
    }
    
    return cell;
}

- (void)toggleTimePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    if ([self hasPickerForIndexPath:indexPath]){
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    if ([self hasInlineTimePicker]){
        before = self.timePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.timePickerIndexPath.row - 1 == indexPath.row);
    
    if ([self hasInlineTimePicker]){
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.timePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.timePickerIndexPath = nil;
    }
    
    if (!sameCellClicked){
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleTimePickerForSelectedIndexPath:indexPathToReveal];
        self.timePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    [self updateTimePicker];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"timeCell"]){
//        [self displayInlineTimePickerForRowAtIndexPath:indexPath];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Actions
    
- (IBAction)dateAction:(id)sender{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineTimePicker]){
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.timePickerIndexPath.row - 1 inSection:0];
    }
    else{
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIPickerView *targetedTimePicker = sender;
    
    NSMutableDictionary *itemData = self.timersArray[targetedCellIndexPath.row];
//    [itemData setValue:targetedTimePicker.date forKey:kDateKey];
    // change all this
//    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}
    

    
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
