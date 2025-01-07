module.exports = (async function() {
    const cds = require('@sap/cds');
    const db = await cds.connect.to('db');
    const S4bupa = await cds.connect.to('API_BUSINESS_PARTNER');

    const { Customers } = db.entities('s4.simple'); // CDS definition of the Customer entity

    // Delegating Request to remote service
    this.on('READ', 'Customers', (req) => {
        console.log('>> delegating to S4 service...');
        return S4bupa.run(req.query);
    });

    // Replicate Data On Demand
    this.after(['CREATE', 'UPDATE'], 'Incidents', async (data) => {
        const { customer_ID: ID } = data;
        if (ID) {
            let replicated = await db.exists(Customers, ID);
            if(!replicated){
                console.log('>> Updating Customer', ID)
                let customer = await S4bupa.read(Customers, ID);
                await INSERT(customer).into(Customers);
            }
        }
    });


})

