using {de.robertwitt.todoey as db} from '../db/schema';

@path: '/api/task'
service TaskAPI {

  entity TaskPriorities  as projection on db.TaskPriorities;
  entity TaskStatuses    as projection on db.TaskStatuses;

  @cds.redirection.target
  entity Tasks           as projection on db.Tasks excluding {
    createdAt,
    createdBy,
    modifiedAt,
    modifiedBy
  };

  entity TaskCollections as projection on db.TaskCollections;

  entity TodaysTasks     as
    select from db.Tasks
    excluding {
      createdAt,
      createdBy,
      modifiedAt,
      modifiedBy
    }
    where
         dueDate           <= $now
      or isPlannedForMyDay =  true

}
