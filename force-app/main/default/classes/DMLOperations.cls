/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Ola Okunola
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myAccount = new Account();

        // Set some fields on the Account
        myAccount.Name = 'Igisogba Ikulepa';

        // Insert the Account into the database
        //Insert as user myAccount;
        Database.insert(myAccount, AccessLevel.USER_MODE);

        // Return the Id of the newly created Account
        return myAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account myAccount = new Account(
                                        Name = name,
                                        Industry = industry
                                );

        // Insert the Account
        //insert as user myAccount;
        Database.insert(myAccount, AccessLevel.USER_MODE);

    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact myContact = new Contact(FirstName = 'Ewenla', LastName =  'Idiaraba', AccountId = accountId);

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId

        // Insert the Contact into the database
        //insert as user myContact;
        Database.insert(myContact, AccessLevel.USER_MODE);

        // Return the Id of the newly created Contact
        return myContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact myContact = [SELECT Id FROM Contact WHERE Id = :contactId WITH USER_MODE LIMIT 1];

        // Update the Contact's last name
        myContact.LastName = newLastName;

        // Update the Contact in the database
        //update as User myContact;
        Database.update(myContact, AccessLevel.USER_MODE);
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity myOpp = [SELECT Id FROM Opportunity WHERE Id = :oppId WITH USER_MODE LIMIT 1];

        // Update the Opportunity's stage
        myOpp.StageName = newStage;

        // Update the Opportunity in the database
        //update as user myOpp;
        Database.update(myOpp, AccessLevel.USER_MODE);
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account myAccount = [SELECT Id FROM Account WHERE Id = :accountId WITH USER_MODE LIMIT 1];

        // Update the Account with the given Id with the new name and industry
        myAccount.Name = newName;
        myAccount.Industry = newIndustry;
        //update as user myAccount;
        Database.update(myAccount, AccessLevel.USER_MODE);
    }


    /**
     * Question 7
     * Create or updates  Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for (Opportunity opp : opportunities) {
            // Set the Opportunity's Stage to Qualification
            opp.StageName = 'Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            opp.CloseDate = Date.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            opp.Amount = 50000;

        }

        // Upsert the opportunities List so that records are either updated or created
        //upsert as user opportunities;
        Database.Upsert(opportunities, AccessLevel.USER_MODE);
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Set<String> oppNamesDedup = new Set<String>(oppNames);
        List<Opportunity> oppsToUpsert = new List<Opportunity>();
        //Map<Id, Opportunity> myOppGetList = new Map<Id, Opportunity>[SELECT Name FROM Opportunity WHERE Name IN :oppNamesDedup];
        Account myAccount = new Account(Name = accountName);
        //upsert as user myAccount;
        Database.upsert(myAccount, AccessLevel.USER_MODE);
        
        // Loop through each Opportunity name
        for (String opp : oppNamesDedup) {
            // Create an Opportunity with the given name
            Opportunity newOpp = new Opportunity(
                name = opp,
                AccountId = myAccount.Id, 
                StageName = 'New', 
                CloseDate = Date.today().addMonths(3)
                );
            
            // Add the Opportunity to the list
            oppsToUpsert.add(newOpp);
        }
        //upsert as user oppsToUpsert;
        Database.upsert(oppsToUpsert, AccessLevel.USER_MODE);
            

    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName WITH USER_MODE];

		// if the Account exists, update the description
        if(!accounts.isEmpty()) {
            accounts[0].Description = 'Updated Account';
            
        } else {
            Account accToInsert = new Account(Name = accountName, Description = 'New Account');
            accounts.add(accToInsert);            
        }

		// otherwise, create a new Account and set the description

		// Upsert the Account
        //upsert as user accounts;
        Database.upsert(accounts, AccessLevel.USER_MODE);
		return accounts[0];
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact to extract the lastnames
        Set<String> lastName = new Set<String>();
        for (Contact con : contactsToUpsert) {
            lastName.add(con.LastName);
        }

		// Extract the Account Name from Contact's LastName
        
		// Get the account based on the name 
        Map<String, String> accNameToAccId = new Map<String, String>();
        List<Account> myReadAccList = [SELECT Id, Name FROM Account WHERE Name IN :lastName WITH USER_MODE];
        
        // Map Account Name with Id
        for (Account acc : myReadAccList) {
            accNameToAccId.put(Acc.Name, Acc.Id);
        }

        //  Or create one if it doesn't exist
        List<Account> myWriteAccList = new List<Account>();
        for (String ln : lastName) {
            if (!accNameToAccId.containsKey(ln)) {
                Account myWriteAcc = new Account(Name = ln);
                myWriteAccList.add(myWriteAcc);
            }
        }

        Database.insert(myWriteAccList, AccessLevel.USER_MODE);
        

        // Update account map 
        for (Account acc : myWriteAccList) {
            accNameToAccId.put(acc.Name, acc.Id);
        }
            
		// Link the Contact to its Account using the Account Id        
        for (Contact con : contactsToUpsert) {
            con.AccountId = accNameToAccId.get(con.LastName);            
            }

		// Insert the Contacts
        //insert as user contactsToUpsert;
        Database.insert(contactsToUpsert, AccessLevel.USER_MODE);
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        
        List<Lead> myLeadList = new List<Lead>();
        for (String individual : leadNames) {
            Lead myLead = new Lead(Company = 'Not Declared');
            myLead.LastName = individual;
            myLeadList.add(myLead);
            //system.debug('myLead: ' + myLeadList);
        }

        // Insert the Leads
        //upsert as user myLeadList;
        Database.upsert(myLeadList, AccessLevel.USER_MODE);

        // Delete the Leads
        //delete as user myLeadList;
        Database.delete(myLeadList, AccessLevel.USER_MODE);
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> myCaseList = new List<Case>();
        for (Integer i = 1; i <= numOfCases; i++) {
            Case myCase = new Case(AccountId = accountId);
            myCaseList.add(myCase);
        }
        //insert as user myCaseList;
        Database.insert(myCaseList, AccessLevel.USER_MODE);

        // Delete the cases
        //delete as user myCaseList;
        Database.delete(myCaseList, AccessLevel.USER_MODE);
    }
}