import systemDateTime from '@ohos.systemDateTime'
import commonDBViewModel from '../../common/viewmodel/CommonDBViewModel'
import { PrefKey } from '../../constant/PrefKey'
import { DateTimeUtil } from '../../utill/DateTimeUtil'
import preferencesHelper from '../../utill/PreferencesHelper'

@Component
export struct LogComponent {
  @State runningState: boolean = false
  @State todayTotalManHours: number = 0
  @State currentTime: number = 0
  private lastStartTime: number = -1
  private intervalId: number = -1

  aboutToAppear() {
    this.init()
  }

  build() {
    Column() {
      Text(`Today ManHours: ${DateTimeUtil.formatTime(this.todayTotalManHours + this.currentTime)}`)
      Button({ type: ButtonType.Circle }) {
        Text(this.runningState ? "Finish" : "Start")
          .fontColor(Color.White)
      }
      .width('40%')
      .height('20%')
      .onClick(() => {
        this.onClickStart()
      })
      .margin({ top: 16 })

      if (this.runningState) {
        Text(`This Session ManHours: ${DateTimeUtil.formatTime(this.currentTime)}`)
          .margin({ top: 16 })
      }
    }
  }

  private async init() {
    console.log("el, call init from LogComponent")
    this.lastStartTime = await preferencesHelper.get(PrefKey.LAST_START_TIME, -1) as number
    if (this.lastStartTime != -1) {
      this.runningState = true
      this.currentTime = systemDateTime.getTime() - this.lastStartTime
      this.startTimer()
    }

    await this.loadTotalTime()
  }

  private async onClickStart() {
    this.runningState = !this.runningState

    if (this.runningState) {
      this.lastStartTime = systemDateTime.getTime()
      await preferencesHelper.put(PrefKey.LAST_START_TIME, this.lastStartTime)
      this.startTimer()
    } else {
      clearInterval(this.intervalId)
      this.currentTime = 0
      await preferencesHelper.put(PrefKey.LAST_START_TIME, -1)
      let currentTime = systemDateTime.getTime()
      await commonDBViewModel.insertData(this.lastStartTime, currentTime, currentTime - this.lastStartTime)
      await this.loadTotalTime()
    }
  }

  private startTimer() {
    this.intervalId = setInterval(
      () => {
        let curren = systemDateTime.getTime()
        this.currentTime = curren - this.lastStartTime
      },
      1000
    )
  }

  private async loadTotalTime() {
    if (commonDBViewModel.isReady()) {
      let dayRange = DateTimeUtil.currentDayTimeStamp()
      this.todayTotalManHours = await commonDBViewModel.sumRangeTotalTime(dayRange[0], dayRange[1]) ?? 0
      console.log(`el, ============DayRange: ${dayRange}}, saveTotalManHours: ${this.todayTotalManHours} =============`)
    }
    else {
      setTimeout(
        () => {
          this.loadTotalTime()
        },
        200
      )
      console.log(`el, loadTotalTime wait for db ready`)
    }
  }
}