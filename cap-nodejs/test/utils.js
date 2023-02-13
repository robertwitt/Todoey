const path = require("path");
const cdsLib = require("@sap/cds/lib");
const cds = require("@sap/cds");

function cdsTest() {
  const test = cdsLib.test(path.join(__dirname, ".."));
  test.axios.defaults.validateStatus = (_status) => true;
  return test;
}

async function createDataForEntity(entityName, data) {
  const db = await cds.connect.to("db");
  const entity = db.model.entities("de.robertwitt.todoey")[entityName];
  await db.delete(entity);
  await db.create(entity).entries(data);
}

module.exports = { cdsTest, createDataForEntity };
