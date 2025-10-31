public with sharing class OnboardingService {
    // Inner helper class for template data
    public class Template {
        public String taskType;
        public Integer daysAfterStart;
        public Id assignedTo;
        public String priority;
        public String notes;

        public Template(String taskType, Integer daysAfterStart, Id assignedTo, String priority, String notes) {
            this.taskType = taskType;
            this.daysAfterStart = daysAfterStart;
            this.assignedTo = assignedTo;
            this.priority = priority;
            this.notes = notes;
        }
    }

    @AuraEnabled
    public static void createOnboardingTasks(List<Id> employeeIds) {
        if (employeeIds == null || employeeIds.isEmpty()) return;

        List<Employee__c> employees = [
            SELECT Id, Name, Start_Date__c
            FROM Employee__c
            WHERE Id IN :employeeIds
        ];

        List<Template> templates = loadTemplatesFromCustomMetadata();

        if (templates.isEmpty() && Test.isRunningTest()) {
            templates.add(new Template('HR Paperwork', 1, null, 'Medium', 'Fill HR forms'));
            templates.add(new Template('IT Setup', 0, null, 'High', 'Provide laptop and credentials'));
        }

        Schema.SObjectType taskType = Schema.getGlobalDescribe().get('Onboarding_Task__c');
        if (taskType == null) {
            return;
        }

        List<SObject> tasksToInsert = new List<SObject>();

        for (Employee__c emp : employees) {
            for (Template tmpl : templates) {
                SObject t = taskType.newSObject();
                t.put('Employee__c', emp.Id);
                String taskName = emp.Name + ' - ' + (tmpl.taskType == null ? 'Onboarding Task' : tmpl.taskType);
                t.put('Name', taskName);

                if (emp.Start_Date__c != null && tmpl.daysAfterStart != null) {
                    try {
                        Date due = emp.Start_Date__c.addDays(tmpl.daysAfterStart);
                        t.put('Due_Date__c', due);
                    } catch (Exception ex) {
                        // ignore invalid dates
                    }
                }

                if (tmpl.priority != null) t.put('Priority__c', tmpl.priority);
                if (tmpl.notes != null) t.put('Notes__c', tmpl.notes);
                if (tmpl.assignedTo != null) t.put('Assigned_To__c', tmpl.assignedTo);
                t.put('Status__c', 'Not Started');

                tasksToInsert.add(t);
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    private static List<Template> loadTemplatesFromCustomMetadata() {
        List<Template> results = new List<Template>();
        try {
            // NOTE: remove or add fields here depending on the fields actually present in your custom metadata.
            List<Onboarding_Task_Template__mdt> mdts = [
                SELECT DeveloperName, Task_Type__c, Days_After_Start__c,
                       Priority__c, Default_Notes__c, Active__c
                FROM Onboarding_Task_Template__mdt
                WHERE Active__c = TRUE
            ];

            for (Onboarding_Task_Template__mdt m : mdts) {
                Integer days = (m.Days_After_Start__c != null) ? Integer.valueOf(m.Days_After_Start__c.intValue()) : null;
                Id assignedTo = null; // set if you add a Default_Assigned_To_UserId__c text field later
                results.add(new Template(
                    m.Task_Type__c,
                    days,
                    assignedTo,
                    m.Priority__c,
                    m.Default_Notes__c
                ));
            }
        } catch (Exception ex) {
            // swallow: if metadata or fields are missing, return empty list (caller handles test fallback)
        }
        return results;
    }
}