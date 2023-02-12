const { cdsTest } = require("../utils");
const { GET, expect } = cdsTest();

describe("Task priorities", () => {
  it("can be queried", async () => {
    const { status, data } = await GET("/api/task/TaskPriorities");
    expect(status).to.equal(200);
    expect(data.value).to.containSubset([
      { code: 1 },
      { code: 3 },
      { code: 5 },
    ]);
  });
});
