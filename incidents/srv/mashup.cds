using { acme.incmgt ,IncidentsService } from './incidents-service';
using { s4 } from './external';


extend service IncidentsService with {
    entity Customers as projection on s4.simple.Customers;
}

extend incmgt.Incidents with {
    customer : Association to s4.simple.Customers;
}