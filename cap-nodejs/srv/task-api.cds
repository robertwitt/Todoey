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

  entity Tasks           as projection on db.Tasks excluding {
    createdBy,
    createdAt,
    modifiedBy,
    modifiedAt,
  } actions {
    action setToDone();
  };

  annotate Tasks {
    status @Core.Computed;
  }

  action setDefaultTaskCollection(collectionID : UUID);

}
