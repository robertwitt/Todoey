const cds = require("@sap/cds");

async function createDataForEntity(entityName, data) {
  const db = await cds.connect.to("db");
  const entity = db.model.entities("de.robertwitt.todoey")[entityName];
  await db.delete(entity);
  db.create(entity).entries(data);
}

module.exports = { createDataForEntity };
