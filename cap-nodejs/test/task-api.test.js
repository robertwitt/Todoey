const path = require("path");
const cds = require("@sap/cds/lib");
const { GET, data, expect } = cds.test(path.join(__dirname, ".."));
const { createDataForEntity } = require("./utils");

describe("Basic querying", () => {
  beforeAll(async () => {
    await createDataForEntity("TaskCollections", [
      {
        ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        title: "Tasks",
        isDefaultCollection: true,
      },
      {
        ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        title: "Business",
        color: "00FFFF",
        isDefaultCollection: false,
      },
    ]);
    await createDataForEntity("Tasks", [
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
        status: "D",
        priority_code: 5,
        dueDate: "2023-01-10",
        isPlannedForMyDay: false,
      },
      {
        ID: "bfc8771e-05af-4332-8f9e-258179377e79",
        title: "Prepare customer presentation",
        collection_ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        status: "O",
        priority_code: 1,
        dueDate: "2023-02-23",
        isPlannedForMyDay: false,
      },
      {
        ID: "568da015-0627-420e-896c-e0e49abd4a6e",
        title: "Groceries shopping",
        collection_ID: "f566a466-70d7-4fca-89e2-24a4f686f4a6",
        status: "O",
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
      {
        ID: "6d2536f8-5104-4b5d-be5e-4d241ccf4419",
        title: "Develop feature 42",
        collection_ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
        status: "O",
        priority_code: 1,
        dueDate: "2023-01-31",
        isPlannedForMyDay: false,
      },
    ]);
  });

  it("should return task priorities", async () => {
    const { status, data } = await GET("/api/task/TaskPriorities");
    expect(status).to.equal(200);
    expect(data.value).to.containSubset([
      { code: 1 },
      { code: 3 },
      { code: 5 },
    ]);
  });

  it("should return tasks of a task collection when expanding", async () => {
    const { status, data } = await GET(
      "/api/task/TaskCollections(9544e7d6-d136-4b04-848c-1d8ef83b5f81)?$expand=tasks"
    );
    expect(status).to.equal(200);
    expect(data).to.containSubset({
      ID: "9544e7d6-d136-4b04-848c-1d8ef83b5f81",
      tasks: [
        { ID: "bfc8771e-05af-4332-8f9e-258179377e79" },
        { ID: "6d2536f8-5104-4b5d-be5e-4d241ccf4419" },
      ],
    });
  });
});
