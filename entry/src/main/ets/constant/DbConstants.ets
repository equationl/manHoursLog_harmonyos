import { relationalStore } from '@kit.ArkData';

export const DB_MAN_HOURS_FILE_NAME = 'manHoursLog.db'
export const TABLE_MAN_HOURS = 'man_hours'

export class DB_CONFIG {
  name: string = DB_MAN_HOURS_FILE_NAME;
  securityLevel = relationalStore.SecurityLevel.S1;
  encrypt = false;
  tables = [TABLE_MAN_HOURS]
}