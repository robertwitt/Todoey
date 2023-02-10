const path = require("path");
const cds = require("@sap/cds/lib");
const { expect } = cds.test(path.join(__dirname, ".."));

it("dummy test", () => {
  expect(true).to.true;
});
