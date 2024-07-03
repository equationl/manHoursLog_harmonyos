import preferences from '@ohos.data.preferences'
import dataPreferences from '@ohos.data.preferences'

/**
 * 用户首选项为应用提供Key-Value键值型的数据处理能力，支持应用持久化轻量级数据，并对其修改和查询。

 数据存储形式为键值对，键的类型为字符串型，值的存储数据类型包括数字型、字符型、布尔型以及这3种类型的数组类型。
 */
export class PreferencesHelper {
  private preferences: preferences.Preferences | null = null


  // 静态方法，用于获取特定上下文和名称的偏好设置
  static getPreferences(context: Context, name: string): Promise<dataPreferences.Preferences> {
    // 调用dataPreferences模块的getPreferences方法，并返回Promise对象
    return dataPreferences.getPreferences(context, name)
  }

  // 静态方法，用于删除特定上下文和名称的偏好设置
  static deletePreferences(context: Context, name: string): Promise<void> {
    // 调用dataPreferences模块的deletePreferences方法，并返回Promise对象
    return dataPreferences.deletePreferences(context, name)
  }

  async init(context: Context) {
    this.preferences = await PreferencesHelper.getPreferences(context,'cache_pref')
  }

  async put(key: string, value: preferences.ValueType) {
    await this.preferences?.put(key, value)
    await this.preferences?.flush()
  }

  async get(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {
    const result = await this.preferences?.get(key, defaultValue)
    return result!
  }

}

const preferencesHelper = new PreferencesHelper()

export default preferencesHelper