const cds = require("@sap/cds");
const { cdsTest } = require("../utils");
const { DELETE, GET, PATCH, POST, expect } = cdsTest({
  username: "TASK_MANAGER",
  password: "Welcome1!",
});

describe("Task collections", () => {
  beforeEach(async () => {
    const db = await cds.connect.to("db");
    const { Tasks, TaskCollections } = db.model.entities(
      "de.robertwitt.todoey"
    );
    await db.delete(Tasks);
    await db.delete(TaskCollections);
    await db.create(TaskCollections).entries([
      {
        ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        title: "Tasks",
        isDefault: true,
      },
      {
        ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        title: "Business",
        color: "00FFFF",
        isDefault: false,
      },
      {
        ID: "d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
        title: "Private",
        color: "FF0000",
        isDefault: false,
      },
    ]);
    await db.create(Tasks).entries([
      {
        ID: "bfc8771e-05af-4332-8f9e-258179377e79",
        title: "Prepare customer presentation",
        collection_ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        status: "O",
        priority_code: 1,
        dueDate: "2023-02-23",
        isPlannedForMyDay: false,
      },
    ]);
  });

  it("can be read with expanded tasks", async () => {
    const { status, data } = await GET(
      "/api/task/TaskCollections(9544e7d6-d136-4b04-848c-1d8ef83b5f81)?$expand=tasks"
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
      tasks: [
        {
          ID: "bfc8771e-05af-4332-8f9e-258179377e79",
          collection_ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        },
      ],
    });
  });

  it("can be created (non-default)", async () => {
    const { status, data } = await POST("/api/task/TaskCollections", {
      title: "New collection",
      color: "04B6A9",
    });
    expect(status).to.equal(201);
    expect(data.ID).not.to.equal(undefined);
    expect(data.isDefault).to.equal(false);

    const {
      data: { value: defaultCollections },
    } = await GET("/api/task/TaskCollections?$filter=isDefault eq true");
    expect(defaultCollections.length).to.equal(1);
    expect(defaultCollections[0].ID).to.equal(
      "f566a466-70d7-4fca-89e2-24a4f686f4a6"
    );
  });

  it("can be created with valid 6-digit color hex", async () => {
    const { status, data } = await POST("/api/task/TaskCollections", {
      title: "New collection",
      color: "0f1afe",
    });
    expect(status).to.equal(201);
    expect(data.color).to.equal("0F1AFE");
  });

  it("can be created with valid 8-digit color hex", async () => {
    const { status, data } = await POST("/api/task/TaskCollections", {
      title: "New collection",
      color: "0f1afe32",
    });
    expect(status).to.equal(201);
    expect(data.color).to.equal("0F1AFE32");
  });

  it("cannot be created with invalid color hex", async () => {
    const { status } = await POST("/api/task/TaskCollections", {
      title: "New collection",
      color: "4jka",
    });
    expect(status).to.equal(400);
  });

  it("can be created, even if trying to create a new default collection", async () => {
    const { status, data } = await POST("/api/task/TaskCollections", {
      title: "New collection",
      isDefault: true,
    });
    expect(status).to.equal(201);
    expect(data.ID).not.to.equal(undefined);
    expect(data.isDefault).to.equal(false);

    const {
      data: { value: defaultCollections },
    } = await GET("/api/task/TaskCollections?$filter=isDefault eq true");
    expect(defaultCollections.length).to.equal(1);
    expect(defaultCollections[0].ID).to.equal(
      "f566a466-70d7-4fca-89e2-24a4f686f4a6"
    );
  });

  it("can be updated, even if trying to create a new default collection", async () => {
    const { status, data } = await PATCH(
      "/api/task/TaskCollections/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      {
        isDefault: true,
      }
    );
    expect(status).to.equal(200);
    expect(data.isDefault).to.equal(false);

    const {
      data: { value: defaultCollections },
    } = await GET("/api/task/TaskCollections?$filter=isDefault eq true");
    expect(defaultCollections.length).to.equal(1);
    expect(defaultCollections[0].ID).to.equal(
      "f566a466-70d7-4fca-89e2-24a4f686f4a6"
    );
  });

  it("cannot be deleted while being the default collection", async () => {
    const { status } = await DELETE(
      "/api/task/TaskCollections/f566a466-70d7-4fca-89e2-24a4f686f4a6"
    );
    expect(status).to.equal(400);
  });

  it("cannot be deleted while still having tasks assigned", async () => {
    const { status } = await DELETE(
      "/api/task/TaskCollections/9544e7d6-d136-4b04-848c-1d8ef83b5f81"
    );
    expect(status).to.equal(400);
  });

  it("can be deleted (non-default, no tasks)", async () => {
    const { status } = await DELETE(
      "/api/task/TaskCollections/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9"
    );
    expect(status).to.equal(204);
  });

  it("can be read when they are the default", async () => {
    const { status, data } = await GET("/api/task/getDefaultTaskCollection()");
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      title: "Tasks",
      color: null,
      isDefault: true,
    });
  });

  it("can be set as default", async () => {
    const { status } = await POST("/api/task/setDefaultTaskCollection", {
      collectionID: "d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
    });
    expect(status).to.equal(204);

    const {
      data: { value: defaultCollections },
    } = await GET("/api/task/TaskCollections?$filter=isDefault eq true");
    expect(defaultCollections.length).to.equal(1);
    expect(defaultCollections[0].ID).to.equal(
      "d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9"
    );
  });
});
