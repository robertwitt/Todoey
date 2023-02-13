const cds = require("@sap/cds");
const { cdsTest } = require("../utils");
const { DELETE, PATCH, POST, expect } = cdsTest();

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
      },
      {
        ID: "568da015-0627-420e-896c-e0e49abd4a6e",
        title: "Groceries shopping",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "D",
        priority_code: 3,
        isPlannedForMyDay: false,
      },
      {
        ID: "821bbc4e-8395-4ea0-a041-d837cd1cbec7",
        title: "Repair broken table",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "X",
        isPlannedForMyDay: true,
      },
    ]);
  });

  it("can be created with 'open' as initial status", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
    });
    expect(status).to.equal(201);
    expect(data.ID).not.to.equal(undefined);
    expect(data).to.containSubset({
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      collectionTitle: "Tasks",
      status: "O",
      isPlannedForMyDay: false,
    });
  });

  it("can be created, ignoring any other status than 'open'", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      status: "D",
    });
    expect(status).to.equal(201);
    expect(data.status).to.equal("O");
  });

  it("can be created with due date and due time", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      dueDate: "2023-02-13",
      dueTime: "11:30:00",
      isPlannedForMyDay: true,
    });
    expect(status).to.equal(201);
    expect(data).to.containSubset({
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      dueDate: "2023-02-13",
      dueTime: "11:30:00",
      isPlannedForMyDay: true,
    });
  });

  it("can be created with due date and no due time", async () => {
    const { status, data } = await POST("/api/task/Tasks", {
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      priorityCode: 3,
      dueDate: "2023-02-13",
    });
    expect(status).to.equal(201);
    expect(data).to.containSubset({
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
      priorityCode: 3,
      priorityName: "moderate",
      dueDate: "2023-02-13",
      dueTime: null,
    });
  });

  it("cannot be created with no due date but due time", async () => {
    const { status } = await POST("/api/task/Tasks", {
      title: "New task",
      collectionID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
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
      }
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
      { dueDate: "2023-02-13" }
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
      }
    );
    expect(status).to.equal(400);
  });

  it("cannot be updated with due time if due date was not set", async () => {
    const { status } = await PATCH(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9",
      { dueTime: "11:30:00" }
    );
    expect(status).to.equal(400);
  });

  it("can be updated with due time if due date was set", async () => {
    const { status, data } = await PATCH(
      "/api/task/Tasks/5d41d440-e6c0-4daf-a4d0-221162f32d72",
      { dueTime: "11:30:00" }
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
      { status: "D" }
    );
    expect(status).to.equal(200);
    expect(data.status).to.equal("O");
  });

  it("can be deleted if still open", async () => {
    const { status } = await DELETE(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9"
    );
    expect(status).to.equal(204);
  });

  it("cannot be deleted if status is done", async () => {
    const { status } = await DELETE(
      "/api/task/Tasks/568da015-0627-420e-896c-e0e49abd4a6e"
    );
    expect(status).to.equal(400);
  });

  it("can set status to 'done'", async () => {
    const { status } = await POST(
      "/api/task/Tasks/d8be86ee-e2fd-4ff3-b126-cbf21c9f18e9/setToDone",
      {}
    );
    expect(status).to.equal(204);
  });
});
