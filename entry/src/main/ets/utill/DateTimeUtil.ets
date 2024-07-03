
export class DateTimeUtil {
  static DAY_MILL_SECOND_TIME = 86400_000
  static HOUR_MILL_SECOND_TIME = 3600_000
  static MINUTE_MILL_SECOND_TIME = 60_000
  static SECOND_MILL_SECOND_TIME = 1_000

  static formatTime(time: number): string {
    let base = Math.floor(time / 1000)
    let hours = Math.floor(base / 3600)
    let minutes = Math.floor((base - hours * 3600) / 60)
    let seconds = Math.floor(base - hours * 3600 - minutes * 60)

    console.log(`base=${base}, hours=${hours}, minutes=${minutes}, seconds=${seconds}`)

    return `${hours.toFixed(0).padStart(2, '0')}:${minutes.toFixed(0).padStart(2, '0')}:${seconds.toFixed(0).padStart(2, '0')}`
  }

  static currentDayTimeStamp(): [number, number] {
    let dateTime = new Date()
    let offset = dateTime.getTimezoneOffset() * 60 * 1000
    console.log(`el, =========== offset: ${offset} =========`)
    let d = Math.floor(dateTime.getTime() / DateTimeUtil.DAY_MILL_SECOND_TIME) * DateTimeUtil.DAY_MILL_SECOND_TIME
    return [Math.floor(d + offset), Math.floor(d + DateTimeUtil.DAY_MILL_SECOND_TIME + offset)]
  }
}