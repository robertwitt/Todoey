using {de.robertwitt.todoey as db} from '../db/schema';

@path    : '/api/task'
@requires: 'TaskManager'
service TaskAPI {

  entity TaskPriorities  as projection on db.TaskPriorities excluding {
    descr
  }

  annotate TaskPriorities with @(
    Capabilities    : {
      InsertRestrictions.Insertable: false,
      UpdateRestrictions.Updatable : false,
      DeleteRestrictions.Deletable : false,
    },
    Core.Description: 'Priority of a task indicate its importance and criticality'
  ) {
    code @Core.Description: 'Identifier of a task priority';
    name @Core.Description: 'Language-dependent description of a task priority';
  }

  entity TaskCollections as projection on db.TaskCollections;

  annotate TaskCollections with @Core.Description: 'A task collection is listing and grouping multiple tasks together' {
    ID        @Core.Description                  : 'Identifier of a task collection';
    title     @Core.Description                  : 'Name or title of a task collection';
    color     @(
      Common.IsUpperCase: true,
      Core.Description  : 'Color of a task collection, represented as 6-digit hexadecimal number',
      assert.format     : '^([a-fA-F0-9]{6}|[a-fA-F0-9]{8})$',
    );
    isDefault @Core                              : {
      Computed            : true,
      ComputedDefaultValue: true,
      Description         : 'Flag whether or not a task collection is the default task collection. New tasks are put into the default if no collection is specified. There can only be one default collection.',
    };
    tasks     @Core.Description                  : 'List of tasks assigned to a task collection'
  }

  entity Tasks           as projection on db.Tasks {
    *,
    modifiedAt as lastModifiedAt
  } excluding {
    createdBy,
    createdAt,
    modifiedBy,
    modifiedAt,
  } actions {
    action setToDone();
  }

  annotate Tasks with @Core.Description: 'A task is an item to note a specific activity or reminder and assign it a due date' {
    ID                @Core.Description: 'Identifier of a task';
    title             @Core.Description: 'Title or subject of a task';
    collection        @Core.Description: 'Task collection a task is assigned to'  @assert.target: true;
    status            @Core            : {
      Computed            : true,
      ComputedDefaultValue: true,
      Description         : 'Status of a task. Allowed values are O (open), D (done), and X (canceled)',
    };
    priority          @Core.Description: 'Priority of a task'                     @assert.target: true;
    dueDate           @Core.Description: 'Date when a task is due to be completed';
    dueTime           @Core.Description: 'Time on the due date when a task is due to be completed. Due date cannot be null if time should be set.';
    isPlannedForMyDay @Core            : {
      ComputedDefaultValue: true,
      Description         : 'Flag whether or not a task is planned for the day'
    };
    lastModifiedAt    @odata.etag;
    subTasks          @Core.Description: 'Sub-tasks of a task';
  }

  annotate SubTask {
    title  @Core.Description: 'Title or subject of a sub-task';
    isDone @Core            : {
      ComputedDefaultValue: true,
      Description         : 'Flag whether or not a sub-task is done'
    }
  }

  function getDefaultTaskCollection() returns TaskCollections;
  annotate getDefaultTaskCollection with @Core.Description: 'Get the task collection that is marked as default';
  action   setDefaultTaskCollection(collectionID : UUID);

  annotate setDefaultTaskCollection with @Core.Description: 'Set a task collection as new default'
  (collectionID                          @Core.Description: 'Identifier of task collection, to be set as new default' )

}
