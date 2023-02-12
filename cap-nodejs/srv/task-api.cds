using {de.robertwitt.todoey as db} from '../db/schema';

@path: '/api/task'
service TaskAPI {

  entity TaskPriorities  as projection on db.TaskPriorities;

  annotate TaskPriorities with @(
    Capabilities.Insertable: false,
    Capabilities.Updatable : false,
    Capabilities.Deletable : false
  );

  entity TaskCollections as projection on db.TaskCollections;

  entity Tasks           as projection on db.Tasks {
    ID,
    title,
    collection.ID    as collectionID,
    collection.title as collectionTitle,
    collection,
    status,
    priority.code    as priorityCode,
    priority.name    as priorityName,
    dueDate,
    isPlannedForMyDay,
  };

  annotate Tasks {
    collection @cds.api.ignore;
  }

  action setDefaultTaskCollection(collectionID : UUID);

}
