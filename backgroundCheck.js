import { LightningElement, track } from 'lwc';
import getBackgroundCheck from '@salesforce/apex/BackgroundCheckService.getBackgroundCheck';

export default class BackgroundCheckLWC extends LightningElement {
    @track employeeName = '';
    @track result;
    @track errorMessage;

    handleNameChange(event) {
        this.employeeName = event.target.value;
    }

    async handleCheck() {
        this.result = null;
        this.errorMessage = null;

        try {
            const res = await getBackgroundCheck({ employeeName: this.employeeName });
            if (res.status === 'error') {
                this.errorMessage = res.message;
            } else {
                this.result = res;
            }
        } catch (error) {
            this.errorMessage = error.body?.message || 'Unexpected error occurred';
        }
    }
}
