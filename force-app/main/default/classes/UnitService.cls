public class UnitService{

    public static Boolean registerUnitResponse(Id unitId, String jsonAnswer){
        
        Database.SavePoint sp = Database.setSavePoint();

        try{
            Unit__c unit = [SELECT Module__c, (SELECT Id, Number_Of_Tries__c 
                           FROM Unit_Responses__r 
                           WHERE Module_Response__r.User__c =: UserInfo.getUserId() 
                           ORDER BY Number_Of_Tries__c DESC LIMIT 1), (SELECT Id, Name FROM Questions__r) FROM Unit__c WHERE Id =: unitId];
            
            Module_Response__c moduleResponse = [SELECT Id FROM Module_Response__c 
                                            WHERE Module__c =: unit.Module__c AND User__c =: Userinfo.getUserId() AND Status__c = 'In Progress'];
            
            if(moduleResponse == null){
                moduleResponse = new Module_Response__c(User__c = Userinfo.getUserId(), Module__c = unit.Module__c, Status__c = 'In Progress');
                insert moduleResponse;
            }

            Unit_Response__c unitResponse = new Unit_Response__c(Unit__c = unitId, Module_Response__c = moduleResponse.Id, Status__c = 'Draft');
            unitResponse.Number_Of_Tries__c = !unit.Unit_Responses__c.isEmpty() ? unit.Unit_Response__c[0].Number_Of_Tries__c + 1 : 1;
            insert unitResponse;
        }
    }
}