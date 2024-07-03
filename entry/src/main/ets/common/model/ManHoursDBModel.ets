import relationalStore from '@ohos.data.relationalStore'
import { TABLE_MAN_HOURS } from '../../constant/DbConstants'

export class ManHoursDBModel {
  static readonly SQL_CREAT_TABLE: string =
    `CREATE TABLE IF NOT EXISTS \`${TABLE_MAN_HOURS}\` (\`id\` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \`start_Time\` INTEGER NOT NULL, \`end_Time\` INTEGER NOT NULL, \`total_Time\` INTEGER NOT NULL, \`delete_flag\` INTEGER NOT NULL DEFAULT 0)`

  private store: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this.store = store
  }


  async insertData(startTime: number, endTime: number, totalTime: number) {
    const valueBucket: relationalStore.ValuesBucket = {
      'start_Time': startTime,
      'end_Time': endTime,
      'total_Time': totalTime
    };

    try {
      let result = this.store.insertSync(TABLE_MAN_HOURS, valueBucket)
      console.info(`el, Succeeded in inserting data. rowId:${result}`);
    } catch (err) {
      console.error(`el, Failed to insert data. Code:${err.code}, message:${err.message}`);
    }
  }

  async markDeleteRowById(id: number) {
    // 修改数据
    const valueBucket: relationalStore.ValuesBucket = {
      'delete_flag': 1,
    };

    let predicates1 = new relationalStore.RdbPredicates(TABLE_MAN_HOURS);
    predicates1.equalTo('id', id);
    try {
      let result = this.store.updateSync(valueBucket, predicates1)
      console.info(`el, Succeeded in updating data. row count: ${result}`);

    } catch (err) {
      console.error(`el, Failed to update data. Code:${err.code}, message:${err.message}`);
    }
  }

  async sumRangeTotalTime(startTime: number, endTime: number): Promise<number | null> {
    let resultSet: relationalStore.ResultSet

    try {
      let resultSet = this.store.querySqlSync(`SELECT SUM(total_Time) AS total FROM ${TABLE_MAN_HOURS} WHERE (start_Time BETWEEN ${startTime} AND ${endTime}) AND delete_flag=0`, null)

      for (let rowIndex = 0; rowIndex < resultSet.rowCount; rowIndex++) {
        let isSuccess = resultSet.goToRow(rowIndex)
        console.info(`el, ResultSet goToRow = ` + isSuccess);
        if (isSuccess) {
          let totalTime = resultSet.getLong(resultSet.getColumnIndex('total'))
          resultSet.close()
          return new Promise((resolve) => {
            resolve(totalTime)
          })
        }
      }
      resultSet.close()
      return new Promise((resolve) => {
        resolve(null)
      })
    } catch (err) {
      resultSet!.close()
      return new Promise((_resolve, reject) => {
        reject(err)
      })
    }
  }

  async countRangeData(startTime: number, endTime: number): Promise<number | null> {
    let resultSet: relationalStore.ResultSet

    try {
      let resultSet = this.store.querySqlSync(`SELECT COUNT() AS count FROM ${TABLE_MAN_HOURS} WHERE (start_Time BETWEEN ${startTime} AND ${endTime}) AND delete_flag=0`, null)

      for (let rowIndex = 0; rowIndex < resultSet.rowCount; rowIndex++) {
        let isSuccess = resultSet.goToRow(rowIndex)
        console.info(`el, ResultSet goToRow = ` + isSuccess);
        if (isSuccess) {
          let count = resultSet.getLong(resultSet.getColumnIndex('count'))
          resultSet.close()
          return new Promise((resolve) => {
            resolve(count)
          })
        }
      }
      resultSet.close()
      return new Promise((resolve) => {
        resolve(null)
      })
    } catch (err) {
      resultSet!.close()
      return new Promise((_resolve, reject) => {
        reject(err)
      })
    }
  }

  async queryRangeDataList(startTime: number, endTime: number): Promise<[number, number, number] | null> {
    let resultSet: relationalStore.ResultSet
    let predicates = new relationalStore.RdbPredicates(TABLE_MAN_HOURS)
    predicates.between("start_Time", startTime, endTime)
    predicates.and()
    predicates.equalTo("delete_flag", 0)
    predicates.orderByDesc("start_Time")

    try {

      let resultSet = await this.store.query(predicates, ["start_Time", "end_Time", "total_Time"])

      for (let rowIndex = 0; rowIndex < resultSet.rowCount; rowIndex++) {
        let isSuccess = resultSet.goToRow(rowIndex)
        console.info(`el,  ResultSet goToRow = ` + isSuccess);
        if (isSuccess) {
          let startTime = resultSet.getLong(resultSet.getColumnIndex('start_Time'))
          let endTime = resultSet.getLong(resultSet.getColumnIndex('end_Time'))
          let totalTime = resultSet.getLong(resultSet.getColumnIndex('total_Time'))
          resultSet.close()
          return new Promise((resolve) => {
            resolve([startTime, endTime, totalTime])
          })
        }
      }
      resultSet.close()
      return new Promise((resolve) => {
        resolve(null)
      })
    } catch (err) {
      resultSet!.close()
      return new Promise((_resolve, reject) => {
        reject(err)
      })
    }
  }

}