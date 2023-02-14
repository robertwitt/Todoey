const { cdsTest } = require("../utils");
const { GET, axios, expect } = cdsTest();

describe("Authorization", () => {
  afterEach(() => {
    axios.defaults.auth = undefined;
  });

  it("works with correct authorized user", async () => {
    axios.defaults.auth = { username: "TASK_MANAGER", password: "Welcome1!" };
    const { status } = await GET("/api/task/Tasks");
    expect(status).to.equal(200);
  });

  it("does not work with authorized user but incorrect password", async () => {
    axios.defaults.auth = { username: "TASK_MANAGER", password: "invalid" };
    const { status } = await GET("/api/task/Tasks");
    expect(status).to.equal(401);
  });

  it("does not work with unauthorized user", async () => {
    axios.defaults.auth = { username: "DUMMY", password: "Welcome1!" };
    const { status } = await GET("/api/task/Tasks");
    expect(status).to.equal(403);
  });

  it("does not work with no user whatsoever", async () => {
    const { status } = await GET("/api/task/Tasks");
    expect(status).to.equal(401);
  });
});
