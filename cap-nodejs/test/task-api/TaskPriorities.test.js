const { cdsTest } = require("../utils");
const { DELETE, GET, POST, PATCH, expect } = cdsTest({
  username: "TASK_MANAGER",
  password: "Welcome1!",
});

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

  it("cannot be created", async () => {
    const { status } = await POST("/api/task/TaskPriorities", { code: 9 });
    expect(status).to.equal(405);
  });

  it("cannot be updated", async () => {
    const { status } = await PATCH("/api/task/TaskPriorities/1", {
      name: "critical",
    });
    expect(status).to.equal(405);
  });

  it("cannot be deleted", async () => {
    const { status } = await DELETE("/api/task/TaskPriorities/1");
    expect(status).to.equal(405);
  });
});
