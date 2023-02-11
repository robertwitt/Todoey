namespace de.robertwitt.todoey;

using {
  sap.common.CodeList,
  cuid,
  managed
} from '@sap/cds/common';

entity TaskPriorities : CodeList {
  key code : UInt8;
}

type TaskStatus : String(1) enum {
  OPEN     = 'O';
  DONE     = 'D';
  CANCELED = 'X';
}

entity Tasks : cuid, managed {
  title             : String(40);
  collection        : Association to one TaskCollections not null;
  status            : TaskStatus not null default 'O';
  priority          : Association to one TaskPriorities;
  dueDate           : Date;
  isPlannedForMyDay : Boolean not null default false;
}

entity TaskCollections : cuid {
  title               : String(40);
  color               : String(6);
  isDefaultCollection : Boolean not null default false;
  tasks               : Association to many Tasks
                          on tasks.collection = $self;
}
