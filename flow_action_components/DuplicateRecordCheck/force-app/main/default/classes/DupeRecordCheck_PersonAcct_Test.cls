@isTest
public with sharing class DupeRecordCheck_PersonAcct_Test {
    public static final Id  PERSON_ACCOUNT_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

    @isTest
    public static void findDuplicates_givenPersonAccountDuplicate_shouldReturnDuplicate(){
        Account personAccount = new Account(
            RecordTypeId = PERSON_ACCOUNT_RECORD_TYPE_ID
        );
        personAccount.FirstName = 'Test';
        personAccount.LastName = 'Test';
        personAccount.PersonEmail = 'test@test.com';
        insert personAccount;

        Account duplicateAccount = personAccount.clone(false,true);

        System.Test.startTest();
        List<Duplicate> dupes = DuplicateRecordCheck_Util.findDuplicates(new List<sObject>{duplicateAccount});
        System.Test.stopTest();

        system.assert(!dupes.isEmpty(),'The return is NOT empty.');
        for(Duplicate dupe : dupes){
            system.assert(dupe.isDuplicate,'It is a duplicate.');
            system.assertEquals(personAccount.Id, dupe.duplicateRecordId, 'And the Ids match.');
            system.assertEquals('Account', dupe.duplicatesObjectType,'And it\'s an Account.');
        }
    }
}
