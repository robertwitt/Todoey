const cds = require("@sap/cds");
const { cdsTest } = require("../utils");
const { DELETE, GET, PATCH, POST, expect } = cdsTest({
  username: "TASK_MANAGER",
  password: "Welcome1!",
});

describe("Tasks", () => {
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
    ]);
    await db.create(Tasks).entries([
      {
        ID: "d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
        title: "Do laundry",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "O",
        priority_code: 5,
        isPlannedForMyDay: true,
        modifiedAt: "2023-01-31T00:00:00.000Z",
        subTasks: [{ title: "Dark" }, { title: "Whites" }],
      },
      {
        ID: "5d41d440-e6c0-4daf-a4d0-221162f32d72",
        title: "Wash the car",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "O",
        priority_code: 5,
        dueDate: "2023-01-10",
        dueTime: "10:00:00",
        isPlannedForMyDay: false,
        modifiedAt: "2023-01-31T00:00:00.000Z",
      },
      {
        ID: "568da015-0627-420e-896c-e0e49abd4a6e",
        title: "Groceries shopping",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "D",
        priority_code: 3,
        isPlannedForMyDay: false,
        modifiedAt: "2023-01-31T00:00:00.000Z",
      },
      {
        ID: "821bbc4e-8395-4ea0-a041-d837cd1cbec7",
        title: "Prepare customer presentation",
        collection_ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        status: "O",
        isPlannedForMyDay: true,
        modifiedAt: "2023-01-31T00:00:00.000Z",
      },
    ]);
  });

  it("can be queried by collection and status", async () => {
    const { status, data } = await GET(
      "/api/task/Tasks?$filter=collection_ID eq f566a466-70d7-4fca-89e2-24a4f686f4a6 and status eq 'O'"
    );
    expect(status).to.equal(200);
    expect(data.value).to.containSubset([
      {
        ID: "d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
        subTasks: [
          { title: "Dark", isDone: false },
          { title: "Whites", isDone: false },
        ],
      },
      {
        ID: "5d41d440-e6c0-4daf-a4d0-221162f32d72",
        subTasks: [],
      },
    ]);
  });

  it("can be created with sub-tasks in default collection", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      status: "O",
      isPlannedForMyDay: false,
      subTasks: [{ title: "New sub-task" }],
    });
    expect(status).to.equal(201);
    expect(data.ID).not.to.equal(undefined);
    expect(data).to.containSubset({
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      status: "O",
      isPlannedForMyDay: false,
      subTasks: [{ title: "New sub-task", isDone: false }],
    });
  });

  it("can be created with 'open' as initial status", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
    });
    expect(status).to.equal(201);
    expect(data.ID).not.to.equal(undefined);
    expect(data).to.containSubset({
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      status: "O",
      isPlannedForMyDay: false,
    });
  });

  it("can be created, ignoring any other status than 'open'", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      status: "D",
    });
    expect(status).to.equal(201);
    expect(data.status).to.equal("O");
  });

  it("cannot be created with invalid priority", async () => {
    const { status } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      priority_code: 4,
    });
    expect(status).to.equal(400);
  });

  it("can be created with due date and due time", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      dueDate: "2023-02-13",
      dueTime: "11:30:00",
      isPlannedForMyDay: true,
    });
    expect(status).to.equal(201);
    expect(data).to.containSubset({
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      dueDate: "2023-02-13",
      dueTime: "11:30:00",
      isPlannedForMyDay: true,
    });
  });

  it("can be created with due date and no due time", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      priority_code: 3,
      dueDate: "2023-02-13",
    });
    expect(status).to.equal(201);
    expect(data).to.containSubset({
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      priority_code: 3,
      dueDate: "2023-02-13",
      dueTime: null,
    });
  });

  it("cannot be created with no due date but due time", async () => {
    const { status } = await POST("/api/task/Tasks", {
      title: "New task",
      collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      dueDate: null,
      dueTime: "11:30:00",
    });
    expect(status).to.equal(400);
  });

  it("can be updated with due date and due time", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      {
        dueDate: "2023-02-13",
        dueTime: "11:30:00",
      },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      dueDate: "2023-02-13",
      dueTime: "11:30:00",
    });
  });

  it("can be updated with due date and no due time", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      { dueDate: "2023-02-13" },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      dueDate: "2023-02-13",
      dueTime: null,
    });
  });

  it("cannot be updated with no due date but due time", async () => {
    const { status } = await PATCH(
      "/api/task/Tasks/5d41d440-e6c0-4daf-a4d0-221162f32d72",
      {
        dueDate: null,
        dueTime: "11:30:00",
      },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(400);
  });

  it("cannot be updated with due time if due date was not set", async () => {
    const { status } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      { dueTime: "11:30:00" },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(400);
  });

  it("can be updated with due time if due date was set", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/5d41d440-e6c0-4daf-a4d0-221162f32d72",
      { dueTime: "11:30:00" },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      dueDate: "2023-01-10",
      dueTime: "11:30:00",
    });
  });

  it("cannot be updated with new status", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      { status: "D" },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data.status).to.equal("O");
  });

  it("can be updated with reordered list of sub-tasks", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      {
        subTasks: [
          { title: "Whites", isDone: false },
          { title: "Dark", isDone: false },
        ],
      },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      subTasks: [
        { title: "Whites", isDone: false },
        { title: "Dark", isDone: false },
      ],
    });
  });

  it("can be updated with removed sub-task", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      {
        subTasks: [{ title: "Whites", isDone: false }],
      },
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      subTasks: [{ title: "Whites", isDone: false }],
    });
  });

  it("can be deleted if still open", async () => {
    const { status } = await DELETE(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(204);
  });

  it("cannot be deleted if status is done", async () => {
    const { status } = await DELETE(
      "/api/task/Tasks/568da015-0627-420e-896c-e0e49abd4a6e",
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(400);
  });

  it("can set status to 'done'", async () => {
    const { status } = await POST(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9/setToDone",
      {},
      { headers: { "If-Match": 'W/"2023-01-31T00:00:00.000Z"' } }
    );
    expect(status).to.equal(204);

    const { data } = await GET(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9"
    );
    expect(data.status).to.equal("D");
  });
});
