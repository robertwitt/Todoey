namespace de.robertwitt.todoey;

using {
  sap.common.CodeList,
  cuid,
  managed
} from '@sap/cds/common';

entity TaskPriorities : CodeList {
  key code : UInt8;
}

entity TaskStatuses : CodeList {
  key code : String(1);
}

entity Tasks : cuid, managed {
  title             : String(40);
  collection        : Association to one TaskCollections not null;
  status            : Association to one TaskStatuses not null;
  priority          : Association to one TaskPriorities;
  dueDate           : Date;
  isPlannedForMyDay : Boolean
}

entity TaskCollections : cuid {
  title               : String(40);
  color               : String(6);
  isDefaultCollection : Boolean;
  tasks               : Association to many Tasks
                          on tasks.collection = $self;
}
