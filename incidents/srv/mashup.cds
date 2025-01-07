using { acme.incmgt ,IncidentsService } from './incidents-service';
using { s4 } from './external';


extend service IncidentsService with {
    entity Customers as projection on s4.simple.Customers;
}

extend incmgt.Incidents with {
    customer : Association to s4.simple.Customers;
}

// Turns Customers View into a table 
annotate s4.simple.Customers with @cds.persistence: { table,skip:false };

// import annotations from rest of the application
using from '../app/fiori';

annotate IncidentsService.Incidents with @(
  UI: {
    // insert table column
    LineItem : [
      ...up to { Value: title },
      { Value: customer.name, Label: 'Customer' },
      ...
    ],

    // insert customer to field group
    FieldGroup #GeneralInformation : {
      Data: [
        { Value: customer_ID, Label: 'Customer'},
        ...
      ]
    },
  }
);

// for an incident's customer, show both name and ID
annotate IncidentsService.Incidents:customer with @Common: {
  Text: customer.name,
  TextArrangement: #TextFirst
};