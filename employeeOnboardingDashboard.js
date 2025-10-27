import { LightningElement, wire } from 'lwc';
import getEmployeeData from '@salesforce/apex/EmployeeDashboardController.getEmployeeData';

export default class EmployeeOnboardingDashboard extends LightningElement {
    employees = [];
    error;

    // Wire Apex method
    @wire(getEmployeeData)
    wiredEmployees({ data, error }) {
        if (data) {
            this.employees = data.map(emp => {
                const tasks = emp.Onboarding_Tasks__r 
                    ? emp.Onboarding_Tasks__r.map(task => ({
                        Id: task.Id,
                        Name: task.Name,
                        Status: task.Status__c,
                        DueDate: task.Due_Date__c,
                        statusColor: this.getStatusColor(task.Status__c)
                    })) 
                    : [];

                return {
                    Id: emp.Id,
                    Name: emp.Name,
                    Email: emp.Email__c,
                    Department: emp.Department__c,
                    Tasks: tasks
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.employees = [];
        }
    }

    // Set background color based on task status
    getStatusColor(status) {
        switch (status) {
            case 'Completed':
                return 'background-color: #2ecc71; color: white;'; // green
            case 'Pending':
                return 'background-color: #f1c40f; color: black;'; // yellow
            case 'In Progress':
                return 'background-color: #3498db; color: white;'; // blue
            default:
                return 'background-color: #bdc3c7; color: black;'; // gray
        }
    }
}
