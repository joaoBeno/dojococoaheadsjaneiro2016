//
//  PersonTableViewController.m
//  dojosabado
//
//  Created by Jose Lino Neto on 1/30/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import "PersonTableViewController.h"
#import "Person.h"
#import <MBProgressHUD.h>
#import "newPersonViewController.h"

@interface PersonTableViewController ()

@property (strong, nonatomic) NSArray *vetorPerson;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation PersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.refreshControl addTarget:self action:@selector(atualizarRemoto) forControlEvents:UIControlEventValueChanged];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Carregando...";
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.vetorPerson){
        [self atualizarRemoto];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vetorPerson count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Person *p = [self.vetorPerson objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.Nome;
    cell.detailTextLabel.text = p.Email;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Excluir";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmar"
                                                                       message:@"Deseja realmente Excluir?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Sim" style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                                              self.hud.mode = MBProgressHUDAnimationFade;
                                                              self.hud.labelText = @"Aguarde...";
                                                              
                                                              Person *p = [self.vetorPerson objectAtIndex:indexPath.row];
                                                              [Person deletePerson:p sucesso:^(NSURLSessionDataTask *resposta, NSArray *objetoDeResposta) {
                                                                  [self atualizarRemoto];
                                                              } falha:^(NSURLSessionDataTask *resposta, NSError *erro) {
                                                              }];
                                                          }];
        
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Não" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:yesAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"Details"]){
         UITableViewCell *cell = (UITableViewCell *)sender;
         NSIndexPath *indice = [self.tableView indexPathForCell:cell];
         
         Person *p = [self.vetorPerson objectAtIndex:indice.row];
         newPersonViewController *npvc = (newPersonViewController *)segue.destinationViewController;
         
         npvc.personEditar = p;
     }
 }
 

#pragma mark - Metodos Locais

-(void)atualizarRemoto{
    [Person getPersons:^(NSURLSessionDataTask *resposta, NSArray *objetoDeResposta) {
        self.vetorPerson = objetoDeResposta;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.hud hide:YES];
    } falha:^(NSURLSessionDataTask *resposta, NSError *erro) {
        [self.hud hide:YES];
        [self.refreshControl endRefreshing];
    } progresso:^(float progresso) {
        
    }];
}

























@end
