public with sharing class EmployeeDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployeeData() {
        return [
            SELECT Id, Name, Email__c, Department__c,
                (SELECT Id, Name, Status__c, Due_Date__c FROM Onboarding_Tasks__r)
            FROM Employee__c
            LIMIT 50
        ];
    }
}
