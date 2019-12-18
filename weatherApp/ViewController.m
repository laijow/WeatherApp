//
//  ViewController.m
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "ViewController.h"
#import <TodayWeather/TodayWeather.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, WeatherManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<LocationModel*>* locations;
@property (nonatomic) UISearchController * searchController;
@property (nonatomic) WeatherManager * weatherManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _weatherManager = [[WeatherManager alloc] init];
    
    _weatherManager.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 9.1, *)) {
        _searchController.obscuresBackgroundDuringPresentation = false;
    } else {
    }
    _searchController.searchBar.placeholder = @"Поиск";
    _searchController.searchBar.barStyle = UIBarStyleDefault;
    _searchController.searchBar.delegate = self;
    _tableView.tableHeaderView = self.searchController.searchBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)keyboardWasShown:(NSNotification*)notification {
    
    NSDictionary * dict = [notification userInfo];
    NSValue * value = (NSValue*)dict[UIKeyboardFrameEndUserInfoKey];
    CGFloat height = value.CGRectValue.size.height;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.f, 0.f, height, 0.f);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

- (void)presentAlertWithTitle:(NSString*)title andWithDescription:(NSString*)description {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    if([self.navigationController.visibleViewController isEqual:self]) {
        [self presentViewController:alert animated:true completion:nil];
    } else {
        [_searchController presentViewController:alert animated:true completion:nil];
    }
    
}

- (void)searchWithText:(NSString*)text {
    
    [_weatherManager getLocationsWithString:text];
  
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _locations.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
    
    LocationModel * location = _locations[indexPath.row];
    
    cell.textLabel.text = location.city;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationModel * location = _locations[indexPath.row];
    [self.weatherManager currentWeatherWithLocation:location];
    
}

#pragma mark - WeatherManagerDelegate

- (void)locationsDidFound:(NSArray<LocationModel *> *)locations {
    
    _locations = locations;
    [_tableView reloadData];
    
}

- (void)weatherDidFoundAtLocation:(LocationModel *)location {
    
    WeatherModel * weather = location.weathers.firstObject;
    NSString * locationWeatherDescription = [NSString stringWithFormat:@"Date: %@\nCity: %@\nTemperature: minimum %3.fºC, maximum %3.fºC", weather.stringDate, location.city, weather.minTemp, weather.maxTemp];
    
    [self presentAlertWithTitle:@"Weather" andWithDescription:locationWeatherDescription];
    
}

- (void)errorSearchWeatherWithErrorDescription:(NSString *)errorDescription {
    
    [self presentAlertWithTitle:@"Error" andWithDescription:errorDescription];
    
}

#pragma mark - Search bar delegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSMutableString* searchText = [NSMutableString stringWithFormat:@"%@", searchBar.text];
    [searchText insertString:text atIndex:range.location];
    NSString * replaceString = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self searchWithText:replaceString];
    
    return YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _locations = nil;
    [_tableView reloadData];
    
}

@end
