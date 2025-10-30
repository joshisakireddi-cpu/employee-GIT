# Employee Onboarding App (Salesforce Full-Stack Project)

### Project Goal
The goal of this project is to apply **full-stack Salesforce development knowledge** by designing and implementing an **Employee Onboarding Management Application** that automates new employee onboarding, integrates with external systems, and provides real-time visibility via a **Lightning Web Component (LWC) dashboard**.

## Features

### 1. Data Modelling
- Created two custom objects:
  - Employee__c → Stores employee information.
  - Onboarding_Task__c → Tracks onboarding tasks assigned to each employee.
- Defined a Master-Detail relationship between Employee and Onboarding Task.

### 2. Automation (Flow)
- Used *Record-Triggered Flow* on Employee creation.
- Automatically assigns default onboarding tasks (e.g., IT Setup, HR Orientation).
- Each new Employee record automatically generates related task records.

### 3. Apex Development
- Developed an *Apex Service Class* (`EmployeeDashboardController.cls`) to fetch data for the LWC.
- Created *BackgroundCheckService.cls* to integrate with an external background check API.
- Implemented *EmployeeBackgroundTrigger* and *EmployeeAutoTaskAssignment* for automation and data consistency.

### 4. Lightning Web Component (LWC)
Component: `employeeOnboardingDashboard`

- Displays all Employees and their onboarding progress.
- Shows *Completed tasks (green)* and *Pending tasks (yellow)*.
- Displays *Background Check Status* and *Result*.
- Modern card-based UI with hover animations and clean SLDS styling.

### 5. Integration
- Connected to an *external Background Check API* (mock integration via Apex HTTP callout).
- Retrieves and updates background verification results for employees.
- Demonstrates Named Credential and Apex callout usage.

## Technologies Used

| Layer | Tool / Technology |
|-------|-------------------|
| **Frontend** | Lightning Web Components (LWC), SLDS |
| **Backend** | Apex Classes, Triggers, SOQL |
| **Automation** | Salesforce Flow |
| **Integration** | Apex HTTP Callouts, Named Credentials |
| **Database** | Salesforce Custom Objects |
| **Version Control** | Git + GitHub |

## Project Architecture
Employee__c
├── Fields: Name, Email__c, Department__c, Background_Check_Status__c, Background_Check_Result__c
└── Onboarding_Tasks__r (related list)
├── Fields: Name, Status__c, Employee__c
└── Auto-created via Flow

**Apex Layers**
- `EmployeeDashboardController.cls` → LWC data service
- `BackgroundCheckService.cls` → API Integration
- `EmployeeAutoTaskAssignment.cls` → Default task logic
- `EmployeeBackgroundTrigger.trigger` → Calls background check service on create
- OnboardingService.cls-This class handles the bulk creation of onboarding tasks

**LWC Component**
- `employeeOnboardingDashboard.html`
- `employeeOnboardingDashboard.js`
- `employeeOnboardingDashboard.css
- backgroundCheck.css
- backgroundCheck.html
- backgroundCheck.js


### 6. Usage
How to use the app.  
## Usage
1. Add a new Employee record.
2. Flow automatically assigns onboarding tasks.
3. Monitor progress on the LWC dashboard.
4. Background check results are fetched via API.

## Author
- Name: SAKIREDDI JOSHIBABU
- GitHub: [https://github.com/joshisakireddi-cpu](https:/joshisakireddi-cpu/github.com/)
