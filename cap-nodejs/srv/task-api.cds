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

  annotate TaskCollections {
    color     @assert.format: '^[a-fA-F0-9]{6}$';
    isDefault @Core.Computed;
  }

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
    dueTime,
    isPlannedForMyDay,
  } actions {
    action setToDone();
  };

  annotate Tasks {
    collectionTitle @Core.Computed;
    collection      @cds.api.ignore;
    status          @Core.Computed;
    priorityName    @Core.Computed
  }

  action setDefaultTaskCollection(collectionID : UUID);

}
