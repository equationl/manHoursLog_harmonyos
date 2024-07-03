import relationalStore from '@ohos.data.relationalStore';
import { DB_CONFIG, DB_MAN_HOURS_FILE_NAME } from '../../constant/DbConstants';
import { DBHelper } from '../../utill/DBHelper';
import { ManHoursDBModel } from '../model/ManHoursDBModel';

export class CommonDBViewModel {
  private isInited = false
  private store: relationalStore.RdbStore | null = null;
  private manHoursDBModel: ManHoursDBModel | null = null;

  async insertData(startTime: number, endTime: number, totalTime: number) {
    if (this.isReady()) {
      await this.manHoursDBModel?.insertData(startTime, endTime, totalTime)
    }
    else {
      console.log(`el, insert data fail, db not ready`)
    }
  }

  async markDeleteRowById(id: number) {
    if (this.isReady()) {
      await this.manHoursDBModel?.markDeleteRowById(id)
    }
    else {
      console.log(`el, mark data delete fail, db not ready`)
    }
  }

  async sumRangeTotalTime(startTime: number, endTime: number): Promise<number | null> {
    if (this.isReady()) {
      return this.manHoursDBModel?.sumRangeTotalTime(startTime, endTime) ?? null
    }
    else {
      console.log("el, sumRangeTotalTime fail: not ready!")
      return new Promise((_resolve, reject) => {
        reject("DB is not ready!")
      })
    }
  }

  async countRangeData(startTime: number, endTime: number): Promise<number | null> {
    if (this.isReady()) {
      return this.manHoursDBModel?.countRangeData(startTime, endTime) ?? null
    }
    else {
      return new Promise((_resolve, reject) => {
        reject("DB is not ready!")
      })
    }
  }

  async queryRangeDataList(startTime: number, endTime: number): Promise<[number, number, number] | null> {
    if (this.isReady()) {
      return this.manHoursDBModel?.queryRangeDataList(startTime, endTime) ?? null
    }
    else {
      return new Promise((_resolve, reject) => {
        reject("DB is not ready!")
      })
    }
  }


  //创建表
  async init(context: Context,) {
    this.store = DBHelper.getRdbStore(DB_MAN_HOURS_FILE_NAME)
    if (this.store === null) {
      let initPromise = DBHelper.getWithCreateDb(context, new DB_CONFIG())

      try {
        this.store = await initPromise
        //创建表
        await this.store.executeSql(ManHoursDBModel.SQL_CREAT_TABLE)

        this.manHoursDBModel = new ManHoursDBModel(this.store)
        this.isInited = true
      } catch (err) {
      }
    }
  }

  isReady(): boolean {
    return this.isInited
  }
}

const commonDBViewModel = new CommonDBViewModel()

export default commonDBViewModel
