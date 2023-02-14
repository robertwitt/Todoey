# SAP Cloud Programming Model (Node.js)

This project implements the Todoey app with the [SAP Cloud Programming Model](https://cap.cloud.sap).

## Local Setup

Prerequisites:

- Node v16 or v18
- NPM
- CDS Development Kit (`@sap/cds-dk`)
- Cloud Foundry CLI
- MultiApps plugin for Cloud Foundry CLI
- Cloud BTA Build Tool (MBT)

Install dependencies:

```bash
npm ci
```

Run tests locally:

```bash
npm test
```

Start the app:

```bash
cds watch
```

## Deployment

The app can be deployed to the Cloud Foundry runtime on SAP Business Technology Platform. An instance of SAP HANA Cloud has to be created and activated.

Login to Cloud Foundry:

```bash
cf login
```

Build the MTA module:

```bash
mbt build -t ./
```

Deploy the module to Cloud Foundry space:

```bash
cf deploy Todoey_1.0.0.mtar
```
