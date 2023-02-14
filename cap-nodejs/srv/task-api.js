const cds = require("@sap/cds");

module.exports = (srv) => {
  const { TaskCollections, Tasks } = srv.entities;

  srv.before(["CREATE", "UPDATE"], TaskCollections, (req) => {
    if (!!req.data.color) {
      req.data.color = req.data.color.toUpperCase();
    }
  });

  srv.before("DELETE", TaskCollections, async (req) => {
    const query = SELECT.one.from(req.query.DELETE.from).columns("isDefault");
    const collection = await srv.run(query);
    if (collection.isDefault) {
      req.reject(400, "The default collection cannot be deleted");
    }
  });

  srv.before("CREATE", Tasks, async (req) => {
    if (!req.data.dueDate && !!req.data.dueTime) {
      req.reject(
        400,
        "Creation with due time but without due date is not allowed"
      );
    }

    if (!req.data.collection_ID) {
      const query = SELECT.one
        .from(TaskCollections)
        .columns("ID")
        .where({ isDefault: true });
      const defaultCollection = await srv.run(query);
      req.data.collection_ID = defaultCollection.ID;
    }
  });

  srv.before("UPDATE", Tasks, async (req) => {
    if (!req.data.dueTime) {
      return;
    }
    let dueDate = req.data.dueDate;
    if (dueDate === undefined) {
      const query = SELECT.one.from(req.query.UPDATE.entity).columns("dueDate");
      const task = await srv.run(query);
      dueDate = task.dueDate;
    }
    if (!dueDate) {
      req.reject(
        400,
        "Updating with due time but without due date is not allowed"
      );
    }
  });

  srv.before("DELETE", Tasks, async (req) => {
    const query = SELECT.one.from(req.query.DELETE.from).columns("status");
    const task = await srv.run(query);
    if (task.status !== "O") {
      req.reject(400, "Only open tasks can be deleted");
    }
  });

  srv.on("setToDone", Tasks, async (req) => {
    const task = await req.query.columns("ID");
    const db = await cds.connect.to("db");
    const { Tasks } = db.entities("de.robertwitt.todoey");
    await db.update(Tasks).set({ status: "O" }).where({ ID: task.ID });
  });

  srv.on("getDefaultTaskCollection", (_req) =>
    SELECT.one.from(TaskCollections).where({ isDefault: true })
  );

  srv.on("setDefaultTaskCollection", async (req) => {
    const db = await cds.connect.to("db");
    const { TaskCollections } = db.entities("de.robertwitt.todoey");
    await db
      .update(TaskCollections)
      .set({ isDefault: false })
      .where("ID !=", req.data.collectionID);
    return db
      .update(TaskCollections)
      .set({ isDefault: true })
      .where({ ID: req.data.collectionID });
  });
};
