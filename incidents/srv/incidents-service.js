module.exports = (async function() {
    const cds = require('@sap/cds');
    const S4bupa = await cds.connect.to('API_BUSINESS_PARTNER')

    this.on('READ', 'Customers', (req) => {
        console.log('>> delegating to S4 service...');
        return S4bupa.run(req.query);
    })
})

