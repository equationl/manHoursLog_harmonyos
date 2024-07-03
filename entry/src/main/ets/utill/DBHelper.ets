import relationalStore from '@ohos.data.relationalStore'

// 导出一个名为DBHelper的类
export class DBHelper {
  // 定义一个私有静态属性dbMap，它是一个Map对象，键是字符串（数据库名），值是RdbStore对象
  private static dbMap = new Map<string, relationalStore.RdbStore>()

  // 定义一个静态方法，用于根据数据库名获取RdbStore对象
  static getRdbStore(dbName: string): relationalStore.RdbStore | null {
    // 从dbMap中获取与dbName对应的RdbStore对象
    let rdbStore = DBHelper.dbMap.get(dbName)
    // 如果没有找到，则返回null
    if (!rdbStore) {
      return null
    } else {
      // 如果找到了，则返回RdbStore对象
      return rdbStore
    }
  }

  // 定义一个静态方法，该方法尝试获取与给定配置匹配的RdbStore对象，如果不存在则创建它
  static getWithCreateDb(
    context: Context, // 上下文对象
    config: relationalStore.StoreConfig // 数据库配置对象
  ): Promise<relationalStore.RdbStore> {
    // 返回一个Promise，用于异步处理
    return new Promise<relationalStore.RdbStore>((success, error) => {
      // 如果context或config.name不存在，则抛出错误
      if (!context || !config.name) {
        error("param error context" + context + "    config:" + config.name)
        return
      }
      // 尝试从dbMap中获取与config.name对应的RdbStore对象
      let rdbStore = DBHelper.dbMap.get(config.name)

      // 如果没有找到
      if (!rdbStore) {
        // 调用relationalStore的getRdbStore方法创建新的RdbStore对象
        // 注意：这里假设relationalStore.getRdbStore是一个返回Promise的方法
        relationalStore.getRdbStore(context, config).then(rdbStore => {
          // 创建成功后，将新的RdbStore对象添加到dbMap中
          DBHelper.dbMap.set(config.name, rdbStore)
          // 并通过Promise的success回调函数返回它
          success(rdbStore)
        }).catch((err:Error) => {
          // 如果在创建过程中发生错误，则通过Promise的error回调函数抛出错误
          error(err)
        })
      } else {
        // 如果已经存在，则直接通过Promise的success回调函数返回它
        success(rdbStore)
      }
    })
  }


}