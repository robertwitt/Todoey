const cds = require("@sap/cds");

module.exports = (srv) => {
  const { TaskCollections } = srv.entities;

  srv.before("DELETE", TaskCollections, async (req) => {
    const query = SELECT.one.from(req.query.DELETE.from).columns("isDefault");
    const collection = await srv.run(query);
    if (collection.isDefault) {
      req.reject(400, "The default collection cannot be deleted");
    }
  });

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
