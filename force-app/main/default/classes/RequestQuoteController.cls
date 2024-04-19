/**
 * @description       : Creates a quote based on the provided cart ID
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 04-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RequestQuoteController {

    @AuraEnabled
    public static String createQuote(Id cartId,Date requestQuoteBy, String reasonForQuote,Id contactId,String userName) {
        try {
            
            system.debug('cartId'+cartId);
            system.debug('requestQuoteBy'+requestQuoteBy);
            system.debug('reasonForQuote'+reasonForQuote);
            if (cartId != null) {
                List<CartItem> cartItems = [SELECT Id, Quantity, Product2Id, ListPrice,SalesPrice, TotalAmount, CartId FROM CartItem WHERE CartId = :cartId];
                List<Pricebook2> PbId = [SELECT Id,name FROM Pricebook2 WHERE Name = 'MADA Services Price Book' limit 1];
                System.debug('cartItems : '+cartItems);

                // Create a new Quote record outside the loop
                Quote newQuote = new Quote(
                    Status = 'Draft',
                    Name = userName + ' ' + 'Quote',
                    Pricebook2Id =  pbId[0].id,
                    Email = 'quotetest@gmail.com',
                    ExpirationDate = requestQuoteBy,
                    Description = reasonForQuote,
                    ContactId =contactId// Set a meaningful name for the quote
                );
                insert newQuote;
                System.debug('newQuote id: '+newQuote.id);


                List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
                // Iterate through cart items to create quote line items
                for (CartItem cartItem : cartItems) {
                    system.debug('inside cartitems');
                    List<PricebookEntry> pricebookEntry = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id = :cartItem.Product2Id 
					AND Pricebook2Id =: PbId[0].Id];
                    // newQuote.Pricebook2Id = pricebookEntry.Pricebook2Id;
                    QuoteLineItem quoteLineItem = new QuoteLineItem(
                        QuoteId = newQuote.Id,
                        //List_Price__c = cartItem.ListPrice,
                        Product2Id = cartItem.Product2Id,
                        UnitPrice = cartItem.SalesPrice,
                        Quantity = cartItem.Quantity,
                        PricebookEntryId = pricebookEntry[0].Id
                    );
                    quoteLineItems.add(quoteLineItem);
                    system.debug('quoteLineItems');
                }

                // update newQuote;
                // Insert all quote line items
                if (!quoteLineItems.isEmpty()) {
                    insert quoteLineItems;
                }
                return newQuote.Id;

            } else {
                return 'Error creating quote: cartId is null';
            }
        } catch (Exception e) {
            System.debug('In Exception...' +e.getMessage());
            return 'Error creating quote: ' + e.getMessage();
        }
    }
}