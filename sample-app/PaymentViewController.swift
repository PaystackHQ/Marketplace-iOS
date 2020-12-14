//
//  PaymentViewController.swift
//  sample-app
//
//  Created by James KUMAKO on 11/15/20.
//  Copyright © 2020 Kuassi Jimmy . All rights reserved.
//

import UIKit
import Paystack

class PaymentViewController: UIViewController , PSTCKPaymentCardTextFieldDelegate {
  
  let paymentTextField = PSTCKPaymentCardTextField()
  @IBOutlet weak var payButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    paymentTextField.frame = CGRect.init(x: 15, y: 15, width: self.view.frame.width - 30, height: 44)
    paymentTextField.delegate = self
    view.addSubview(paymentTextField)


  }
  
  func paymentCardTextFieldDidChange(textField: PSTCKPaymentCardTextField) {
      
    self.payButton.isEnabled = textField.isValid
    
  }
  
  @IBAction func charge(sender: UIButton) {
    let cardParams = paymentTextField.cardParams as PSTCKCardParams

    // cardParams already fetched from our view or assembled by you
    let transactionParams = PSTCKTransactionParams.init();

    // building new Paystack Transaction
    transactionParams.amount = 250000;
    let custom_filters: NSMutableDictionary = [
        "recurring": true
      ];
    let items: NSMutableArray = [
        "Bag","Glasses"
      ];
    do {
        //try transactionParams.setCustomFieldValue("iOS SDK", displayedAs: "Paid Via");
        //try transactionParams.setCustomFieldValue("Paystack hats", displayedAs: "To Buy");
        //try transactionParams.setMetadataValue("iOS SDK", forKey: "paid_via");
        //try transactionParams.setMetadataValueDict(custom_filters, forKey: "custom_filters");
        try transactionParams.setMetadataValueArray(items, forKey: "items");
    } catch {
        print(error);
    }
    transactionParams.email = "jkumako@yahoo.fr";

     

    PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) -> Void in
        self.handleError(error: error)
      }, didRequestValidation: { (reference) -> Void in
                // an OTP was requested, transaction has not yet succeeded
            }, didTransactionSuccess: { (reference) -> Void in
                // transaction may have succeeded, please verify on backend
      })
  }
  
  func handleError(error: Error) {
    
    print("Error : \(error)")
    
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destination.
      // Pass the selected object to the new view controller.
  }
  */

}
