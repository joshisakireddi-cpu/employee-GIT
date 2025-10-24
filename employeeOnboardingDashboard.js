import { LightningElement, wire, track } from 'lwc';
import getEmployeesWithTasks from '@salesforce/apex/EmployeeDashboardController.getEmployeesWithTasks';

export default class EmployeeOnboardingDashboard extends LightningElement {
    @track searchKey = '';
    @track employees;
    @track error;

    columns = [
        { label: 'Employee Name', fieldName: 'Name' },
        { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' },
        { label: 'Total Tasks', fieldName: 'TotalTasks', type: 'number' },
        { label: 'Completed Tasks', fieldName: 'CompletedTasks', type: 'number' },
        { label: 'Pending Tasks', fieldName: 'PendingTasks', type: 'number' }
    ];

    @wire(getEmployeesWithTasks, { searchKey: '$searchKey' })
    wiredEmployees({ error, data }) {
        if (data) {
            this.employees = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.employees = undefined;
        }
    }

    handleSearch(event) {
        this.searchKey = event.target.value;
    }
}
