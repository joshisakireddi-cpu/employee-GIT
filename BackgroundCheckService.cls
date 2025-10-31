public with sharing class BackgroundCheckService {
 
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getBackgroundCheck(String employeeName) {
        Map<String, Object> response = new Map<String, Object>();
 
        // 1️⃣ Find employee by name
        List<Employee__c> employees = [
            SELECT Id, Name, Email__c, Start_Date__c
            FROM Employee__c
            WHERE Name LIKE :('%' + employeeName + '%')
            LIMIT 5
        ];
 
        if (employees.isEmpty()) {
            response.put('status', 'error');
            response.put('message', 'No employee found for "' + employeeName + '".');
            return response;
        }
 
        // Just take the first matching employee for simplicity
        Employee__c emp = employees[0];
 
        // 2️⃣ Fetch related Onboarding Tasks
        List<Onboarding_Task__c> tasks = [
            SELECT Id, Name, Status__c
            FROM Onboarding_Task__c
            WHERE Employee__c = :emp.Id
        ];
 
        Integer completed = 0;
        Integer inProgress = 0;
        Integer pending = 0;
 
        for (Onboarding_Task__c t : tasks) {
            if (t.Status__c == 'Completed') completed++;
            else if (t.Status__c == 'In Progress') inProgress++;
            else pending++;
        }
 
        // 3️⃣ Build response map
        response.put('status', 'success');
        response.put('employeeName', emp.Name);
        response.put('email', emp.Email__c);
        response.put('startDate', String.valueOf(emp.Start_Date__c));
        response.put('completed', completed);
        response.put('inProgress', inProgress);
        response.put('pending', pending);
 
        return response;
    }
}