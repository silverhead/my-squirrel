# Application structure

```mermaid
---
title: Entity relation diagram
---
erDiagram
    USER ||--o{ BANK_ACCOUNT : have
    USER {
        int id PK, UK
        string firstName
        string lastName
        string email
        string password
    }
    BANK_ACCOUNT {
        int id PK, UK
        User user FK
        string name
        string logo
        float initialSold
        float lastSold
    }
    BANK_ACCOUNT ||--o{ OPERATION : contains
    OPERATION {
        int id PK, UK
        BankAccount bankAccount FK
        Category category FK
        enum operationTypeEnum FK
        string label
        string description
        string operationNumber
        date valueDate
        date operationDate
        date comptabilityDate
        float debit
        float credit
    }
    CATEGORY ||--o{ OPERATION : "depends of"
    BANK_ACCOUNT ||--o{ CATEGORY : have
    CATEGORY {
        int id PK, UK
        BankAccount bankAccount FK
        string label
    }
    
    OPERATION_TYPE_ENUM ||--o{ OPERATION : is
    OPERATION_TYPE_ENUM {
        string label
        string code PK
    }

    PERIODICITY_DELAY_ENUM{
        string label 
        int value PK
    }

    PERIODICITY_DELAY_ENUM ||--o{ PERIODICITY: ""
    PERIODICITY {
        string label
        enum perodicityDelayEnum FK
    }

    DURATION_TYPE_ENUM{
        string label
        int value
    }

    DURATION_TYPE_ENUM ||--o{ PERIODICAL_OPERATION: ""
    PERIODICITY ||--o{ PERIODICAL_OPERATION: ""
    PERIODICAL_OPERATION{
        int id PK, UK
        Periodicity periodicity FK
        string label
        int duration
        float amount
    }

    USER ||--o{ PROJECT : "have"
    PROJECT {
        int id PK, UK
        User user FK
        string label
        string description
        float amount
        date endDate
    }
```
```mermaid
---
title: Page diagrams
---
flowchart TD
    Login --> Accounts(Accounts list)
    Login --> Subscription
    Login --> ForgottenPassword(Forgotten password)
    Accounts --> AddAccount(Add account)
    Accounts --> AccountOperation(Account operations list)
    Accounts --> AccountDashboard(Account dashboard)
    Accounts --> CategoriesList(Categories list)
    AccountDashboard --> AccountOperation
    CategoriesList --> CategoryEdit(Category edition)
    AccountOperation --> PeriodicityOperationModal(Periodicity operation modal)
    AllPages(All pages) --> AddProject(Add project)
    AllPages(All pages) --> UserParams(User params)
    AllPages(All pages) --> Accounts
```

Code architecture

```ultree
      RootFolder
          src
              Shared
              Security
                  Presentation
                  Business
                  Infrastructure
              BankAccount
                  BankAccount
                      Presentation
                      Business
                      Infrastructure
                  Operation
                      Presentation
                      Business
                      Infrastructure
              Category
                  Presentation
                  Business
                  Infrastructure
              Periodicity
                  Presentation
                  Business
                  Infrastructure
              Project
                  Presentation
                  Business
                  Infrastructure
```